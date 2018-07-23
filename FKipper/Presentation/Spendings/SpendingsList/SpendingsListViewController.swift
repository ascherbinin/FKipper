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

class SpendingsListViewController: UIViewController, StoryboardInitializable, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var viewModel: SpendingsListViewModel!
    private let disposeBag = DisposeBag()
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<SectionOfSpends> = SpendingsListViewController.dataSource()
    
    private let exitButton = UIBarButtonItem(barButtonSystemItem: .action , target: nil, action: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSpendsWithTableView()
        configureEvents()
       // navigationItem.leftBarButtonItem = exitButton
        
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.startObserveQuery()
    }
    
    private func configureEvents() {
        exitButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return}
            strongSelf.viewModel.coordinatorDelegate.cancel(from: strongSelf)
        }).disposed(by: disposeBag)
        
        segmentedControl.rx.value.bind(to: viewModel.selectedFilter).disposed(by: disposeBag)
    }


    private func bindSpendsWithTableView() {
        viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension SpendingsListViewController {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<SectionOfSpends> {
        
//        func setupSectionHeader(_ header: String) -> String {
//
//        }
//
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .fade),
            configureCell: { (dataSource, table, idxPath, item) in
                let cell = table.dequeueReusableCell(withIdentifier: SpendingsListTableViewCell.reuseIdentificator, for: idxPath) as? SpendingsListTableViewCell
                 cell?.spendViewModel = item
                return cell!
        },
            titleForHeaderInSection: { (ds, section) -> String? in
                return ds[section].sectionHeader()
        }
        )
    }
}


