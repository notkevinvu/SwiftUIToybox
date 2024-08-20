//
//  ImageZoomView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/19/24.
//

import SwiftUI

struct ImageZoomView: View {
    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    var body: some View {
        testImageOne
            .resizable()
            .scaledToFit()
            .scaleEffect(currentZoom + totalZoom)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentZoom = value.magnification - 1
                    }
                    .onEnded { value in
                        totalZoom += currentZoom
                        currentZoom = 0
                    }
            )
    }
}

#Preview {
    ImageZoomView()
}
