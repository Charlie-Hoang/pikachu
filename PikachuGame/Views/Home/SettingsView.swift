//
//  SettingsView.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userSettings = UserSettings.shared
    @State private var editingName: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Player Name")) {
                    HStack {
                        TextField("Enter your name", text: $editingName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Save") {
                            if !editingName.isEmpty {
                                userSettings.playerName = editingName
                            }
                        }
                        .buttonStyle(.borderedProminent)
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
                editingName = userSettings.playerName
            }
        }
    }
}
