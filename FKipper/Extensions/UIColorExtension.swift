//
//  UIColorExtensions.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 07.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation

extension UIColor {
    
    open class var greenActiveColor: UIColor {
        return UIColor(red: 212/255, green: 251/255, blue: 121/255, alpha: 1)
    }
    
    open class var grayDisableColor: UIColor {
        return UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    open class var darkBlueColor: UIColor {
        return UIColor(red: 0/255, green: 84/255, blue: 147/255, alpha: 1)
    }
    
    open class var lightBlueColor: UIColor {
        return UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1)
    }
    
    convenience init(_ hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
