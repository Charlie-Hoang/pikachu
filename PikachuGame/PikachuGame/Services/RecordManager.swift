//
//  RecordManager.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation

/// Manages game records - saving and loading player scores
class RecordManager {
    static let shared = RecordManager()
    
    private let recordsKey = "gameRecords"
    
    private init() {}
    
    /// Save a new game record
    func saveRecord(_ record: GameRecord) {
        var records = loadRecords()
        records.append(record)
        
        // Sort by score (descending) and date (most recent first)
        records.sort { record1, record2 in
            if record1.score != record2.score {
                return record1.score > record2.score
            }
            return record1.date > record2.date
        }
        
        // Keep only top 100 records
        if records.count > 100 {
            records = Array(records.prefix(100))
        }
        
        saveRecords(records)
    }
    
    /// Load all game records
    func loadRecords() -> [GameRecord] {
        guard let data = UserDefaults.standard.data(forKey: recordsKey) else {
            return []
        }
        
        do {
            let records = try JSONDecoder().decode([GameRecord].self, from: data)
            return records
        } catch {
            print("Error loading records: \(error)")
            return []
        }
    }
    
    /// Get records for a specific level
    func getRecords(forLevel levelId: Int) -> [GameRecord] {
        let allRecords = loadRecords()
        return allRecords.filter { $0.levelId == levelId }
    }
    
    /// Get best score for a level
    func getBestScore(forLevel levelId: Int) -> Int? {
        let levelRecords = getRecords(forLevel: levelId)
        return levelRecords.first?.score
    }
    
    /// Clear all records
    func clearAllRecords() {
        UserDefaults.standard.removeObject(forKey: recordsKey)
    }
    
    // MARK: - Private Methods
    
    private func saveRecords(_ records: [GameRecord]) {
        do {
            let data = try JSONEncoder().encode(records)
            UserDefaults.standard.set(data, forKey: recordsKey)
        } catch {
            print("Error saving records: \(error)")
        }
    }
}
