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

private class PlayerAvatarGeneratorProgressState: ObservableObject {
    @Published var generating: Bool = true
    @Published var progress: Double = 0
}

struct PlayerAvatarGeneratorView: View {
    @ObservedObject var model: PlayerAvatarGeneratorViewState
    @ObservedObject private var progressState = PlayerAvatarGeneratorProgressState()
    
    var body: some View {
        VStack {
            HStack {
                Text("Choose an animal for your avatar:")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 16) {
                ForEach(Animal.allCases) { enumCase in
                    Button(action: {
                        model.animal = enumCase
                    }) {
                        Text(enumCase.rawValue)
                            .font(.system(size: 24))
                    }
                    .padding(.init(top: 2, leading: 8, bottom: 2, trailing: 8))
                    .background(model.animal == enumCase ? Color.gcGrayLight : .gcGrayLighter)
                    .cornerRadius(8)
                }
            }
            
            Spacer().frame(height: 32)
            
            Button(action: {
                if let animal = model.animal,
                   #available(iOS 16.2, *) {
                    progressState.generating = true
                    let image = ImageGenerator.generate(prompt: "photorealistic \(animal.description) dressed as an athlete and playing \(model.sport), HD, detailed and intricate",
                                                        progressHandler: { progress in
                        progressState.progress = Double(progress.step) / Double(progress.stepCount)
                        return true
                    })
                    progressState.generating = false
                    progressState.progress = 0
                    
                    model.image = image
                }
            }) {
                Text("Generate")
            }
            .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            
            if progressState.generating {
                Spacer().frame(height: 16)
                HStack {
                    ProgressView()
                        .frame(width: 16)
                    Spacer().frame(width: 16)
                    ProgressView(value: progressState.progress)
                    Spacer().frame(width: 32)
                }
            }
            
            Spacer().frame(maxHeight: .infinity)
            
            if let image = model.image {
                Image(uiImage: image)
            }
            
            Spacer()
                .frame(maxHeight: .infinity)
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
