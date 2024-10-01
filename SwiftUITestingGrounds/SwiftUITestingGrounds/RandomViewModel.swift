//
//  RandomViewModel.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 6/25/24.
//

import Foundation

@MainActor
final class RandomViewModel: ObservableObject {
    @Published var showAlert: Bool = false
    
    func triggerAlert() {
        showAlert = true
    }
    
    func createTestFile() {
        let docDirectoryUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let docDirectoryUrl = docDirectoryUrls.first else {
            return
        }
        
        let tempUrl = URL(filePath: "TestEvent", relativeTo: docDirectoryUrl)
        let finalTempUrl = tempUrl.appending(component: "kvte")
    }
}
