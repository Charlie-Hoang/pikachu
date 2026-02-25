//
//  GameView.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @StateObject private var userSettings = UserSettings.shared
    @Environment(\.presentationMode) var presentationMode
    
    init(level: Level) {
        _viewModel = StateObject(wrappedValue: GameViewModel(level: level))
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.05)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                // Header
                HStack {
                    // Back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Home")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    // Player name
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.green)
                        Text(userSettings.playerName)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    // Score
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(viewModel.score)")
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    // Timer (countdown)
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(viewModel.timeRemaining < 60 ? .red : .blue)
                        Text(formatTime(viewModel.timeRemaining))
                            .font(.headline)
                            .foregroundColor(viewModel.timeRemaining < 60 ? .red : .primary)
                    }
                }
                .padding()
                
                // Game Board with padding for outside paths
                GeometryReader { geometry in
                    let padding: CGFloat = 30 // Padding for drawing lines outside board
                    let boardWidth = geometry.size.width - (padding * 2)
                    let boardHeight = geometry.size.height - (padding * 2)
                    let rows = viewModel.board.count
                    let cols = viewModel.board.first?.count ?? 0
                    
                    let cardWidth = (boardWidth - CGFloat(cols + 1) * 4) / CGFloat(cols)
                    let cardHeight = (boardHeight - CGFloat(rows + 1) * 4) / CGFloat(rows)
                    let cardSize = min(cardWidth, cardHeight)
                    
                    ZStack {
                        // Connection lines layer (behind cards)
                        if !viewModel.connectionPath.isEmpty {
                            ConnectionLinesView(
                                path: viewModel.connectionPath,
                                cardSize: cardSize,
                                spacing: 4,
                                padding: padding,
                                boardRows: rows,
                                boardCols: cols
                            )
                        }
                        
                        // Cards layer
                        VStack(spacing: 4) {
                            ForEach(0..<rows, id: \.self) { row in
                                HStack(spacing: 4) {
                                    ForEach(0..<cols, id: \.self) { col in
                                        if let card = viewModel.board[row][col] {
                                            CardView(card: card, size: cardSize)
                                                .onTapGesture {
                                                    viewModel.cardTapped(card)
                                                }
                                                .disabled(!viewModel.connectionPath.isEmpty)
                                        } else {
                                            // Empty space
                                            Rectangle()
                                                .fill(Color.clear)
                                                .frame(width: cardSize, height: cardSize)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(padding)
                        .allowsHitTesting(viewModel.connectionPath.isEmpty)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Restart button
                Button(action: {
                    viewModel.restartGame()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Restart")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.bottom)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.showingAlert) {
            if viewModel.isGameWon {
                // Victory alert with next level option
                return Alert(
                    title: Text("Victory!"),
                    message: Text(viewModel.alertMessage),
                    primaryButton: .default(Text("Next Level")) {
                        viewModel.moveToNextLevel()
                    },
                    secondaryButton: .cancel(Text("Home")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            } else {
                // Game over or other alerts
                return Alert(
                    title: Text(viewModel.isGameOver ? "Game Over" : "Notice"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if viewModel.isGameOver {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(level: Level.defaultLevel)
    }
}
