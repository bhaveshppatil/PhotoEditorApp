//
//  ImageFilter.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 06/05/24.
//

import Foundation
import CoreImage
import UIKit

enum Filters: CaseIterable, CustomStringConvertible {
    case normalImage, sepia, motionBlur, colorInvert, crystallize, comic, sRGBToneCurveToLinear
    
    var description: String {
        switch self {
        case .normalImage: return "None"
        case .sepia: return "Sepia"
        case .motionBlur: return "Motion Blur"
        case .colorInvert: return "Color Invert"
        case .crystallize: return "Crystallize"
        case .comic: return "Comic Effect"
        case .sRGBToneCurveToLinear: return "CISRGBToneCurveToLinear"
            
        }
    }
}


class FilterManager: ObservableObject {
    @Published var selectedImage: UIImage
    
    private let context = CIContext()
    
    init() {
        self.selectedImage = UIImage(named: "sample_image") ?? UIImage()
    }
    
    func updateSelectedImage(updatedImage: UIImage) {
        self.selectedImage = updatedImage
    }

    func applySepia(to image: CIImage) -> UIImage? {
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(image, forKey: "inputImage")
        filter?.setValue(0.9, forKey: "inputIntensity")
        return filteredImage(from: filter)
    }
    
    func applyMotionBlur(to image: CIImage) -> UIImage? {
        let filter = CIFilter(name: "CIMotionBlur")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(30.0, forKey: kCIInputRadiusKey)
        filter?.setValue(20.0, forKey: kCIInputAngleKey)
        return filteredImage(from: filter)
    }
    
    func applyColorInvert(to image: CIImage) -> UIImage? {
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(image, forKey: kCIInputImageKey)
        return filteredImage(from: filter)
    }
    
    func applyCrystallize(to image: CIImage) -> UIImage? {
        let filter = CIFilter(name: "CICrystallize")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(35, forKey: kCIInputRadiusKey)
        filter?.setValue(CIVector(x: 200, y: 200), forKey: kCIInputCenterKey)
        return filteredImage(from: filter)
    }
    
    func applyComicEffect(to image: CIImage) -> UIImage? {
        let filter = CIFilter(name: "CIComicEffect")
        filter?.setValue(image, forKey: kCIInputImageKey)
        return filteredImage(from: filter)
    }
    
    func applySRGBToneCurveToLinearFilter(to inputImage: CIImage) -> UIImage? {
        guard let filter = CIFilter(name: "CISRGBToneCurveToLinear") else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        return filteredImage(from: filter)
    }
    
    private func filteredImage(from filter: CIFilter?) -> UIImage? {
        guard let outputImage = filter?.outputImage else { return nil }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
}
