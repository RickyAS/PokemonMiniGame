//
//  HomeRouter.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import Foundation
import UIKit
//MARK: - Base
protocol BaseRouterProtocol {
    var title: String { get }
    var navigation: UINavigationController { get }
    init(_ navigation: UINavigationController, title: String)
    func start()
}

protocol HomeRouterProtocol {
    func openDetail(isCatch: Bool, entity: PokemonEntity)
}


//MARK: - Router
class HomeRouter: BaseRouterProtocol, HomeRouterProtocol {
    var title: String
    var navigation: UINavigationController
    
    required init(_ navigation: UINavigationController, title: String) {
        self.navigation = navigation
        self.title = title
    }
    
    func start() {
        let view = HomeView()
        view.presenter = HomePresenter(interactor: HomeInteractor(), router: self)
        view.navigationItem.title =  title
        navigation.pushViewController(view, animated: true)
    }
    
    func openDetail(isCatch: Bool, entity: PokemonEntity) {
        let router = DetailRouter(navigation, title: entity.name)
        router.isCatch = isCatch
        router.entity = entity
        router.start()
    }
}
