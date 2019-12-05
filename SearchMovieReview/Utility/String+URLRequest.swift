//
//  String+URLRequest.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import Foundation

// Mark:- Constants
struct Constants {
    static let methodName = "GET"
    static let kRequestType = "Content-Type"
    static let kContentType = "application/json"
}

extension String {
    func urlRequest(method: String = Constants.methodName) -> URLRequest {
        let url : URL = {
            let url = URL(string: self)!
            return url
        }()
        
        // Create request
        var request = URLRequest(url: url)
        request.addValue(Constants.kContentType, forHTTPHeaderField: Constants.kRequestType)
        // Setup HTTP method
        request.httpMethod = method
        return request
    }
}

