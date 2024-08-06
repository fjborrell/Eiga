//
//  MediaRowView.swift
//  Eiga
//
//  Created by Fernando Borrell on 8/4/24.
//

import SwiftUI

// MARK: - View Model

/// A view model for managing a media item as a single row
@Observable
class MediaRowViewModel: Identifiable {
    
    // MARK: - State
    
    /// The media item represented by this poster.
    let media: any Media
    
    /// The URL of the poster image.
    var posterURL: URL?
    
    /// The quality of the poster image to fetch.
    var imageQuality: TMBDImageConfig.PosterSize = .w500
    
    /// Any error encountered while loading the poster.
    var posterError: Error?
    
    // MARK: - Initialization
    
    /// Initializes a new media row view model.
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
}

// MARK: - View

/// A view that displays a row for a media item.
struct MediaRowView: View {
    @State var viewModel: MediaRowViewModel
    
    var body: some View {
        HStack(spacing: 9) {
            rowImage
            rowLabel
        }
    }
    
    /// The rounded poster image view, which asynchronously loads the image.
    var rowImage: some View {
        AsyncImage(url: viewModel.posterURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .aspectRatio(contentMode: .fit)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                MissingImageView(error: viewModel.posterError)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    /// A label of the associated media, stating release year and producer.
    var rowLabel: some View {
        VStack(alignment: .leading) {
            let title: String = viewModel.media.title
            let releaseYear: Int = viewModel.media.voteCount
            let producer: String = viewModel.media.productionCompanies.first?.name ?? "Unknown"
            Text(title)
                .font(.manrope(14, .regular))
            Text("\(releaseYear), \(producer)")
                .font(.manrope(10, .extraLight))
        }
        .foregroundStyle(.white)
    }
}


// MARK: - Preview

private struct PreviewWrapper: View {
    let tmbd = TMBDService()
    @State var movie: (any Media)?
    
    var body: some View {
        Group {
            if let movie = movie {
                MediaRowView(viewModel: MediaRowViewModel(media: movie))
            } else {
                ProgressView()
            }
        }
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
