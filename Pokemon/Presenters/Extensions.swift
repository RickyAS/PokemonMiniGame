//
//  Extensions.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import Foundation

final class PokemonStorage {
    static let shared = PokemonStorage()
    private let key = "com.pokemon.list"
    private init() {}
    
    func loadEntities<T: Codable>() -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key),
           let loadedEntities = try? JSONDecoder().decode(T.self, from: savedData) {
            return loadedEntities
        }
        return nil
    }
    
    func saveEntities<T:Codable>(entities: T) {
        if let encoded = try? JSONEncoder().encode(entities) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}

extension String {
    func splitNameNumber() -> Int {
        let parts = self.split(separator: "-").map({String($0)})
        let value = parts.last ?? "0"
        return Int(value) ?? 0
    }
}

extension Int {
    private func generateFibonacciSequence(upTo max: Int) -> [Int] {
        var sequence = [0, 1]
        while sequence.last! < max {
            let nextNumber = sequence[sequence.count - 1] + sequence[sequence.count - 2]
            sequence.append(nextNumber)
        }
        return sequence
    }
    
    func nextFibonacciNumber() -> Int {
        let fibonacciSequence = generateFibonacciSequence(upTo: self * 2)
        if let index = fibonacciSequence.firstIndex(of: self) {
            if index + 1 < fibonacciSequence.count {
                return fibonacciSequence[index + 1]
            }
        }
        return 0
    }
    
    func isPrimeNumber() -> Bool {
        let number = self
        if number <= 1 {
            return false
        }
        if number <= 3 {
            return true
        }
        if number % 2 == 0 || number % 3 == 0 {
            return false
        }
        
        var i = 5
        while i * i <= number {
            if number % i == 0 || number % (i + 2) == 0 {
                return false
            }
            i += 6
        }
        return true
    }
}
