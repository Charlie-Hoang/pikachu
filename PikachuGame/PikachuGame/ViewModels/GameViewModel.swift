//
//  GameViewModel.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var board: [[Card?]] = []
    @Published var selectedCard: Card?
    @Published var score: Int = 0
    @Published var timeElapsed: Int = 0
    @Published var isGameWon: Bool = false
    @Published var showingAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private var level: Level
    private let pathFinder = PathFinder()
    private var timer: Timer?
    
    init(level: Level) {
        self.level = level
        setupBoard()
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
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
                if pathFinder.canConnect(card1: selected, card2: card, board: board) {
                    // Valid match!
                    matchCards(selected, card)
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
        isGameWon = false
        selectedCard = nil
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
            showAlert("Congratulations! You won! 🎉")
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.timeElapsed += 1
        }
    }
    
    private func saveGameRecord() {
        let record = GameRecord(
            levelId: level.id,
            levelName: level.name,
            score: score,
            timeElapsed: timeElapsed
        )
        RecordManager.shared.saveRecord(record)
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}
