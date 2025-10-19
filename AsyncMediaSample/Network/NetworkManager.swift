//
//  NetworkManager.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import Foundation

public protocol NetworkManaging {
    func performDataRequest<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type) async throws -> T
    func downloadFile(_ request: NetworkRequest, to destination: URL?) async throws -> URL
    func uploadFile(_ request: NetworkRequest, fileURL: URL) async throws -> Data
    func downloadData(_ request: NetworkRequest) async throws -> Data
}

public final class NetworkManager: NetworkManaging {
    public static let shared = NetworkManager()
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Generic Data Request
    public func performDataRequest<T: Decodable>(_ request: NetworkRequest, decodeTo type: T.Type) async throws -> T {
        let req = try request.asURLRequest()
        let (data, response) = try await session.data(for: req)
        try validate(response: response)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Download File
    public func downloadFile(_ request: NetworkRequest, to destination: URL? = nil) async throws -> URL {
        let req = try request.asURLRequest()
        let (tempURL, response) = try await session.download(for: req)
        try validate(response: response)
        
        let finalURL = destination ?? FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.moveItem(at: tempURL, to: finalURL)
        return finalURL
    }
    
    // MARK: - Upload File
    public func uploadFile(_ request: NetworkRequest, fileURL: URL) async throws -> Data {
        let req = try request.asURLRequest()
        let (data, response) = try await session.upload(for: req, fromFile: fileURL)
        try validate(response: response)
        return data
    }
    
    // MARK: - Download Raw Data (for images)
    public func downloadData(_ request: NetworkRequest) async throws -> Data {
        let req = try request.asURLRequest()
        let (data, response) = try await session.data(for: req)
        try validate(response: response)
        return data
    }
    
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
    }
}
