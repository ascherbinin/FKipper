//
//  CheckInCoordinator.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 28.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

enum SignUpCoordinatorResult {
    case success(UUser)
    case cancel
}

class SignUpCoordinator: BaseCoordinator<SignUpCoordinatorResult> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<SignUpCoordinatorResult> {
        // Initialize a View Controller from the storyboard and put it into the UINavigationController stack
        let viewController = SignUpViewController.initFromStoryboard(name: "Auth")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        // Initialize a View Model and inject it into the View Controller
        let viewModel = SignUpViewModel("")
        viewController.viewModel = viewModel
        
        // Map the outputs of the View Model to the LanguageListCoordinationResult type
        let cancel = viewModel.didCancel.map { _ in SignUpCoordinatorResult.cancel }
        let user = viewModel.didSuccessSignUp.map { SignUpCoordinatorResult.success($0) }
        
        // Present View Controller onto the provided rootViewController
        rootViewController.present(navigationController, animated: true)
        
        // Merge the mapped outputs of the view model, taking only the first emitted event and dismissing the View Controller on that event
        return Observable.merge(cancel, user)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}
