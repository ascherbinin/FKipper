//
//  SpendingsTableViewCell.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 23.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SpendingsListTableViewCell: UITableViewCell {
    
    static let reuseIdentificator = "SpendingsCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    
    let disposeBag = DisposeBag()
    
    var spendViewModel: SpendViewModel? {
        didSet {
            guard let svm = spendViewModel else {
                return
            }
            
            svm.titleText.bind(to:lblTitle.rx.text).disposed(by: disposeBag)
            svm.category.map{$0.type.image()}.bind(to:categoryImageView.rx.image).disposed(by: disposeBag)
            svm.costValue.map{"\($0)"}.bind(to:lblValue.rx.text).disposed(by: disposeBag)
            svm.date.map{$0.toTimeString()}.bind(to: lblDate.rx.text).disposed(by: disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        imageBackground.layer.cornerRadius = 20
        imageBackground.layer.borderWidth = 1
        imageBackground.layer.borderColor = UIColor.darkGray.cgColor
//        self.container.backgroundColor = [UIColor clearColor];
        imageBackground.layer.shadowColor = UIColor.black.cgColor;
        imageBackground.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageBackground.layer.shadowOpacity = 0.5
        imageBackground.layer.shadowRadius = 2.0
        imageBackground.layer.shadowPath = UIBezierPath(roundedRect: imageBackground.bounds, cornerRadius: 20).cgPath
//        vwBackground.layer.cornerRadius = 10
//        vwBackground.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}
