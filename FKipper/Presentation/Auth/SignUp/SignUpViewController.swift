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
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var viewModel: SignUpViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

     private func configureBindings() {
        btnCancel.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return}
            strongSelf.viewModel.coordinatorDelegate.cancel(from: strongSelf)
        }).disposed(by: disposeBag)
        
        btnSignUp.rx.tap
            .bind(to: viewModel.didTapSignUp)
            .disposed(by: disposeBag)
        
        
        textFieldEmail.rx.text.orEmpty.bind(to: viewModel.emailField.value).disposed(by: disposeBag)
        textFieldPassword.rx.text.orEmpty.bind(to: viewModel.passwordField.value).disposed(by: disposeBag)
        textFieldUsername.rx.text.orEmpty.bind(to: viewModel.userNameField).disposed(by: disposeBag)
        
        viewModel.isValid
            .asObservable()
            .subscribe(onNext: {[weak self] isValid in
                self?.btnSignUp.changeState(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        
        self.view.applyGradient(colours: [UIColor.darkBlueColor, UIColor.lightBlueColor],
                                locations: [0.2, 0.7],
                                direction: GradientPoint.bottomTop.draw())
        
        btnSignUp.applyGradient(colours: [UIColor.lightGray, UIColor.clear],
                                locations: [0.3, 0.6],
                                direction: GradientPoint.topBottom.draw(),  withAlpha: 0.1)
        
        localize()
    }
    
    
    
    private func localize() {
        btnSignUp.setTitle("SignUp".localized(), for: .normal)
        btnCancel.setTitle("Cancel".localized(), for: .normal)
    }
}

