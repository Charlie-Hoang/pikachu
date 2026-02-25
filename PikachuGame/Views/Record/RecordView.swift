//
//  RecordView.swift
//  PikachuGame
//
//  Created on 25/02/2026.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var records: [GameRecord] = []
    @State private var showingClearAlert = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.05)
                .ignoresSafeArea()
            
            VStack {
                // Header
                HStack {
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
                    
                    Text("Records")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        showingClearAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                
                // Records List
                if records.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "chart.bar.doc.horizontal")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No records yet")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text("Play some games to see your scores here!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(records) { record in
                            RecordRowView(record: record)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadRecords()
        }
        .alert(isPresented: $showingClearAlert) {
            Alert(
                title: Text("Clear All Records"),
                message: Text("Are you sure you want to delete all records? This action cannot be undone."),
                primaryButton: .destructive(Text("Clear")) {
                    clearRecords()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func loadRecords() {
        records = RecordManager.shared.loadRecords()
    }
    
    private func clearRecords() {
        RecordManager.shared.clearAllRecords()
        loadRecords()
    }
}

struct RecordRowView: View {
    let record: GameRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(record.levelName)
                    .font(.headline)
                
                Spacer()
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("\(record.score)")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
            }
            
            HStack {
                // Player name
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.caption)
                    Text(record.playerName)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(.green)
                
                Spacer()
                
                // Time
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(formatTime(record.timeElapsed))
                        .font(.caption)
                }
                .foregroundColor(.gray)
                
                Spacer()
                
                // Date
                Text(formatDate(record.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
