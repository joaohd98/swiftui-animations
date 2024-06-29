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
    
    var imageObject: UIImage
    
    @EnvironmentObject var viewModel: ImageAnalysisViewModel
    
    func makeUIView(context: Context) -> CustomizedUIImageView {
        let imageView = CustomizedUIImageView()
        
        imageView.image = imageObject
        imageView.contentMode = .scaleToFill
        viewModel.interaction.preferredInteractionTypes = [.imageSubject]
        imageView.addInteraction(viewModel.interaction)

        viewModel.loadedImageView = imageView
        
        return imageView
    }
    
    func updateUIView(_ uiView: CustomizedUIImageView, context: Context) { }
    
}

class CustomizedUIImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
