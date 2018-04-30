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
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var tfPwd: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPwd: UILabel!
    
    
    var viewModel: AuthViewModel!
    private let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    private func setupBindings() {
        viewModel
            .title
            .asObservable()
            .subscribe(onNext: {[weak self] title in
                self?.title = title
            }).disposed(by: disposeBag)
        
        btnSignUp.rx.tap
            .bind(to: viewModel.showSignUp)
            .disposed(by: disposeBag)
        
    }
}
