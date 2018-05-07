//
//  SignInViewController.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 27.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class SignInViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPwd: UILabel!
    
    
    var viewModel: SignInViewModel!
    private let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBindings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    private func configureBindings() {
        textFieldEmail.rx.text.orEmpty.bind(to: viewModel.emailField.value).disposed(by: disposeBag)
        textFieldPassword.rx.text.orEmpty.bind(to: viewModel.passwordField.value).disposed(by: disposeBag)
        
        viewModel
            .title
            .asObservable()
            .subscribe(onNext: {[weak self] title in
                self?.title = title
            }).disposed(by: disposeBag)
        
        btnSignUp.rx.tap
            .bind(to: viewModel.showSignUp)
            .disposed(by: disposeBag)
        
//        viewModel.isValid.map { $0 }
//            .bind(to: btnLogin.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        btnLogin.rx.tap
            .do(onNext:  { [unowned self] in
                self.textFieldEmail.resignFirstResponder()
                self.textFieldPassword.resignFirstResponder()
            }).subscribe(onNext: { [unowned self] in
                if self.viewModel.validForm() {
                    self.viewModel.signin()
                }
            }).disposed(by: disposeBag)
        
        
        viewModel.errorMessage
            .asObservable()
            .filter{$0 != nil}
            .bind { [weak self] errorMessage in
                self?.view.makeToast(errorMessage)
            }.disposed(by: disposeBag)
    }
}
