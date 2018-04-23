//
//  MainScreenViewController.swift
//  EatIT
//
//  Created by Scherbinin Andrey on 04.12.17.
//  Copyright © 2017 Scherbinin Andrey. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RecipeSearchViewController: UIViewController, StoryboardInitializable, UITableViewDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var refreshControl : UIRefreshControl?
    var activityView: UIActivityIndicatorView!
    var viewModel: RecipeSearchViewModel!
    private let disposeBag = DisposeBag()
    
    static let startLoadingOffset: CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setupUI()
        setupActivityView()
//        setupCancelSearchButton()
        bindRecipesWithTableView()
        setupBindings()
        
        self.refreshControl = UIRefreshControl()
        if let refreshControl = self.refreshControl {
            self.view.addSubview(refreshControl)
        }
    }
    
    private func setupUI() {
//        navigationItem.rightBarButtonItem = chooseLanguageButton
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    }
    
    private func setupBindings() {
        
        // View Model outputs to the View Controller
//        searchBar.rx.text
//            .orEmpty
//            .distinctUntilChanged()
//            .bind(to: viewModel.recipeQuery)
//            .disposed(by: disposeBag)

        
//        viewModel.showLoadingUI
//            .observeOn(MainScheduler.instance)
//            .skip(1)
//            .subscribe(onNext: { [ weak self] show in
//            
//        }).disposed(by: disposeBag)
        
        rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map{ _ in ()}
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
//        viewModel.alertMessage
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in self?.presentAlert(message: $0) })
//            .disposed(by: disposeBag)
        
        // View Controller UI actions to the View Model
        
//        tableView.refreshControl?.rx.controlEvent(.valueChanged)
//            .map({ [weak self] () -> Bool in
//                return self?.tableView.refreshControl?.isRefreshing ?? false
//            })
//            .bind(to: viewModel.reloading)
//            .disposed(by: disposeBag)
        
//        viewModel.reloading
//            .asObservable()
//            .distinctUntilChanged()
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [weak self] isLoading in
//                if !isLoading {
//                    self?.tableView.refreshControl?.endRefreshing()
//                }
//        }).disposed(by: disposeBag)
//
//        chooseLanguageButton.rx.tap
//            .bind(to: viewModel.chooseLanguage)
//            .disposed(by: disposeBag)
        
        tableView
            .rxReachedBottom
            .map{ _ in ()}
            .bind(to: viewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
        
        refreshControl?.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RecipeViewModel.self)
            .bind(to: viewModel.selectRecipe)
            .disposed(by: disposeBag)
        
        // dismiss keyboard on scroll
        tableView.rx.contentOffset
            .subscribe { [weak self] _ in
                if let _ = self?.searchBar.isFirstResponder {
                    self?.searchBar.resignFirstResponder()
                }
            }
            .disposed(by: disposeBag)
        
        // so normal delegate customization can also be used
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel
            .loading
            .asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: { isLoading in
                if (isLoading) {
                    self.refreshControl?.endRefreshing()
                }
            })
        .bind(to: isLoading(for: self.view))
        .disposed(by: disposeBag)
    }
    
    private func setupRecipeCell(_ cell: RecipeTableViewCell, recipe: RecipeViewModel) {
       cell.recipeViewModel = recipe
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
//    private func setupCancelSearchButton() {
//        let shouldShowCancelButton = Observable.of(
//            searchBar.rx.textDidBeginEditing.map { return true },
//            searchBar.rx.textDidEndEditing.map { return false } )
//            .merge()
//
//        shouldShowCancelButton.subscribe(onNext: { [searchBar] shouldShow in
//            searchBar?.showsCancelButton = shouldShow
//        }).disposed(by: disposeBag)
//
//        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [searchBar] in
//            searchBar?.resignFirstResponder()
//        }).disposed(by: disposeBag)
//    }
    
    func setupActivityView() {
        activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
    }
    
    private func bindRecipesWithTableView() {
        viewModel.recipes.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: RecipeTableViewCell.reuseIdentificator,
                                       cellType: RecipeTableViewCell.self)) { [weak self] row, model, cell in
                                        self?.setupRecipeCell(cell, recipe: model)
        }.disposed(by: disposeBag)
    }
    
    private func isLoading(for view: UIView) -> AnyObserver<Bool> {
        return Binder(view, binding: { [weak self] (hud, isLoading) in
            switch isLoading {
            case true:
                self?.activityView.startAnimating()
            case false:
                self?.activityView.stopAnimating()
                break
            }
        }).asObserver()
    }
    
}

extension UIScrollView {
    var rxReachedBottom: Observable<Void> {
        return rx.contentOffset
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let scrollView = self else {
                    return Observable.empty()
                }
                
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? Observable.just(()) : Observable.empty()
        }
    }
}
