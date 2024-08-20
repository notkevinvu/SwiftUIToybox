//
//  NavLinkTapGestureView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 6/24/24.
//

import SwiftUI

struct NavLinkTapGestureView: View {
    
    let dummyData: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
    @State var subtitleText: Int = Int.random(in: 0...100)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(dummyData, id: \.self) { int in
                    NavigationLink("\(String(int))") {
                        Text("This is the detail page for \(int)")
                    }
                    .simultaneousGesture(TapGesture().onEnded({ _ in
                        print("Tapped nav link!")
                        subtitleText = Int.random(in: 0...100)
                    }))
                }
            }
        }
    }
}

#Preview {
    NavLinkTapGestureView()
}
