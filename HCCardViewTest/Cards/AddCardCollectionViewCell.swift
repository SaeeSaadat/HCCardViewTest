//
//  AddCardCollectionViewCell.swift
//  HCCardViewTest
//
//  Created by Saee Saadat on 2/15/21.
//

import UIKit

class AddCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var animationView: UIView!

    private var circles: [BankCircle] = []
    
    private let leadingDistance: CGFloat = 10.0
    
    private var imageIndex = 0
    private let banks: [Bank] = [.ayande, .eghtesad, .mellat, .ayande, .eghtesad, .mellat, .ayande, .eghtesad, .mellat]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setBackground()
        
        for i in 1...4 {
            let circle = createCircle()
            animationView.addSubview(circle)
            NSLayoutConstraint.activate([
                circle.leadingAnchor.constraint(equalTo: animationView.leadingAnchor, constant: leadingDistance + CGFloat(20 * (i-1)) ),
                circle.centerYAnchor.constraint(equalTo: animationView.centerYAnchor)
            ])
            circles.append(circle)
        }
        setupCircleImages()
    }
    
    private func createCircle() -> BankCircle{
        
        let circle = BankCircle()
        circle.awakeFromNib()
        circle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circle.heightAnchor.constraint(equalToConstant: 30),
            circle.widthAnchor.constraint(equalToConstant: 30),
        ])
        circle.layer.cornerRadius = 15
        circle.clipsToBounds = true
        circle.backgroundColor = .white
        
        circle.contentMode = .scaleAspectFill
        
        return circle
    }
    
    private func setupCircleImages() {
        for i in 0...3 {
            circles[i].imageView.image = banks[imageIndex].logo
            imageIndex = (imageIndex + 1) % banks.count
        }
    }
    
    private func setBackground() {
        
        let gradientBackground = CAGradientLayer()
        gradientBackground.colors = [(UIColor(named: "AccentColor") ?? .yellow).cgColor, (UIColor(named: "AccentColor-light") ?? .orange).cgColor]
        gradientBackground.frame = self.contentView.frame
        gradientBackground.startPoint = CGPoint(x: 0.2, y: 0.8)
        gradientBackground.endPoint = CGPoint(x: 0.6, y: 0.2)
        
        self.contentView.layer.insertSublayer(gradientBackground, at: 0)
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.clipsToBounds = true
        
    }

}

fileprivate class BankCircle: UIView {
    var imageView = UIImageView()
    
    override func awakeFromNib() {
        self.imageView = UIImageView()
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        
        ])
    }
}
