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
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func toMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func dateBefore(byDays days: Int) -> String {
        var dateComponent = DateComponents()
        dateComponent.day = -days
        let beforeDate = Calendar.current.date(byAdding: dateComponent, to: self)
        return beforeDate?.toShortString() ?? Date().toShortString()
    }
}
