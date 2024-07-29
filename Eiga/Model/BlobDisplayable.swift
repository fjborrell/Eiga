//
//  BlobDisplayable.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/28/24.
//

import Foundation
import SwiftUI

protocol BlobDisplayable: Identifiable {
    associatedtype BlobView: View
    @ViewBuilder func makeBlobView(isBlurred: Bool) -> BlobView
    func getCaption() -> String
}

extension BlobDisplayable {
    @ViewBuilder func makeBlobView() -> BlobView {
        makeBlobView(isBlurred: false)
    }
}

struct BlobMedia: BlobDisplayable {
    let id: UUID = UUID()
    let media: any Media
    
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

    func getCaption() -> String {
        return media.title
    }
}
