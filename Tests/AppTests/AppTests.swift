@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    var app: Application!
    var mockRequestController: MockRequestController!
    
    override func setUpWithError() throws {
        try? super.setUpWithError()
        app = Application(.testing)
        
        mockRequestController = MockRequestController(response: [["1.1.1.1": 1]])
        try configure(app, requestController: mockRequestController)
    }
    
    override func tearDownWithError() throws {
        try? super.tearDownWithError()
        app.shutdown()
    }
    
    func testHelloWorld() throws {
        try app.test(.GET, "home", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Home page")
        })
    }
    
    func testTop100() throws {
        try app.test(.GET, "top100", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string,
                            """
                            {
                              "result" : [
                                {
                                  "1.1.1.1" : 1
                                }
                              ]
                            }
                            """)
        })
    }
    
    func testTop100returnsEmptyList() throws {
        mockRequestController = MockRequestController(response: [])
        try configure(app, requestController: mockRequestController)
        
        try app.test(.GET, "top100", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string,
                            """
                            {
                              "result" : [
                            
                              ]
                            }
                            """)
        })
    }
}
