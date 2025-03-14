//
//  ImageCache.swift
//  WeatherApp
//
//  Created by Abhishek Dogra on 18/01/25.
//

import SwiftUI
import Foundation
import CryptoKit

@MainActor
struct AsyncCachedImage<ImageView: View, PlaceholderView: View>: View {
    var url: URL?
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView
    
    @State private var image: UIImage? = nil
    
    private var cacheDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    init(
        url: String,
        @ViewBuilder content: @escaping (Image) -> ImageView,
        @ViewBuilder placeholder: @escaping () -> PlaceholderView
    ) {
        self.url = URL(string: url)
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            if let image {
                content(Image(uiImage: image))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            if let loadedImage = await loadImage() {
                                await MainActor.run {
                                    self.image = loadedImage
                                }
                            }
                        }
                    }
            }
        }
    }
    
    private func loadImage() async -> UIImage? {
        guard let url else { return nil }
        
        let cachePath = cacheDirectory.appendingPathComponent(cacheFilename(for: url))
        
        if let diskImage = loadImageFromDisk(at: cachePath) {
            return diskImage
        }
        
        return await downloadAndCacheImage(from: url, to: cachePath)
    }
    
    private func loadImageFromDisk(at path: URL) -> UIImage? {
        guard FileManager.default.fileExists(atPath: path.path),
              let data = try? Data(contentsOf: path),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    private func downloadAndCacheImage(from url: URL, to path: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            
            try data.write(to: path, options: .atomic)
            return image
        } catch {
            print("Error downloading: \(error)")
            return nil
        }
    }
    
    private func cacheFilename(for url: URL) -> String {
        let hash = SHA256.hash(data: Data(url.absoluteString.utf8)).compactMap { String(format: "%02x", $0) }.joined()
        return hash + ".jpg"
    }
}
