//
//  UnavailableView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/16/24.
//

import SwiftUI

struct UnavailableView: View {
    
    var body: some View {
        ContentUnavailableView {
            VStack {
                Image(systemName: "person.3.fill")
                Text("No events available")
            }
        } description: {
            Text("Press \"Add event\" to get started.")
        }
    }
}

#Preview {
    UnavailableView()
}
