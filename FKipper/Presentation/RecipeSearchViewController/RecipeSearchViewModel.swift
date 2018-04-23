//
//  MainScreenViewModel.swift
//  EatIT
//
//  Created by Scherbinin Andrey on 04.12.17.
//  Copyright © 2017 Scherbinin Andrey. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class RecipeSearchViewModel {
    
//    private let privateDataSource: Variable<[Recipe]> = Variable([])
    
    // MARK: - Inputs
    
//    /// Call to update current language. Causes reload of the repositories.
//    let setCurrentLanguage: AnyObserver<String>
//    
//    /// Call to show language list screen.
//    let chooseLanguage: AnyObserver<Void>
    
//    / Call to open repository page.
    let selectRecipe: AnyObserver<RecipeViewModel>
//
//    /// Call to reload repositories.
//    let reloading: Variable<Bool> = Variable<Bool>(false)
//    let recipeQuery: Variable<String> = Variable<String>("")
//    let pageNumber: Variable<Int> = Variable<Int>(1)
    
    
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let loading = Variable<Bool>(false)
    let recipes = Variable<[RecipeViewModel]>([])
    var pageIndex:Int = 1
    let error = PublishSubject<Swift.Error>()
    
    private let disposeBag = DisposeBag()
    // MARK: - Outputs
    
//    /// Emits an array of fetched repositories.
//    let recipes: Observable<[Recipe]>
//
//    /// Emits a formatted title for a navigation item.
    let title: Observable<String>
////
//
//    let showLoadingUI = PublishSubject<Bool>()
////    /// Emits an error messages to be shown.
//    let alertMessage = PublishSubject<String>()
////
////    /// Emits an url of repository page to be shown.
    let showRecipe: Observable<Recipe>
//
////    public let dataSource: Observable<[Recipe]>
//
////    private let currentPageNumber = 1
//
//    private lazy var query: Observable<String> = {
//        return self.searchText
//            .debounce(0.3, scheduler: MainScheduler.instance)
//            .filter{ $0.count >= 3 }.do(onNext: { [weak self] _ in
//                self?.showLoadingUI.onNext(true)
//            })
//    }()
//
//    private lazy var nextPageTrigger: Observable<Int> = {
//        return self.pageNumberValue
//    }()
//
//    private lazy var pageNumberValue: Observable<Int> = {
//        return self.pageNumber.asObservable()
//    }()
//
//    private lazy var searchText: Observable<String> = {
//        return self.recipeQuery.asObservable()
//            .skip(1)
//    }()
//
//    private var clearPreviousRecipesOnTextChanged: Observable<[RecipeViewModel]> {
//        return searchText
//            .filter{ $0.count >= 3 }
//            .map { _ in return [RecipeViewModel]()
//        }
//    }
//
//    private lazy var isRefreshing: Observable<Bool> = {
//        return reloading.asObservable()
//    }()
//
//    private var getRecipes: Observable<[RecipeViewModel]> {
//        let refreshLastQueryOnPullToRefresh = isRefreshing.filter { $0 == true }
//            .withLatestFrom(query)
//        let queryObs = Observable.of(query, refreshLastQueryOnPullToRefresh).merge()
//        return Observable.combineLatest(queryObs, nextPageTrigger)
//            .flatMapLatest { query, nextPageNumber in
//                return SearchService()
//                    .searchByQuery(query: query, nextPageNumber: nextPageNumber)
//                    .catchError { [weak self] error in
//                    self?.alertMessage.onNext(error.localizedDescription)
//                    return Observable.empty()
//                    }.map {
//                        self.showLoadingUI.onNext(false)
//                        return $0.map(RecipeViewModel.init)
//                }
//        }
//    }
//
//    var recipes: Observable<[RecipeViewModel]> {
//        return Observable.of(getRecipes.do(onNext: { [weak self] _ in
//            self?.reloading.value = false
//        }),clearPreviousRecipesOnTextChanged).merge()
//    }
    
    init(title: String) {
        
//        let _currentLanguage = BehaviorSubject<String>(value: initialLanguage)
//        self.setCurrentLanguage = _currentLanguage.asObserver()
        
//        self.dataSource = privateDataSource.asObservable()
        
        self.title = Observable.just(title)
//
//
////        let _query = PublishSubject<String>()
////        self.recipeQuery = _query.asObserver()
//
        let _selectRecipe = PublishSubject<RecipeViewModel>()
        self.selectRecipe = _selectRecipe.asObserver()
        self.showRecipe = _selectRecipe.asObservable().map{$0.recipe}
        
//        self.recipes = Observable.combineLatest( _reload, _query)
//            .flatMapLatest { (_, query) in
//
//            }
//
        
//        let _chooseLanguage = PublishSubject<Void>()
//        self.chooseLanguage = _chooseLanguage.asObserver()
//        self.showLanguageList = _chooseLanguage.asObservable()
        
        let refreshRequest = loading
            .asObservable()
            .sample(refreshTrigger)
            .flatMap{ [unowned self] loading -> Observable<[RecipeViewModel]> in
            if loading {
                return Observable.empty()
            } else {
                self.pageIndex = 1
                return SearchService()
                    .searchByQuery(query: "chicken",
                                   nextPageNumber: self.pageIndex)
                    .map{return $0.map(RecipeViewModel.init)}
            }
            
        }
        
        let nextPageRequest = loading
            .asObservable()
            .sample(loadNextPageTrigger)
            .flatMap{ [unowned self] loading -> Observable<[RecipeViewModel]> in
                if loading {
                    return Observable.empty()
                } else {
                    self.pageIndex = self.pageIndex + 1
                    return SearchService()
                        .searchByQuery(query: "chicken",
                                       nextPageNumber: self.pageIndex)
                        .map{return $0.map(RecipeViewModel.init)}
                }
        
        }
        
        let request = Observable
            .of(refreshRequest, nextPageRequest)
            .merge()
            .share(replay: 1)
        
        let response = request.flatMap { (recipes) -> Observable<[RecipeViewModel]> in
            request.do(onError: {error in
                self.error.onNext(error)
            }).catchError({ (error) -> Observable<[RecipeViewModel]> in
                Observable.empty()
            })
        }.share(replay: 1)
        
        Observable.combineLatest(request, response, recipes.asObservable()) { request, response, recipes in
            return self.pageIndex == 1 ? response : recipes + response
        }
        .sample(response)
        .bind(to: recipes)
        .disposed(by: disposeBag)
        
        Observable
            .of(request.map { _ in true},
                response.map { _ in false},
                error.map { _ in false})
        .merge()
            .subscribe({[weak self] (res) in
//                if let result = res.element {
//                    self?.loading.value = result
//                }
                print("=======RESULT: \(res)========")
            })
//        .bind(to: loading)
        .disposed(by: disposeBag)
    }
}
