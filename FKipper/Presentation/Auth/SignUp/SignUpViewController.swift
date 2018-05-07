//
//  CheckInViewController.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 28.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//


import UIKit
import RxSwift

class SignUpViewController: UIViewController, StoryboardInitializable {
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lblPwd: UILabel!
    @IBOutlet weak var tfPwd: UITextField!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var viewModel: SignUpViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
//        viewModel
//            .title
//            .asObservable()
//            .subscribe(onNext: {[weak self] title in
//                self?.title = title
//            }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
       // navigationItem.title = "Check In"
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
     private func setupBindings() {
        btnCancel.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
        
        btnSignUp.rx.tap
            .bind(to: viewModel.didTapSignUp)
            .disposed(by: disposeBag)
        
        
        tfEmail.rx.text.orEmpty.bind(to: viewModel.emailField.value).disposed(by: disposeBag)
        tfPwd.rx.text.orEmpty.bind(to: viewModel.passwordField.value).disposed(by: disposeBag)
        
    }
}

