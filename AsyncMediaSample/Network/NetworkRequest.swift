//
//  NetworkRequest.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import Foundation

public protocol NetworkRequest {
    var url: URL? { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

public extension NetworkRequest {
    func asURLRequest() throws -> URLRequest {
        guard let url = url else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body
        return request
    }
}
