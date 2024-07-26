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
    let size: TMBDImageConfig.PosterSize = .original

    @State private var posterURL: URL?
    @State private var errorMessage: String?
    
    var body: some View {
        VStack() {
            AsyncImage(url: posterURL) { state in
                switch state {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 176)
            .onAppear {
                loadPosterURL()
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(MediaMode.movie.color.opacity(0.35))
                        .frame(width: 14, height: 14)
                    Image(systemName: MediaMode.movie.iconName)
                        .imageScale(.small)
                        .foregroundStyle(MediaMode.movie.color)
                }
                
                Text(media.title)
                    .font(.manrope(12))
                    .lineLimit(2, reservesSpace: true)
            }
            .frame(width: <#T##CGFloat?#>)
            
        }
    }
    
    private func loadPosterURL() {
        do {
            posterURL = try media.getPosterURL(size: size)
        } catch ImageError.missingImagePath {
            errorMessage = "No poster available"
        } catch ImageError.invalidURL {
            errorMessage = "Invalid poster URL"
        } catch {
            errorMessage = "Unexpected error"
        }
    }
}
