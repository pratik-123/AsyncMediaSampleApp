//
//  ImageListViewModel.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import SwiftUI

@MainActor
final class ImageListViewModel: ObservableObject {
    @Published var images: [ImageItem] = []
    @Published var errorMessage: String?
    @Published var activeCellID: UUID?
    @Published var activeMarker: CGPoint?
    
    private let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func load() async {
        do {
            images = try await dataSource.fetchImages()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
