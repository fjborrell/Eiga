//
//  MoviePosterView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation
import SwiftUI

struct PosterView<M: Media>: View {
    let media: M
    @State var height: CGFloat = 176
    @State private var posterURL: URL?
    @State var imageQuality: TMBDImageConfig.PosterSize = .w500
    @State var posterError: Error?
    
    var body: some View {
        VStack(spacing: 9) {
            self.posterImage
            self.posterLabel
        }
    }
    
    var posterImage: some View {
        AsyncImage(url: self.posterURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .aspectRatio(contentMode: .fit)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            case .failure:
                MissingImageView(error: posterError)
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: self.height)
        .onAppear {
            loadPosterURL()
        }
    }
    
    var posterLabel: some View {
        HStack(alignment: .top) {
            Circle()
                .frame(width: 17, height: 17)
                .opacity(0.25)
                .overlay(
                    Image(systemName: MediaMode.movie.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 10)
                )
                .foregroundStyle(MediaMode.movie.color)
            
            Text(media.title)
                .font(.manrope(12))
                .foregroundStyle(.white)
                .lineLimit(2, reservesSpace: true)
        }
    }
    
    private func loadPosterURL() {
        do {
            posterURL = try media.getPosterURL(size: self.imageQuality)
            posterError = nil
        } catch {
            posterError = error
            posterURL = nil
        }
    }
}

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
    @State private var movie: Movie?
    
    var body: some View {
        Group {
            if let movie = movie {
                PosterView(media: movie)
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
