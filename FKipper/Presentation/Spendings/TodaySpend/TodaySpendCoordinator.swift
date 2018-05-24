//
//  TodaySpendCoordinator.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 24.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation

protocol TodaySpendCoordinatorDelegate {
    func exit(from coordinator: Coordinator)
    func didFinish(from coordinator: Coordinator)
}


class TodaySpendCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    var delegate: TodaySpendCoordinatorDelegate!

    
    lazy var todaySpendViewModel: TodaySpendViewModel! = {
        let viewModel = TodaySpendViewModel("SignInTitle".localized())
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    lazy var spendingsListSpendViewModel: SpendingsListViewModel! = {
        let viewModel = SpendingsListViewModel(title: "SignInTitle".localized())
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    init(on navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewController = TodaySpendViewController.initFromStoryboard(name: "Main")
        viewController.viewModel = todaySpendViewModel
        
        todaySpendViewModel.didExit
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.delegate.exit(from: strongSelf)
            }).disposed(by: disposeBag)
        
        todaySpendViewModel.didTapOnList.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.todaySpendViewModel.coordinatorDelegate.needShowSpendingsList(from: viewController)
        }).disposed(by: disposeBag)
        
        self.navigationController.setViewControllers([viewController], animated: true)
    }
    
}

extension TodaySpendCoordinator : TodaySpendViewModelCoordinatorDelegate {
    func needShowSpendingsList(from controller: UIViewController) {
        let spendingsListViewController = SpendingsListViewController.initFromStoryboard(name: "Main")
        spendingsListViewController.viewModel = spendingsListSpendViewModel
        navigationController.pushViewController(spendingsListViewController, animated: true)
    }
    

}

extension TodaySpendCoordinator : SpendingsListViewModelCoordinatorDelegate {
    func cancel(from controller: UIViewController) {
        navigationController.popViewController(animated: true)
    }
    
    
}
