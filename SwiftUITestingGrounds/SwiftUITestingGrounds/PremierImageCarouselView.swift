//
//  PremierImageCarouselView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 9/30/24.
//

import SwiftUI

// MARK: -- Holder view
struct PremierImageCarouselHolderView: View {
    @Environment(ImageCarouselViewModel.self) var viewModel
    
    var body: some View {
        MediaItemGridView()
            .padding(.horizontal, 8)
            .allowsHitTesting(viewModel.selectedItem == nil)
            .overlay {
                Rectangle()
                    .fill(.background)
                    .ignoresSafeArea()
                    .opacity(viewModel.animateView ? (1 - viewModel.dragProgress) : 0)
            }
    }
}

// MARK: -- Grid view

struct MediaItemGridView: View {
    
    @Environment(ImageCarouselViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(spacing: 3), count: 3),
                        spacing: 3
                    ) {
                        ForEach($viewModel.items) { $item in
                            gridImageView($item)
                        }
                    }
                    .padding(.vertical, 15)
                }
            }
            .onChange(of: viewModel.selectedItem) { oldValue, newValue in
                if let item = viewModel.items.first(where: { $0.id == newValue?.id }),
                   !item.appeared
                {
                    scrollProxy.scrollTo(item.id, anchor: .bottom)
                }
            }
        }
        .navigationTitle("Test images")
    }
    
    @ViewBuilder
    func gridImageView(_ mediaItem: Binding<TempMediaItem>) -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .anchorPreference(key: HeroKey.self, value: .bounds) { anchor in
                    return [mediaItem.id + "SOURCE": anchor]
                }
            Image(uiImage: mediaItem.thumbnailImage.wrappedValue)
                .squareOriginalAspectRatioImage()
                .opacity(viewModel.selectedItem?.id == mediaItem.id ? 0 : 1)
        }
        .id(mediaItem.id)
        .didFrameChange { frame, bounds in
            let minY = frame.minY
            let maxY = frame.maxY
            let height = bounds.height
            
            if maxY < 0 || minY > height {
                mediaItem.appeared.wrappedValue = false
            } else {
                mediaItem.appeared.wrappedValue = true
            }
        }
        .onDisappear {
            mediaItem.appeared.wrappedValue = false
        }
        .onTapGesture {
            viewModel.selectedItem = mediaItem.wrappedValue
        }
    }
}

// MARK: -- Detail carousel

struct ImageDetailCarouselView: View {
    @Environment(ImageCarouselViewModel.self) var viewModel
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            detailCarouselView
            
            bottomIndicatorCarouselView()
        }
        .onAppear {
            viewModel.toggleView(show: true)
        }
    }
    
    @ViewBuilder
    var navigationBar: some View {
        HStack {
            Button {
                viewModel.toggleView(show: false)
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    
                    Text("Back")
                }
            }
            
            Spacer(minLength: 0)
            
            Menu {
                Button {
                    print("TODO: IMPLEMENT SHARE")
                } label: {
                    Label("Share image", systemImage: "square.and.arrow.up")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .symbolVariant(.circle)
            }
        }
        .padding([.top, .horizontal], 15)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .offset(y: viewModel.showDetailView ? (-120 * viewModel.dragProgress) : -120)
        .animation(
            .easeInOut(duration: 0.1),
            value: viewModel.showDetailView
        )
    }
    
    @ViewBuilder
    var detailCarouselView: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.items) { item in
                        carouselImageView(item, size: size)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollPosition(
                id: .init(
                    get: {
                        return viewModel.detailScrollPosition
                    }, set: {
                        viewModel.detailScrollPosition = $0
                    }
                )
            )
            .onChange(of: viewModel.detailScrollPosition) { oldValue, newValue in
                viewModel.detailPageDidChange()
            }
            .background {
                if let selectedItem = viewModel.selectedItem {
                    Rectangle()
                        .fill(.clear)
                        .anchorPreference(key: HeroKey.self, value: .bounds) { anchor in
                            return [selectedItem.id + "DEST": anchor]
                        }
                }
            }
            .offset(viewModel.offset)
            
            Rectangle()
                .foregroundStyle(.clear)
                .frame(width: 10)
                .contentShape(.rect)
                .simultaneousGesture(
                    dismissDragGesture(size: size)
                )
        }
        .opacity(viewModel.showDetailView ? 1 : 0)
    }
    
    @ViewBuilder
    func carouselImageView(_ item: TempMediaItem, size: CGSize) -> some View {
//        PhotoDetailView(image: item.primaryImage)
//            .frame(width: size.width, height: size.height)
        Image(uiImage: item.primaryImage)
            .resizable()
            .scaledToFit()
            .frame(width: size.width, height: size.height)
            .clipped()
            .contentShape(.rect)
    }
    
    @ViewBuilder
    func bottomIndicatorCarouselView() -> some View {
        @Bindable var viewModel = viewModel
        
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 5) {
                    ForEach(viewModel.items) { item in
                        Image(uiImage: item.thumbnailImage)
                            .squareOriginalAspectRatioImage(dimension: 50)
                            .onTapGesture {
                                viewModel.didSelectItemInBottomCarousel(item: item)
                            }
                    }
                }
                .padding(.vertical, 10)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollPosition(id: .init(get: {
                return viewModel.detailIndicatorPosition
            }, set: {
                viewModel.detailIndicatorPosition = $0
            }))
            .safeAreaPadding(.horizontal, (size.width - 50) / 2)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 50, height: 50)
                    .allowsHitTesting(false)
            }
            .onChange(of: viewModel.detailIndicatorPosition) { oldValue, newValue in
                viewModel.detailIndicatorDidChange()
            }
        }
        .frame(height: 70)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
        .offset(y: viewModel.showDetailView ? (120 * viewModel.dragProgress) : 120)
        .animation(.easeInOut(duration: 0.1), value: viewModel.showDetailView)
    }
    
    private func dismissDragGesture(size: CGSize) -> some Gesture {
        @Bindable var viewModel = viewModel
        
        return DragGesture(minimumDistance: 0)
            .onChanged { value in
                let translation = value.translation
                viewModel.offset = translation
                print("translation: \(translation)")
                
                // progress for fading out detail view
                // can also use width to compute
                let heightProgress = max(min(translation.height / 200, 1), 0)
                viewModel.dragProgress = heightProgress
            }
            .onEnded { value in
                let translation = value.translation
                let velocity = value.velocity
                // can use width to dismiss as well but just using height here
//                            let width = translation.width + (velocity.width / 5)
                let height = translation.height + (velocity.height / 5)
                
                if height > (size.height * 0.5) {
                    // close view
                    
                    viewModel.toggleView(show: false)
                } else {
                    // reset to origin
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.offset = .zero
                        viewModel.dragProgress = 0
                    }
                }
            }
    }
}

// MARK: -- Hero layer

struct HeroLayer: View {
    @Environment(ImageCarouselViewModel.self) var viewModel
    var item: TempMediaItem
    var sAnchor: Anchor<CGRect>
    var dAnchor: Anchor<CGRect>
    
    var body: some View {
        GeometryReader { proxy in
            let sRect = proxy[sAnchor]
            let dRect = proxy[dAnchor]
            let animateView = viewModel.animateView
            
            let viewSize: CGSize = .init(
                width: animateView ? dRect.width : sRect.width,
                height: animateView ? dRect.height : sRect.height
            )
            
            let viewPosition: CGSize = .init(
                width: animateView ? dRect.minX : sRect.minX,
                height: animateView ? dRect.minY : sRect.minY
            )
            
            if !viewModel.showDetailView {
                Image(uiImage: item.primaryImage)
                    .resizable()
                    .aspectRatio(contentMode: animateView ? .fit : .fill)
                    .frame(width: viewSize.width, height: viewSize.height)
                    .clipped()
                    .offset(viewPosition)
                    .transition(.identity)
            }
        }
    }
}

struct HeroKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

// MARK: -- Preview

#Preview {
    let viewModel: ImageCarouselViewModel = .init()
    
    return PremierImageCarouselHolderView()
        .environment(viewModel)
        .preferredColorScheme(.dark)
}

// MARK: -- Coordinator/view model

@Observable
final class ImageCarouselViewModel {
    
    var items: [TempMediaItem] = largeResizedImages.compactMap {
        TempMediaItem(
            primaryImage: $0,
            thumbnailImage: $0.resizeImage(newWidth: 200) ?? $0
        )
    }
    
    var selectedItem: TempMediaItem?
    var animateView: Bool = false
    var showDetailView: Bool = false
    
    // Scroll positions
    var detailScrollPosition: String?
    var detailIndicatorPosition: String?
    
    // Gesture properties
    var offset: CGSize = .zero
    var dragProgress: CGFloat = 0
    
    func detailPageDidChange() {
        if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
            selectedItem = updatedItem
            withAnimation(.easeInOut(duration: 0.1)) {
                detailIndicatorPosition = updatedItem.id
            }
        }
    }
    
    func detailIndicatorDidChange() {
        if let updatedItem = items.first(where: { $0.id == detailIndicatorPosition }) {
            selectedItem = updatedItem
            withAnimation(.easeInOut(duration: 0.1)) {
                detailScrollPosition = updatedItem.id
            }
        }
    }
    
    func didSelectItemInBottomCarousel(item: TempMediaItem) {
        withAnimation(.easeInOut(duration: 0.1)) {
            detailIndicatorPosition = item.id
            detailIndicatorDidChange()
        }
    }
    
    func toggleView(show: Bool) {
        if show {
            // this will trigger the carousel scrollview to scroll to the
            // selected item
            detailScrollPosition = selectedItem?.id
            detailIndicatorPosition = selectedItem?.id
            
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 0.2), completionCriteria: .removed) {
                animateView = false
                offset = .zero
            } completion: {
                self.resetAnimationProperties()
            }
        }
    }
    
    func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil
        detailIndicatorPosition = nil
        offset = .zero
        dragProgress = 0
    }
}

extension View {
    /// This modifier will extract the item's position in the scroll view
    /// as well as the scrollview bounds values, which we can then use to
    /// determine whether the item is visible or not.
    @ViewBuilder
    func didFrameChange(result: @escaping (CGRect, CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let frame = proxy.frame(in: .scrollView(axis: .vertical))
                    let bounds = proxy.bounds(of: .scrollView(axis: .vertical)) ?? .zero
                    
                    Color.clear
                        .preference(key: FrameKey.self, value: .init(frame: frame, bounds: bounds))
                        .onPreferenceChange(FrameKey.self) { value in
                            result(value.frame, value.bounds)
                        }
                }
            }
    }
}

struct ViewFrame: Equatable {
    var frame: CGRect = .zero
    var bounds: CGRect = .zero
}

struct FrameKey: PreferenceKey {
    static var defaultValue: ViewFrame = .init()
    static func reduce(value: inout ViewFrame, nextValue: () -> ViewFrame) {
        value = nextValue()
    }
}

// MARK: -- Media item struct
struct TempMediaItem: Identifiable, Equatable {
    let id: String = UUID().uuidString
    var primaryImage: UIImage
    var thumbnailImage: UIImage
    var appeared: Bool = false
}
