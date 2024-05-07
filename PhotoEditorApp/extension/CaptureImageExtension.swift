//
//  CaptureImageView.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 06/05/24.
//

import Foundation
import SwiftUI

extension CaptureImageView {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isShown: Bool
        @Binding var capturedImage: UIImage?
        
        init(isShown: Binding<Bool>, capturedImage: Binding<UIImage?>) {
            _isShown = isShown
            _capturedImage = capturedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let uiImage = info[.originalImage] as? UIImage else { return }
            capturedImage = uiImage
            isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
}

