//
//  Level.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation

struct Level: Codable {
    let id: Int
    let name: String
    let rows: Int
    let cols: Int
    let pokemonTypes: Int // Number of different Pokemon types
    let timeLimit: Int? // Optional time limit in seconds
    
    static let defaultLevel = Level(
        id: 1,
        name: "Level 1",
        rows: 20,
        cols: 10,
        pokemonTypes: 20,
        timeLimit: nil
    )
}
