//
//  HomeInteractor.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import Foundation
import RxSwift

protocol HomeInteractorProtocol {
    func fetchEntities(offset: Int) -> Observable<[PokemonEntity]>
}

class HomeInteractor: HomeInteractorProtocol {
    
    private func fetchPokemonList(offset: Int) -> Observable<[PokemonListItem]> {
            let urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=\(offset)"
            guard let url = URL(string: urlString) else { return Observable.just([]) }

            return URLSession.shared.rx.data(request: URLRequest(url: url))
                .map { data in
                    let decoder = JSONDecoder()
                    let response = try? decoder.decode(PokemonListResponse.self, from: data)
                    return response?.results ?? []
                }
        }
        
        private func fetchPokemonDetail(urlString: String) -> Observable<PokemonEntity> {
            guard let url = URL(string: urlString) else { return Observable.empty() }

            return URLSession.shared.rx.data(request: URLRequest(url: url))
                .map { data in
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(PokemonDetailResponse.self, from: data)
                    let id = String(response.id)
                    let name = response.name
                    let image = response.sprites.frontDefault ?? ""
                    let hp = response.stats.map({$0.baseStat})
                    let type = response.types.first?.type.name ?? ""
                    return PokemonEntity(id: id, name: name, image: image, type: type, hp: hp)
                }
        }
        
    func fetchEntities(offset: Int) -> Observable<[PokemonEntity]> {
        return fetchPokemonList(offset: offset)
                .flatMap { list in
                    Observable.from(list)
                }
                .flatMap { item in
                    self.fetchPokemonDetail(urlString: item.url)
                }
                .toArray()
                .asObservable()
        }
}

