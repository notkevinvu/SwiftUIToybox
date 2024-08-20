//
//  TwoColumnGridView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 5/23/24.
//

import SwiftUI

struct TwoColumnGridView: View {
    
    let columns = [GridItem](repeating: .init(.flexible(minimum: 50)), count: 2)
    
    let data = (1...10).map { "Item \($0)" }
    let testImages: [Image] = [
        Image("ez"),
        Image("clueless"),
        Image("bedge"),
        Image("prayge"),
        Image("madge"),
        Image("monkaw"),
        Image("testImage1"),
        Image("testImage2"),
        Image("testImage3"),
        Image("testImage4")
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(testImages) { image in
                    image
                        .squareOriginalAspectRatioImage()
                        .overlay {
                            ZStack {
                                VStack {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "checkmark.circle")
                                            .resizable()
                                            .frame(width: 19, height: 19)
                                            .foregroundStyle(.white)
                                            .background(.blue)
                                            .clipShape(.circle)
                                    }
                                    Spacer()
                                    HStack {
                                        Text("12:49pm")
                                            .font(.system(size: 12))
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 10)
                                            .background(.black)
                                            .clipShape(.capsule)
                                        Spacer()
                                    }
                                }
                                .padding(10)
                                
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    TwoColumnGridView()
        .preferredColorScheme(.dark)
}

