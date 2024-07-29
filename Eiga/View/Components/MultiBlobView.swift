//
//  MultiBlobView.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/27/24.
//

import SwiftUI
import Foundation

/// A carousel-style view for items ("blobs"), with interactive gestures and animations
struct MultiBlobView<Item: BlobDisplayable>: View {
    // MARK: - Properties
    
    @Binding var activeIndex: Int
    let items: [Item]
    let containerWidth: CGFloat
    let containerHeight: CGFloat
    let blobWidth: CGFloat
    
    // MARK: - Constants
    
    private let blobCornerRadius: CGFloat = 16
    private let blobSpacing: CGFloat = 6
    private let activeIndicatorWidth: CGFloat = 55
    private let indicatorHeight: CGFloat = 7
    private let indicatorSpacing: CGFloat = 6
    private let indicatorCornerRadius: CGFloat = 20
    private let swipeInputRecognitionThreshhold: CGFloat = 0.20
    
    // MARK: - State
    
    @State private var textOpacity: Double = 1.0
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
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            blobs
            scrollIndicator
        }
    }
    
    // MARK: - Subviews

    // Creates the swipeable item "blob" carousel
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
                .mask(
                    RoundedRectangle(cornerRadius: self.blobCornerRadius)
                )
            }
        }
        .frame(width: containerWidth, height: containerHeight)
        .gesture(dragGesture)
        .animation(.smooth(), value: currentDragOffset)
    }
    
    // Creates the scroll/page indicator for the carousel
    private var scrollIndicator: some View {
        GeometryReader { geometry in
            HStack(spacing: indicatorSpacing) {
                ForEach(Array(0..<items.count), id: \.self) { index in
                    RoundedRectangle(cornerRadius: indicatorCornerRadius)
                        .fill(index == activeIndex ? .pink : .white)
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
    
    // Creates the caption to be overlayed over each blob
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
    private func isLeftMostBlob(_ index: Int) -> Bool { index == 0 }
    private func isRightMostBlob(_ index: Int) -> Bool { index == (items.count - 1) }
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
        if abs(progress) > swipeInputRecognitionThreshhold {
            if progress > 0 && isDecrementable {
                activeIndex -= 1
            } else if progress < 0 && isIncrementable {
                activeIndex += 1
            }
        }
        currentDragOffset = 0
    }
    
    // MARK: - Calculation Methods
    
    /// Calculates the width of a blob based on its index and drag progress
    /// - Parameter index: The index of the blob
    /// - Returns: The calculated width of the blob
    private func calculateBlobWidth(for index: Int) -> CGFloat {
        let baseWidth = isActive(index) ? blobWidth : smallBlobWidth
        
        if isDraggingAtEdge(activeIndex) {
            return baseWidth
        }
        
        if isActive(index) {
            // Active blob shrinks as it's dragged
            return max(smallBlobWidth, baseWidth - abs(dragProgress) * widthDifference)
        } else if isLeftNeighbor(index) && isDraggingRight {
            // Left neighbor grows when dragging right
            return min(baseWidth + (dragProgress * widthDifference), blobWidth)
        } else if isRightNeighbor(index) && isDraggingLeft {
            // Right neighbor grows when dragging left
            return min(baseWidth - (dragProgress * widthDifference), blobWidth)
        }
        
        return baseWidth
    }
    
    /// Calculates the height of a blob based on its index and drag progress
    /// - Parameter index: The index of the blob
    /// - Returns: The calculated height of the blob
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
    
    /// Calculates the width of a page indicator based on its index and drag progress
    /// - Parameters:
    ///   - index: The index of the indicator
    ///   - totalWidth: The total width of the indicator container
    /// - Returns: The calculated width of the indicator
    private func calculatePageIndicatorWidth(for index: Int, totalWidth: CGFloat) -> CGFloat {
        let activeWidth = activeIndicatorWidth
        let inactiveWidth = inactiveIndicatorWidth
        let progress = CGFloat(activeIndex) - dragProgress
        
        // Calculate distance from the current progress
        let distance = CGFloat(index) - progress
        // Normalize the distance to a 0-1 range
        let normalized = 1 - min(abs(distance), 1)
        
        // Interpolate between inactive and active widths based on normalized distance
        return inactiveWidth + (activeWidth - inactiveWidth) * normalized
    }
}

//MARK: - Preview

private struct PreviewWrapper: View {
    @State private var activeIndex = 0
    @State private var mediaItems: [any Media] = []
    let tmbd: TMBDService
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if !mediaItems.isEmpty {
                    MultiBlobView(
                        activeIndex: $activeIndex,
                        items: mediaItems.map(BlobMedia.init),
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
            if let item = try? await tmbd.fetchMovie(id: id) {
                mediaItems.append(item)
            }
        }
    }
}

#Preview {
    PreviewWrapper(tmbd: TMBDService())
        .hueBackground(hueColor: .pink)
}
