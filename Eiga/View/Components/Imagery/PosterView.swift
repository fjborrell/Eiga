//
//  MoviePosterView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation
import SwiftUI

// MARK: - View Model

/// A view model for managing poster data and scaling.
@Observable
class PosterViewModel {
    // MARK: - Constants
    
    /// The base height of the poster.
    let baseHeight: CGFloat = 165
    
    /// The aspect ratio of the poster (width to height).
    let aspectRatio: CGFloat = 2/3
    
    // MARK: - State
    
    /// The media item represented by this poster.
    let media: any Media
    
    /// The current scale factor of the poster.
    var scale: CGFloat = 1.0
    
    /// The URL of the poster image.
    var posterURL: URL?
    
    /// The quality of the poster image to fetch.
    var imageQuality: TMBDImageConfig.PosterSize = .w500
    
    /// Any error encountered while loading the poster.
    var posterError: Error?
    
    // MARK: - Computed Properties
    
    /// The scaled height of the poster.
    var scaledHeight: CGFloat {
        baseHeight * scale
    }
    
    /// The scaled width of the poster.
    var scaledWidth: CGFloat {
        scaledHeight * aspectRatio
    }
    
    // MARK: - Initialization
    
    /// Initializes a new poster view model.
    /// - Parameter media: The media item to represent.
    init(media: any Media) {
        self.media = media
        loadPosterURL()
    }
    
    // MARK: - Methods
    
    /// Attempts to load the poster URL for the media item.
    func loadPosterURL() {
        do {
            posterURL = try media.getPosterURL(size: imageQuality)
            posterError = nil
        } catch {
            posterError = error
            posterURL = nil
        }
    }
    
    /// Updates the scale factor of the poster.
    /// - Parameter newScale: The new scale factor to apply.
    func updateScale(_ newScale: CGFloat) {
        scale = newScale
    }
}

// MARK: - View

/// A view that displays a poster for a media item.
struct PosterView: View {
    @State var viewModel: PosterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9 * viewModel.scale) {
            posterImage
            posterLabel
        }
        .frame(width: viewModel.scaledWidth)
    }
    
    /// The poster image view, which asynchronously loads the image.
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
    
    /// The label view displaying the media type icon and title.
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
                .font(.manrope(12 * viewModel.scale)) // Custom font, ensure it's defined elsewhere
                .foregroundStyle(.white)
                .lineLimit(2, reservesSpace: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Helper Views

/// A view displayed when the poster image is missing or failed to load.
struct MissingImageView: View {
    var error: Error?
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "photo.badge.exclamationmark")
                .imageScale(.large)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.white, .red)
            Text(errorMessage)
                .font(.caption)
                .foregroundColor(.red)
                .lineLimit(5)
                .multilineTextAlignment(.center)
        }
    }
    
    /// Generates an appropriate error message based on the error type.
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
        .hueBackground(hueColor: .pink) // Custom modifier, ensure it's defined elsewhere
}
