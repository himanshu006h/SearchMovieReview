//
//  SearchServiceTest.swift
//  SearchMovieReviewTests
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import XCTest
@testable import SearchMovieReview

class SearchServiceTest: XCTestCase {
    
    struct Constants {
        static let StatusCodeDict = "Status code : 200"
        static let completionHandlerMsg = "Call completes immediately by invoking completion handler"
        static let testURL = "http://www.omdbapi.com/?apikey=26c01fe0&s=home&page=10&Content-Type=application/json"
    }
    
    // Properties
    var sessionUnderTest : URLSession!

    override func setUp() {
        sessionUnderTest = URLSession(configuration : URLSessionConfiguration.default)
    }

    override func tearDown() {
        sessionUnderTest = nil
    }


    func testValidCallToInfoAPIGetsStatusCode200(){
        let request = Constants.testURL.urlRequest()
        let promise = expectation(description: Constants.StatusCodeDict)
        
        // when
        sessionUnderTest.dataTask(with: request) { (data, response, error) in
            // then
            if let error = error{
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else{
                    XCTFail("Status code = \(statusCode)")
                }
            }
            }.resume()
        waitForExpectations(timeout: 10, handler: nil)
    }

}
