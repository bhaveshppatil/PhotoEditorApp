//
//  FilterThumbnail.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 06/05/24.
//

import Foundation
import SwiftUI

struct FilterThumbnail: View {
    let image: UIImage
    let isSelected: Bool
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 100, height: 100)
            .scaledToFit()
            .border(isSelected ? Color.blue : Color.clear, width: 2)
    }
}
