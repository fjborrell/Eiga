//
//  MultiBlobView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/27/24.
//

import SwiftUI
import Foundation

struct MultiBlobView<Item: BlobDisplayable>: View {
    // MARK: - Properties
    
    @Binding var activeIndex: Int
    let items: [Item]
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    let blobWidth: CGFloat
    let cornerRadius: CGFloat = 16
    let activeIndicatorWidth: CGFloat = 55
    let indicatorHeight: CGFloat = 7
    let indicatorSpacing: CGFloat = 6
    let blobSpacing: CGFloat = 6
    @State private var textOpacity: Double = 1.0
    
    // MARK: - Gesture State
    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var currentDragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    // MARK: - Computed Properties
    
    private var smallBlobWidth: CGFloat {
        (containerWidth - blobWidth) / CGFloat(items.count - 1)
    }
    
    private var smallBlobHeight: CGFloat {
        containerHeight - (containerHeight * 0.2)
    }
    
    private var inactiveIndicatorWidth: CGFloat {
        self.activeIndicatorWidth * 0.3
    }
    
    private var indicatorContainerWidth: CGFloat {
        self.activeIndicatorWidth + (inactiveIndicatorWidth * CGFloat(items.count - 1))
    }
    
    private var dragProgress: CGFloat {
        (dragOffset + currentDragOffset) / containerWidth
    }
    
    private func makeBlobCaption(item: Item) -> some View {
        VStack {
            Spacer()
            Text(item.getCaption())
                .font(.manrope(20, .extraBold))
                .frame(width: blobWidth)
                .lineLimit(2)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .opacity(textOpacity)
                .padding()
        }
    }

    private var blobs: some View {
        HStack(spacing: blobSpacing) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                ZStack() {
                    item.makeBlobView(isBlurred: !isActive(index))
                }
                .frame(
                    width: calculateBlobWidth(for: index),
                    height: calculateBlobHeight(for: index)
                )
                .overlay(
                    isActive(index) ? makeBlobCaption(item: item) : nil
                )
                .overlay(
                    isActive(index) ? .clear : .black.opacity(0.15)
                )
                .mask(
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                )
            }
        }
        .frame(width: containerWidth, height: containerHeight)
        .gesture(dragGesture)
        .animation(.smooth(), value: currentDragOffset)
    }
    
    private var scrollIndicator: some View {
        GeometryReader { geometry in
            HStack(spacing: 6) {
                ForEach(Array(0..<items.count), id: \.self) { index in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(index == activeIndex ? .pink : .white)
                        .frame(
                            width: calculatePageIndicatorWidth(for: index, totalWidth: geometry.size.width),
                            height: indicatorHeight
                        )
                }
            }
        }
        .frame(width: indicatorContainerWidth, height: indicatorHeight)
        .animation(.smooth(), value: currentDragOffset)
        .gesture(dragGesture)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            blobs
            scrollIndicator
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
                if !isDragging {
                    isDragging = true
                    withAnimation(.easeOut(duration: 0.1)) {
                        textOpacity = 0.0
                    }
                }
            }
            .onEnded { value in
                handleDragEnd(translation: value.translation.width)
                isDragging = false
                withAnimation(.easeIn(duration: 0.25)) {
                    textOpacity = 1.0
                }
            }
    }
    
    private func handleDragEnd(translation: CGFloat) {
        let progress = translation / containerWidth
        if abs(progress) > 0.35 {
            if progress > 0 && isDecrementable {
                activeIndex -= 1
            } else if progress < 0 && isIncrementable {
                activeIndex += 1
            }
        }
        currentDragOffset = 0
    }
    
    private func calculateBlobWidth(for index: Int) -> CGFloat {
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
    
    private func calculateBlobHeight(for index: Int) -> CGFloat {
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
    
    private func calculatePageIndicatorWidth(for index: Int, totalWidth: CGFloat) -> CGFloat {
        let activeWidth = activeIndicatorWidth
        let inactiveWidth = inactiveIndicatorWidth
        let progress = CGFloat(activeIndex) - dragProgress
        
        let distance = CGFloat(index) - progress
        let normalized = 1 - min(abs(distance), 1)
        
        return inactiveWidth + (activeWidth - inactiveWidth) * normalized
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
                    MultiBlobView(
                        activeIndex: $activeIndex,
                        items: mediaItems.map { BlobMedia(media: $0) },
                        containerWidth: geometry.size.width,
                        containerHeight: 190,
                        blobWidth: 280
                    )
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
