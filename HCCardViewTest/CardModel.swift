//
//  CardModel.swift
//  HCCardViewTest
//
//  Created by Saee Saadat on 2/15/21.
//

import UIKit

struct CardModel {
    let bank: Bank?
    let name: String?
    let number: String?
    let expDate: String?
}

enum CustomCardModel {
    case addCard
}

enum Bank: String {
    case ayande = "Ayande"
    case eghtesad = "Eghtesad-Novin"
    case mellat = "Mellat"
    case keshavarzi = "Keshavarzi"
    case sarmaye = "Sarmaye"
    case maskan = "Maskan"
    case shahr = "Shahr"
    case parsian = "Parsian"
    
    var logo: UIImage? {
        return UIImage(named: self.rawValue + "-logo")
    }
    var persianName: String? {
        switch self {
        case .ayande:
            return "بانک آینده"
        case .mellat:
            return "بانک ملت"
        case .eghtesad:
            return "بانک اقتصاد نوین"
        default:
            return "سام آدر بانک"
        }
    }
    var color: UIColor {
        return UIColor(named: self.rawValue + "-color") ?? .cyan
    }
    
    var backgroundColors: [UIColor] {
        return [UIColor(named: self.rawValue + "-background-color-1") ?? .green, UIColor(named: self.rawValue + "-background-color-2") ?? .systemPink]
    }
}
