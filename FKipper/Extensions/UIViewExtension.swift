//
//  UIViewExtension.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 08.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation


extension UIView {
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours)
    }
    
    func applyGradient(colours: [UIColor],
                       locations: [NSNumber]? = nil,
                       direction: GradientType = GradientPoint.leftRight.draw(),
                       withAlpha: CGFloat = 1.0) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.withAlphaComponent(withAlpha).cgColor }
        gradient.locations = locations
        gradient.startPoint = direction.x
        gradient.endPoint = direction.y
        self.layer.insertSublayer(gradient, at: 0)
    }
}
