//
//  User.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 28.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation


struct UUser {
    
    let uid: String
    let name: String? = nil
    let email: String
    var group: String? = nil
    
    init(authData: User) {
        self.init(uid: authData.uid,
                  name: authData.displayName ?? "",
                  email: authData.email!)
    }
    
    init(uid: String,
         name: String,
         email: String) {
        self.uid = uid
        self.email = email
        self.group = uid
    }
    
}
