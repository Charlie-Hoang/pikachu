//
//  ConnectionLinesView.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import SwiftUI

/// View to draw connection lines between matched cards
struct ConnectionLinesView: View {
    let path: [Position]
    let cardSize: CGFloat
    let spacing: CGFloat
    let padding: CGFloat
    let boardRows: Int
    let boardCols: Int
    
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            guard path.count >= 2 else { return }
            
            var pathBuilder = Path()
            
            // Convert first position to point
            let firstPoint = positionToPoint(path[0])
            pathBuilder.move(to: firstPoint)
            
            // Draw lines through all positions
            for i in 1..<path.count {
                let point = positionToPoint(path[i])
                pathBuilder.addLine(to: point)
            }
            
            // Trim path based on animation progress
            let trimmedPath = pathBuilder.trimmedPath(from: 0, to: animationProgress)
            
            // Draw the path with animation
            context.stroke(
                trimmedPath,
                with: .color(.green),
                lineWidth: 4
            )
            
            // Draw circles at corner points (only for animated portion)
            if animationProgress > 0.9 {
                for position in path {
                    let point = positionToPoint(position)
                    let circle = Path(ellipseIn: CGRect(
                        x: point.x - 5,
                        y: point.y - 5,
                        width: 10,
                        height: 10
                    ))
                    context.fill(circle, with: .color(.green))
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                animationProgress = 1.0
            }
        }
    }
    
    /// Convert board position to screen coordinates
    private func positionToPoint(_ position: Position) -> CGPoint {
        // For positions outside the board, place them at the edge
        let col = position.col
        let row = position.row
        
        // Calculate x coordinate
        let x: CGFloat
        if col < 0 {
            x = padding / 2  // Left edge
        } else {
            x = padding + CGFloat(col) * (cardSize + spacing) + cardSize / 2
        }
        
        // Calculate y coordinate
        let y: CGFloat
        if row < 0 {
            y = padding / 2  // Top edge
        } else {
            y = padding + CGFloat(row) * (cardSize + spacing) + cardSize / 2
        }
        
        return CGPoint(x: x, y: y)
    }
}
