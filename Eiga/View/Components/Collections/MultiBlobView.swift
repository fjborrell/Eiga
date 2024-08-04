//
//  MultiBlobView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/27/24.
//

import SwiftUI
import Foundation

/// A view that displays multiple "blob" items in a carousel format.
struct MultiBlobView<Item: BlobDisplayable>: View {
    // MARK: - Environment
    @Environment(AppState.self) var appState: AppState
    
    // MARK: - State
    
    @Binding var activeIndex: Int
    @Binding var items: [Item]
    @State private var captionOpacity: Double = 1.0
    @State private var currentDragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @GestureState private var dragOffset: CGFloat = 0
    
    // MARK: - Constants
    
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    let activeBlobRatio: CGFloat // 1 = Whole Carousel
    private let blobCornerRadius: CGFloat = 16
    private let blobSpacing: CGFloat = 6
    private let activeIndicatorWidth: CGFloat = 55
    private let indicatorHeight: CGFloat = 7
    private let indicatorSpacing: CGFloat = 6
    private let indicatorCornerRadius: CGFloat = 20
    private let swipeInputRecognitionThreshhold: CGFloat = 0.20
    private let captionWidthRatio: CGFloat = 0.9
    
    // MARK: - Computed Properties
    
    private var totalSpacing: CGFloat {
        blobSpacing * CGFloat(items.count - 1)
    }
    
    private var adjustedBlobWidth: CGFloat {
        (containerWidth - totalSpacing) * activeBlobRatio
    }
    
    private var adjustedSmallBlobWidth: CGFloat {
        (containerWidth - totalSpacing - adjustedBlobWidth) / CGFloat(items.count - 1)
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
    
    private var widthDifference: CGFloat { adjustedBlobWidth - adjustedSmallBlobWidth }
    private var heightDifference: CGFloat { containerHeight - smallBlobHeight }
    
    private var isDraggingLeft: Bool { dragProgress < 0 }
    private var isDraggingRight: Bool { dragProgress > 0 }
    
    private var isDecrementable: Bool { activeIndex > 0 }
    private var isIncrementable: Bool { activeIndex < items.count - 1 }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            blobs
            scrollIndicator
        }
    }
    
    // MARK: - View Components
    
    private var blobs: some View {
        HStack(spacing: blobSpacing) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                ZStack() {
                    item.makeBlobView(isBlurred: !isActive(index))
                    if isActive(index) {
                        makeBlobCaption(item: item)
                            .opacity(captionOpacity)
                    }
                }
                .frame(
                    width: calculateBlobWidth(for: index),
                    height: calculateBlobHeight(for: index)
                )
                .mask(
                    RoundedRectangle(cornerRadius: self.blobCornerRadius)
                )
            }
        }
        .frame(width: containerWidth, height: containerHeight)
        .gesture(dragGesture)
        .animation(.smooth(), value: currentDragOffset)
    }
    
    private var scrollIndicator: some View {
        GeometryReader { geometry in
            HStack(spacing: indicatorSpacing) {
                ForEach(Array(0..<items.count), id: \.self) { index in
                    RoundedRectangle(cornerRadius: indicatorCornerRadius)
                        .fill(index == activeIndex ? appState.selectedMediaMode.color : .white)
                        .frame(
                            width: calculatePageIndicatorWidth(
                                for: index,
                                totalWidth: geometry.size.width
                            ),
                            height: indicatorHeight
                        )
                }
            }
        }
        .frame(width: indicatorContainerWidth, height: indicatorHeight)
        .animation(.smooth(), value: currentDragOffset)
        .gesture(dragGesture)
    }
    
    // MARK: - Helper Functions
    
    /// Creates a caption view for a blob item.
    /// - Parameter item: The item to create a caption for.
    /// - Returns: A view containing the item's caption.
    @ViewBuilder
    private func makeBlobCaption(item: Item) -> some View {
        Text(item.getCaption())
            .font(.manrope(20, .extraBold))
            .lineLimit(2)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .frame(width: adjustedBlobWidth * captionWidthRatio, height: smallBlobHeight, alignment: .bottom)
    }
    
    /// Checks if the given index is the active index.
    private func isActive(_ index: Int) -> Bool { index == activeIndex }
    
    /// Checks if the given index is the left neighbor of the active index.
    private func isLeftNeighbor(_ index: Int) -> Bool { index == activeIndex - 1 }
    
    /// Checks if the given index is the right neighbor of the active index.
    private func isRightNeighbor(_ index: Int) -> Bool { index == activeIndex + 1 }
    
    /// Checks if the given index is the leftmost blob.
    private func isLeftMostBlob(_ index: Int) -> Bool { index == 0 }
    
    /// Checks if the given index is the rightmost blob.
    private func isRightMostBlob(_ index: Int) -> Bool { index == (items.count - 1) }
    
    /// Checks if the user is dragging at the edge of the carousel.
    private func isDraggingAtEdge(_ index: Int) -> Bool {
        return isLeftMostBlob(index) && isDraggingRight || isRightMostBlob(index) && isDraggingLeft
    }
    
    // MARK: - Gesture Handling
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation.width
            }
            .onChanged { value in
                currentDragOffset = value.translation.width
                if !isDragging {
                    isDragging = true
                }
                updateCaptionOpacity(dragProgress: dragProgress)
            }
            .onEnded { value in
                handleDragEnd(translation: value.translation.width)
                isDragging = false
                withAnimation(.smooth()) {
                    captionOpacity = 1.0
                }
            }
    }
    
    /// Handles the end of a drag gesture.
    /// - Parameter translation: The total translation of the drag gesture.
    private func handleDragEnd(translation: CGFloat) {
        let progress = translation / containerWidth
        if abs(progress) > swipeInputRecognitionThreshhold {
            if progress > 0 && isDecrementable {
                activeIndex -= 1
            } else if progress < 0 && isIncrementable {
                activeIndex += 1
            }
        }
        currentDragOffset = 0
    }
    
    /// Updates the opacity of the caption based on drag progress.
    /// - Parameter dragProgress: The current drag progress.
    private func updateCaptionOpacity(dragProgress: CGFloat) {
        captionOpacity = 1.0 - min(abs(dragProgress), 1.0)
    }
    
    // MARK: - Calculation Functions
    
    /// Calculates the width of a blob for a given index.
    /// - Parameter index: The index of the blob.
    /// - Returns: The calculated width of the blob.
    private func calculateBlobWidth(for index: Int) -> CGFloat {
        let baseWidth = isActive(index) ? adjustedBlobWidth : adjustedSmallBlobWidth
        
        if isDraggingAtEdge(activeIndex) {
            return baseWidth
        }
        
        if isActive(index) {
            // Active blob shrinks as it's dragged
            return max(adjustedSmallBlobWidth, baseWidth - abs(dragProgress) * widthDifference)
        } else if isLeftNeighbor(index) && isDraggingRight {
            // Left neighbor grows when dragging right
            return min(baseWidth + (dragProgress * widthDifference), adjustedBlobWidth)
        } else if isRightNeighbor(index) && isDraggingLeft {
            // Right neighbor grows when dragging left
            return min(baseWidth - (dragProgress * widthDifference), adjustedBlobWidth)
        }
        
        return baseWidth
    }
    
    /// Calculates the height of a blob for a given index.
    /// - Parameter index: The index of the blob.
    /// - Returns: The calculated height of the blob.
    private func calculateBlobHeight(for index: Int) -> CGFloat {
        let baseHeight = isActive(index) ? containerHeight : smallBlobHeight
        
        if isActive(index) {
            // Active blob shrinks as it's dragged
            return max(smallBlobHeight, baseHeight - abs(dragProgress) * heightDifference)
        } else if isLeftNeighbor(index) && isDraggingRight {
            // Left neighbor grows when dragging right
            return baseHeight + dragProgress * heightDifference
        } else if isRightNeighbor(index) && isDraggingLeft {
            // Right neighbor grows when dragging left
            return baseHeight - dragProgress * heightDifference
        }
        
        return baseHeight
    }
   
    /// Calculates the width of a page indicator for a given index.
    /// - Parameters:
    ///   - index: The index of the indicator.
    ///   - totalWidth: The total width available for indicators.
    /// - Returns: The calculated width of the indicator.
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

private struct PreviewWrapper: View {
    @State private var activeIndex = 0
    @State private var mediaItems: [BlobMedia] = []
    let tmbd: TMBDService
    
    var body: some View {
        VStack {
            if !mediaItems.isEmpty {
                GeometryReader { geometry in
                    MultiBlobView(
                        activeIndex: $activeIndex,
                        items: self.$mediaItems,
                        containerWidth: geometry.size.width,
                        containerHeight: 190,
                        activeBlobRatio: 0.8
                    )
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await fetchMediaItems()
        }
    }
    
    /// Fetches media items for the preview
    func fetchMediaItems() async {
        let mediaIDs = [810693, 447365, 569094]
        for id in mediaIDs {
            if let item = try? await tmbd.fetchMovie(id: id) {
                mediaItems.append(BlobMedia(media: item))
            }
        }
    }
}

#Preview {
    PreviewWrapper(tmbd: TMBDService())
        .hueBackground(hueColor: .pink)
}
