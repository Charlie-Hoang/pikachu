//
//  PathFinder.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation

/// Service to find valid paths between two cards following Pikachu game rules
/// Two cards can connect if we can draw a path with maximum 3 straight lines (2 turns)
class PathFinder {
    
    /// Check if two cards can connect according to Pikachu rules
    /// - Parameters:
    ///   - card1: First card
    ///   - card2: Second card
    ///   - board: 2D array representing the board (nil = empty, Card = occupied)
    /// - Returns: True if cards can connect, false otherwise
    func canConnect(card1: Card, card2: Card, board: [[Card?]]) -> Bool {
        // Cards must be of the same type
        guard card1.pokemonType == card2.pokemonType else { return false }
        
        // Cards must be different
        guard card1.id != card2.id else { return false }
        
        let pos1 = card1.position
        let pos2 = card2.position
        
        // Try direct line (0 turns)
        if hasDirectLine(from: pos1, to: pos2, board: board) {
            return true
        }
        
        // Try one turn (1 corner)
        if hasOneTurnPath(from: pos1, to: pos2, board: board) {
            return true
        }
        
        // Try two turns (2 corners)
        if hasTwoTurnPath(from: pos1, to: pos2, board: board) {
            return true
        }
        
        return false
    }
    
    // MARK: - Private Methods
    
    /// Check if there's a direct line between two positions
    private func hasDirectLine(from pos1: Position, to pos2: Position, board: [[Card?]]) -> Bool {
        // Same row
        if pos1.row == pos2.row {
            let minCol = min(pos1.col, pos2.col)
            let maxCol = max(pos1.col, pos2.col)
            for col in (minCol + 1)..<maxCol {
                if board[pos1.row][col] != nil {
                    return false
                }
            }
            return true
        }
        
        // Same column
        if pos1.col == pos2.col {
            let minRow = min(pos1.row, pos2.row)
            let maxRow = max(pos1.row, pos2.row)
            for row in (minRow + 1)..<maxRow {
                if board[row][pos1.col] != nil {
                    return false
                }
            }
            return true
        }
        
        return false
    }
    
    /// Check if there's a path with one turn
    private func hasOneTurnPath(from pos1: Position, to pos2: Position, board: [[Card?]]) -> Bool {
        // Try corner at (pos1.row, pos2.col)
        let corner1 = Position(row: pos1.row, col: pos2.col)
        if isEmptyOrTarget(corner1, target: pos2, board: board) {
            if hasDirectLine(from: pos1, to: corner1, board: board) &&
               hasDirectLine(from: corner1, to: pos2, board: board) {
                return true
            }
        }
        
        // Try corner at (pos2.row, pos1.col)
        let corner2 = Position(row: pos2.row, col: pos1.col)
        if isEmptyOrTarget(corner2, target: pos2, board: board) {
            if hasDirectLine(from: pos1, to: corner2, board: board) &&
               hasDirectLine(from: corner2, to: pos2, board: board) {
                return true
            }
        }
        
        return false
    }
    
    /// Check if there's a path with two turns
    private func hasTwoTurnPath(from pos1: Position, to pos2: Position, board: [[Card?]]) -> Bool {
        let rows = board.count
        let cols = board[0].count
        
        // Try horizontal then vertical then horizontal
        for col in 0..<cols {
            let mid1 = Position(row: pos1.row, col: col)
            let mid2 = Position(row: pos2.row, col: col)
            
            if isEmptyOrTarget(mid1, target: pos2, board: board) &&
               isEmptyOrTarget(mid2, target: pos2, board: board) {
                if hasDirectLine(from: pos1, to: mid1, board: board) &&
                   hasDirectLine(from: mid1, to: mid2, board: board) &&
                   hasDirectLine(from: mid2, to: pos2, board: board) {
                    return true
                }
            }
        }
        
        // Try vertical then horizontal then vertical
        for row in 0..<rows {
            let mid1 = Position(row: row, col: pos1.col)
            let mid2 = Position(row: row, col: pos2.col)
            
            if isEmptyOrTarget(mid1, target: pos2, board: board) &&
               isEmptyOrTarget(mid2, target: pos2, board: board) {
                if hasDirectLine(from: pos1, to: mid1, board: board) &&
                   hasDirectLine(from: mid1, to: mid2, board: board) &&
                   hasDirectLine(from: mid2, to: pos2, board: board) {
                    return true
                }
            }
        }
        
        return false
    }
    
    /// Check if a position is empty or is the target position
    private func isEmptyOrTarget(_ pos: Position, target: Position, board: [[Card?]]) -> Bool {
        if pos == target {
            return true
        }
        return board[pos.row][pos.col] == nil
    }
}
