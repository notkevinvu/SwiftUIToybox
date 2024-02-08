//
//  File.swift
//  
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation
import Data

public protocol NetworkService {
    var session: URLSession { get }
    func request<T: Decodable>(type: T.Type, endpoint: EndpointPath) async throws -> T
}

@available(iOS 15.0, *)
public class RestNetworkServiceAdapter: NetworkService {
    public var session: URLSession
    
    public init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    public convenience init() {
        self.init(configuration: .default)
    }
    
    public func request<T: Decodable>(type: T.Type, endpoint: EndpointPath) async throws -> T {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {
            throw TBError.invalidRequest
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        if let headers = endpoint.headers {
            for header in headers {
                urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw TBError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw TBError.decodingError
        }
    }
}
