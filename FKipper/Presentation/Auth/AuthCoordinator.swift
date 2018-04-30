//
//  AuthCoordinator.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 27.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

class AuthCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = AuthViewModel(title: "AuthTitle".localized()) // Need title
        let viewController = AuthViewController.initFromStoryboard(name: "Auth")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewModel.showSignUpViewController
            .flatMap { [weak self] _ -> Observable<UUser?> in
                guard let `self` = self else { return .empty() }
                
                return self.showSignUpViewController(on: viewController)
            }.subscribe(onNext:{ user in
                print(user?.email ?? "Empty")
            })
            // Ignore nil results which means that Language List screen was dismissed by cancel button.
//            .filter { $0 != nil }
//            .map { $0! }
            // Bind selected language to the `setCurrentLanguage` observer of the View Model
//            .bind(to: viewModel.c)
            .disposed(by: disposeBag)
        
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
}
