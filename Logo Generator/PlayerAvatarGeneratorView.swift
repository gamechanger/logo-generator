//
//  PlayerAvatarGeneratorView.swift
//  Logo Generator
//
//  Created by Joshua Sharo on 12/19/22.
//

import SwiftUI

class PlayerAvatarGeneratorViewState: ObservableObject {
    @Published var animal: Animal?
    @Published var sport: String = "baseball"
    @Published var image: UIImage?
}

@MainActor private class PlayerAvatarGeneratorProgressState: ObservableObject {
    @Published var hasGenerated: Bool = false
}

@available(iOS 16.2, *)
struct PlayerAvatarGeneratorView: View {
    @ObservedObject var model: PlayerAvatarGeneratorViewState
    @StateObject private var progressState = PlayerAvatarGeneratorProgressState()
    @StateObject private var imageGenerator = ImageGenerator()
    
    var body: some View {
        VStack {
            HStack {
                Text("Choose an animal for your avatar:")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 16) {
                    ForEach(Animal.allCases) { enumCase in
                        Button(action: {
                            model.animal = enumCase
                        }) {
                            Text(enumCase.rawValue)
                                .font(.system(size: 24))
                        }
                        .padding(.init(top: 2, leading: 8, bottom: 2, trailing: 8))
                        .background(model.animal == enumCase ? Color.gcLightBlue : .gcGrayLighter)
                        .disabled(imageGenerator.isGenerating)
                        .cornerRadius(8)
                    }
                }
            }
            .frame(maxHeight: 136)
            
            Spacer().frame(height: 32)
            
            Button(action: {
                if let animal = model.animal {
                    imageGenerator.generate(prompt: "photorealistic \(animal.description) dressed as an athlete and playing \(model.sport), HD, detailed and intricate")
                    progressState.hasGenerated = true
                }
            }) {
                Text(progressState.hasGenerated ? "Regenerate" : (imageGenerator.isGenerating ? "Generating..." : "Generate"))
            }
            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.white)
            .background(imageGenerator.isGenerating ? Color.gcGrayLight : Color.gcBlue)
            .disabled(imageGenerator.isGenerating)
            .cornerRadius(8)
            
            Spacer().frame(height: 16)
                
            switch imageGenerator.generationState {
            case let .generating(progress: progress):
                let progress = Double(progress.step) / Double(progress.stepCount)
                HStack {
                    ProgressView()
                        .frame(width: 16)
                    Spacer().frame(width: 16)
                    ProgressView(value: progress)
                    Spacer().frame(width: 32)
                }
                
            case let .finished(image):
                Image(uiImage: image)
                
                Spacer().frame(height: 16)
                
                Button(action: {}) {
                    Text("Set as avatar")
                }
                .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                .foregroundColor(.white)
                .background(imageGenerator.isGenerating ? Color.gcGrayLight : Color.gcBlue)
                .disabled(imageGenerator.isGenerating)
                .cornerRadius(8)
                
                Spacer().frame(height: 16)
            default:
                HStack{}
            }
            
            Spacer().frame(maxHeight: .infinity)
        }
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}

@available(iOS 16.2, *)
struct PlayerAvatarGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerAvatarGeneratorView(model: .init())
    }
}
