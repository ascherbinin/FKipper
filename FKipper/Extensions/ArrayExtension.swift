//
//  ArrayExtension.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 29.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
