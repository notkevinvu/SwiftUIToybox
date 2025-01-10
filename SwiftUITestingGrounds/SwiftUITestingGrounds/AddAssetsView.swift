//
//  AddAssetsView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/12/24.
//

import SwiftUI

struct AddAssetsView: View {
    @State var showProgress: Bool = true
    @State var showRoomScanActionSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("Upload Assets to Event")
                .fontWeight(.bold)
            
            addAssetButtonsList
        }
//        .progressOverlay("Testing background", shouldShowOverlay: $showProgress)
        .toastView(
            "Testing background",
            "Test subtitle",
            isToastPresented: $showProgress,
            toastType: .error,
            shouldShowProgressView: false
        )
        .confirmationDialog("Room Scan Type", isPresented: $showRoomScanActionSheet) {
            Button("Single scan") { }
            Button("Multi-room") { }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    @ViewBuilder
    var addAssetButtonsList: some View {
        List {
            Group {
                Label("Test", systemImage: "info.circle.fill")
                
                Button {
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
                
                Button {
                    showRoomScanActionSheet = true
                } label: {
                    Label("Room scan", systemImage: "rotate.3d")
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
