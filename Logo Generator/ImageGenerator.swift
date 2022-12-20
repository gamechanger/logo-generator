//
//  ImageGenerator.swift
//  Logo Generator
//
//  Created by Joshua Sharo on 12/20/22.
//

import Foundation
import UIKit
import StableDiffusion
import CoreML

@available(iOS 16.2, *)
@MainActor class ImageGenerator: ObservableObject {
    
    enum GenerationState {
        case stopped
        case started
        case generating(progress: StableDiffusionPipeline.Progress)
        case finished(image: UIImage)
        case failed(error: Error)
        
        func isGenerating() -> Bool {
            switch self {
            case .generating: return true
            default: return false
            }
        }
    }
    
    @Published var generationState: GenerationState = .stopped
    
    var isGenerating: Bool {
        return self.generationState.isGenerating()
    }
    
    private static let configuration: MLModelConfiguration = {
        let configuration = MLModelConfiguration()
        configuration.computeUnits = .cpuAndGPU
        return configuration
    }()

    private static let pipeline: StableDiffusionPipeline = {
        guard let path = Bundle.main.path(forResource: "Models", ofType: nil, inDirectory: nil) else {
            fatalError("Fatal error: failed to find the CoreML models.")
        }
        let resourceUrl = URL(fileURLWithPath: path)
        do {
            return try StableDiffusionPipeline(resourcesAt: resourceUrl, configuration: configuration)
        } catch {
            fatalError("Fatal error: failed to create StableDiffusionPipeline\n\(error)")
        }
    }()
    
    static func loadPipeline() {
        do {
            try pipeline.loadResources()
        } catch {
            print(error)
        }
    }
    
    static func unloadPipeline() {
        pipeline.unloadResources()
    }
    
    func generate(prompt: String) {
        do {
            self.generationState = .started
            guard let image = try Self.pipeline.generateImages(prompt: prompt,
                                                          seed: Int.random(in: Int.min...Int.max),
                                                          progressHandler: { progress in
                print("Finished step \(progress.step) / \(progress.stepCount)")
                self.generationState = .generating(progress: progress)
                
                return true
            }).compactMap({ $0 }).first else {
                throw LogoGeneratorError.generateImagesFailed
            }
           
            self.generationState = .finished(image: UIImage(cgImage: image))
        } catch {
            print(error)
            self.generationState = .failed(error: error)
        }
    }
}
