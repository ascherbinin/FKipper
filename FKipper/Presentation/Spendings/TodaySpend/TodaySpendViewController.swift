//
//  TodaySpendViewController.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 24.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift
import RxAnimated

class TodaySpendViewController: UIViewController, StoryboardInitializable {
    
    var viewModel: TodaySpendViewModelType!
    private let disposeBag = DisposeBag()
    private var viewsIds: [Int] = []

    @IBOutlet weak var lblTotalSpend: UILabel!
    @IBOutlet weak var vwCircle: UIView!
    
    private let exitButton = UIBarButtonItem(barButtonSystemItem: .action , target: nil, action: nil)
    
    private let listButton = UIBarButtonItem(barButtonSystemItem: .bookmarks , target: nil, action: nil)
    
    private let addButton = UIBarButtonItem(barButtonSystemItem: .add , target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = exitButton
        
        let rightButtons = [listButton, addButton]

        navigationItem.rightBarButtonItems = rightButtons
        
        vwCircle.layer.borderColor = UIColor.darkGray.cgColor
        
        viewModel
            .titleText
            .asObservable()
            .subscribe(onNext: {[weak self] title in
                self?.title = title
            }).disposed(by: disposeBag)
        
//        viewModel
//            .showActivity
//            .subscribe(onNext: {[weak self] needShow in
//                if needShow {
//                    self?.view.makeToastActivity(.center)
//                }
//                else {
//                    self?.view.hideToastActivity()
//                }
//            }).disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind(to: viewModel.exit)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.tapOnAdd)
            .disposed(by: disposeBag)
        
        viewModel
            .totalSpendToday
            .asObservable()
            .map{"\($0)"}
            .distinctUntilChanged()
            .bind(animated: lblTotalSpend.rx.animated.tick(.top, duration: 0.33).text)
            .disposed(by: disposeBag)
        
        viewModel.todaySpends.bind { (spends) in
            self.drawCategoriesViews(todaySpends: spends)
        }.disposed(by: disposeBag)
        
        listButton.rx.tap
            .bind(to: viewModel.tapOnList)
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.startObserveQuery()
    }
    
    fileprivate func drawCategoriesViews(todaySpends: [Spend]) {
//        let categoriesSpends = todaySpends.removingDuplicates()
        let sorted = todaySpends.sorted { (sp1, sp2) -> Bool in
            sp1.date > sp2.date
        }
        for (index, spend) in sorted.enumerated() {
            let angle = Double(index * 45)
            if !viewsIds.contains(where: { $0 == spend.category.hashValue}) {
                let center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY)
                let radius: Double = 95
                let result = Measurement(value: angle, unit: UnitAngle.degrees)
                    .converted(to: .radians).value
                let x: Double = Double(Double(center.x) + (radius * sin(result))) - 24
                let y: Double = Double(Double(center.y) + (radius * cos(result))) - 24
                let categoryView = CategoryView(frame: CGRect(x: x, y: y, width: 48.0, height: 48.0))
                categoryView.setup(category: spend.category)
                viewsIds.append(spend.category.hashValue)
                self.view.addSubview(categoryView)
            }
        }
    }

  
}
