//
//  UserSettings.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation

/// Manages user settings and preferences
@MainActor
class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    @Published var playerName: String {
        didSet {
            UserDefaults.standard.set(playerName, forKey: "playerName")
        }
    }
    
    private init() {
        self.playerName = UserDefaults.standard.string(forKey: "playerName") ?? "Player"
    }
    
    /// Reset player name to default
    func resetPlayerName() {
        playerName = "Player"
    }
}
