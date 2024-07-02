//
//  ObjectPickFromPictureView.swift
//  animations-swift
//
//  Created by João Damazio on 28/06/24.
//

import Foundation
import UIKit
import SwiftUI
import VisionKit
import Combine

@MainActor
struct ObjectPickableImageView: UIViewRepresentable {
    
    var uiImage: UIImage
    var onChangeImage: (_ value: UIImage) -> Void = { _ in }
    @EnvironmentObject var viewModel: ImageAnalysisViewModel
    
    func makeUIView(context: Context) -> CustomizedUIImageView {
        let imageView = CustomizedUIImageView()
        
        imageView.image = uiImage
        imageView.contentMode = .scaleAspectFill
        viewModel.interaction.preferredInteractionTypes = [.imageSubject]
        imageView.addInteraction(viewModel.interaction)
        viewModel.loadedImageView = imageView
        onChangeImage(uiImage)

        return imageView
    }
    
    func updateUIView(_ uiView: CustomizedUIImageView, context: Context) {
        if uiView.image != uiImage {
            uiView.image = uiImage
            uiView.addInteraction(viewModel.interaction)
            viewModel.loadedImageView = uiView
            onChangeImage(uiImage)
        }
    }
    
}

class CustomizedUIImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}

#Preview {
    ObjectDetector()
}
