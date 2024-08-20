//
//  ThumbnailView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/25/24.
//

import SwiftUI

struct ThumbnailView: View {
    
    @ObservedObject var thumbnailGenerator = ThumbnailGenerator()
    
    var body: some View {
        VStack {
            Text("USDZ Thumbnail")
                .font(.largeTitle)
            
            if let thumbnailImage = thumbnailGenerator.thumbnailImage {
                thumbnailImage
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
            }
            
            Button {
                Task {
                    await thumbnailGenerator.asyncGenerateThumbnail(forResource: "CH46")
                }
            } label: {
                Text("Generate CH46 thumbnail")
            }
            .padding()
            
            Button {
                Task {
                    await thumbnailGenerator.asyncGenerateThumbnail(forResource: "F35")
                }
            } label: {
                Text("Generate F35 thumbnail")
            }
            .padding()
            
            Button {
                Task {
                    await thumbnailGenerator.asyncGenerateThumbnail(forResource: "maneki")
                }
            } label: {
                Text("Generate maneki thumbnail")
            }
            .padding()
        }
    }
}

#Preview {
    ThumbnailView()
}
