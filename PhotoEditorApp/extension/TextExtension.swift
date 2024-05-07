//
//  TextExtension.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 07/05/24.
//

import Foundation
import SwiftUI

extension Text {
    func buttonStyle() -> some View {
        self
            .foregroundColor(.black)
            .font(.subheadline)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
    }
}

