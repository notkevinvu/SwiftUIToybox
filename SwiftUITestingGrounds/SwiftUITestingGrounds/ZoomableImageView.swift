//
//  ZoomableImageView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/19/24.
//

import SwiftUI
import PDFKit
import UIKit

// MARK: -- Horizontal zoomable carousel
struct HorizontalZoomableImageCarouselView: View {
    @State private var scrollPositionIndex: Int?
    
    var body: some View {
        VStack {
            scrollViewTest
            //        pagedTabViewTest
        }
        .safeAreaInset(edge: .bottom) {
            miniCarouselView
        }
    }
    
    @ViewBuilder
    var scrollViewTest: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(0..<largeResizedImages.count, id: \.self) { imageIndex in
//                    ZoomableImageView(image: Image(uiImage: uiImage))
                    PhotoDetailView(image: largeResizedImages[imageIndex])
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .animation(.default, value: scrollPositionIndex)
        .scrollPosition(id: $scrollPositionIndex, anchor: .center)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
    }
    
    @State var currentImageIndex: Int = 0
    
    @ViewBuilder
    var miniCarouselView: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<resizedTestImages.count, id: \.self) { imageIndex in
                                Image(uiImage: resizedTestImages[imageIndex])
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(.rect(cornerRadius: 8))
                                    .id(imageIndex)
                                    .onTapGesture {
                                        scrollPositionIndex = imageIndex
                                    }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(
                        .horizontal,
                        EdgeInsets(
                            top: 0,
                            leading: ((proxy.size.width / 2) - 50),
                            bottom: 0,
                            trailing: ((proxy.size.width / 2) - 50)
                        ),
                        for: .scrollContent
                    )
                    .scrollPosition(id: $scrollPositionIndex, anchor: .center)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.never)
                    .frame(height: 80)
                }
            }
        }
    }
    
    @ViewBuilder
    var pagedTabViewTest: some View {
        TabView {
            ForEach(largeResizedImages) { uiImage in
                ZoomableImageView(image: Image(uiImage: uiImage))
//                PhotoDetailView(image: uiImage)
//                    .containerRelativeFrame(.horizontal)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
}

// MARK: -- Zoomable image
struct ZoomableImageView: View {
    
    let image: Image
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    
    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero
    
    public init(image: Image) {
        self.image = image
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(x: offset.x, y: offset.y)
                    .simultaneousGesture(makeMagnificationGesture(size: proxy.size))
                    .simultaneousGesture(makeDoubleTapMagnificationGesture(size: proxy.size))
                    .highPriorityGesture(makeDragGesture(size: proxy.size))
            }
            .animation(.default, value: scale)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private func makeDoubleTapMagnificationGesture(size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded { _ in
                if scale != 1 {
                    scale = 1
                    offset = .zero
                    return
                } else {
                    scale *= 2
                }
            }
    }
    
    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value
                
                // To minimize jittering
                if abs(1 - delta) > 0.01 {
                    scale *= delta
                }
            }
            .onEnded { _ in
                lastScale = 1
                if scale < 1 {
                    withAnimation {
                        scale = 1
                    }
                }
                adjustMaxOffset(size: size)
            }
    }
    
    private func makeDragGesture(size: CGSize) -> some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                guard scale != 1 else { return }
                let diff = CGPoint(
                    x: value.translation.width - lastTranslation.width,
                    y: value.translation.height - lastTranslation.height
                )
                offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
                lastTranslation = value.translation
            }
            .onEnded { _ in
                guard scale != 1 else { return }
                
                adjustMaxOffset(size: size)
            }
    }
    
    private func adjustMaxOffset(size: CGSize) {
        let maxOffsetX = (size.width * (scale - 1)) / 2
        let maxOffsetY = (size.height * (scale - 1)) / 2
        
        var newOffsetX = offset.x
        var newOffsetY = offset.y
        
        print("Max offset: \(maxOffsetX)")
        print("New offset before calcs - x: \(newOffsetX), y: \(newOffsetY)")
        
        if abs(newOffsetX) > maxOffsetX {
            newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
        }
        if abs(newOffsetY) > maxOffsetY {
            newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
        }
        
        let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
        print("New offset after calcs: \(newOffset)")
        if newOffset != offset {
            withAnimation {
                offset = newOffset
            }
        }
        self.lastTranslation = .zero
    }
}

// MARK: -- Photo Detail pdf
struct PhotoDetailView: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument()
        guard let page = PDFPage(image: image) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
        view.hideScrollViewIndicator()
        
        view.pageShadowsEnabled = false
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        
    }
}

extension PDFView {
    func hideScrollViewIndicator() {
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                return
            }
        }
    }
}

#Preview {
//    ZoomableImageView(image: testImageOne)
    HorizontalZoomableImageCarouselView()
}
