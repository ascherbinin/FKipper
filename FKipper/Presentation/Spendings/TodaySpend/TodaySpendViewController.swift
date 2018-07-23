//
//  TodaySpendViewController.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 24.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift
import RxAnimated

class TodaySpendViewController: UIViewController, StoryboardInitializable, DynamicsViewsProtocol,
DynamicViewDelegate {
    
    lazy var center = CGPoint(x: vwCircle.center.x, y: vwCircle.center.y)
    var dynamicsViews: [DynamicView] = []
    var dynamicsViewDelegate: DynamicViewDelegate!
    lazy var radius = Double(vwCircle.bounds.size.width / 2)
    var isTapped = false
    
    func didTap(_ sender: DynamicView) {
        print(sender.description)
    }
    
    var viewModel: TodaySpendViewModelType!
    private let disposeBag = DisposeBag()
    private var viewsIds: [Int] = []
    
    @IBOutlet weak var lblTotalSpend: UILabel!
    @IBOutlet weak var vwCircle: UIView!
    
    private let exitButton = UIBarButtonItem(barButtonSystemItem: .action , target: nil, action: nil)
    
    private let listButton = UIBarButtonItem(barButtonSystemItem: .bookmarks , target: nil, action: nil)
    
    private let addButton = UIBarButtonItem(barButtonSystemItem: .add , target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicsViewDelegate = self
        navigationItem.leftBarButtonItem = exitButton
        configureGestures()
        let rightButtons = [listButton, addButton]
        
        navigationItem.rightBarButtonItems = rightButtons
        
        vwCircle.layer.borderColor = UIColor.darkGray.cgColor
        
        viewModel
            .titleText
            .asObservable()
            .subscribe(onNext: {[weak self] title in
                self?.title = title
            }).disposed(by: disposeBag)
        
        //        viewModel
        //            .showActivity
        //            .subscribe(onNext: {[weak self] needShow in
        //                if needShow {
        //                    self?.view.makeToastActivity(.center)
        //                }
        //                else {
        //                    self?.view.hideToastActivity()
        //                }
        //            }).disposed(by: disposeBag)
        
        exitButton.rx.tap
            .bind(to: viewModel.exit)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.tapOnAdd)
            .disposed(by: disposeBag)
        
        viewModel
            .totalSpendToday
            .asObservable()
            .map{"\($0)"}
            .distinctUntilChanged()
            .bind(animated: lblTotalSpend.rx.animated.tick(.top, duration: 0.33).text)
            .disposed(by: disposeBag)
        
        viewModel.todaySpends.bind { [weak self] (categories) in
            categories.forEach({ (category) in
                self?.appendNewDynamicView(category, isTapped: self?.isTapped ?? false)
            })
            print(categories)
            }.disposed(by: disposeBag)
        
        listButton.rx.tap
            .bind(to: viewModel.tapOnList)
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel.startObserveQuery()
    }
    
    private func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 1
        vwCircle.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.mapToVoid().bind(to: viewModel.tapOnAdd).disposed(by: disposeBag)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: nil)
        doubleTapGesture.numberOfTapsRequired = 2
        vwCircle.addGestureRecognizer(doubleTapGesture)
        
        doubleTapGesture.rx.event.mapToVoid()
//            .do(onNext: {
//            _ = Observable.just("+").bind(animated: self.lblTotalSpend.rx.animated.tick(.top, duration: 0.33).text)
//            })
            .bind { [weak self] _ in self?.animateView()}
            .disposed(by: disposeBag)
        
        tapGesture.require(toFail: doubleTapGesture)
    }
    
    private func animateView() {
        let modifier: CGFloat = isTapped ? 1 : 0.5
        UIView.animate(withDuration: 0.5) {
            self.vwCircle.transform = CGAffineTransform(scaleX: modifier, y: modifier)
        }
        isTapped = !isTapped
        hideViews(hide: isTapped)
    }
    
}
