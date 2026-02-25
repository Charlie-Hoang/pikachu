//
//  GameRecord.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation

struct GameRecord: Identifiable, Codable {
    let id: UUID
    let levelId: Int
    let levelName: String
    let score: Int
    let timeElapsed: Int // in seconds
    let date: Date
    
    init(levelId: Int, levelName: String, score: Int, timeElapsed: Int) {
        self.id = UUID()
        self.levelId = levelId
        self.levelName = levelName
        self.score = score
        self.timeElapsed = timeElapsed
        self.date = Date()
    }
}
