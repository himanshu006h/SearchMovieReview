//
//  NetworkDataLoader.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import Foundation

typealias QueryCompletionHandler = (_ result : FetchResult) -> Void
typealias FetchResult = Result<Any, APIErrors>

enum ServiceType: Int {
    case movieDetails = 0
}

struct NetworkDataLoaderConstant {
    static let baseUrlString = "http://www.omdbapi.com/"
    static let getMethod = "GET"
}

class NetworkDataLoader {
    var dataTask: URLSessionDataTask?
    let decoder = JSONDecoder()
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func loadResult(with endPoint: FetchEndPoint, urlString: String = NetworkDataLoaderConstant.baseUrlString, serviceType: ServiceType = ServiceType.movieDetails
        , bodyPram: [String: Any] = [String: Any](), completion: @escaping QueryCompletionHandler) {
        
        var request: URLRequest
        switch serviceType {
        case .movieDetails:
            request = urlString.urlRequest()
        }
        
        endPoint.encode(request: &request, urlParameters: endPoint.urlParameters)
        dataTask = session.dataTask(with: request) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                completion(.failure(.requestFailed(error: error as NSError)))
                return
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 || response.statusCode == 201 {
                self.parseData((String(data:data,
                                       encoding:.isoLatin1)!.data(using: .utf8)!), serviceType: serviceType, completion: { result in
                                        switch result {
                                        case let .success(feedInfo): completion(.success(feedInfo))
                                        case let .failure(error) : completion(.failure(error))
                                        }
                })
            }else{
                if (response as? HTTPURLResponse) != nil{
                    completion(.failure(.responseUnsuccessful))
                }
            }
        }
        dataTask?.resume()
    }
    
    //Parse Data as per service type
    private func parseData(_ data: Data, serviceType: ServiceType = ServiceType.movieDetails, completion: QueryCompletionHandler) {
        switch serviceType {
        case .movieDetails:
            do {
                let movieInfo = try decoder.decode(MovieDetails.self, from: data)
                completion(.success(movieInfo))
            } catch _ as NSError {
                completion(.failure(.jsonParsingFailure))
                return
            }
        }
    }
}


