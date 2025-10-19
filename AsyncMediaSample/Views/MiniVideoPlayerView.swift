//
//  MiniVideoPlayerView.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import SwiftUI
import AVKit

struct MiniVideoPlayerView: View {
    let player: AVPlayer
    var body: some View {
        VideoPlayer(player: player)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
            .shadow(radius: 3)
    }
}
