//
//  NSLocalizedStringExtension.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 26.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation


extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
