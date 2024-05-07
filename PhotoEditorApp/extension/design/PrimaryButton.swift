//
//  PrimaryButton.swift
//  PhotoEditorApp
//
//  Created by Bhavesh Patil on 07/05/24.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .font(.subheadline)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
            .animation(.easeInOut)
    }
}
