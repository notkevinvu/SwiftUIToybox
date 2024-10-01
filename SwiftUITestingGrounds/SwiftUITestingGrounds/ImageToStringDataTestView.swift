//
//  ImageToStringDataTestView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 7/9/24.
//

import SwiftUI

struct ImageToStringDataTestView: View {
    
    let testImages: [UIImage] = [
        UIImage(resource: .ez),
        UIImage(resource: .bedge),
        UIImage(resource: .carinaNebula),
        UIImage(resource: .earthObservationFleet20230130),
        UIImage(resource: .dogYorkshireTerrier)
    ]
    
    @State private var imageString: String = ""
    @State private var convertedImage: UIImage?
    
    var body: some View {
//        singleRandomImageConversionView
        multiImageConversionView
    }
    
    // MARK: -- Single image
    @ViewBuilder
    var singleRandomImageConversionView: some View {
        Button("Convert random image to string") {
            convertImageToStringData()
        }
        .buttonStyle(.borderedProminent)
        
        Text(imageString)
            .lineLimit(4)
        
        Button("Convert string data back into image") {
            convertStringDataToImage()
        }
        .buttonStyle(.borderedProminent)
        
        if let convertedImage,
           let resizedImage = convertedImage.resizeImage(newWidth: 300)
        {
            Image(uiImage: resizedImage)
                .resizable()
                .scaledToFit()
                .frame(width: 300)
        }
        
        Button("Create json") {
            convertStringDataIntoHolderJsonData()
        }
        .buttonStyle(.borderedProminent)
        
        Button("Create test holder") {
            convertHolderJsonDataToModelObject()
        }
        .buttonStyle(.borderedProminent)
    }
    
    func convertImageToStringData() {
        guard let randomImage = testImages.randomElement() else { return }
        
        guard let imageData = randomImage.pngData() else { return }
        
        let base64String = imageData.base64EncodedString()
        print("String length: \(base64String.count)")
        
        imageString = base64String
    }
    
    func convertStringDataToImage() {
        guard !imageString.isEmpty else { return }
        
        guard let imageDataFromString = Data(base64Encoded: imageString) else { return }
        
        let uiImage = UIImage(data: imageDataFromString)
        convertedImage = uiImage
    }
    
    @State private var holderJsonData: Data?
    
    func convertStringDataIntoHolderJsonData() {
        convertedImage = nil
        guard !imageString.isEmpty else { return }
        
        let testDictionary: [String: Any] = [
            "name": "Test",
            "imageString": imageString
        ]
        
        do {
            let dictAsData = try JSONSerialization.data(withJSONObject: testDictionary)
            holderJsonData = dictAsData
        } catch {
            return
        }
    }
    
    struct TestHolder {
        let name: String
        var imageData: Data?
    }
    
    func convertHolderJsonDataToModelObject() {
        guard let holderJsonData else { return }
        
        do {
            if let dataAsDict = try JSONSerialization.jsonObject(with: holderJsonData) as? [String: Any]
            {
                let name = (dataAsDict["name"] as? String) ?? "no name"
                let imageDataString = (dataAsDict["imageString"] as? String) ?? "no image"
                let imageData = Data(base64Encoded: imageDataString)
                
                let testHolder = TestHolder(name: name, imageData: imageData)
                
                if let imageData {
                    convertedImage = UIImage(data: imageData)
                }
                print(testHolder)
            }
            
        } catch {
            return
        }
    }
    
    // MARK: -- Multiple images
    
    struct TestMultiHolder: Codable {
        let name: String
        let date: Date
        var imageDataStringArray: [String]
    }
    
    @State private var imageStringArray: [String] = []
    @State private var multiHolderData: Data?
    @State private var dataSizeText: String = ""
    
    @ViewBuilder
    var multiImageConversionView: some View {
        Button("Convert images to json data") {
            convertImagesToJsonData()
        }
        .buttonStyle(.borderedProminent)
        
        Text(dataSizeText)
        
        Button("Convert json to model") {
            convertHolderDataToModel()
        }
        .buttonStyle(.borderedProminent)
        
        ForEach(imagesFromStringData) { image in
            Image(uiImage: image)
                .resizable()
                .frame(maxWidth: 300, maxHeight: .infinity)
        }
    }
    
    func convertImagesToJsonData() {
        let imageDataArray = testImages.compactMap({ $0.pngData() })
        // maybe just encode the data directly?
        let stringDataArray = imageDataArray.map { $0.base64EncodedString() }
        imageStringArray = stringDataArray
        
        let testDate = Date(timeIntervalSince1970: 1589733927)
        
        let holder = TestMultiHolder(
            name: "test",
            date: testDate,
            imageDataStringArray: imageStringArray
        )
        
        let dict: [String: Any] = [
            "name": "Test",
            "date": testDate.timeIntervalSince1970,
            "imageDataStringArray": imageStringArray
        ]
        
        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            
//            let data = try encoder.encode(holder)
            
            let data = try JSONSerialization.data(withJSONObject: dict)
            
            multiHolderData = data
            let bcf = ByteCountFormatter()
            dataSizeText = bcf.string(fromByteCount: Int64(data.count))
            print("Finished encoding")
        } catch {
            print("Failed encoding")
            return
        }
    }
    
    @State private var imagesFromStringData: [UIImage] = []
    
    func convertHolderDataToModel() {
        guard let multiHolderData else { return }
        
        do {
            let decoder = JSONDecoder()
            
            let finalHolder = try decoder.decode(TestMultiHolder.self, from: multiHolderData)
            
            for imageString in finalHolder.imageDataStringArray {
                if let imageData = Data(base64Encoded: imageString),
                   let uiImageFromData = UIImage(data: imageData)
                {
                    imagesFromStringData.append(uiImageFromData)
                }
            }
        } catch {
            print("Failed to decode")
            return
        }
    }
}

#Preview {
    ImageToStringDataTestView()
}
