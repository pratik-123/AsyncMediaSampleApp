//
//  ImageListView.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import SwiftUI
import AVKit

struct ImageListView: View {
    @StateObject var viewModel: ImageListViewModel
    
    @State private var activeItemID: UUID?
    @State private var activeMarker: CGPoint?
    @State private var player: AVPlayer?

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.images) { item in
                        ImageRowView(
                            item: item,
                            activeItemID: $activeItemID,
                            activeMarker: $activeMarker,
                            player: $player
                        )
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Async Media Sample")
            .task { await viewModel.load() }
        }
    }
}
