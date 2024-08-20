//
//  ThumbnailGenerator.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/25/24.
//

import SwiftUI
import UIKit
import QuickLookThumbnailing

class ThumbnailGenerator: ObservableObject {
    @Published var thumbnailImage: Image?
    
    func generateThumbnail() {
        guard let url = Bundle.main.url(forResource: "maneki", withExtension: "usdz") else {
            print("Faulty url")
            return
        }
        
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(fileAt: url, size: .init(width: 1000, height: 1000), scale: scale, representationTypes: .all)
        
        let generator = QLThumbnailGenerator.shared
        
        generator.generateRepresentations(for: request) { thumbnail, repType, error in
            DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    print("Failed to generate thumbnail for repType \(repType) - \(error?.localizedDescription)")
                    return
                } else if let thumbnail {
                    self.thumbnailImage = Image(uiImage: thumbnail.uiImage)
                }
                
            }
        }
    }
    
    @MainActor
    func asyncGenerateThumbnail(forResource resource: String) async {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "usdz") else {
            print("Faulty url")
            return
        }
        
        let scale = UIScreen.main.scale
        
        guard let data = try? Data(contentsOf: url) else { return }
        
        let temp = FileManager.default.temporaryDirectory
        let tempFileID = UUID().uuidString + ".usdz"
        let tempFileUrl = temp.appending(path: tempFileID)
        
        try? data.write(to: tempFileUrl)
        
        let request = QLThumbnailGenerator.Request(fileAt: tempFileUrl, size: .init(width: 100, height: 100), scale: scale, representationTypes: .thumbnail)
        request.iconMode = false
        
        let generator = QLThumbnailGenerator.shared
        
        do {
            let representation = try await generator.generateBestRepresentation(for: request)
            let uiImage = representation.uiImage
            
            thumbnailImage = Image(uiImage: uiImage)
        } catch let error {
            print("Failed to generate thumbnail for \(error)")
            return
        }
    }
    
//    func imageByMakingWhiteBackgroundTransparent(_ cgImage: CGImage) -> UIImage? {
//
//        let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
//
//        UIGraphicsBeginImageContext(self.size)
//
//        if let maskedImageRef = cgImage.copy(maskingColorComponents: colorMasking) {
//
//            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, self.size.height)
//            CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0)
//
//            CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height), maskedImageRef)
//
//            let result = UIGraphicsGetImageFromCurrentImageContext()
//
//            UIGraphicsEndImageContext()
//
//            return result
//        }
//
//        return nil
//    }
}
