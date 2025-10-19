//
//  ImageListRequest.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import Foundation

struct ImageListRequest: NetworkRequest {
    let urlString: String
    var url: URL? { URL(string: urlString) }
    var method: String { "GET" }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var body: Data? { nil }
}
