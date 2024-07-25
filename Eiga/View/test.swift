//
//  test.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/24/24.
//

import Foundation
import SwiftUI

struct MoviePosterView: View {
    let movie: Movie
    let size: TMBDImageConfig.PosterSize
    
    @State private var posterURL: URL?
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 225)
            .onAppear {
                loadPosterURL()
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Text(movie.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
    
    private func loadPosterURL() {
        do {
            posterURL = try movie.getPosterURL(size: size)
        } catch ImageError.missingImagePath {
            errorMessage = "No poster available"
        } catch ImageError.invalidURL {
            errorMessage = "Invalid poster URL"
        } catch {
            errorMessage = "Unexpected error"
        }
    }
}
