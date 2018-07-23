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
//
//class NibLoadingView: UIView {
//
//    @IBOutlet weak var view: UIView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        nibSetup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        nibSetup()
//    }
//
//    private func nibSetup() {
//        backgroundColor = .clear
//
//        view = loadViewFromNib()
//        view.frame = bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.translatesAutoresizingMaskIntoConstraints = true
//
//        addSubview(view)
//    }
//
//    private func loadViewFromNib() -> UIView {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
//        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
//
//        return nibView
//    }
//}


class NibView: UIView {
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
    }
}

private extension NibView {
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
}

extension UIView {
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
