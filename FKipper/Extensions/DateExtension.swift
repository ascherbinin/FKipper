//
//  DateExtensions.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 25.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation


extension Date {
    func toShortString() -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func dateBefore(byDays days: Int) -> String {
        var dateComponent = DateComponents()
        dateComponent.day = -days
        let beforeDate = Calendar.current.date(byAdding: dateComponent, to: self)
        return beforeDate?.toShortString() ?? Date().toShortString()
    }
}
