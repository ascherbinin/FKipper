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
    func didSignIn(from coordinator: Coordinator)
}

class SignInCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let delegate: SignInCoordinatorDelegate
    
    lazy var signInViewModel: SignInViewModel! = {
        let viewModel = SignInViewModel(title: "SignInTitle".localized()) 
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    lazy var signUpViewModel: SignUpViewModel! = {
        let viewModel = SignUpViewModel("")
        viewModel.coordinatorDelegate = self
        return viewModel
    }()
    
    init(on navigationController: UINavigationController,
         delegate: SignInCoordinatorDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    override func start() {
        let viewController = SignInViewController.initFromStoryboard(name: "Auth")
        viewController.viewModel = signInViewModel
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
        
//        viewModel
//            .showSpendingsViewController
//            .subscribe(onNext: { [weak self] _ in
//            guard let `self` = self else { return }
//            self.delegate.didSignIn()
//        }).disposed(by: disposeBag)
    }
    
    private func showSignUpViewController(from controller: UIViewController) {
        let signUpViewController = SignUpViewController.initFromStoryboard(name: "Auth")
        signUpViewController.viewModel = signUpViewModel
        if let signInVC = controller as? SignInViewController {
            signUpViewController.transitioningDelegate = signInVC
        }
        controller.present(signUpViewController, animated: true, completion: nil)
    }
//
//    private func showSpendingsViewController(on window: UIWindow) {
//        let spendingsCoordinator = SpendingsCoordinator(window: window)
//        _ = coordinate(to: spendingsCoordinator)
//    }
}

extension SignInCoordinator: SignInViewModelCoordinatorDelegate {
    func needShowSpendings() {
        delegate.didSignIn(from: self)
    }
    
    func needShowSignUp(from controller: UIViewController) {
        showSignUpViewController(from: controller)
    }
    
}

extension SignInCoordinator: SignUpViewModelCoordinatorDelegate {
    func cancel(from controller: UIViewController) {
         controller.dismiss(animated: true, completion: nil)
    }
    
    func successSignUp(from controller: UIViewController) {
        delegate.didSignIn(from: self)
        controller.dismiss(animated: true, completion: nil)
    }

}
