import Vapor
import Queues

func routes(_ app: Application, requestController: RequestControllerProtocol) throws {
    app.get("home") { req -> String in
        requestController.requestHandled(ipAddress: req.remoteAddress?.ipAddress)
        
        return "Home page"
    }
    
    app.get("top100") { req -> String in
        requestController.requestHandled(ipAddress: req.remoteAddress?.ipAddress)
        
        do {
            let list = requestController.top100()
            let data = try JSONSerialization.data(withJSONObject: list, options: .prettyPrinted)
            let response = String(data: data, encoding: .utf8)!
            return response
        } catch {
            return "Error response: \(error)"
        }
    }
}
