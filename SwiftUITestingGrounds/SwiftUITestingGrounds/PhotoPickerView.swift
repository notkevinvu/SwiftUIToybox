//
//  PhotoPickerView.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 5/16/24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    
    @State var shouldShowPhotosPicker: Bool = false
    @State var photoPickerItem: PhotosPickerItem?
    @State var selectedPhoto: Image?
    
    @State var multiplePhotos: [PhotosPickerItem] = []
    @State var selectedPhotos: [Image] = []
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $multiplePhotos, matching: .images, preferredItemEncoding: .automatic) {
                Text("Select pictures")
            }
            
            ScrollView {
                
                ForEach(selectedPhotos) { photo in
                    photo
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
            }
            .scrollIndicators(.hidden)
            
        }
        .onChange(of: multiplePhotos) { oldValue, newValue in
            handleSelected(newValue)
        }
    }
    
    func handleSelected(_ selectedItems: [PhotosPickerItem]) {
        Task {
            selectedPhotos.removeAll()
            
            print("HANDLE MULTIPLE PHOTOS")
            for item in selectedItems {
                
                if let imageData = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: imageData)
                {
                    selectedPhotos.append(Image(uiImage: uiImage))
                } else {
                    print("Failed to extract image data")
                }
            }
        }
    }
}

#Preview {
    PhotoPickerView()
}

extension Image: Identifiable {
    public var id: String {
        UUID().uuidString
    }
}
