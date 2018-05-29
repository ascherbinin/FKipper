//
//  CategoryView.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 29.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation


class CategoryView : UIView {

    var categoryID: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("My Custom Init");
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented"); }
    
    func setup(category: Category) {
        categoryID = category.hashValue
        setupViews(category: category)
    }
    
    private func setupViews(category: Category) {
        let bgView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        bgView.image = #imageLiteral(resourceName: "hexagon")
        let ivCategory = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        ivCategory.contentMode = .center
        ivCategory.tintColor = UIColor.darkGray
        ivCategory.image = category.image()
        bgView.addSubview(ivCategory)
        self.addSubview(bgView)
        self.alpha = 0.65
        layoutSubviews()
    }
}
