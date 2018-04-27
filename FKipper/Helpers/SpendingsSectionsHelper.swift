//
//  SpendingsSectionsHelper.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 25.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfSpends {
    var header: String
    var items: [SpendViewModel]
}

extension SectionOfSpends: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = SpendViewModel
    
    init(original: SectionOfSpends, items: [Item]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return header
    }
}

//
//// MARK: Just extensions to say how to determine identity and how to determine is entity updated
//
//extension NumberSection
//: AnimatableSectionModelType {
//    typealias Item = IntItem
//    typealias Identity = String
//
//    var identity: String {
//        return header
//    }
//
//    var items: [IntItem] {
//        return numbers
//    }
//
//    init(original: NumberSection, items: [Item]) {
//        self = original
//        self.numbers = items
//    }
//}
//
//extension NumberSection
//: CustomDebugStringConvertible {
//    var debugDescription: String {
//        let interval = updated.timeIntervalSince1970
//        let numbersDescription = numbers.map { "\n\($0.debugDescription)" }.joined(separator: "")
//        return "NumberSection(header: \"\(self.header)\", numbers: \(numbersDescription)\n, updated: \(interval))"
//    }
//}
//
//extension IntItem
//    : IdentifiableType
//, Equatable {
//    typealias Identity = Int
//
//    var identity: Int {
//        return number
//    }
//}
//
//// equatable, this is needed to detect changes
//func == (lhs: IntItem, rhs: IntItem) -> Bool {
//    return lhs.number == rhs.number && lhs.date == rhs.date
//}
//
//// MARK: Some nice extensions
//extension IntItem
//: CustomDebugStringConvertible {
//    var debugDescription: String {
//        return "IntItem(number: \(number), date: \(date.timeIntervalSince1970))"
//    }
//}
//
//extension IntItem
//: CustomStringConvertible {
//
//    var description: String {
//        return "\(number)"
//    }
//}
//
//extension NumberSection: Equatable {
//
//}
//
//func == (lhs: NumberSection, rhs: NumberSection) -> Bool {
//    return lhs.header == rhs.header && lhs.items == rhs.items && lhs.updated == rhs.updated
//}
