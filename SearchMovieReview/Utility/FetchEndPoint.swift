//
//  FetchEndPoint.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

protocol FetchEndPointProtocol {
    var baseURL: URL { get }
}

// Can have mutilple cases for fetch request for different api calls
enum FetchEndPoint {
    case fetchMovie(searchText: String, pageNumber: Int)
}

class KeyConstants {
    
    enum FetchMovies: String {
        case apikey
        case s
        case page
    }
}

extension FetchEndPoint: FetchEndPointProtocol {
    
    var baseURL: URL {
        guard let url = URL(string: NetworkDataLoaderConstant.baseUrlString) else {
            fatalError("url can't be made right now")
        }
        return url
    }
    
    var urlParameters: Parameters {
        switch self {
        case .fetchMovie(let searchText, let pageNumber):
            return [
                KeyConstants.FetchMovies.apikey.rawValue : "26c01fe0",
                KeyConstants.FetchMovies.s.rawValue: searchText,
                KeyConstants.FetchMovies.page.rawValue: pageNumber,
            ]
        }
    }
    
    func encode(request: inout URLRequest, urlParameters: Parameters?) {
        guard let urlParameters = urlParameters, let url = request.url  else { return }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = [URLQueryItem]()
            request.timeoutInterval = 10
            for (key, value) in urlParameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            request.url = urlComponents.url
        }
    }
}
