//
//  DetailRouter.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import Foundation
import UIKit

protocol DetailRouterProtocol {
    func showPreview(image: String)
}

class DetailRouter: BaseRouterProtocol, DetailRouterProtocol {
    var title: String
    var navigation: UINavigationController
    var isCatch: Bool!
    var entity: PokemonEntity!
    
    required init(_ navigation: UINavigationController, title: String) {
        self.navigation = navigation
        self.title = title
    }
    
    func start() {
        let view = DetailView()
        view.presenter = DetailPresenter(isCatch: isCatch, entity: entity, router: self)
        navigation.pushViewController(view, animated: true)
    }
    
    
    func showPreview(image: String) {
        let view = ImgDisplayView(image: image)
        view.modalPresentationStyle = .overCurrentContext
        navigation.present(view, animated: false)
    }
}
