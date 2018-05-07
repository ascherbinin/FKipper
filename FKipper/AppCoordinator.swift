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

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let authCoordinator = SignInCoordinator(window: window)
        return coordinate(to: authCoordinator)
    }
}
