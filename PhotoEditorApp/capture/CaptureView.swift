//
//  CaptureView.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 06/05/24.
//

import SwiftUI

struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var capturedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, capturedImage: $capturedImage)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}
