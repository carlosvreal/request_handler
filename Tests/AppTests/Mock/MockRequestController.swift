//
//  File.swift
//  
//
//  Created by Carlos Real on 04/11/21.
//

@testable import App
import XCTVapor

final class MockRequestController: RequestControllerProtocol {
    private(set) var response: [[String: Int]]
    
    init(response: [[String: Int]]) {
        self.response = response
    }
    
    func top100() -> [String: [[String: Int]]] {
        return ["result": response]
    }
    
    func requestHandled(ipAddress: String?) {}
    func clear() {}
}
