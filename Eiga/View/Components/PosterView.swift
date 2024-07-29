//
//  MoviePosterView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation
import SwiftUI

// MARK: - View Model

@Observable
class PosterViewModel {
    let media: any Media
    let baseHeight: CGFloat = 165
    let aspectRatio: CGFloat = 2/3
    
    var scale: CGFloat = 1.0
    var posterURL: URL?
    var imageQuality: TMBDImageConfig.PosterSize = .w500
    var posterError: Error?
    
    var scaledHeight: CGFloat {
        baseHeight * scale
    }
    
    var scaledWidth: CGFloat {
        scaledHeight * aspectRatio
    }
    
    init(media: any Media) {
        self.media = media
        loadPosterURL()
    }
    
    func loadPosterURL() {
        do {
            posterURL = try media.getPosterURL(size: imageQuality)
            posterError = nil
        } catch {
            posterError = error
            posterURL = nil
        }
    }
    
    func updateScale(_ newScale: CGFloat) {
        scale = newScale
    }
}

// MARK: - View

struct PosterView: View {
    @State var viewModel: PosterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9 * viewModel.scale) {
            posterImage
            posterLabel
        }
        .frame(width: viewModel.scaledWidth)
    }
    
    var posterImage: some View {
        AsyncImage(url: viewModel.posterURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .aspectRatio(contentMode: .fit)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10 * viewModel.scale)
            case .failure:
                MissingImageView(error: viewModel.posterError)
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: viewModel.scaledHeight)
    }
    
    var posterLabel: some View {
        HStack(alignment: .top, spacing: 4 * viewModel.scale) {
            Circle()
                .frame(width: 17 * viewModel.scale, height: 17 * viewModel.scale)
                .opacity(0.25)
                .overlay(
                    Image(systemName: MediaMode.movie.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 10 * viewModel.scale)
                )
                .foregroundStyle(MediaMode.movie.color)
            
            Text(viewModel.media.title)
                .font(.manrope(12 * viewModel.scale))
                .foregroundStyle(.white)
                .lineLimit(2, reservesSpace: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Helper Views
struct MissingImageView: View {
    var error: Error?
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "photo.badge.exclamationmark")
                .imageScale(.large)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.white, .red)
            Text(error?.localizedDescription ?? "Error")
                .font(.caption)
                .foregroundColor(.red)
                .lineLimit(5)
                .multilineTextAlignment(.center)
        }
    }
    
    private var errorMessage: String {
        if let errorMessage = error as? ImageError {
            switch errorMessage {
            case .missingImagePath:
                return "No Poster Available"
            case .invalidURL:
                return "Invalid Image URL"
            }
        }
        return error?.localizedDescription ?? "Unknown Error"
    }
}

// MARK: - Preview

private struct PreviewWrapper: View {
    let tmbd = TMBDService()
    @State var movie: (any Media)?
    
    var body: some View {
        Group {
            if let movie = movie {
                PosterView(viewModel: PosterViewModel(media: movie))
            } else {
                ProgressView()
            }
        }
        .frame(width: 150, height: 200)
        .task {
            do {
                self.movie = try await tmbd.fetchMovie(id: 810693)
            } catch {
                print("Error fetching movie: \(error)")
            }
        }
    }
}

#Preview {
    PreviewWrapper()
        .hueBackground(hueColor: .pink)
}
