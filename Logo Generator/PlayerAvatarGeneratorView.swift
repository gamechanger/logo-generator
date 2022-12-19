//
//  PlayerAvatarGeneratorView.swift
//  Logo Generator
//
//  Created by Joshua Sharo on 12/19/22.
//

import SwiftUI

class PlayerAvatarGeneratorViewState: ObservableObject {
    @Published var animal: Animal?
}

struct PlayerAvatarGeneratorView: View {
    @ObservedObject var model: PlayerAvatarGeneratorViewState
    
    var body: some View {
        VStack {
            Text("Choose an animal for your avatar:")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
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
                        .background(model.animal == enumCase ? Color.gcGrayLight : .gcGrayLighter)
                        .cornerRadius(5)
                    }
                }
            }
        }
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}

struct PlayerAvatarGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerAvatarGeneratorView(model: .init())
    }
}