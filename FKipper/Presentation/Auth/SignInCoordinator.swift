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
    func didFinish(from coordinator: Coordinator)
}

class SignInCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    var delegate: SignInCoordinatorDelegate!
    
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
    
    init(on navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewController = SignInViewController.initFromStoryboard(name: "Auth")
        viewController.viewModel = signInViewModel
        self.navigationController.setViewControllers([viewController], animated: true)
//        self.navigationController.present(viewController, animated: true, completion: nil)
    }
    
    private func showSignUpViewController(from controller: UIViewController) {
        let signUpViewController = SignUpViewController.initFromStoryboard(name: "Auth")
        signUpViewController.viewModel = signUpViewModel
        if let signInVC = controller as? SignInViewController {
            signUpViewController.transitioningDelegate = signInVC
        }
        controller.present(signUpViewController, animated: true, completion: nil)
    }
    
    override func finish() {
        delegate?.didFinish(from: self)
    }

}

extension SignInCoordinator: SignInViewModelCoordinatorDelegate {
    func didSignIn(from controller: UIViewController) {
        delegate.didSignIn(from: self)
    }
    
    func needShowSignUp(from controller: UIViewController) {
        showSignUpViewController(from: controller)
    }
    
}

extension SignInCoordinator: SignUpViewModelCoordinatorDelegate {
    func didSignUp(from controller: UIViewController) {
        delegate.didSignIn(from: self)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func cancel(from controller: UIViewController) {
         controller.dismiss(animated: true, completion: nil)
    }
}
