import Vapor
import Queues

public func configure(_ app: Application, requestController: RequestControllerProtocol) throws {
    // Register scheduler to clean up cache every day
    app.queues.schedule(CleanupJob(request: requestController))
        .daily()
        .at(.midnight)
    
    try app.queues.startScheduledJobs()
    
    // register routes
    try routes(app, requestController: requestController)
}
