//
//  PokemonEntity.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import Foundation

struct PokemonEntity: Codable {
    var id: String
    var name: String
    let image: String
    let type: String
    let hp: [Int]
}

struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    let name: String
    let url: String
}

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let sprites: PokemonSprites
    let types: [PokemonTypeEntry]
    let stats: [PokemonStat]
    
    struct PokemonStat: Codable {
        let baseStat: Int
        
        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
        }
    }
    
    struct PokemonSprites: Codable {
        let frontDefault: String?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    struct PokemonTypeEntry: Codable {
        let type: PokemonType
    }
    
    struct PokemonType: Codable {
        let name: String
    }
}










