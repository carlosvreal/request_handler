//
//  File.swift
//  
//
//  Created by Carlos Real on 04/11/21.
//

@testable import App
import XCTVapor
import XCTest

final class RequestControllerTests: XCTestCase {
    
    func testRequestHandledStoresIpAddress() {
        let requestController = RequestController()
        
        requestController.requestHandled(ipAddress: "127.0.0.1")
        XCTAssertFalse(requestController.top100()["result"]!.isEmpty)
    }
    
    func testRequestHandledDoesNotStoresInvalidAddress() {
        let requestController = RequestController()
        
        requestController.requestHandled(ipAddress: "111.AAA")
        XCTAssertTrue(requestController.top100()["result"]!.isEmpty)
    }
    
    func testSortedListMethod() {
        let requestController = RequestController()
        
        requestController.requestHandled(ipAddress: "127.0.0.1")
        requestController.requestHandled(ipAddress: "127.0.0.1")
        
        requestController.requestHandled(ipAddress: "127.0.0.2")
        
        requestController.requestHandled(ipAddress: "127.0.0.100")
        requestController.requestHandled(ipAddress: "127.0.0.100")
        requestController.requestHandled(ipAddress: "127.0.0.100")
        requestController.requestHandled(ipAddress: "127.0.0.100")
        
        let expected = ["result": [["127.0.0.100": 4],
                                   ["127.0.0.1": 2],
                                   ["127.0.0.2": 1]]]
                        
        let result = requestController.top100()
        
        XCTAssertEqual(result, expected)
    }
    
    func testClearAllCache() {
        let requestController = RequestController()
        
        requestController.requestHandled(ipAddress: "127.0.0.1")
        requestController.requestHandled(ipAddress: "127.0.0.2")
        requestController.requestHandled(ipAddress: "127.0.0.3")
        
        XCTAssertFalse(requestController.top100()["result"]!.isEmpty)
        
        requestController.clear()
    
        XCTAssertTrue(requestController.top100()["result"]!.isEmpty)
    }
}
