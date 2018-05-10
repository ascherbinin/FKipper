//
//  CheckInViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 28.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

class SignUpViewModel {
    
    // MARK: - Inputs
    let signUpUser: AnyObserver<UUser>
    let cancel: AnyObserver<Void>
    let didTapSignUp = PublishSubject<Void>()
    // MARK: - Outputs
    let didSuccessSignUp: Observable<UUser>
    let didCancel: Observable<Void>

    let isValid = Variable<Bool>(false)
    
    let emailField = EmailFieldViewModel()
    let passwordField = PasswordFieldViewModel()
    let userNameField = Variable("")
    private let disposeBag = DisposeBag()
    
    let title: Observable<String>
    
    init(_ title: String) {
        
        self.title = Observable.just(title)
        
        let _signUpUser = PublishSubject<UUser>()
        self.signUpUser = _signUpUser.asObserver()
        self.didSuccessSignUp = _signUpUser.asObservable()
        
        let _cancel = PublishSubject<Void>()
        self.cancel = _cancel.asObserver()
        self.didCancel = _cancel.asObservable()
        
        didTapSignUp.asObservable().bind(onNext: {[weak self] _ in
            self?.createUser()
        }).disposed(by: disposeBag)
        
        
        Observable.combineLatest(emailField.value.asObservable(),
                                 passwordField.value.asObservable())
            .map {!$0.0.isEmpty && !$0.1.isEmpty}
            .bind(to: isValid)
            .disposed(by: disposeBag)
    }
    
    private func createUser () {

        Auth.auth().createUser(withEmail: emailField.value.value,
                               password: passwordField.value.value) { (user, error) in
            if error == nil {
                let user = UUser(authData: user!)
                if !self.userNameField.value.isEmpty  {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.userNameField.value
                    changeRequest?.commitChanges { (error) in
                        if error == nil {
                            self.signUpUser.onNext(user)
                        }                     
                    }
                }
                else {
                    print(user.name ?? "NO NAME")
                    self.signUpUser.onNext(user)
                }
//                Auth.auth().signIn(withEmail: email, password: pwd, completion: nil)
            }
        }
        
//        Auth().createUser(withEmail: email,
//                                password: pwd,
//                                completion: { (user, error) in
//        if error == nil {
//        Auth().auth.signIn(withEmail: email, password: pwd)
//        }
//        })
    }
}
