//
//  RecipeTableViewCell.swift
//  EatIT
//
//  Created by Scherbinin Andrey on 11.12.17.
//  Copyright © 2017 Scherbinin Andrey. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
class RecipeTableViewCell: UITableViewCell {
    
    static let reuseIdentificator = "RecipeCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var vwBackground: UIView!
    
    let disposeBag = DisposeBag()
    
    var recipeViewModel: RecipeViewModel? {
        didSet {
            guard let rvm = recipeViewModel else {
                return
            }
            
            rvm.titleText.bind(to:lblTitle.rx.text).disposed(by: disposeBag)
            rvm.authorText.bind(to:lblAuthor.rx.text).disposed(by: disposeBag)
            rvm.imageURL.subscribe(onNext: { [weak self] url in
                self?.ivImage.kf.setImage(with: url)
            }).disposed(by: disposeBag)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwBackground.layer.cornerRadius = 10
        vwBackground.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
    }


}
