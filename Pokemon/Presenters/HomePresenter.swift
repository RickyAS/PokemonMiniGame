//
//  HomePresenter.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import Foundation
import RxSwift
import RxRelay

protocol HomePresenterProtocol {
    var entities: BehaviorRelay<[PokemonEntity]> {get}
    var isCatch: Bool {get set}
    func retriveList(isReload: Bool)
    func changeSegment(ind: Int)
    func openDetail(entity: PokemonEntity)
}

class HomePresenter: HomePresenterProtocol {
    let interactor: HomeInteractorProtocol
    let router: HomeRouterProtocol
    init(interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    var entities = BehaviorRelay<[PokemonEntity]>(value: [])
    var isCatch = true
    private var collections = [PokemonEntity]()
    private var myPets = [PokemonEntity]()
    private let bag = DisposeBag()
    private var page = 0
    private var isLastPage = false
    
    func retriveList(isReload: Bool){
        // reload to restart page
        if isReload {
            page = 0
            isLastPage = false
        } else {
            page += 20
        }
        // stop fetching when it reaches the last page
        if isLastPage {
            return
        }
        interactor.fetchEntities(offset: page)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else {return}
                if isReload {
                    self.collections = result
                } else {
                    // append new data to collection
                    self.isLastPage = result.isEmpty
                    self.collections.append(contentsOf: result)
                }
                self.entities.accept(self.collections)
            }).disposed(by: bag)
    }
    
    func changeSegment(ind: Int) {
        // switch collection from different sources
        entities.accept([])
        if ind == 1 {
            retriveMyList()
            isCatch = false
            entities.accept(myPets)
        } else {
            isCatch = true
            entities.accept(collections)
        }
    }
    
    func retriveMyList() {
        // retrieve collection from user default
        if let entities: [PokemonEntity] = PokemonStorage.shared.loadEntities() {
            self.myPets = entities
        }
    }
    
    func openDetail(entity: PokemonEntity) {
        router.openDetail(isCatch: isCatch, entity: entity)
    }
}
