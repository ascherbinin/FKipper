//
//  SignInViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 27.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

protocol SignInViewModelCoordinatorDelegate {
    func didSignIn(from controller: UIViewController)
    func needShowSignUp(from controller: UIViewController)
}

class SignInViewModel {
    
    var coordinatorDelegate: SignInViewModelCoordinatorDelegate!
    
    let title: Observable<String>
    let showSignUp: AnyObserver<Void>
    let signInSuccess: AnyObserver<Void>
    let showSignUpViewController: Observable<Void>
    let didSignIn: Observable<Void>
    
    let isValid = Variable<Bool>(false)
    
    let emailField = EmailFieldViewModel()
    let passwordField = PasswordFieldViewModel()
    var errorMessage = Variable<String?>(nil)
    
    let disposeBag = DisposeBag()
    
    func validForm() -> Bool {
        return emailField.validate() && passwordField.validate()
    }
    
    init(title: String) {
        
        self.title = Observable.just(title)
        
//        let _selectSpend = PublishSubject<SpendViewModel>()
//        self.selectSpend = _selectSpend.asObserver()
//        self.selectedSpend = _selectSpend.asObservable().map{$0.spend}
//        
//        query = baseQuery()
        
        let _showSignUp = PublishSubject<Void>()
        self.showSignUp = _showSignUp.asObserver()
        self.showSignUpViewController = _showSignUp.asObservable()
        
        emailField.errorValue.asObservable().bind(to: errorMessage).disposed(by: disposeBag)
        passwordField.errorValue.asObservable().bind(to: errorMessage).disposed(by: disposeBag)
        
        let _signInSuccess = PublishSubject<Void>()
        self.signInSuccess = _signInSuccess.asObserver()
        self.didSignIn = _signInSuccess.asObservable()
    
        Observable.combineLatest(emailField.value.asObservable(),
                                 passwordField.value.asObservable())
            .map {!$0.0.isEmpty && !$0.1.isEmpty}
            .bind(to: isValid)
            .disposed(by: disposeBag)
        
    }
    
    func signin() {
        Auth.auth().signIn(withEmail: emailField.getValue(),
                           password: passwordField.getValue()) { [weak self] (user, error) in
            if error == nil {
                print("SIGNIN COMPLETE \(user?.email ?? "EMPTY EMAIL")")
                self?.signInSuccess.onNext(())
            }
            else {
                self?.errorMessage.value = error?.localizedDescription
            }
        }
    }
}
