//
//  DetailPresenter.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import Foundation
import RxSwift
import RxRelay

protocol DetailPresenterProtocol {
    var name: String {get}
    var isCatch: Bool {get}
    var logs: BehaviorRelay<[String]> {get}
    var entity: BehaviorRelay<PokemonEntity?> {get}
    func insertActivityLog()
    func showCard()
}

class DetailPresenter: DetailPresenterProtocol {
    let router: DetailRouterProtocol
    let name: String
    let isCatch: Bool
    
    init(isCatch: Bool, entity: PokemonEntity, router: DetailRouterProtocol) {
        self.name = entity.name
        self.entity.accept(entity)
        self.router = router
        self.isCatch = isCatch
        
        if let entities: [PokemonEntity] = PokemonStorage.shared.loadEntities(), !entities.isEmpty {
            currentNumber = entity.name.splitNameNumber()
            self.entities = entities
        }
    }
    
    var logs = BehaviorRelay<[String]>(value: [])
    var entity = BehaviorRelay<PokemonEntity?>(value: nil)
    private var entities = [PokemonEntity]()
    private let bag = DisposeBag()
    private var currentNumber = 0
    
    
    func insertActivityLog() {
        guard var pet = entity.value else { return }
        
        var message = ""
        if isCatch {
            // capture Pokemon with 50% chance
            let randomizer = Double(arc4random_uniform(100)) / 100.0
            if randomizer < 0.5 {
                pet.id = pet.id + "\(currentNumber)"
                pet.name = "\(pet.name)-\(currentNumber)"
                
                message = "Captured \(pet.name)!"
                entities.append(pet)
                
                // rename Pokemon based on fibo on the next capture
                if currentNumber < 2 {
                    currentNumber += 1
                } else {
                    currentNumber = currentNumber.nextFibonacciNumber()
                }
            } else {
                message = "Failed to capture"
            }
        } else {
            // release Pokemon when name contains prime number
            if currentNumber.isPrimeNumber() {
                message = "Released \(pet.name)! \(currentNumber) is a prime"
                entities.removeAll(where: {$0.id == pet.id})
            } else {
                message = "Failed to release! \(currentNumber) is not a prime"
            }
        }
        logs.accept(logs.value + [message])
        PokemonStorage.shared.saveEntities(entities: entities)
    }
    
    func showCard() {
        router.showPreview(image: entity.value?.image ?? "")
    }
    
    deinit {
        print("DetailPresenter released!!")
    }
}
