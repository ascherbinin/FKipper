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
    
    @IBOutlet weak var logoView: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var newAccountLabel: UILabel!
    
    
    var viewModel: SignInViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configureBindings() {
        textFieldEmail.rx.text.orEmpty.bind(to: viewModel.emailField.value).disposed(by: disposeBag)
        textFieldPassword.rx.text.orEmpty.bind(to: viewModel.passwordField.value).disposed(by: disposeBag)
        
        textFieldEmail.rx.controlEvent(UIControlEvents.editingDidEnd).subscribe(onNext: { [weak self] _ in
            self?.textFieldPassword.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        viewModel
            .title
            .asObservable()
            .subscribe(onNext: {[weak self] title in
                self?.title = title
            }).disposed(by: disposeBag)
        
        btnSignUp.rx.tap
            .bind(to: viewModel.showSignUp)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .asObservable()
            .subscribe(onNext: {[weak self] isValid in
                self?.btnLogin.changeState(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
        
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
    
    private func configureUI() {
        self.view.applyGradient(colours: [UIColor.darkBlueColor, UIColor.lightBlueColor],
                                locations: [0.2, 0.7],
                                direction: GradientPoint.bottomTop.draw())
        
        btnLogin.applyGradient(colours: [UIColor.lightGray, UIColor.clear],
                               locations: [0.3, 0.6],
                               direction: GradientPoint.topBottom.draw(),  withAlpha: 0.1)
        localize()
    }
    
    private func localize() {
        btnLogin.setTitle("Login".localized(), for: .normal)
        btnSignUp.setTitle("SignUp".localized(), for: .normal)
        newAccountLabel.text = "NewAccountQuestion".localized()
    }
    
}

extension SignInViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return FlipPresentAnimationController(originFrame: self.view.frame)
    }
}
