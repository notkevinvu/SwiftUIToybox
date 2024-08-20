//
//  SwiftUITestingGroundsApp.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 5/16/24.
//

import SwiftUI

@main
struct SwiftUITestingGroundsApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
//            TransitionView()
                .environmentObject(RandomViewModel())
                .environment(Router())
                .environment(MapViewModel())
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

