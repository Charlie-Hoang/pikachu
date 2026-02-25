//
//  Card.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation

struct Card: Identifiable, Equatable {
    let id: UUID
    let pokemonType: Int // Type of Pokemon (1-N for different Pokemon)
    var position: Position
    var isMatched: Bool
    var isSelected: Bool
    
    init(pokemonType: Int, position: Position) {
        self.id = UUID()
        self.pokemonType = pokemonType
        self.position = position
        self.isMatched = false
        self.isSelected = false
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Position: Equatable {
    var row: Int
    var col: Int
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
}
