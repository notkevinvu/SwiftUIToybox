//
//  AddAssetsView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/12/24.
//

import SwiftUI

struct AddAssetsView: View {
    @State var showProgress: Bool = true
    
    var body: some View {
        VStack {
            Text("Upload Assets to Event")
                .fontWeight(.bold)
            
            addAssetButtonsList
        }
        .progressOverlay("Testing background", shouldShowOverlay: $showProgress)
    }
    
    @ViewBuilder
    var addAssetButtonsList: some View {
        List {
            Group {
                Label("Test", systemImage: "info.circle.fill")
                
                Button {
                    print("Camera")
                    showProgress.toggle()
                } label: {
                    Label("Camera", systemImage: "camera")
                }
                .foregroundStyle(.white)
                
                Button {
                    print("Photos")
                    showProgress = true
                } label: {
                    Label("Photos", systemImage: "photo.stack")
                }
                .foregroundStyle(.white)
                
                Button {
                    print("Files")
                    showProgress = true
                } label: {
                    Label("Files", systemImage: "doc")
                }
                .foregroundStyle(.white)
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                -20
            }
            .padding(.vertical, 7.5)
        }
        
    }
}

#Preview {
    AddAssetsView()
        .preferredColorScheme(.dark)
}

struct ProgressOverlayViewModifier: ViewModifier {
    var progressText: String
    @Binding var shouldShowOverlay: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay {
//                ZStack {
//                    Color.black
//                        .opacity(0.6)
//                    ProgressView {
//                        Text(progressText)
//                    }
//                    .foregroundStyle(.white)
//                    .padding()
//                    .background(.white.opacity(0.4))
//                    .clipShape(.rect(cornerRadius: 10))
//                    .opacity(shouldShowOverlay ? 1 : 0)
//                }
                
                if shouldShowOverlay {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            ProgressView()
                                .tint(.black)
                            
                            Text("Loading events...")
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Button {
                                shouldShowOverlay = false
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 8))
                    }
                    .padding(.horizontal, 24)
                    .transition(.asymmetric(insertion: .offset(y: 200), removal: .offset(y: 200)))
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
