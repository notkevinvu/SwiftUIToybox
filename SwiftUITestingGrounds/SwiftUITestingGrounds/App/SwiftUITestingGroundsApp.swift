//
//  SwiftUITestingGroundsApp.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 5/16/24.
//

import SwiftUI

@main
struct SwiftUITestingGroundsApp: App {
    // MARK: - Navigation (New modular system)
    @State private var appRouter = AppRouter()

    // MARK: - Legacy Router (kept during migration)
    @State private var legacyRouter = Router()

    var body: some Scene {
        WindowGroup {
            MainView()
//            TransitionView()
                .environmentObject(RandomViewModel())
                // New modular navigation system
                .environment(appRouter)
                // Legacy router (remove after full migration)
                .environment(legacyRouter)
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

