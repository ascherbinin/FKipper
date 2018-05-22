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

class AppCoordinator: Coordinator, SignInCoordinatorDelegate {
    
    func didSignIn() {
//        removeChildCoordinator(<#T##coordinator: Coordinator##Coordinator#>)
        showMainScreen()
    }
    
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
        signInViewController.start()
    }
    
    private func showMainScreen () {
        print("haliluya open main screen")
    }
}
