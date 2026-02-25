//
//  SettingsView.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedLevel: Level
    @State private var levels: [Level] = []
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Select Level")) {
                    ForEach(levels, id: \.id) { level in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(level.name)
                                    .font(.headline)
                                Text("\(level.rows)x\(level.cols) - \(level.pokemonTypes) types")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if selectedLevel.id == level.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedLevel = level
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to Play")
                            .font(.headline)
                        Text("1. Tap two cards of the same Pokemon type")
                        Text("2. Cards connect if you can draw a path with max 3 straight lines")
                        Text("3. Clear all cards to win!")
                        Text("4. Move to next level for more challenge")
                    }
                    .font(.caption)
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                levels = LevelManager.shared.loadLevels()
            }
        }
    }
}
