//
//  AppCoordinator.swift
//                   
//
//  Created by Scherbinin Andrey on 26.01.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AppCoordinator: Coordinator {
    
    private let window: UIWindow?
    private let isLogged: Bool = false
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        if !isLogged {
            showAuth()
        } else {
            showMainScreen()
        }
    }
    
    override func finish() {
        
    }
    
    private func showAuth() {
        let signInViewController = SignInCoordinator(on: rootViewController, delegate: self)
        addChildCoordinator(signInViewController)
        signInViewController.start()
    }
    
    private func showMainScreen () {
        let spendingsListCoordinator = SpendingsListCoordinator(with: rootViewController)
        spendingsListCoordinator.delegate = self
        addChildCoordinator(spendingsListCoordinator)
        spendingsListCoordinator.start()
        print("haliluya open main screen")
    }
}

extension AppCoordinator: SignInCoordinatorDelegate {
    func didSignIn(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showMainScreen()
    }
}

extension AppCoordinator: SpendingsListCoordinatorDelegate {
    func exit(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
        showAuth()
    }
}

