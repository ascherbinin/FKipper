//
//  SpendingsCoordinator.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 23.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//
import RxSwift

protocol SpendingsListCoordinatorDelegate {
    func exit(from coordinator: Coordinator)
}

class SpendingsListCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    var delegate: SpendingsListCoordinatorDelegate!
    
    init(with rootNavigationViewController: UINavigationController) {
        self.navigationController = rootNavigationViewController
    }
    
    override func start() {
        let viewModel = SpendingsViewModel(title: "SpendingsTitle".localized())
        let viewController = SpendingsViewController.initFromStoryboard(name: "Main")
        
        viewController.viewModel = viewModel
        
        viewModel.selectedSpend
            .subscribe(onNext: { [weak self] spend in
                self?.showSpend(in: self?.navigationController, by: spend) })
            .disposed(by: disposeBag)
        
        viewModel.didExit
            .subscribe(onNext: { [weak self] _ in
//            viewController.dismiss(animated: true, completion: nil)
                guard let strongSelf = self else { return }
//            self?.showAuth(on: self?.window)
            strongSelf.delegate.exit(from: strongSelf)
        }).disposed(by: disposeBag)
        
        //        viewModel.
        //            .flatMap { [weak self] _ -> Observable<String?> in
        //                guard let `self` = self else { return .empty() }
        //                return self.showLanguageList(on: viewController)
        //            }
        //            .filter { $0 != nil }
        //            .map { $0! }
        //            .bind(to: viewModel.setCurrentLanguage)
        //            .disposed(by: disposeBag)
        //
//
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//
//        return Observable.never()
        
        self.navigationController.present(viewController, animated: true, completion: nil)
    }
    
    private func showSpend(in navigationController: UINavigationController?, by spend: Spend) {
       print("\(spend.title)")
    }
    
//    private func showAuth(on window: UIWindow?) {
//        guard let window = window else { return }
//        let appCoordinator = AppCoordinator(window: window)
//        _ = coordinate(to: appCoordinator)
//    }
    
    //    private func showLanguageList(on rootViewController: UIViewController) -> Observable<String?> {
    //        let languageListCoordinator = LanguageListCoordinator(rootViewController: rootViewController)
    //        return coordinate(to: languageListCoordinator)
    //            .map { result in
    //                switch result {
    //                case .language(let language): return language
    //                case .cancel: return nil
    //                }
    //        }
    //    }
}
