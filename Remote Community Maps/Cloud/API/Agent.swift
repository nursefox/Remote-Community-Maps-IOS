//
//  Agent.swift
//  CombineNetworkLayer
//
//  Created by Vadym Bulavin on 11/18/19.
//  Copyright © 2019 Vadym Bulavin. All rights reserved.
//

import Foundation
import Combine

struct Agent {
    
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .eraseToAnyPublisher()
    }
    
    func run(_ request: URLRequest) -> AnyPublisher<Void, Error> {
        URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Void in
                guard
                    let httpResponse = result.response as? HTTPURLResponse,
                    [200, 201].contains(httpResponse.statusCode) else
                {
                    throw URLError(.badServerResponse)
                }
                return ()
            }
            .eraseToAnyPublisher()
    }
    
}
