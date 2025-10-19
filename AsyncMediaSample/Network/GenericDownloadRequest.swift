//
//  GenericDownloadRequest.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import Foundation

struct GenericDownloadRequest: NetworkRequest {
    var url: URL?
    var method: String { "GET" }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
}
