//
//  SignInCoordinator.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 27.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

class SignInCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = SignInViewModel(title: "SignInTitle".localized()) // Need title
        let viewController = SignInViewController.initFromStoryboard(name: "Auth")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewModel
            .showSignUpViewController
            .flatMap { [weak self] _ -> Observable<UUser?> in
                guard let `self` = self else { return .empty() }
                
                return self.showSignUpViewController(on: viewController)
            }.subscribe(onNext:{ user in
                if user != nil {
                    self.showSpendingsViewController(on: self.window)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .showSpendingsViewController
            .subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.showSpendingsViewController(on: self.window)
        }).disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }

    private func showSignUpViewController(on rootViewController: UIViewController) -> Observable<UUser?> {
        let signUpCoordinator = SignUpCoordinator(rootViewController: rootViewController)
        return coordinate(to: signUpCoordinator)
            .map { result in
                switch result {
                case .success(let user): return user
                case .cancel: return nil
                }
        }
    }
    
    private func showSpendingsViewController(on window: UIWindow) {
        let spendingsCoordinator = SpendingsCoordinator(window: window)
        _ = coordinate(to: spendingsCoordinator)
    }
}
