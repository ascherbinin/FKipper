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
        startObserveAuthState()
    }
    
    override func finish() {
        
    }
    
    private func showAuth() {
        let signInViewCoordinator = SignInCoordinator(on: rootViewController)
        signInViewCoordinator.delegate = self
        addChildCoordinator(signInViewCoordinator)
        
        signInViewCoordinator.start()
    }
    
    private func showMainScreen (for userID: String?) {
        guard let uid = userID else {
            return
        }
        let todaySpendCoordinator = TodaySpendCoordinator(on: rootViewController, for: uid)
        todaySpendCoordinator.delegate = self
        addChildCoordinator(todaySpendCoordinator)
        todaySpendCoordinator.start()
        print("haliluya open main screen")
    }
    
    private func startObserveAuthState() {
        Auth.auth().addStateDidChangeListener() {[weak self] auth, user in
        // 2
            if user != nil {
                self?.showMainScreen(for: user?.uid)
            }
            else {
                self?.showAuth()
            }
        }
    }
}

extension AppCoordinator: SignInCoordinatorDelegate {
    func didFinish(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
    
    func didSignIn(from coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
//        showMainScreen()
    }
}

extension AppCoordinator: TodaySpendCoordinatorDelegate {
    func exit(from coordinator: Coordinator) {
        do {
            try Auth.auth().signOut()
              removeChildCoordinator(coordinator)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
}

