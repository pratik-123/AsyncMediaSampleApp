//
//  ImageItem.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import Foundation

struct ImageItem: Identifiable, Codable, Hashable {
    let id = UUID()
    let title: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case title, url
    }
}
