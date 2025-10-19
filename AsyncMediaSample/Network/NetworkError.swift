//
//  NetworkError.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
    case fileSaveError
    case noData
    case uploadFailed
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .serverError(let code): return "Server error: \(code)"
        case .decodingError: return "Failed to decode data"
        case .fileSaveError: return "File save failed"
        case .noData: return "No data"
        case .uploadFailed: return "Upload failed"
        case .unknown(let err): return err.localizedDescription
        }
    }
}
