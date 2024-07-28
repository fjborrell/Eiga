//
//  BlobCarouselView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/27/24.
//

import SwiftUI
import Foundation

protocol CarouselDisplayable: Identifiable {
    associatedtype BlobView: View
    @ViewBuilder func makeBlobView() -> BlobView
}

struct CarouselImage: CarouselDisplayable {
    let id = UUID()
    let image: Image
    
    func makeBlobView() -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct CarouselMedia: CarouselDisplayable {
    let id: Int
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
}

struct BlobCarouselView<Item: CarouselDisplayable>: View {
    // MARK: - Properties
    
    @Binding var activeIndex: Int
    let items: [Item]
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    let blobWidth: CGFloat
    
    // MARK: - Gesture State
    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var currentDragOffset: CGFloat = 0
    
    // MARK: - Computed Properties
    
    private var smallBlobWidth: CGFloat {
        (containerWidth - blobWidth) / CGFloat(items.count - 1)
    }
    
    private var smallBlobHeight: CGFloat {
        containerHeight - (containerHeight * 0.2)
    }
    
    private var dragProgress: CGFloat {
        (dragOffset + currentDragOffset) / containerWidth
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    item.makeBlobView()
                        .frame(
                            width: calculateWidth(for: index),
                            height: calculateHeight(for: index)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 6)
                }
            }
            .frame(width: containerWidth, height: containerHeight)
            .animation(.smooth(), value: currentDragOffset)
            .gesture(dragGesture)
        }
    }
    
    // MARK: - Helper Properties and Methods
    
    private var widthDifference: CGFloat { blobWidth - smallBlobWidth }
    private var heightDifference: CGFloat { containerHeight - smallBlobHeight }
    
    private var isDraggingLeft: Bool { dragProgress < 0 }
    private var isDraggingRight: Bool { dragProgress > 0 }
    
    private var isDecrementable: Bool { activeIndex > 0 }
    private var isIncrementable: Bool { activeIndex < items.count - 1 }
    
    private func isActive(_ index: Int) -> Bool { index == activeIndex }
    private func isLeftNeighbor(_ index: Int) -> Bool { index == activeIndex - 1 }
    private func isRightNeighbor(_ index: Int) -> Bool { index == activeIndex + 1 }
    
    // MARK: - Gesture Helpers
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
            }
            .onChanged { value in
                currentDragOffset = value.translation.width
            }
            .onEnded { value in
                handleDragEnd(translation: value.translation.width)
            }
    }
    
    private func handleDragEnd(translation: CGFloat) {
        let threshold = containerWidth / 4
        if translation > threshold && isDecrementable {
            activeIndex -= 1
        } else if translation < -threshold && isIncrementable {
            activeIndex += 1
        }
        currentDragOffset = 0
    }
    
    private func calculateWidth(for index: Int) -> CGFloat {
        let baseWidth = isActive(index) ? blobWidth : smallBlobWidth
        
        if isActive(index) {
            return max(smallBlobWidth, baseWidth - abs(dragProgress) * widthDifference)
        } else if isLeftNeighbor(index) && isDraggingRight {
            return baseWidth + dragProgress * widthDifference
        } else if isRightNeighbor(index) && isDraggingLeft {
            return baseWidth - dragProgress * widthDifference
        }
        
        return baseWidth
    }
    
    private func calculateHeight(for index: Int) -> CGFloat {
        let baseHeight = isActive(index) ? containerHeight : smallBlobHeight
        
        if isActive(index) {
            return max(smallBlobHeight, baseHeight - abs(dragProgress) * heightDifference)
        } else if isLeftNeighbor(index) && isDraggingRight {
            return baseHeight + dragProgress * heightDifference
        } else if isRightNeighbor(index) && isDraggingLeft {
            return baseHeight - dragProgress * heightDifference
        }
        
        return baseHeight
    }
}

// MARK: - Preview
struct ParentView: View {
    @State private var activeIndex = 0
    @State private var mediaItems: [any Media] = []
    let tmbd: TMBDService
    let fetchMedia: (TMBDService, Int) async throws -> (any Media)?
    
    init(tmbd: TMBDService, fetchMedia: @escaping (TMBDService, Int) async throws -> (any Media)?) {
        self.tmbd = tmbd
        self.fetchMedia = fetchMedia
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if !mediaItems.isEmpty {
                    BlobCarouselView(
                        activeIndex: $activeIndex,
                        items: mediaItems.map { CarouselMedia(id: $0.id, media: $0) },
                        containerWidth: geometry.size.width,
                        containerHeight: 190,
                        blobWidth: 280
                    )
                    
                    // Pagination indicator
                    HStack {
                        ForEach(0..<mediaItems.count, id: \.self) { index in
                            Circle()
                                .fill(index == activeIndex ? Color.blue : Color.gray)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding()
                } else {
                    ProgressView()
                }
            }
        }
        .padding(30)
        .task {
            await fetchMediaItems()
        }
    }
    
    func fetchMediaItems() async {
        let mediaIDs = [810693, 447365, 569094]
        for id in mediaIDs {
            do {
                if let item = try await fetchMedia(tmbd, id) {
                    mediaItems.append(item)
                }
            } catch {
                print("Error fetching media \(id): \(error)")
            }
        }
    }
}

// Helper struct to create the preview
private struct PreviewWrapper: View {
    let tmbd = TMBDService()
    
    var body: some View {
        ParentView(tmbd: tmbd) { service, id in
            try await service.fetchMovie(id: id)
        }
        .hueBackground(hueColor: .pink)
    }
}

#Preview {
    PreviewWrapper()
}
