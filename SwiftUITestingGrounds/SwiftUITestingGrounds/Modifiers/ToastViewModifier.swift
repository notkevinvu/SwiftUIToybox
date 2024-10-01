//
//  ToastViewModifier.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 9/18/24.
//

import SwiftUI

struct ToastViewModifier: ViewModifier {
    let title: String
    let subtitle: String
    @Binding var isToastPresented: Bool
    let toastType: ToastType
    let shouldShowProgressView: Bool
    
    public enum ToastType {
        case warning
        case error
        case success
        case info
        
        var backgroundColor: Color {
            switch self {
                case .warning:
                        .init(red: 254/255, green: 249/255, blue: 219/255)
                case .error:
                        .init(red: 255/255, green: 245/255, blue: 244/255)
                case .success:
                        .init(red: 235/255, green: 251/255, blue: 238/255)
                case .info:
                        .init(red: 231/255, green: 245/255, blue: 254/255)
            }
        }
        
        var primaryColor: Color {
            switch self {
                case .warning:
                        .init(red: 151/255, green: 97/255, blue: 23/255)
                case .error:
                        .init(red: 160/255, green: 62/255, blue: 63/255)
                case .success:
                        .init(red: 35/255, green: 90/255, blue: 48/255)
                case .info:
                        .init(red: 48/255, green: 98/255, blue: 149/255)
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isToastPresented {
                    VStack {
                        Spacer()
                        
                        HStack {
                            if shouldShowProgressView {
                                ProgressView()
                                    .tint(.black)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(title)
                                    .foregroundStyle(toastType.primaryColor)
                                    .font(.system(size: 16, weight: .semibold))
                                Text(subtitle)
                                    .foregroundStyle(toastType.primaryColor)
                                    .font(.system(size: 12))
                            }
                            
                            Spacer()
                            
                            Button {
                                isToastPresented = false
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(toastType.primaryColor, .white)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(toastType.backgroundColor)
                        .clipShape(.rect(cornerRadius: 8))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(toastType.primaryColor, lineWidth: 3)
//                        }
                        
                    }
                    .padding(.horizontal, 24)
                    .transition(.asymmetric(insertion: .offset(y: 200), removal: .offset(y: 200)))
                }
            }
            .animation(.default, value: isToastPresented)
    }
}

extension View {
    func toastView(
        _ title: String,
        _ subtitle: String,
        isToastPresented: Binding<Bool>,
        toastType: ToastViewModifier.ToastType,
        shouldShowProgressView: Bool
    ) -> some View {
        modifier(
            ToastViewModifier(
                title: title,
                subtitle: subtitle,
                isToastPresented: isToastPresented,
                toastType: toastType,
                shouldShowProgressView: shouldShowProgressView
            )
        )
    }
}
