//
//  TodaySpendViewModel.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 24.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

protocol TodaySpendViewModelType {
    var titleText: Observable<String> { get }
    var exit: AnyObserver<Void> { get }
    var didExit: Observable<Void> { get }
    
    var tapOnList: AnyObserver<Void> { get }
    var didTapOnList: Observable<Void> { get }
}

protocol TodaySpendViewModelCoordinatorDelegate: class {
//    func cancel(from controller: UIViewController)
    func needShowSpendingsList(from controller: UIViewController)
}

class TodaySpendViewModel: TodaySpendViewModelType {

    var titleText: Observable<String>
    
    let exit: AnyObserver<Void>
    let didExit: Observable<Void>
    
    let tapOnList: AnyObserver<Void>
    let didTapOnList: Observable<Void>
    
    var coordinatorDelegate: TodaySpendViewModelCoordinatorDelegate!

    init(_ title: String) {
        titleText = Observable.just(title)
        
        let _exit = PublishSubject<Void>()
        self.exit = _exit.asObserver()
        self.didExit = _exit.asObservable()
        
        let _tapOnList = PublishSubject<Void>()
        self.tapOnList = _tapOnList.asObserver()
        self.didTapOnList = _tapOnList.asObservable()
    }

}
