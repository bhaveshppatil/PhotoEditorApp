//
//  ImageFilter.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 06/05/24.
//

import SwiftUI

extension FilterManager {
    func applyFilter(_ filter: Filters, selectedImageForFilter: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: selectedImageForFilter) else { return nil }
        switch filter {
        case .normalImage: return selectedImageForFilter
        case .sepia: return applySepia(to: ciImage)
        case .motionBlur: return applyMotionBlur(to: ciImage)
        case .colorInvert: return applyColorInvert(to: ciImage)
        case .crystallize: return applyCrystallize(to: ciImage)
        case .comic: return applyComicEffect(to: ciImage)
        case .sRGBToneCurveToLinear:
            return applySRGBToneCurveToLinearFilter(to: ciImage)
            
        }
    }
}
