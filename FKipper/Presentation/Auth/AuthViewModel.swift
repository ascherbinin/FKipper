//
//  AuthViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 27.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

class AuthViewModel {
    
    let title: Observable<String>
    let showSignUp: AnyObserver<Void>
    let showSignUpViewController: Observable<Void>
    
    let emailField = Variable<String>("")
    let pwdField = Variable<String>("")
    
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
    }
}
