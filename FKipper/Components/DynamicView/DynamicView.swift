//
//  DynamicView.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 16/07/2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import UIKit

protocol DynamicEntryViewProtocol {
    var id: String { get }
    var title: String { get }
    var image: UIImage? { get }
}

protocol DynamicViewDelegate: class {
    func didTap(_ sender: DynamicView)
}

struct Sizes {
    static let dynamicViewSize: CGSize = CGSize(width: 64.0, height: 64.0)
}

class DynamicView: UIView {
    
    var id: String
    var title: String
    var endPosition: CGPoint
    weak var delegate : DynamicViewDelegate!
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 10.0, height: 10.0)))
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, center: CGPoint, endPosition: CGPoint, entry: DynamicEntryViewProtocol) {
        self.endPosition = endPosition
        self.title = entry.title
        self.id = entry.id
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnView(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        self.addSubview(titleLabel)
        titleLabel.text = String(title.first ?? "!")
        configureLayer()
        configureImage(image: entry.image)
    }
    
    private func configureLayer() {
        let radius = frame.width / 2
        layer.cornerRadius = radius
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    }
    
    private func configureImage(image: UIImage?) {
        guard let image = image else { return }
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .center
        addSubview(imageView)
        imageView.image = image
        imageView.tintColor = UIColor.darkGray
    }
    
    @objc private func tapOnView(_ sender: UITapGestureRecognizer) {
        print("single tap in view \(self.description)")
        delegate?.didTap(self)
    }
    
    func setup(angle: Double) {
        
        // Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        shapeLayer.path = createBezierPath().cgPath
        
        // apply other properties related to the path
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        //        shapeLayer.position = CGPoint(x: 10, y: 10)
        
        // add the new layer to our custom view
        self.layer.addSublayer(shapeLayer)
    }
    
    func createBezierPath() -> UIBezierPath {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 49.64, y: 95.75))
        bezierPath.addCurve(to: CGPoint(x: 14.36, y: 95.75), controlPoint1: CGPoint(x: 32, y: 86.2), controlPoint2: CGPoint(x: 14.36, y: 95.75))
        bezierPath.addLine(to: CGPoint(x: 0.25, y: 12.98))
        bezierPath.addCurve(to: CGPoint(x: 32, y: 0.25), controlPoint1: CGPoint(x: 0.25, y: 12.98), controlPoint2: CGPoint(x: 16.12, y: 0.25))
        bezierPath.addCurve(to: CGPoint(x: 63.75, y: 12.98), controlPoint1: CGPoint(x: 47.88, y: 0.25), controlPoint2: CGPoint(x: 63.75, y: 12.98))
        bezierPath.addLine(to: CGPoint(x: 49.64, y: 95.75))
        UIColor.black.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .bevel
        bezierPath.stroke()
        
        return bezierPath
    }
    
    static func calculateViewPosition(indexOfView: Int,
                                      center: CGPoint,
                                      radius: Double,
                                      viewsCount: Int) -> CGPoint{
        let angle = Double(indexOfView * (360 / viewsCount)) + 180
        let result = Measurement(value: angle, unit: UnitAngle.degrees)
            .converted(to: .radians).value
        let x: Double = Double(Double(center.x) + (radius * sin(result)))
        let y: Double = Double(Double(center.y) + (radius * cos(result)))
        return CGPoint(x: x, y: y)
    }
    
}
