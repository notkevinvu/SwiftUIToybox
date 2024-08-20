//
//  TransitionView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/18/24.
//

import SwiftUI

struct TransitionView: View {
    
    @State var shouldTriggerLoginToOnboardingTransition: Bool = false {
        didSet {
            print("Should trigger: \(shouldTriggerLoginToOnboardingTransition)")
        }
    }
    
    var body: some View {
        VStack {
            
            Button("Transition") {
                withAnimation(.spring(duration: 0.5)) {
                    shouldTriggerLoginToOnboardingTransition.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
            
            HStack {
                if !shouldTriggerLoginToOnboardingTransition {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.red)
                        .frame(width: 100, height: 100)
                        .transition(.asymmetric(insertion: .offset(x: -300), removal: .offset(x: -300)))
                }
                
                if shouldTriggerLoginToOnboardingTransition {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.blue)
                        .frame(width: 100, height: 100)
                        .transition(.offset(x: 300))
                }
            }
        }
        .onAppear {
            shouldTriggerLoginToOnboardingTransition = false
        }
    }
}

#Preview {
    TransitionView()
}
