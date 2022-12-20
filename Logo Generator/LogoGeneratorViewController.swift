//
//  ViewController.swift
//  Logo Generator
//
//  Created by Kristopher Woodall on 12/15/22.
//

import UIKit
import StableDiffusion
import SnapKit
import SwiftUI
import CoreML

enum LogoGeneratorError: Error {
    case unsupportedOS
    case generateImagesFailed
}

class LogoGeneratorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: generate())
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
//        let generatorView = UIHostingController(rootView: PlayerAvatarGeneratorView(model: .init()))
//        view.addSubview(generatorView.view)
//        generatorView.view.snp.makeConstraints { make in
//            make.left.top.right.bottom.equalToSuperview()
//        }
    }

    func generate() -> UIImage? {
        guard let path = Bundle.main.path(forResource: "Models", ofType: nil, inDirectory: nil) else {
            fatalError("Fatal error: failed to find the CoreML models.")
        }
        let resourceUrl = URL(fileURLWithPath: path)
        do {
            guard #available(iOS 16.2, *) else {
                throw LogoGeneratorError.unsupportedOS
            }
            
            let pipeline = try StableDiffusionPipeline(resourcesAt: resourceUrl)
            guard let image = try pipeline.generateImages(prompt: "beach with palm trees", seed: -1).compactMap({ $0 }).first else {
                throw LogoGeneratorError.generateImagesFailed
            }
            return UIImage(cgImage: image)
        } catch {
            print(error)
            return nil
        }
    }
}

