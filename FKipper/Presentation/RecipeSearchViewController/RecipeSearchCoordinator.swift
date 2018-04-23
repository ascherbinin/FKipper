//
//  RecipeSearchCoordinator.swift
//  EatIT
//
//  Created by Scherbinin Andrey on 26.01.2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import RxSwift
import SafariServices

class RecipeSearchCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = RecipeSearchViewModel(title: "Search")
        let viewController = RecipeSearchViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewModel.showRecipe
            .subscribe(onNext: { [weak self] recipe in self?.showRecipe(in: navigationController, by: recipe.url) })
            .disposed(by: disposeBag)
        
//        viewModel.
//            .flatMap { [weak self] _ -> Observable<String?> in
//                guard let `self` = self else { return .empty() }
//                return self.showLanguageList(on: viewController)
//            }
//            .filter { $0 != nil }
//            .map { $0! }
//            .bind(to: viewModel.setCurrentLanguage)
//            .disposed(by: disposeBag)
//
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showRecipe(in navigationController: UINavigationController, by url: String) {
        if let url = URL(string: url) {
            let safariViewController = SFSafariViewController(url: url)
            navigationController.pushViewController(safariViewController, animated: true)
        }
    }
    
//    private func showLanguageList(on rootViewController: UIViewController) -> Observable<String?> {
//        let languageListCoordinator = LanguageListCoordinator(rootViewController: rootViewController)
//        return coordinate(to: languageListCoordinator)
//            .map { result in
//                switch result {
//                case .language(let language): return language
//                case .cancel: return nil
//                }
//        }
//    }
}
