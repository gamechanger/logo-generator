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

        let generatorView = UIHostingController(rootView: PlayerAvatarGeneratorView(model: .init()))
        view.addSubview(generatorView.view)
        generatorView.view.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}

