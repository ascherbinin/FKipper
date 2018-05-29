//
//  AddSpendViewController.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 28.05.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation
import RxSwift

class AddSpendViewController: UIViewController, StoryboardInitializable  {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldValue: UITextField!
    
    @IBOutlet weak var pvCategory: UIPickerView!
    
    var viewModel: AddSpendViewModelType!
    var pickerEntries: [Category] = []
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            red: 0.8,
            green: 0.6,
            blue: 0.3,
            alpha: 0.75)
        
        pickerEntries = Category.allValues

        
        btnAdd.rx.tap.subscribe(onNext: {[weak self] in
            self?.addNewSpend()
        }).disposed(by: disposeBag)
        
        btnCancel.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.coordinatorDelegate.cancelPopover(from: strongSelf)
        }).disposed(by: disposeBag)
        
        viewModel.didSuccessAddSpend.subscribe(onNext: {[weak self] spend in
           guard let strongSelf = self else { return }
           strongSelf.viewModel.coordinatorDelegate.didAddNewSpend(from: strongSelf)
        }).disposed(by: disposeBag)
//        configureUI()
//        configureBindings()
        
        textFieldTitle.rx.text.orEmpty.bind(to: viewModel.titleField).disposed(by: disposeBag)
        textFieldValue.rx.text.orEmpty.bind(to: viewModel.valueField).disposed(by: disposeBag)
        
        Observable.just(pickerEntries)
            .bind(to: pvCategory.rx.itemTitles) { _, item in
                return "\(item.rawValue)"
            }
            .disposed(by: disposeBag)
        
        pvCategory.rx
            .modelSelected(Category.self)
            .map{$0.first}
            .map{$0?.rawValue}
            .startWith(pickerEntries.first?.rawValue)
            .bind(to: viewModel.categoryField)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func addNewSpend() {
        viewModel.addNewSpand()
    }
}

//extension AddSpendViewController: UIPickerViewDelegate {
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerEntries[row]
//    }
//}
//
//extension AddSpendViewController: UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerEntries.count
//    }
//
//
//}
