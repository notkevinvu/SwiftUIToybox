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
}
