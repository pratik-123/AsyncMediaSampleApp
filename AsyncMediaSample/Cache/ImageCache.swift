//
//  ImageCache.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import UIKit
import SwiftUI

enum CachePolicy {
    case memory
    case disk
    case both
}

final class ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        createDirectoryIfNeeded()
    }
    
    func image(forKey key: String, policy: CachePolicy, maxAge: TimeInterval) -> Image? {
        let fileKey = key.safeFileName()
        
        if policy == .memory || policy == .both {
            if let uiImage = memoryCache.object(forKey: fileKey as NSString) {
                return Image(uiImage: uiImage)
            }
        }
        
        if policy == .disk || policy == .both {
            let fileURL = cacheDirectory.appendingPathComponent(fileKey)
            
            guard let attrs = try? fileManager.attributesOfItem(atPath: fileURL.path),
                  let modDate = attrs[.modificationDate] as? Date,
                  Date().timeIntervalSince(modDate) < maxAge,
                  let data = try? Data(contentsOf: fileURL),
                  let uiImage = UIImage(data: data) else {
                return nil
            }
            
            if policy == .both {
                memoryCache.setObject(uiImage, forKey: fileKey as NSString)
            }
            
            return Image(uiImage: uiImage)
        }
        
        return nil
    }
    
    func store(_ image: Image, data: Data, forKey key: String, policy: CachePolicy) {
        let fileKey = key.safeFileName()
        if let uiImage = UIImage(data: data) {
            if policy == .memory || policy == .both {
                memoryCache.setObject(uiImage, forKey: fileKey as NSString)
            }
            
            if policy == .disk || policy == .both {
                let path = cacheDirectory.appendingPathComponent(fileKey)
                try? data.write(to: path)
            }
        }
    }
    
    func clearMemory() {
        memoryCache.removeAllObjects()
    }
    
    func clearDisk() {
        try? fileManager.removeItem(at: cacheDirectory)
        createDirectoryIfNeeded()
    }
    
    private func createDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
}

private extension String {
    func safeFileName() -> String {
        let unsafeChars = CharacterSet.alphanumerics.inverted
        return components(separatedBy: unsafeChars).joined(separator: "_")
    }
}
