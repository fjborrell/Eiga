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
    @ViewBuilder func makeBlobView() -> BlobView
    func getCaption() -> String
}

struct BlobImage: BlobDisplayable {
    let id = UUID()
    let image: Image
    
    func makeBlobView() -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    func getCaption() -> String {
        return String()
    }
}

struct BlobMedia: BlobDisplayable {
    let id: UUID = UUID()
    let media: any Media
    
    func makeBlobView() -> some View {
        AsyncImage(url: try? media.getBackdropURL(size: TMBDImageConfig.BackdropSize.w1280)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
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
