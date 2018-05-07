//
//  SignInViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 27.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

class SignInViewModel {
    
    let title: Observable<String>
    let showSignUp: AnyObserver<Void>
    let showSpendings: AnyObserver<Void>
    let showSignUpViewController: Observable<Void>
    let showSpendingsViewController: Observable<Void>
    
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
        
        let _showSpendings = PublishSubject<Void>()
        self.showSpendings = _showSpendings.asObserver()
        self.showSpendingsViewController = _showSpendings.asObservable()
        
    }
    
    func signin() {
        Auth.auth().signIn(withEmail: emailField.getValue(),
                           password: passwordField.getValue()) { [weak self] (user, error) in
            if error == nil {
                print("SIGNIN COMPLETE \(user?.email ?? "EMPTY EMAIL")")
                self?.showSpendings.onNext(())
            }
            else {
                self?.errorMessage.value = error?.localizedDescription
            }
        }
    }
}
