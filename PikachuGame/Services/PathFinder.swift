//
//  PathFinder.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import Foundation

/// Service to find valid paths between two cards following Pikachu game rules
/// Two cards can connect if we can draw a path with maximum 3 straight lines (2 turns)
/// Paths can go outside the board boundaries
class PathFinder {
    
    /// Check if two cards can connect according to Pikachu rules
    /// - Parameters:
    ///   - card1: First card
    ///   - card2: Second card
    ///   - board: 2D array representing the board (nil = empty, Card = occupied)
    /// - Returns: Tuple of (canConnect, path) where path is array of positions if connected
    func canConnect(card1: Card, card2: Card, board: [[Card?]]) -> (Bool, [Position]) {
        // Cards must be of the same type
        guard card1.pokemonType == card2.pokemonType else { return (false, []) }
        
        // Cards must be different
        guard card1.id != card2.id else { return (false, []) }
        
        let pos1 = card1.position
        let pos2 = card2.position
        
        // Try direct line (0 turns)
        if let path = findDirectLine(from: pos1, to: pos2, board: board) {
            return (true, path)
        }
        
        // Try one turn (1 corner)
        if let path = findOneTurnPath(from: pos1, to: pos2, board: board) {
            return (true, path)
        }
        
        // Try two turns (2 corners) - including paths outside board
        if let path = findTwoTurnPath(from: pos1, to: pos2, board: board) {
            return (true, path)
        }
        
        return (false, [])
    }
    
    // MARK: - Private Methods
    
    /// Find direct line path between two positions
    private func findDirectLine(from pos1: Position, to pos2: Position, board: [[Card?]]) -> [Position]? {
        // Same row
        if pos1.row == pos2.row {
            let minCol = min(pos1.col, pos2.col)
            let maxCol = max(pos1.col, pos2.col)
            for col in (minCol + 1)..<maxCol {
                if board[pos1.row][col] != nil {
                    return nil
                }
            }
            return [pos1, pos2]
        }
        
        // Same column
        if pos1.col == pos2.col {
            let minRow = min(pos1.row, pos2.row)
            let maxRow = max(pos1.row, pos2.row)
            for row in (minRow + 1)..<maxRow {
                if board[row][pos1.col] != nil {
                    return nil
                }
            }
            return [pos1, pos2]
        }
        
        return nil
    }
    
    /// Find path with one turn
    private func findOneTurnPath(from pos1: Position, to pos2: Position, board: [[Card?]]) -> [Position]? {
        // Try corner at (pos1.row, pos2.col)
        let corner1 = Position(row: pos1.row, col: pos2.col)
        if isEmptyOrTarget(corner1, target: pos2, board: board) {
            if findDirectLine(from: pos1, to: corner1, board: board) != nil &&
               findDirectLine(from: corner1, to: pos2, board: board) != nil {
                return [pos1, corner1, pos2]
            }
        }
        
        // Try corner at (pos2.row, pos1.col)
        let corner2 = Position(row: pos2.row, col: pos1.col)
        if isEmptyOrTarget(corner2, target: pos2, board: board) {
            if findDirectLine(from: pos1, to: corner2, board: board) != nil &&
               findDirectLine(from: corner2, to: pos2, board: board) != nil {
                return [pos1, corner2, pos2]
            }
        }
        
        return nil
    }
    
    /// Find path with two turns - including paths outside board
    private func findTwoTurnPath(from pos1: Position, to pos2: Position, board: [[Card?]]) -> [Position]? {
        let rows = board.count
        let cols = board[0].count
        
        // Try paths through columns (including outside board: -1 and cols)
        for col in -1...cols {
            let mid1 = Position(row: pos1.row, col: col)
            let mid2 = Position(row: pos2.row, col: col)
            
            // Check if path is valid
            if canDrawPath(from: pos1, through: mid1, mid2, to: pos2, board: board) {
                return [pos1, mid1, mid2, pos2]
            }
        }
        
        // Try paths through rows (including outside board: -1 and rows)
        for row in -1...rows {
            let mid1 = Position(row: row, col: pos1.col)
            let mid2 = Position(row: row, col: pos2.col)
            
            // Check if path is valid
            if canDrawPath(from: pos1, through: mid1, mid2, to: pos2, board: board) {
                return [pos1, mid1, mid2, pos2]
            }
        }
        
        return nil
    }
    
    /// Check if we can draw a path through two middle points
    private func canDrawPath(from start: Position, through mid1: Position, _ mid2: Position, to end: Position, board: [[Card?]]) -> Bool {
        // Check if middle points are outside board or empty
        if !isOutsideBoard(mid1, board: board) && !isEmptyOrTarget(mid1, target: end, board: board) {
            return false
        }
        if !isOutsideBoard(mid2, board: board) && !isEmptyOrTarget(mid2, target: end, board: board) {
            return false
        }
        
        // Check all three segments
        return canDrawSegment(from: start, to: mid1, board: board) &&
               canDrawSegment(from: mid1, to: mid2, board: board) &&
               canDrawSegment(from: mid2, to: end, board: board)
    }
    
    /// Check if we can draw a straight line segment
    private func canDrawSegment(from pos1: Position, to pos2: Position, board: [[Card?]]) -> Bool {
        guard !board.isEmpty && !board[0].isEmpty else { return false }
        
        // Same row - horizontal line
        if pos1.row == pos2.row {
            let minCol = min(pos1.col, pos2.col)
            let maxCol = max(pos1.col, pos2.col)
            
            // Check if row is within board bounds
            guard pos1.row >= 0 && pos1.row < board.count else {
                // Outside board - path is clear
                return true
            }
            
            for col in (minCol + 1)..<maxCol {
                if !isOutsideBoard(Position(row: pos1.row, col: col), board: board) &&
                   board[pos1.row][col] != nil {
                    return false
                }
            }
            return true
        }
        
        // Same column - vertical line
        if pos1.col == pos2.col {
            let minRow = min(pos1.row, pos2.row)
            let maxRow = max(pos1.row, pos2.row)
            
            // Check if column is within board bounds
            guard pos1.col >= 0 && pos1.col < board[0].count else {
                // Outside board - path is clear
                return true
            }
            
            for row in (minRow + 1)..<maxRow {
                if !isOutsideBoard(Position(row: row, col: pos1.col), board: board) &&
                   board[row][pos1.col] != nil {
                    return false
                }
            }
            return true
        }
        
        return false
    }
    
    /// Check if a position is outside the board
    private func isOutsideBoard(_ pos: Position, board: [[Card?]]) -> Bool {
        let rows = board.count
        let cols = board[0].count
        return pos.row < 0 || pos.row >= rows || pos.col < 0 || pos.col >= cols
    }
    
    /// Check if a position is empty or is the target position
    private func isEmptyOrTarget(_ pos: Position, target: Position, board: [[Card?]]) -> Bool {
        if pos == target {
            return true
        }
        if isOutsideBoard(pos, board: board) {
            return true
        }
        return board[pos.row][pos.col] == nil
    }
}
