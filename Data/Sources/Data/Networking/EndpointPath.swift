//
//  EndpointPath.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation

public protocol EndpointPath {
    var method: String { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var headers: [String: String]? { get }
    /// HTTP body, represented as `[String: Any]` which should be serialized to data before passing
    /// to the `URLRequest`
    var body: [String: Any]? { get }
}

public extension EndpointPath {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "jsonplaceholder.typicode.com"
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
}
