//
//  SpendingsViewController.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 23.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Toast_Swift

class SpendingsViewController: UIViewController, StoryboardInitializable, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel: SpendingsViewModel!
    private let disposeBag = DisposeBag()
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<SectionOfSpends> = SpendingsViewController.dataSource()
    
    private let exitButton = UIBarButtonItem(barButtonSystemItem: .action , target: nil, action: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSpendsWithTableView()
        
        navigationItem.leftBarButtonItem = exitButton
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 66
        
        tableView.rx
            .modelSelected(SpendViewModel.self)
            .bind(to: viewModel.selectSpend)
            .disposed(by: disposeBag)
        
//        viewModel.selectedSpend.asObservable().subscribe(onNext: { spend in
//            print(spend.title)
//        }).disposed(by: disposeBag)
        
        viewModel
            .title
            .asObservable()
            .subscribe(onNext: {[weak self] title in
            self?.title = title
        }).disposed(by: disposeBag)
        
        viewModel
            .showActivity
            .subscribe(onNext: {[weak self] needShow in
            if needShow {
                self?.view.makeToastActivity(.center)
            }
            else {
                self?.view.hideToastActivity()
            }
        }).disposed(by: disposeBag)
        
        exitButton.rx.tap.debug("====TAP")
            .bind(to: viewModel.exit)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startObserveQuery()
    }

    private func bindSpendsWithTableView() {
        viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension SpendingsViewController {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<SectionOfSpends> {
        
        func setupSectionHeader(_ header: String) -> String {
            switch header {
            case Date().toShortString():
                return "Today".localized()
            case Date().dateBefore(byDays: 1):
                return "Yesterday".localized()
            default:
                return header
            }
        }
        
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .middle,
                                                           reloadAnimation: .none,
                                                           deleteAnimation: .none),
            configureCell: { (dataSource, table, idxPath, item) in
                let cell = table.dequeueReusableCell(withIdentifier: SpendingsTableViewCell.reuseIdentificator, for: idxPath) as? SpendingsTableViewCell
                 cell?.spendViewModel = item
                return cell!
        },
            titleForHeaderInSection: { (ds, section) -> String? in
                return setupSectionHeader(ds[section].header)
        }
        )
    }
}


