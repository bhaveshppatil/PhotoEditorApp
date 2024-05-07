//
//  ContentView.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 06/05/24.
//

import SwiftUI

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
    @State private var filteredImage: UIImage?
    @StateObject var filterMaker = FilterManager()
    @State private var selectedFilter: Filters = .normalImage
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let image = selectedImage {
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
                                    editedImage = addTextToImage(image: image, text: editText)
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
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Filters.allCases, id: \.self) { filter in
                                if let filteredImage = filterMaker.applyFilter(filter, selectedImageForFilter: image) {
                                    FilterThumbnail(image: filteredImage, isSelected: selectedFilter == filter)
                                        .onTapGesture {
                                            isFilterApplied = true
                                            self.filteredImage = filteredImage
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
                        showCaptureImageView.toggle()
                    }
                    
                    createButton("Add Text") {
                        isEditingText.toggle()
                    }
                    .animation(.linear)
                    
                    createButton("From Photos") {
                        editedImage == nil
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
                    createButton("Share") {
                        isShowingShareSheet.toggle()
                    }
                    .sheet(isPresented: $isShowingShareSheet) {
                        ShareSheet(activityItems: [self.editedImage!])
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
        
        let fontSize: CGFloat = 100 // Adjust font size here
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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
