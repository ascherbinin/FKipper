//
//  Spending.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 23.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct Spend {
    
    var title: String
    var category: String
    var costValue: Double
    var date: Date
    
    var dictionary: [String: Any] {
        return [
            "title": title,
            "category": category,
            "costValue": costValue,
            "date": date
        ]
    }
    
}

extension Spend : DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
        let category = dictionary["category"] as? String,
        let costValue = dictionary["costValue"] as? Double,
        let date = dictionary["date"] as? Date else { return nil }
        
        self.init(title: title, category: category,
                  costValue: costValue, date: date)
    }
}


class SpendViewModel {
    let disposeBag = DisposeBag()
    let spend: Spend
    var titleText: BehaviorSubject<String>
    var categoryText: BehaviorSubject<String>
    var costValue: BehaviorSubject<Double>
    var date: BehaviorSubject<Date>
    
    init(spend: Spend) {
        self.spend = spend
        
        titleText = BehaviorSubject<String>(value: spend.title)
        categoryText = BehaviorSubject<String>(value: spend.category)
        costValue = BehaviorSubject<Double>(value: spend.costValue)
        date = BehaviorSubject<Date>(value: spend.date)
    }
}

extension SpendViewModel: IdentifiableType {
    typealias Identity = SpendViewModel
    
    var identity: SpendViewModel {
        return SpendViewModel(spend: spend)
    }
    
}

extension SpendViewModel: Hashable {
    var hashValue: Int {
        return spend.date.hashValue
    }
    
    static func == (lhs: SpendViewModel, rhs: SpendViewModel) -> Bool {
        return lhs.spend.date == rhs.spend.date
            && lhs.spend.title == lhs.spend.title
            && lhs.spend.costValue == rhs.spend.costValue
    }
    
    
}
