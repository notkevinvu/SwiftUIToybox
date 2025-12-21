//
//  SwiftUITestingGroundsApp.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 5/16/24.
//

import SwiftUI

@main
struct SwiftUITestingGroundsApp: App {
    // MARK: - Navigation
    @State private var appRouter = AppRouter()
    @State private var mainRouter = MainRouter()

    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(RandomViewModel())
                // Navigation system
                .environment(appRouter)
                .environment(mainRouter)
                // ViewModels
                .environment(MapViewModel())
                .environment(ImageCarouselViewModel())
        }
    }
}


let testImageOne = Image("testImage1")
let testImageTwo = Image("testImage2")
let testImageThree = Image("testImage3")
let testImageFour = Image("testImage4")
let bedgeImage = Image("bedge")
let ezImage = Image("ez")
let madgeImage = Image("madge")
let cluelessImage = Image("clueless")
let monkaWImage = Image("monkaw")
let okImage = Image("ok")

