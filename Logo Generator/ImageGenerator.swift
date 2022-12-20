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
class ImageGenerator {
    private static let configuration: MLModelConfiguration = {
        let configuration = MLModelConfiguration()
        configuration.computeUnits = .cpuAndGPU
        return configuration
    }()
    
    static func generate(prompt: String,
                         progressHandler: ((StableDiffusionPipeline.Progress) -> Bool)? = nil) -> UIImage? {
        guard let path = Bundle.main.path(forResource: "Models", ofType: nil, inDirectory: nil) else {
            fatalError("Fatal error: failed to find the CoreML models.")
        }
        let resourceUrl = URL(fileURLWithPath: path)
        do {
            let pipeline = try StableDiffusionPipeline(resourcesAt: resourceUrl, configuration: configuration, reduceMemory: true)
            guard let image = try pipeline.generateImages(prompt: prompt,
                                                          stepCount: 10,
                                                          seed: Int.random(in: Int.min...Int.max),
                                                          progressHandler: { progress in
                print("Finished step \(progress.step) / \(progress.stepCount)")
                return progressHandler?(progress) ?? true
            }).compactMap({ $0 }).first else {
                throw LogoGeneratorError.generateImagesFailed
            }
            return UIImage(cgImage: image)
        } catch {
            print(error)
            return nil
        }
    }
}
