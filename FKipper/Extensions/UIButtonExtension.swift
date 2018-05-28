//
//  UIButtonExtensions.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 07.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation

extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x:0.0, y:0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func animatedChange(to bgColor: UIColor,
                        duration: TimeInterval = 0.5,
                        newTitle: String? = nil,
                        enabled: Bool) {
        UIView.transition(with: self, duration: duration, options: .curveEaseInOut, animations: {
            self.backgroundColor = bgColor
            if let title = newTitle {
              self.setTitle(title, for: .normal)
              let color = enabled ? UIColor.darkGray : UIColor.white
              self.setTitleColor(color, for: .normal)
            }
        }) { (completition) in
            self.isEnabled = enabled
        }
    }
    
    func changeState(isEnabled: Bool, newTitle: String? = nil) {
        let color = isEnabled ? UIColor.greenActiveColor : UIColor.grayDisableColor
        let title = newTitle ?? titleLabel?.text
        self.animatedChange(to: color, newTitle: title, enabled: isEnabled)
    }

}
