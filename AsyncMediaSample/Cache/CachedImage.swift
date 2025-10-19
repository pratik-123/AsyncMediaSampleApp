//
//  CachedImage.swift
//  AsyncMediaSample
//
//  Created by Pratik Lad on 19/10/25.
//

import SwiftUI

final class ImageCacheConfig {
    static let shared = ImageCacheConfig()
    var defaultPolicy: CachePolicy = .both
    var defaultExpiration: TimeInterval = 60 * 60 * 24 // 24 hours
    private init() {}
}

struct CachedImage: View {
    let urlString: String
    let placeholder: AnyView
    let cornerRadius: CGFloat
    let showsLoader: Bool
    let cachePolicy: CachePolicy
    let cacheExpiration: TimeInterval

    @State private var image: Image?
    @Environment(\.scenePhase) private var scenePhase

    private let cache = ImageCache.shared
    private let network: NetworkManaging = NetworkManager.shared

    // MARK: - Init
    init(
        urlString: String,
        placeholder: AnyView,
        cornerRadius: CGFloat = 0,
        showsLoader: Bool = true,
        cachePolicy: CachePolicy? = nil,
        cacheExpiration: TimeInterval? = nil
    ) {
        self.urlString = urlString
        self.placeholder = placeholder
        self.cornerRadius = cornerRadius
        self.showsLoader = showsLoader

        self.cachePolicy = cachePolicy ?? ImageCacheConfig.shared.defaultPolicy
        self.cacheExpiration = cacheExpiration ?? ImageCacheConfig.shared.defaultExpiration
    }

    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .cornerRadius(cornerRadius)
                    .transition(.opacity.combined(with: .scale))
            } else {
                placeholder
                    .overlay(
                        showsLoader ? AnyView(ProgressView().progressViewStyle(CircularProgressViewStyle())) : AnyView(EmptyView())
                    )
                    .cornerRadius(cornerRadius)
            }
        }
        .task { await loadImage() }
        .onChange(of: scenePhase) {
            if scenePhase == .background || scenePhase == .inactive {
                if cachePolicy == .memory || cachePolicy == .both {
                    cache.clearMemory()
                }
            }
        }
        .animation(.easeInOut, value: image)
    }

    @Sendable
    private func loadImage() async {
        if let cached = cache.image(forKey: urlString, policy: cachePolicy, maxAge: cacheExpiration) {
            await MainActor.run { self.image = cached }
            return
        }

        guard let url = URL(string: urlString) else { return }

        let request = GenericDownloadRequest(url: url)

        do {
            let data = try await network.downloadData(request)
            if let uiImage = UIImage(data: data) {
                let swiftUIImage = Image(uiImage: uiImage)
                cache.store(swiftUIImage, data: data, forKey: urlString, policy: cachePolicy)
                await MainActor.run { self.image = swiftUIImage }
            }
        } catch {
            await MainActor.run {
                self.image = Image(systemName: "exclamationmark.triangle")
            }
        }
    }
}
