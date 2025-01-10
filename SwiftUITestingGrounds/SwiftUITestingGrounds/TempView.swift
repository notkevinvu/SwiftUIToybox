//
//  TempView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 10/25/24.
//

import SwiftUI

struct TempView: View {
    var body: some View {
        VStack {
            Spacer()
            
            shareImage
                .symbolVariant(.circle)
                .symbolVariant(.fill)
                .foregroundStyle(.blue, .tertiary)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var shareImage: some View {
        Image(systemName: "square.and.arrow.up")
            .font(.system(size: 48))
    }
}

#Preview {
    TempView()
        .preferredColorScheme(.dark)
}
