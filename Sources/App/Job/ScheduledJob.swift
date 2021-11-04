//
//  File.swift
//  
//
//  Created by Carlos Real on 04/11/21.
//

import Vapor
import Queues

// Wrapper to clean up ip addressses list
struct CleanupJob: ScheduledJob {
    
    let request: RequestControllerProtocol
    
    func run(context: QueueContext) -> EventLoopFuture<Void> {
        // clear cached content
        request.clear()
        
        return context.eventLoop.makeSucceededFuture(())
    }
}
