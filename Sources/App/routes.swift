import Vapor
import Queues

func routes(_ app: Application, requestController: RequestController) throws {
    app.get { req -> String in
        requestController.requestHandled(ipAddress: req.remoteAddress?.ipAddress)
 
        return "Home page"
    }

    app.get("top100") { req -> [String: String] in
        requestController.requestHandled(ipAddress: req.remoteAddress?.ipAddress)
        
        return requestController.top100()
    }
}
