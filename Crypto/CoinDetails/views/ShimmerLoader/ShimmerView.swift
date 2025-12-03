//
//  ShimmerView.swift
//  Crypto
//
//  Created by Sarah Munini Mwangangi on 03/12/2025.
//

import UIKit

final class ShimmerView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }
    
    private func setup() {
        backgroundColor = UIColor.systemGray5
        layer.cornerRadius = 8
        clipsToBounds = true
        
        gradientLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        gradientLayer.locations  = [0, 0.5, 1]
        layer.addSublayer(gradientLayer)
        
        animateShimmer()
    }
    
    private func animateShimmer() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue   = [1, 1.5, 2]
        animation.duration  = 1.0
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
