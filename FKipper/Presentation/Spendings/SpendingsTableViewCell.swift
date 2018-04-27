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

class SpendingsTableViewCell: UITableViewCell {
    
    static let reuseIdentificator = "SpendingsCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    
    let disposeBag = DisposeBag()
    
    var spendViewModel: SpendViewModel? {
        didSet {
            guard let svm = spendViewModel else {
                return
            }
            
            svm.titleText.bind(to:lblTitle.rx.text).disposed(by: disposeBag)
            svm.categoryText.bind(to:lblCategory.rx.text).disposed(by: disposeBag)
            svm.costValue.map{"\($0)"}.bind(to:lblValue.rx.text).disposed(by: disposeBag)
            svm.date.map{$0.toShortString()}.bind(to: lblDate.rx.text).disposed(by: disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        vwBackground.layer.cornerRadius = 10
        vwBackground.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
    
    
}
