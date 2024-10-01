//
//  ProgressOverlayViewModifier.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 9/18/24.
//

import SwiftUI

struct ProgressOverlayViewModifier: ViewModifier {
    var progressText: String
    @Binding var shouldShowOverlay: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    Color.black
                        .opacity(0.6)
                    ProgressView {
                        Text(progressText)
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(.white.opacity(0.4))
                    .clipShape(.rect(cornerRadius: 10))
                    .opacity(shouldShowOverlay ? 1 : 0)
                }
            }
            .animation(.default, value: shouldShowOverlay)
            
    }
}

extension View {
    func progressOverlay(_ progressText: String, shouldShowOverlay: Binding<Bool>) -> some View {
        modifier(ProgressOverlayViewModifier(progressText: progressText, shouldShowOverlay: shouldShowOverlay))
    }
}
