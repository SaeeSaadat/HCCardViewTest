//
//  CardCollectionViewCell.swift
//  HCCardViewTest
//
//  Created by Saee Saadat on 2/15/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var bankLogoImageView: UIImageView!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expDateLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(logo: UIImage?, bank: String, cardNumber: String, name: String, expDate: String, themeColor: UIColor, numberColor: UIColor = .black, backgroundColors: [UIColor]) {
        
        self.bankLabel.text = bank
        self.bankLogoImageView.image = logo
        self.cardNumberLabel.text = insertSpacesEveryFourDigitsIntoString(string: cardNumber)
        self.nameLabel.text = name
        self.expDateLabel.text = expDate
        
        [bankLabel, nameLabel, expLabel].forEach({
            $0?.tintColor = themeColor
            $0?.textColor = themeColor
        })
        [cardNumberLabel, expDateLabel].forEach({
            $0?.textColor = numberColor
            $0?.tintColor = numberColor
        })
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        guard backgroundColors.count > 1 else {
            if backgroundColors.count == 0 {
                self.contentView.backgroundColor = UIColor(named: "AccentColor")
            } else {
                self.contentView.backgroundColor = backgroundColors[0]
            }
            return
        }
        
        let gradientBackground = CAGradientLayer()
        gradientBackground.colors = [backgroundColors[0].cgColor, backgroundColors[1].cgColor]
        gradientBackground.frame = self.contentView.frame
        gradientBackground.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientBackground.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        self.contentView.layer.insertSublayer(gradientBackground, at: 0)
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.clipsToBounds = true
        
    }

}


extension CardCollectionViewCell {
        

    func insertSpacesEveryFourDigitsIntoString(string: String) -> String {
        var stringWithAddedSpaces = ""
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            if i > 0 && (i % 4) == 0 {
                stringWithAddedSpaces.append(contentsOf: "   ")
            }
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
}
