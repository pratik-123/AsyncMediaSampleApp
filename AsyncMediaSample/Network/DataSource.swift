//
//  DataSource.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import Foundation

protocol DataSource {
    func fetchImages() async throws -> [ImageItem]
}

final class RemoteDataSource: DataSource {
    private let manager: NetworkManaging
    private let urlString: String
    
    init(urlString: String, manager: NetworkManaging = NetworkManager.shared) {
        self.urlString = urlString
        self.manager = manager
    }
    
    func fetchImages() async throws -> [ImageItem] {
        let req = ImageListRequest(urlString: urlString)
        return try await manager.performDataRequest(req, decodeTo: [ImageItem].self)
    }
}

final class LocalDataSource: DataSource {
    private let fileName: String
    
    init(fileName: String) { self.fileName = fileName }
    
    func fetchImages() async throws -> [ImageItem] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NetworkError.invalidURL
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([ImageItem].self, from: data)
    }
}
