import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }

// Note: In order to be injected, RequestController needs to be public as well
let requestController = RequestController()
try configure(app, requestController: requestController)
try app.run()
