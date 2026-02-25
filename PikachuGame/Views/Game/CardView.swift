//
//  CardView.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import SwiftUI

struct CardView: View {
    let card: Card
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: card.isSelected ? 3 : 1)
                )
                .shadow(color: card.isSelected ? .blue.opacity(0.5) : .black.opacity(0.2),
                       radius: card.isSelected ? 5 : 2,
                       x: 0,
                       y: 2)
            
            // Pokemon image
            if let image = getPokemonImage(for: card.pokemonType) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.7, height: size * 0.7)
            } else {
                // Fallback to emoji if image not found
                Text(getPokemonEmoji(for: card.pokemonType))
                    .font(.system(size: size * 0.5))
            }
        }
        .frame(width: size, height: size)
        .scaleEffect(card.isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: card.isSelected)
    }
    
    private var backgroundColor: Color {
        if card.isSelected {
            return Color.blue.opacity(0.3)
        }
        return Color.white
    }
    
    private var borderColor: Color {
        if card.isSelected {
            return Color.blue
        }
        return Color.gray.opacity(0.3)
    }
    
    /// Load Pokemon image from bundle
    private func getPokemonImage(for type: Int) -> UIImage? {
        let imageName = "pik\(type)"
        
        // Load from bundle (images should be added to project resources)
        if let image = UIImage(named: imageName) {
            return image
        }
        
        return nil
    }
    
    /// Get Pokemon emoji based on type (fallback if image not found)
    private func getPokemonEmoji(for type: Int) -> String {
        let emojis = [
            "⚡️", "🔥", "💧", "🌿", "❄️", "👻", "🐉", "🌟",
            "🌙", "☀️", "🌈", "💎", "🎯", "🎨", "🎭", "🎪",
            "🎸", "🎺", "🎻", "🎹", "🥁", "🎤", "🎧", "🎮",
            "🎲", "🎰", "🎳", "🎯", "🏀", "⚽️"
        ]
        let index = (type - 1) % emojis.count
        return emojis[index]
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CardView(
                card: Card(pokemonType: 1, position: Position(row: 0, col: 0)),
                size: 60
            )
            
            CardView(
                card: Card(pokemonType: 2, position: Position(row: 0, col: 1)),
                size: 60
            )
        }
        .padding()
    }
}
