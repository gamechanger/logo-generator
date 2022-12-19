//
//  Animal.swift
//  Logo Generator
//
//  Created by Joshua Sharo on 12/19/22.
//

import Foundation

enum Animal: String, Identifiable, CaseIterable {
    case 🐶
    case 🐱
    case 🐰
    case 🦊
    case 🐻
    case 🐼
    case 🐨
    case 🐯
    case 🦁
    case 🐮
    case 🐵
    case 🐧
    case 🐺
    case 🦖
    case 🦍
    case 🦥
    case 🐎
    case 🐲
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .🐶:
            return "dog"
        case .🐱:
            return "cat"
        case .🐰:
            return "bunny"
        case .🦊:
            return "fox"
        case .🐻:
            return "brown bear"
        case .🐼:
            return "polar bear"
        case .🐨:
            return "koala bear"
        case .🐯:
            return "tiger"
        case .🦁:
            return "lion"
        case .🐮:
            return "cow"
        case .🐵:
            return "monkey"
        case .🐧:
            return "penguin"
        case .🐺:
            return "wolf"
        case .🦖:
            return "dinosaur"
        case .🦍:
            return "gorilla"
        case .🦥:
            return "sloth"
        case .🐎:
            return "mustang (horse)"
        case .🐲:
            return "dragon"
        }
    }
}
