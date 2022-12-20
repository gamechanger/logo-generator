//
//  ContentView.swift
//  LogoPicker
//
//  Created by Jide Opeola on 12/19/22.
//

import SwiftUI

struct LogoPickerView: View {
    @State var images: [UIImage] = []
    @State var selectedImage: Int?
    public var savePressed: ((Int) -> Void)?
        
    var body: some View {
        NavigationStack {
                    Text("")
                        .navigationTitle("Pick an image")
                        .toolbar {
                            Button("Save") {
                                print("Save Image option")
                                if let selectedImage {
                                    savePressed?(selectedImage)
                                }
                            }
                        }
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: UIScreen.main.bounds.width / 3, maximum: UIScreen.main.bounds.width / 2), spacing: 12),
                    GridItem(.flexible(minimum: UIScreen.main.bounds.width / 3, maximum: UIScreen.main.bounds.width / 2), spacing: 12)
                ], spacing: 20, content: {
                    ForEach(images.indices, id:  \.self) { i in
                        HStack {
                            Button {
                                selectedImage = i
                            } label: {
                                ChildView(activeBlock: selectedImage == i, image: images[i])
                            }
                        }
                        .cornerRadius(20)
                    }
                }).padding(.horizontal, 12)
            }
        }
    }
}

struct ChildView: View {
    var activeBlock:Bool       // << value, no binding needed
    var image: UIImage
    
    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    
                if activeBlock {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: StrokeStyle(lineWidth: 14))
                        .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogoPickerView()
    }
}
