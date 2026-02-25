//
//  HomeView.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var showingGame = false
    @State private var showingRecords = false
    @State private var showingSettings = false
    @State private var selectedLevel: Level = Level.defaultLevel
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Game Title
                    VStack(spacing: 10) {
                        Text("⚡️ PIKACHU ⚡️")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        Text("Classic Matching Game")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    // Buttons
                    VStack(spacing: 20) {
                        // Start Button
                        NavigationLink(destination: GameView(level: selectedLevel), isActive: $showingGame) {
                            Button(action: {
                                showingGame = true
                            }) {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("START GAME")
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: 250)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                            }
                        }
                        
                        // Records Button
                        NavigationLink(destination: RecordView(), isActive: $showingRecords) {
                            Button(action: {
                                showingRecords = true
                            }) {
                                HStack {
                                    Image(systemName: "chart.bar.fill")
                                    Text("RECORDS")
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: 250)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                            }
                        }
                        
                        // Settings Button
                        Button(action: {
                            showingSettings = true
                        }) {
                            HStack {
                                Image(systemName: "gearshape.fill")
                                Text("SETTINGS")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: 250)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView(selectedLevel: $selectedLevel)
                        }
                    }
                    
                    Spacer()
                    
                    // Version info
                    Text("Version 1.0")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
