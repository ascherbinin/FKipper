//
//  SpendingsViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 23.04.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import FirebaseFirestore

class SpendingsViewModel {

    let exit: AnyObserver<Void>
    let didExit: Observable<Void>
    let selectedSpend: Observable<Spend>
    let selectSpend: AnyObserver<SpendViewModel>
    let showActivity = PublishSubject<Bool>()
    let title: Observable<String>
    
    let sections = Variable<[SectionOfSpends]>([])
    private var documents: [DocumentSnapshot] = []
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                startObserveQuery()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    func startObserveQuery() {
        guard let query = query else { return }
        stopObserving()
        
        // Display data from Firestore, part one
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            self.showActivity.onNext(true)
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Spend in
                if let model = Spend(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(Spend.self) with dictionary \(document.data())")
                }
            }
            
            var sectionsDict: [String : SectionOfSpends] = [:]
            
            // Need change sorted algorithm
            for element in models {
                let keyDate = element.date.toShortString()
                if sectionsDict.index(forKey:keyDate) == nil {
                    sectionsDict[keyDate] = SectionOfSpends(header: keyDate,
                                                            items: [SpendViewModel(spend: element)])
                }
                else {
                    sectionsDict[keyDate]?.items.append(SpendViewModel(spend: element))
                }
            }
            let sortDict = sectionsDict.sorted(by: { (arg0, arg1) -> Bool in
                return arg0.key > arg1.key
            })
            self.sections.value = sortDict.map{$0.1}
            self.documents = snapshot.documents
            self.showActivity.onNext(false)
        }
    }
    
    
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("spends").limit(to: 20)
    }
    
    init(title: String) {

        self.title = Observable.just(title)
        
        let _selectSpend = PublishSubject<SpendViewModel>()
        self.selectSpend = _selectSpend.asObserver()
        self.selectedSpend = _selectSpend.asObservable().map{$0.spend}

        let _exit = PublishSubject<Void>()
        self.exit = _exit.asObserver()
        self.didExit = _exit.asObservable()
        
        query = baseQuery()
        
    }
    
}

