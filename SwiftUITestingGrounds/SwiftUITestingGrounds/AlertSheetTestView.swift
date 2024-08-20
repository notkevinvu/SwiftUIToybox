//
//  AlertSheetTestView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/9/24.
//

import SwiftUI

struct AlertSheetTestView: View {
    
    @State var shouldShowStorageFullAlert: Bool = false
    @State var isUserStorageFull: Bool = true
    
    var body: some View {
        Text("Hello, World!")
            .alert("", isPresented: $shouldShowStorageFullAlert) {
                Button("Ok", role: .cancel, action: {})
            } message: {
                VStack(alignment: .center) {
                    Image(systemName: "icloud.circle.fill")
                        .font(.system(size: 28))
                    
                    Text("Sync to iCloud")
                        .font(.system(size: 24))
                    
                    Text("This event will sync to iCloud as long as you have available iCloud storage... Lorem ipsum something something")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
            }
//            .alert("Storage full", isPresented: $shouldShowStorageFullAlert) {
//                Button("Ok", role: .cancel, action: {})
//            }
            .onAppear {
                if isUserStorageFull {
                    shouldShowStorageFullAlert = true
                }
            }
    }
}

#Preview {
    AlertSheetTestView()
}
