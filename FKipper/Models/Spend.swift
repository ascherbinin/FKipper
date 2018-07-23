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

struct Category {
    var type: CategoryType
    var id: String
    
    init?(id: String) {
        self.id = id
        switch id {
        case "0":
            type = .Auto
        case "1":
            type = .Entertainment
        case "2":
            type = .Food
        default:
            return nil
        }
    }
    
    init?(type: CategoryType) {
        self.type = type
        switch type {
        case CategoryType.Auto:
            id = "0"
        case CategoryType.Entertainment:
            id = "1"
        case CategoryType.Food:
            id = "2"
        default:
            return nil
        }
    }
}

enum CategoryType: String, EnumCollection {
    case Auto
    case Entertainment
    case Food
    case Other
    
    func image() -> UIImage? {
        switch self {
        case .Auto:
            return #imageLiteral(resourceName: "cat_auto")
        case .Entertainment:
            return #imageLiteral(resourceName: "cat_entertainment")
        case .Food:
            return #imageLiteral(resourceName: "cat_food")
        default :
            return nil
        }
    }
    
}

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.type.rawValue == rhs.type.rawValue && lhs.id == rhs.id
    }
}

extension Category: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}

extension Category : DynamicEntryViewProtocol {
    var title: String {
        get {
            return self.type.rawValue
        }
    }
    
    var image: UIImage? {
        get {
            return self.type.image()
        }
    }
    
    
}


struct Spend {
    
    var title: String
    var category: Category
    var costValue: Double
    var date: Date
    
    var dictionary: [String: Any] {
        return [
            "title": title,
            "categoryID": category.id,
            "costValue": costValue,
            "date": date
        ]
    }
    
}

extension Spend : DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
        let categoryID = dictionary["categoryID"] as? String,
        let costValue = dictionary["costValue"] as? Double,
        let date = dictionary["date"] as? Date else { return nil }
        guard let cat = Category(id: categoryID) else {
            return nil
        }
        
        self.init(title: title, category: cat,
                  costValue: costValue, date: date)
    }
}

//extension Spend: Equatable {
//    static func ==(lhs: Spend, rhs: Spend) -> Bool {
//        let areEqual = lhs.category == rhs.category
//        
//        return areEqual
//    }
//}

class SpendViewModel {
    let disposeBag = DisposeBag()
    let spend: Spend
    var titleText: BehaviorSubject<String>
    var category: BehaviorSubject<Category>
    var costValue: BehaviorSubject<Double>
    var date: BehaviorSubject<Date>
    
    init(spend: Spend) {
        self.spend = spend
        
        titleText = BehaviorSubject<String>(value: spend.title)
        category = BehaviorSubject<Category>(value: spend.category)
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
