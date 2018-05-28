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

    @IBOutlet weak var lblTotalSpend: UILabel!
    
    private let exitButton = UIBarButtonItem(barButtonSystemItem: .action , target: nil, action: nil)
    
    private let listButton = UIBarButtonItem(barButtonSystemItem: .bookmarks , target: nil, action: nil)
    
    private let addButton = UIBarButtonItem(barButtonSystemItem: .add , target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = exitButton
        
        let rightButtons = [listButton, addButton]

        navigationItem.rightBarButtonItems = rightButtons
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 66
//
//        tableView.rx
//            .modelSelected(SpendViewModel.self)
//            .bind(to: viewModel.selectSpend)
//            .disposed(by: disposeBag)
        
        //        viewModel.selectedSpend.asObservable().subscribe(onNext: { spend in
        //            print(spend.title)
        //        }).disposed(by: disposeBag)
        
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
            .bind(animated: lblTotalSpend.rx.animated.tick(.top, duration: 0.33).text)
            .disposed(by: disposeBag)
        
        listButton.rx.tap
            .bind(to: viewModel.tapOnList)
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.startObserveQuery()
    }
  
}
