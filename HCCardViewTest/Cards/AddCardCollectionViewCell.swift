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
    private let banks: [Bank] = [.ayande, .eghtesad, .mellat, .maskan, .keshavarzi, .parsian, .sarmaye, .shahr]
    private var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setBackground()
        
        animationView.clipsToBounds = true
        
        for i in 1...4 {
            let circle = createCircle()
            animationView.addSubview(circle)
            circle.yConstraint = circle.centerYAnchor.constraint(equalTo: animationView.centerYAnchor)
            NSLayoutConstraint.activate([
                circle.leadingAnchor.constraint(equalTo: animationView.leadingAnchor, constant: leadingDistance + CGFloat(20 * (i-1)) ),
                circle.yConstraint!
            ])
            circles.append(circle)
        }
        setupCircleImages()
        startAnimation()
    }
    
    func createAnimations(startAfter: Bool = false) {
//        UIView.animate(withDuration: 1.0, delay: 0.4, options: [.repeat, .curveEaseInOut], animations: {
//
//        }, completion: nil)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                self.setupCircleImages()
            })
            
            UIView.animateKeyframes(withDuration: 4.0, delay: 1.0, options: [], animations: {
                
                for i in 0..<self.circles.count {
                    let circle = self.circles[i]
                    circle.yConstraint?.constant = self.animationView.frame.height
                    UIView.addKeyframe(withRelativeStartTime: (Double(i) * 0.25)/5, relativeDuration: 0.25, animations: {
                        self.layoutIfNeeded()
                    })
                }
                
                for i in stride(from: self.circles.count - 1, through: 0, by: -1) {
                    let circle = self.circles[i]
                    circle.yConstraint?.constant = 0
                    UIView.addKeyframe(withRelativeStartTime: (4 + Double(i) * 0.25) / 5, relativeDuration: 0.25, animations: {
                        self.layoutIfNeeded()
                    })
                }
                
            }, completion: { _ in
                print("completed")
            })
        })
        
        if startAfter {
            timer!.fire()
        }
    }
    
    func startAnimation() {
        if let _ = self.timer {
            self.timer?.fire()
        } else {
            createAnimations(startAfter: true)
        }
    }
    func stopAnimation() {
        self.timer?.invalidate()
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
        for i in 0..<circles.count {
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
    var yConstraint: NSLayoutConstraint?
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
