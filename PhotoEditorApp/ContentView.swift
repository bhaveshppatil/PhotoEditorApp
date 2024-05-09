//
//  ContentView.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 06/05/24.
//

import SwiftUI
import Photos

struct ContentView: View {
    @State private var showCaptureImageView = false
    @State private var capturedImage: UIImage?
    @State private var selectedImage: UIImage?
    @State private var isEditingText = false
    @State private var editText = ""
    @State private var isShowingImagePicker = false
    @State private var isShowingShareSheet = false
    @State private var editedImage: UIImage?
    @State private var isFilterApplied = false
    @State private var isSaved = false
    @State private var filteredImage: UIImage?
    @StateObject var filterMaker = FilterManager()
    @State private var selectedFilter: Filters = .normalImage
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let image = showCaptureImageView ? capturedImage : selectedImage {
                    ZStack(alignment: .topLeading) {
                        Image(uiImage: (editedImage ?? (isFilterApplied ? filteredImage : image)) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                        
                        if isEditingText {
                            VStack {
                                TextField("Enter text", text: $editText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Spacer().frame(height: 50)
                                
                                Button("Done") {
                                    editedImage = addTextToImage(image: editedImage ?? image, text: editText)
                                    isEditingText = false
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                            }
                            .background(Color.black.opacity(0.5))
                            .padding()
                            .allowsHitTesting(true)
                        }
                    }
                    .padding()
                    
                    if isSaved {
                        Text("Image saved to Photos.")
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Filters.allCases, id: \.self) { filter in
                                if let filteredImage = filterMaker.applyFilter(filter, selectedImageForFilter: image) {
                                    FilterThumbnail(image: filteredImage, isSelected: selectedFilter == filter)
                                        .onTapGesture {
                                            isSaved = false
                                            isFilterApplied = true
                                            self.filteredImage = filteredImage
                                            self.editedImage = filteredImage
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    Image(uiImage: UIImage(named: "add_image") ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .onTapGesture {
                            showCaptureImageView.toggle()
                        }
                        .sheet(isPresented: $showCaptureImageView) {
                            CaptureImageView(isShown: self.$showCaptureImageView, capturedImage: self.$capturedImage)
                        }
                }
                HStack {
                    createButton("Take a Photo") {
                        isSaved = false
                        selectedImage = nil
                        showCaptureImageView.toggle()
                    }
                    
                    if selectedImage != nil {
                        createButton("Add Text") {
                            isEditingText.toggle()
                        }
                        .animation(.easeInOut)
                    }
                    createButton("From Photos") {
                        isSaved = false
                        editedImage = nil
                        isFilterApplied = false
                        isShowingImagePicker.toggle()
                    }
                    .animation(.easeInOut)
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(selectedImage: self.$selectedImage, isShowingImagePicker: self.$isShowingImagePicker)
                    }
                }
                .frame(width: geometry.size.width)
                
                if editedImage != nil {
                    HStack {
                        createButton("Share") {
                            isShowingShareSheet.toggle()
                        }
                        .sheet(isPresented: $isShowingShareSheet) {
                            ShareSheet(activityItems: [self.editedImage!])
                        }
                            createButton("Save") {
                                saveImageToPhotos(imageToSave: self.editedImage ?? UIImage())
                            }
                    
                    }
                }
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white)
        }
        .cornerRadius(10)
        .padding(.vertical, 50)
        .padding(.horizontal, 10)
        .background(Color.black)
        .onReceive([selectedFilter].publisher.first()) { _ in
            filterMaker.applyFilter(selectedFilter, selectedImageForFilter: selectedImage ?? UIImage())
        }
    }
    
    private func createButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(PrimaryButtonStyle())
    }
    
    private func addTextToImage(image: UIImage, text: String) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        image.draw(at: .zero)
        
        let fontSize: CGFloat = 100
        let textFont = UIFont.systemFont(ofSize: fontSize)
        let textColor = UIColor.black
        let textAlignment = NSTextAlignment.center
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let textRect = CGRect(x: 20, y: 20, width: imageSize.width - 40, height: imageSize.height - 40)
        (text as NSString).draw(in: textRect, withAttributes: textAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
    
    func saveImageToPhotos(imageToSave: UIImage) {
        // Request permission to access the photo library
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                // Permission granted, save the image
                saveImage(imageToSave: imageToSave)
            case .denied, .restricted:
                // Permission denied or restricted
                print("Permission to access photo library was not granted.")
            case .notDetermined:
                // User has not yet made a decision
                print("User has not yet made a decision regarding access to photo library.")
            @unknown default:
                print("Unknown authorization status.")
            }
        }
    }

    private func saveImage(imageToSave: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest.creationRequestForAsset(from: imageToSave)
            request.creationDate = Date() // Optionally set creation date
        } completionHandler: { success, error in
            if success {
                isSaved = true
                print("Image saved to Photos.")
            } else {
                print("Error saving image to Photos:", error?.localizedDescription ?? "")
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
