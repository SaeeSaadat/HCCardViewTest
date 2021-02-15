//
//  Extensions.swift
//  HCCardViewTest
//
//  Created by Saee Saadat on 2/16/21.
//

import UIKit

extension UIView {
    func applyCircleShadow(shadowRadius: CGFloat = 2,
                           shadowOpacity: Float = 0.3,
                           shadowColor: CGColor = UIColor.black.cgColor,
                           shadowOffset: CGSize = CGSize.zero) {
        
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}
