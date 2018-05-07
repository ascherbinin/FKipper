//
//  LoginModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 30.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation


struct LoginModel {
    var email: String = ""
    var password: String = ""
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
