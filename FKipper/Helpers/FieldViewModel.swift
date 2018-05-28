//
//  FieldViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 30.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import RxSwift

// FieldViewModel
protocol FieldViewModel {
    var title: String { get}
    var errorMessage: String { get }
    
    // Observables
    var value: Variable<String> { get set }
    var errorValue: Variable<String?> { get}
    
    // Validation
    func validate() -> Bool
}

extension FieldViewModel {
    
    func validateSize(_ value: String, size: (min:Int, max:Int)) -> Bool {
        return (size.min...size.max).contains(value.count)
    }
    
    func validateString(_ value: String?, pattern: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", pattern)
        return test.evaluate(with: value)
    }
    
    func getValue() -> String {
        return value.value
    }
}

// Data FieldViewModel : Password
struct PasswordFieldViewModel : FieldViewModel, SecureFieldViewModel {
    
    var value: Variable<String> = Variable("")
    var errorValue: Variable<String?> = Variable(nil)
    
    let title = "Password"
    let errorMessage = "Wrong password !"
    
    var isSecureTextEntry: Bool = true
    
    func validate() -> Bool {
        // between 6 and 25 caracters
        guard validateSize(value.value, size: (6,25)) else {
            errorValue.value = errorMessage
            return false
        }
        errorValue.value = nil
        return true
    }
}

// Options for FieldViewModel
protocol SecureFieldViewModel {
    var isSecureTextEntry: Bool { get }
}

// Data FieldViewModel : Email
struct EmailFieldViewModel : FieldViewModel {
    
    var value: Variable<String> = Variable("")
    var errorValue: Variable<String?> = Variable(nil)
    
    let title = "Email"
    let errorMessage = "Email is wrong"
    
    func validate() -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        guard validateString(value.value, pattern:emailPattern) else {
            errorValue.value = errorMessage
            return false
        }
        errorValue.value = nil
        return true
    }
}
