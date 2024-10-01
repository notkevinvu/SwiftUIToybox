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
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                
                ZStack {
                    Image(systemName: "checkmark.icloud.fill")
                        .symbolRenderingMode(.palette)
                        .font(.system(size: 48))
                        .foregroundStyle(.black)
                    
                    Image(systemName: "checkmark.icloud")
                        .symbolRenderingMode(.palette)
                        .font(.system(size: 48))
                        .foregroundStyle(.green)
                }
                
                ForEach(testImages) { image in
                    Image(uiImage: image.resizeImage(newWidth: 300) ?? UIImage())
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

extension UIImage: @retroactive Identifiable {
    
}

#Preview {
    TwoColumnGridView()
        .preferredColorScheme(.dark)
}

