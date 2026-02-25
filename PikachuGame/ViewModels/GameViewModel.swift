//
//  GameViewModel.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published var board: [[Card?]] = []
    @Published var selectedCard: Card?
    @Published var score: Int = 0
    @Published var timeElapsed: Int = 0
    @Published var timeRemaining: Int = 600 // 10 minutes = 600 seconds
    @Published var isGameWon: Bool = false
    @Published var isGameOver: Bool = false
    @Published var showingAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var connectionPath: [Position] = []
    
    private var level: Level
    private let pathFinder = PathFinder()
    private var timer: Timer?
    private let gameTimeLimit: Int = 600 // 10 minutes
    
    init(level: Level) {
        self.level = level
        setupBoard()
        startTimer()
    }
    
    // MARK: - Public Methods
    
    func cardTapped(_ card: Card) {
        // Ignore if card is already matched
        guard !card.isMatched else { return }
        
        if let selected = selectedCard {
            // Second card selected
            if selected.id == card.id {
                // Same card tapped again - deselect
                deselectCard(selected)
            } else {
                // Check if cards can connect
                let (canConnect, path) = pathFinder.canConnect(card1: selected, card2: card, board: board)
                if canConnect {
                    // Valid match! Show path and match cards
                    connectionPath = path
                    // Delay to show the path animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.matchCards(selected, card)
                        self.connectionPath = []
                    }
                } else {
                    // Invalid match - show feedback
                    showAlert("These cards cannot connect!")
                    deselectCard(selected)
                }
            }
        } else {
            // First card selected
            selectCard(card)
        }
    }
    
    func restartGame() {
        score = 0
        timeElapsed = 0
        timeRemaining = gameTimeLimit
        isGameWon = false
        isGameOver = false
        selectedCard = nil
        connectionPath = []
        setupBoard()
        startTimer()
    }
    
    // MARK: - Private Methods
    
    private func setupBoard() {
        let rows = level.rows
        let cols = level.cols
        
        // Calculate total cards (must be even)
        let totalCards = rows * cols
        guard totalCards % 2 == 0 else {
            print("Error: Board size must have even number of cells")
            return
        }
        
        // Create pairs of cards
        var cards: [Card] = []
        let pairsNeeded = totalCards / 2
        
        for i in 0..<pairsNeeded {
            let pokemonType = (i % level.pokemonTypes) + 1
            // Create two cards of the same type (temporary positions)
            cards.append(Card(pokemonType: pokemonType, position: Position(row: 0, col: 0)))
            cards.append(Card(pokemonType: pokemonType, position: Position(row: 0, col: 0)))
        }
        
        // Shuffle cards
        cards.shuffle()
        
        // Create board and assign positions
        var newBoard: [[Card?]] = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        var cardIndex = 0
        
        for row in 0..<rows {
            for col in 0..<cols {
                var card = cards[cardIndex]
                card.position = Position(row: row, col: col)
                newBoard[row][col] = card
                cardIndex += 1
            }
        }
        
        board = newBoard
    }
    
    private func selectCard(_ card: Card) {
        var updatedCard = card
        updatedCard.isSelected = true
        updateCard(updatedCard)
        selectedCard = updatedCard
    }
    
    private func deselectCard(_ card: Card) {
        var updatedCard = card
        updatedCard.isSelected = false
        updateCard(updatedCard)
        selectedCard = nil
    }
    
    private func matchCards(_ card1: Card, _ card2: Card) {
        // Mark cards as matched
        var updatedCard1 = card1
        var updatedCard2 = card2
        updatedCard1.isMatched = true
        updatedCard2.isMatched = true
        updatedCard1.isSelected = false
        updatedCard2.isSelected = false
        
        updateCard(updatedCard1)
        updateCard(updatedCard2)
        
        // Remove from board
        board[card1.position.row][card1.position.col] = nil
        board[card2.position.row][card2.position.col] = nil
        
        selectedCard = nil
        score += 10
        
        // Check if game is won
        checkGameWon()
    }
    
    private func updateCard(_ card: Card) {
        board[card.position.row][card.position.col] = card
    }
    
    private func checkGameWon() {
        let hasRemainingCards = board.flatMap { $0 }.contains { $0 != nil }
        if !hasRemainingCards {
            isGameWon = true
            timer?.invalidate()
            saveGameRecord()
            showAlert("Congratulations! You won! 🎉\nScore: \(score)\nReady for next level?")
        }
    }
    
    func moveToNextLevel() {
        // Increase pokemon types by 2 for next level
        let newPokemonTypes = level.pokemonTypes + 2
        level = Level(
            id: level.id + 1,
            name: "Level \(level.id + 1)",
            rows: level.rows,
            cols: level.cols,
            pokemonTypes: newPokemonTypes,
            timeLimit: nil
        )
        
        // Reset game state for new level
        score = 0
        timeElapsed = 0
        timeRemaining = gameTimeLimit
        isGameWon = false
        isGameOver = false
        selectedCard = nil
        connectionPath = []
        setupBoard()
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                
                self.timeElapsed += 1
                self.timeRemaining -= 1
                
                // Check if time is up
                if self.timeRemaining <= 0 {
                    self.gameOver()
                }
            }
        }
    }
    
    private func gameOver() {
        isGameOver = true
        timer?.invalidate()
        saveGameRecord()
        showAlert("Time's up! Game Over!\nFinal Score: \(score)")
    }
    
    private func saveGameRecord() {
        let playerName = UserSettings.shared.playerName
        let record = GameRecord(
            levelId: level.id,
            levelName: level.name,
            score: score,
            timeElapsed: timeElapsed,
            playerName: playerName
        )
        RecordManager.shared.saveRecord(record)
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}
