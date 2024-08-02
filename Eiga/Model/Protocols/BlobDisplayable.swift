//
//  BlobDisplayable.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/28/24.
//

import Foundation
import SwiftUI

/// A protocol that defines requirements for objects that can be displayed as blobs.
protocol BlobDisplayable: Identifiable {
    /// The associated type for the blob view.
    associatedtype BlobView: View
    
    /// Creates a view for the blob, optionally blurred.
    /// - Parameter isBlurred: Whether the blob should be displayed with a blur effect.
    /// - Returns: A view representing the blob.
    @ViewBuilder func makeBlobView(isBlurred: Bool) -> BlobView
    
    /// Provides a caption for the blob.
    /// - Returns: A string caption for the blob.
    func getCaption() -> String
}

// MARK: - BlobDisplayable Extension

extension BlobDisplayable {
    /// A convenience method for making an unblurred blob.
    /// - Returns: An unblurred blob view.
    @ViewBuilder func makeBlobView() -> BlobView {
        makeBlobView(isBlurred: false)
    }
}

// MARK: - BlobMedia

/// A struct that represents media content as a blob.
struct BlobMedia: BlobDisplayable {
    // MARK: Properties
    
    /// A unique identifier for the blob.
    let id: UUID = UUID()
    
    /// The media content represented by this blob.
    let media: any Media
    
    // MARK: BlobDisplayable Conformance
    
    /// Creates a view for the media blob, optionally blurred.
    /// - Parameter isBlurred: Whether the blob should be displayed with a blur effect.
    /// - Returns: An AsyncImage view representing the media's backdrop.
    func makeBlobView(isBlurred: Bool) -> some View {
        AsyncImage(url: try? media.getBackdropURL(size: TMBDImageConfig.BackdropSize.w1280)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: isBlurred ? 1.5 : 0)
                    .overlay(isBlurred ? .black.opacity(0.35) : .clear)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            @unknown default:
                EmptyView()
            }
        }
    }

    /// Provides the title of the media as a caption.
    /// - Returns: The title of the media.
    func getCaption() -> String {
        return media.title
    }
}
