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
    
    init(title: String) {
        
        self.title = Observable.just(title)
        
//        let _selectSpend = PublishSubject<SpendViewModel>()
//        self.selectSpend = _selectSpend.asObserver()
//        self.selectedSpend = _selectSpend.asObservable().map{$0.spend}
//        
//        query = baseQuery()
    }
}
