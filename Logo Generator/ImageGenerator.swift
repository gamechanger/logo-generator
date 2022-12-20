//
//  ImageGenerator.swift
//  Logo Generator
//
//  Created by Joshua Sharo on 12/20/22.
//

import Foundation
import UIKit
import StableDiffusion

@available(iOS 16.2, *)
class ImageGenerator {
    static func generate(prompt: String,
                         progressHandler: ((StableDiffusionPipeline.Progress) -> Bool)? = nil) -> UIImage? {
        guard let path = Bundle.main.path(forResource: "Models", ofType: nil, inDirectory: nil) else {
            fatalError("Fatal error: failed to find the CoreML models.")
        }
        let resourceUrl = URL(fileURLWithPath: path)
        do {
            let pipeline = try StableDiffusionPipeline(resourcesAt: resourceUrl)
            guard let image = try pipeline.generateImages(prompt: prompt,
                                                          stepCount: 2,
                                                          seed: -1,
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
