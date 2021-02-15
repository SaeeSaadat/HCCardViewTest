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
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                self.setupCircleImages()
            })
            
            let animationOption: UIView.AnimationOptions = .curveEaseInOut
            let keyframeAnimationOption: UIView.KeyframeAnimationOptions = UIView.KeyframeAnimationOptions(rawValue: animationOption.rawValue)
            UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [keyframeAnimationOption], animations: {
                
                for i in 0..<self.circles.count {
                    let circle = self.circles[i]
                    circle.yConstraint?.constant = (self.animationView.frame.height + circle.frame.height) / 2 + 5
                    UIView.addKeyframe(withRelativeStartTime: (Double(i) * 0.15)/1.5, relativeDuration: 0.35 , animations: {
                        self.layoutIfNeeded()
                    })
                }
                
                for i in 0..<self.circles.count {
                    let circle = self.circles[i]
                    circle.yConstraint?.constant = 0
                    UIView.addKeyframe(withRelativeStartTime: (0.8 + Double(i) * 0.15)/1.5, relativeDuration: 0.35, animations: {
                        self.layoutIfNeeded()
                    })
                }
                
            }, completion: nil)
        })
        
        if startAfter {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.timer!.fire()
            })
            
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
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = .white
        circle.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            circle.heightAnchor.constraint(equalToConstant: 30),
            circle.widthAnchor.constraint(equalToConstant: 30),
        ])
        
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

    var imageView = UIImageView() //RoundImageView()
    var yConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        needsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let radius: CGFloat = self.bounds.size.height / 2.0
        layer.cornerRadius = radius
        clipsToBounds = true
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.height / 2.0).cgPath
    }
}

