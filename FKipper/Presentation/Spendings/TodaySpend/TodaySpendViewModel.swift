//
//  TodaySpendViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 24.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

protocol TodaySpendViewModelType {
    var titleText: Observable<String> { get }
    var exit: AnyObserver<Void> { get }
    var didExit: Observable<Void> { get }
    
    var tapOnAdd: AnyObserver<Void> { get }
    var didTapOnAdd: Observable<Void> { get }
    
    var tapOnList: AnyObserver<Void> { get }
    var didTapOnList: Observable<Void> { get }
    
    var totalSpendToday: BehaviorRelay<Double> { get }
    var todaySpends: BehaviorRelay<[Spend]> { get }
    
    func startObserveQuery()
}

protocol TodaySpendViewModelCoordinatorDelegate: class {
//    func cancel(from controller: UIViewController)
    func needShowSpendingsList(from controller: UIViewController)
    func needShowAddSpend(from controller: UIViewController)
}

class TodaySpendViewModel: TodaySpendViewModelType {

    var userID: String
    var titleText: Observable<String>
    
    let exit: AnyObserver<Void>
    let didExit: Observable<Void>
    
    let tapOnList: AnyObserver<Void>
    let didTapOnList: Observable<Void>
    
    let tapOnAdd: AnyObserver<Void>
    let didTapOnAdd: Observable<Void>
    
    let totalSpendToday = BehaviorRelay<Double>(value: 0.0)
    var todaySpends = BehaviorRelay<[Spend]>(value: [])
    
    private var documents: [DocumentSnapshot] = []
    var coordinatorDelegate: TodaySpendViewModelCoordinatorDelegate!

    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                startObserveQuery()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    init(_ title: String, userID: String) {
        titleText = Observable.just(title)
        
        let _exit = PublishSubject<Void>()
        self.exit = _exit.asObserver()
        self.didExit = _exit.asObservable()
        
        let _tapOnList = PublishSubject<Void>()
        self.tapOnList = _tapOnList.asObserver()
        self.didTapOnList = _tapOnList.asObservable()
        
        let _tapOnAdd = PublishSubject<Void>()
        self.tapOnAdd = _tapOnAdd.asObserver()
        self.didTapOnAdd = _tapOnAdd.asObservable()
        
        self.userID = userID
        
        query = makeBaseQuery()
        
        
    }
    
    
    
    func startObserveQuery() {
        guard let query = query else { return }
        print("****IS HERE WITH ID: \(self.userID)")
        stopObserving()
        
        // Display data from Firestore, part one
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
//            self.showActivity.onNext(true)
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
            
            if snapshot.documents != self.documents {
                let filteredModels = models.filter{ Calendar.current.isDateInToday($0.date)}
                self.todaySpends.accept(filteredModels)
                let totalSpends = filteredModels.reduce(0, { $0 + $1.costValue})
                
                //            var sectionsDict: [String : SectionOfSpends] = [:]
                
                //            // Need change sorted algorithm
                //            for element in models {
                //                let keyDate = element.date.toShortString()
                //                if sectionsDict.index(forKey:keyDate) == nil {
                //                    sectionsDict[keyDate] = SectionOfSpends(header: keyDate,
                //                                                            items: [SpendViewModel(spend: element)])
                //                }
                //                else {
                //                    sectionsDict[keyDate]?.items.append(SpendViewModel(spend: element))
                //                }
                //            }
                
                //            let sortDict = sectionsDict.sorted(by: { (arg0, arg1) -> Bool in
                //                return arg0.key > arg1.key
                //            })
                self.totalSpendToday.accept(totalSpends)
                print(totalSpends)
                //            self.sections.value = sortDict.map{$0.1}
                //            self.documents = snapshot.documents
                //            self.showActivity.onNext(false)
                self.documents = snapshot.documents
            }
   
        }
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    fileprivate func makeBaseQuery() -> Query {
        return Firestore.firestore().collection("spends").document(self.userID).collection("entries")
    }
}
