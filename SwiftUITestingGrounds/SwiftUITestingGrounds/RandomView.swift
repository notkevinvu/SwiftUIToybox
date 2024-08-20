//
//  RandomView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 5/23/24.
//

import SwiftUI
//import AVFoundation
import AVKit

struct RandomView: View {
    
    @Namespace var nameSpace
    @EnvironmentObject var randomViewModel: RandomViewModel
    @State var player = AVPlayer()
    
    let videosResourceNames: [String] = [
        "beachRocks",
        "beachWaves",
        "pcHologram",
        "shipGirl",
        "stocks",
        "turtle"
    ]
    
    @State var videoAssets: [AVPlayerItem] = []
    
    var body: some View {
        VideoPlayer(player: player) {
            
        }
        .onAppear {
            getVideoAssets()
        }
        .background(.clear)
        .overlay(alignment: .top) {
            Button("Randomize video") {
                randomizeVideo()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func getVideoAssets() {
        for name in videosResourceNames {
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp4") else { return }
            
            let asset = AVURLAsset(url: url)
            videoAssets.append(.init(asset: asset))
        }
        
        randomizeVideo()
    }
    
    func randomizeVideo() {
        player.replaceCurrentItem(with: videoAssets.randomElement())
    }
}

#Preview {
    RandomView()
        .environmentObject(RandomViewModel())
}

extension Image {
    func squareOriginalAspectRatioImage() -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 148)
            .clipShape(.rect(cornerRadius: 8))
    }
}
