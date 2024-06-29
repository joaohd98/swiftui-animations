//
//  ImageAnalysisViewModel.swift
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
class ImageAnalysisViewModel: NSObject, ObservableObject {
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    var loadedImageView: UIImageView?
    
    func analyzeImage(_ image: UIImage) async throws -> Set<ImageAnalysisInteraction.Subject> {
        let configuration = ImageAnalyzer.Configuration([.visualLookUp])
        let analysis = try await analyzer.analyze(image, configuration: configuration)
        interaction.analysis = analysis
        let detectedSubjects = await interaction.subjects
        return detectedSubjects
    }
}
