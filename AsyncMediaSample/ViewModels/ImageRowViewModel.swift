//
//  ImageRowViewModel.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import Foundation
import CoreGraphics

@MainActor
final class ImageRowViewModel: ObservableObject {
    @Published private(set) var markers: [CGPoint] = []
    
    func addMarker(at point: CGPoint) {
        markers.append(point)
    }
}
