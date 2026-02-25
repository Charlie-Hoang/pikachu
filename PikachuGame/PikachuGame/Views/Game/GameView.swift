//
//  GameView.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
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
                    
                    // Score
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Score: \(viewModel.score)")
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    // Timer
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.blue)
                        Text(formatTime(viewModel.timeElapsed))
                            .font(.headline)
                    }
                }
                .padding()
                
                // Game Board
                GeometryReader { geometry in
                    let boardWidth = geometry.size.width
                    let boardHeight = geometry.size.height
                    let rows = viewModel.board.count
                    let cols = viewModel.board.first?.count ?? 0
                    
                    let cardWidth = min((boardWidth - CGFloat(cols + 1) * 4) / CGFloat(cols), 40)
                    let cardHeight = min((boardHeight - CGFloat(rows + 1) * 4) / CGFloat(rows), 40)
                    let cardSize = min(cardWidth, cardHeight)
                    
                    VStack(spacing: 4) {
                        ForEach(0..<rows, id: \.self) { row in
                            HStack(spacing: 4) {
                                ForEach(0..<cols, id: \.self) { col in
                                    if let card = viewModel.board[row][col] {
                                        CardView(card: card, size: cardSize)
                                            .onTapGesture {
                                                viewModel.cardTapped(card)
                                            }
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
            Alert(
                title: Text(viewModel.isGameWon ? "Victory!" : "Notice"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK")) {
                    if viewModel.isGameWon {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
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
