//
//  LevelManager.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation

/// Manages game levels - loading, saving, and providing level data
@MainActor
class LevelManager {
    static let shared = LevelManager()
    
    private init() {}
    
    /// Load all available levels
    func loadLevels() -> [Level] {
        // Try to load from JSON file first
        if let levels = loadLevelsFromFile() {
            return levels
        }
        
        // Return default levels if file doesn't exist
        return getDefaultLevels()
    }
    
    /// Get a specific level by ID
    func getLevel(id: Int) -> Level? {
        let levels = loadLevels()
        return levels.first { $0.id == id }
    }
    
    // MARK: - Private Methods
    
    private func loadLevelsFromFile() -> [Level]? {
        guard let url = getLevelsFileURL() else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            let levels = try JSONDecoder().decode([Level].self, from: data)
            return levels
        } catch {
            print("Error loading levels: \(error)")
            return nil
        }
    }
    
    private func getLevelsFileURL() -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent("levels.json")
    }
    
    /// Default levels for the game
    private func getDefaultLevels() -> [Level] {
        return [
            Level(id: 1, name: "Level 1", rows: 10, cols: 20, pokemonTypes: 25, timeLimit: nil),
            Level(id: 2, name: "Level 2", rows: 10, cols: 20, pokemonTypes: 30, timeLimit: 300),
            Level(id: 3, name: "Level 3", rows: 12, cols: 22, pokemonTypes: 35, timeLimit: 240)
        ]
    }
    
    /// Save custom levels to file (for future expansion)
    func saveLevels(_ levels: [Level]) {
        guard let url = getLevelsFileURL() else { return }
        
        do {
            let data = try JSONEncoder().encode(levels)
            try data.write(to: url)
        } catch {
            print("Error saving levels: \(error)")
        }
    }
}
