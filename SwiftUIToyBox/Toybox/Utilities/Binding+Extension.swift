//
//  Binding+Extension.swift
//  SwiftUIToybox
//
//  Created by Kevin Vu on 3/11/24.
//

import SwiftUI

extension Binding {
    
    /// A utility method to avoid creating another state/published boolean to show alerts, sheets,
    /// and modals by creating a boolean itself where represents `true` if the optional
    /// has a value and `false` if it is nil.
    ///
    /// Example usage: `...isPresented: $viewModel.errorMessage.presence()`
    func presence<T>() -> Binding<Bool> where Value == Optional<T> {
        return .init {
            self.wrappedValue != nil
        } set: { newValue in
            precondition(newValue == false)
            self.wrappedValue = nil
        }
    }
}
