//
//  Extensions.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 9/9/24.
//

import UIKit
import SwiftUI

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension Image {
    func squareOriginalAspectRatioImage(dimension: CGFloat? = nil) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .frame(width: dimension, height: dimension)
            .clipShape(.rect(cornerRadius: 8))
            .aspectRatio(1, contentMode: .fit)
            .contentShape(.rect)
    }
    
    func rectangularRoundedImage(height: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: height)
            .clipShape(.rect(cornerRadius: 8))
            .contentShape(.rect)
    }
}
