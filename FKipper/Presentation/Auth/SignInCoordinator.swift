//
//  SignInCoordinator.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 27.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

protocol SignInCoordinatorDelegate {
    func didSignIn()
}

class SignInCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let delegate: SignInCoordinatorDelegate
    
    init(on navigationController: UINavigationController,
         delegate: SignInCoordinatorDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    override func start() {
        let viewModel = SignInViewModel(title: "SignInTitle".localized()) // Need title
        let viewController = SignInViewController.initFromStoryboard(name: "Auth")
        viewController.viewModel = viewModel
        self.navigationController.present(viewController, animated: true, completion: nil)
//        viewModel
//            .showSignUpViewController
//            .flatMap { [weak self] _ -> Observable<UUser?> in
//                guard let `self` = self else { return .empty() }
//
//                return self.showSignUpViewController(on: viewController)
//            }.subscribe(onNext:{ user in
//                if user != nil {
//                    self.
//                }
//            })
//            .disposed(by: disposeBag)
        
        viewModel
            .showSpendingsViewController
            .subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.delegate.didSignIn()
        }).disposed(by: disposeBag)
    }
    
//    private func showSignUpViewController(on rootViewController: UIViewController) -> Observable<UUser?> {
//        let signUpCoordinator = SignUpCoordinator(rootViewController: rootViewController)
//        return coordinate(to: signUpCoordinator)
//            .map { result in
//                switch result {
//                case .success(let user): return user
//                case .cancel: return nil
//                }
//        }
//    }
//
//    private func showSpendingsViewController(on window: UIWindow) {
//        let spendingsCoordinator = SpendingsCoordinator(window: window)
//        _ = coordinate(to: spendingsCoordinator)
//    }
}
