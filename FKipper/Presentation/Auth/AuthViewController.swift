//
//  AuthViewController.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 27.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import UIKit
import RxSwift

class AuthViewController: UIViewController, StoryboardInitializable {
    
    var viewModel: AuthViewModel!
    private let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .title
            .asObservable()
            .subscribe(onNext: {[weak self] title in
                self?.title = title
            }).disposed(by: disposeBag)
    }
    
}
