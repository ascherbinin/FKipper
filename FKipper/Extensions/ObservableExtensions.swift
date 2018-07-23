//
//  ObservableExtensions.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 16/07/2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    
    func mapToVoid() -> Observable<Void> {
        return map(to: ())
    }
    
    func map<T>(to value: T) -> Observable<T> {
        return self.map { _ -> T in
            return value
        }
    }
}
