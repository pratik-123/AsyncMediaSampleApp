//
//  ImageRowView.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import SwiftUI
import AVKit

struct ImageRowView: View {
    let item: ImageItem
    @StateObject private var viewModel = ImageRowViewModel()
    @State private var dragStartLocation: CGPoint? = nil
    
    @Binding var activeItemID: UUID?
    @Binding var activeMarker: CGPoint?
    @Binding var player: AVPlayer?
    
    private let tapRadius: CGFloat = 0.05 // 5% of width/height
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            imageContent
                .frame(height: 250)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 4)
            
            Text(item.title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
                .padding(.bottom, 8)
        }
        .padding(.vertical, 8)
        .onDisappear {
            if activeItemID == item.id {
                stopVideo()
            }
        }
    }
    
    // MARK: - image content
    private var imageContent: some View {
        GeometryReader { geo in
            ZStack {
                baseImage
                markers(in: geo.size)
                videoOverlay(in: geo.size)
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if dragStartLocation == nil {
                            dragStartLocation = value.startLocation
                        }
                    }
                    .onEnded { value in
                        defer { dragStartLocation = nil }
                        guard let start = dragStartLocation else { return }
                        
                        let distance = hypot(value.location.x - start.x, value.location.y - start.y)
                        
                        if distance < 10 {
                            handleTap(location: value.location, in: geo.size)
                        }
                    }
            )
        }
    }
    
    private var baseImage: some View {
        CachedImage(
            urlString: item.url,
            placeholder: AnyView(Color.gray.opacity(0.3)),
            cornerRadius: 12,
            showsLoader: true
        )
        .allowsHitTesting(false)
    }
    
    private func markers(in size: CGSize) -> some View {
        ForEach(Array(viewModel.markers.enumerated()), id: \.offset) { _, point in
            let abs = CGPoint(x: point.x * size.width, y: point.y * size.height)
            Circle()
                .fill(Color.red)
                .frame(width: 12, height: 12)
                .position(abs)
                .zIndex(1)
        }
    }
    
    private func videoOverlay(in size: CGSize) -> some View {
        Group {
            if activeItemID == item.id,
               let marker = activeMarker,
               let player = player {
                let abs = CGPoint(x: marker.x * size.width, y: marker.y * size.height)
                let videoSize: CGSize = CGSize(width: 200, height: 120)
                let adjustedX = min(max(videoSize.width / 2, abs.x),
                                    size.width - videoSize.width / 2)
                let adjustedY = min(max(videoSize.height / 2, abs.y),
                                    size.height - videoSize.height / 2)
                
                MiniVideoPlayerView(player: player)
                    .frame(width: videoSize.width, height: videoSize.height)
                    .position(x: adjustedX, y: adjustedY)
                    .onAppear { player.play() }
                    .zIndex(2)
            }
        }
    }
    
    // MARK: - Tap Handling Logic
    private func handleTap(location: CGPoint, in size: CGSize) {
        let normalized = CGPoint(x: location.x / size.width,
                                 y: location.y / size.height)
        
        if let existingMarker = viewModel.markers.first(where: {
            hypot($0.x - normalized.x, $0.y - normalized.y) < tapRadius
        }) {
            handleMarkerTap(existingMarker)
        } else {
            viewModel.addMarker(at: normalized)
        }
    }
    
    private func handleMarkerTap(_ marker: CGPoint) {
        stopVideo()
        
        if activeItemID == item.id && activeMarker == marker {
            activeItemID = nil
            activeMarker = nil
            return
        }
        
        activeItemID = item.id
        activeMarker = marker
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            playVideo()
        }
    }
    
    private func playVideo() {
        guard let url = Bundle.main.url(forResource: "SampleVideo", withExtension: "mp4") else {
            return
        }
        let newPlayer = AVPlayer(url: url)
        player = newPlayer
    }
    
    private func stopVideo() {
        player?.pause()
        player = nil
    }
}
