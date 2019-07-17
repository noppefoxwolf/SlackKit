//
//  SmokeServer.swift
//  SKServer
//
//  Created by Peter Zignego on 3/6/19.
//

import SKCore
import SmokeHTTP1
import SmokeOperationsHTTP1
import SmokeOperations
import NIOHTTP1
import ShapeCoding

public struct SlackKitServer {
    var incomingWebhooks = [IncomingWebhook]()
}

public typealias HandlerSelector = StandardSmokeHTTP1HandlerSelector<SlackKitServer, JSONPayloadHTTP1OperationDelegate>

struct SmokeServer {

    let context = SlackKitServer()

    @discardableResult
    init(operations: [SKOperation],
         port: Int = ServerDefaults.defaultPort,
         invocationStrategy: InvocationStrategy = GlobalDispatchQueueAsyncInvocationStrategy()) {
        do {
            let server = try SmokeHTTP1Server.startAsOperationServer(withHandlerSelector: handlerSelector(operations),
                                                                     andContext: context,
                                                                     andPort: port,
                                                                     invocationStrategy: invocationStrategy)

            try server.waitUntilShutdownAndThen {
                print("Server shutdown")
            }
        } catch let error {
            print(error)
        }
    }

    func handlerSelector(_ operations: [SKOperation]) -> HandlerSelector {
        let handlerSelector: StandardSmokeHTTP1HandlerSelector<SlackKitServer, JSONPayloadHTTP1OperationDelegate> = {
            var newHandlerSelector = StandardSmokeHTTP1HandlerSelector<SlackKitServer, JSONPayloadHTTP1OperationDelegate>(defaultOperationDelegate: JSONPayloadHTTP1OperationDelegate())
            for operation in operations {
                switch operation.type {
                case .slashCommand:
                    guard let slashCommand = operation as? SlashCommand else { continue }
                    slashCommand.addHandlerWithHandler(&newHandlerSelector)
                case .oAuth:
                    guard let oauth = operation as? OAuth else { continue }
                    oauth.addHandlerWithHandler(&newHandlerSelector)
                }
            }

            return newHandlerSelector
        }()

        return handlerSelector
    }
}
