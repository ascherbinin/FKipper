//
//  AddSpendViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 28.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxCocoa
import FirebaseFirestore
import RxSwift

protocol AddSpendViewModelCoordinatorDelegate {
    func didAddNewSpend(from controller: UIViewController)
    func cancelPopover(from controller: UIViewController)
}

protocol AddSpendViewModelType {
    func addNewSpand()
    var didSuccessAddSpend: Observable<Spend> {get}

    var coordinatorDelegate: AddSpendViewModelCoordinatorDelegate! { get }
    
    var titleField: BehaviorRelay<String?> { get }
    var categoryField: BehaviorRelay<Category?> { get }
    var valueField: BehaviorRelay<String?> { get }
    var categoryEntries: [Category] { get }
}

class AddSpendViewModel: AddSpendViewModelType {

    var coordinatorDelegate: AddSpendViewModelCoordinatorDelegate!
    
    let titleField = BehaviorRelay<String?>(value: nil)
    let categoryField = BehaviorRelay<Category?>(value: nil)
    let valueField = BehaviorRelay<String?>(value: nil)
    
    let db = Firestore.firestore()
    let userID: String
    
    let addedSpendSuccess: AnyObserver<Spend>
    let cancel: AnyObserver<Void>
    // MARK: - Outputs
    let didSuccessAddSpend: Observable<Spend>
    
    var categoryEntries: [Category] = []
    
    init(for userID: String) {
        self.userID = userID
        
        let _addNewSpend = PublishSubject<Spend>()
        self.addedSpendSuccess = _addNewSpend.asObserver()
        self.didSuccessAddSpend = _addNewSpend.asObservable()
        
        let _cancel = PublishSubject<Void>()
        self.cancel = _cancel.asObserver()

        
        categoryEntries = CategoryType.allValues.compactMap{Category(type: $0)}
    }
    
    
    func addNewSpand() {
        guard let title = titleField.value,
            let category = categoryField.value,
            let value = Double(valueField.value ?? "") else { return }
        let newSpend = Spend(title: title, category: category, costValue: value, date: Date())
        db.collection("spends").document(self.userID).collection("entries").document().setData(newSpend.dictionary)
        addedSpendSuccess.onNext(newSpend)
        
    }
    
    
}
