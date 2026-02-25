# Pikachu Game - iOS

A classic Pikachu matching game built with SwiftUI for iOS. Match pairs of Pokemon cards by connecting them with a path of maximum 3 straight lines.

## 🎮 Game Features

- **Classic Pikachu Gameplay**: Match pairs of identical Pokemon cards
- **Smart Path Finding**: Cards connect if you can draw a path with max 3 straight lines (2 turns) without crossing other cards
- **Multiple Levels**: Progress through different board layouts with increasing difficulty
- **Score Tracking**: Records are saved automatically with time and score
- **Clean UI**: Beautiful SwiftUI interface with smooth animations

## 📋 Requirements

- iOS 15.0+
- Xcode 16.1+
- Swift 6.0+

## 🏗️ Architecture

The project follows **MVVM (Model-View-ViewModel)** architecture for clean separation of concerns and easy scalability:

```
PikachuGame/
├── Models/              # Data models
│   ├── Card.swift       # Card entity with position and type
│   ├── Level.swift      # Level configuration
│   └── GameRecord.swift # Game score records
├── ViewModels/          # Business logic
│   └── GameViewModel.swift
├── Views/               # UI components
│   ├── Home/           # Home screen & settings
│   ├── Game/           # Game board & cards
│   └── Record/         # Score records
├── Services/            # Core game logic
│   ├── PathFinder.swift    # Pikachu path algorithm
│   ├── LevelManager.swift  # Level management
│   └── RecordManager.swift # Score persistence
└── Resources/           # Assets & levels
    ├── Assets.xcassets/
    └── Levels/
```

## 🚀 Getting Started

### 1. Open the Project

```bash
cd /Users/t0299501/Working/C/ai/projects/pikachu
open PikachuGame.xcodeproj
```

### 2. Build and Run

1. Select a simulator or device in Xcode
2. Press `Cmd + R` to build and run
3. The app will launch with the home screen

### 3. Play the Game

- Tap **START GAME** to begin
- Tap two cards of the same Pokemon type
- If they can connect (max 3 straight lines), they'll be removed
- Clear all cards to win and move to the next level!

## 🎯 Game Rules

Two cards can connect if:
1. They are the same Pokemon type
2. You can draw a path between them with **maximum 3 straight lines** (0, 1, or 2 turns)
3. The path doesn't cross over any other cards

### Path Examples:
- **Direct line** (0 turns): Cards in same row/column with no obstacles
- **One turn** (L-shape): One corner point
- **Two turns** (Z-shape): Two corner points

## 🔧 Customization

### Adding New Levels

Edit `Services/LevelManager.swift` to add more levels:

```swift
private func getDefaultLevels() -> [Level] {
    return [
        Level(id: 1, name: "Level 1", rows: 10, cols: 15, pokemonTypes: 20, timeLimit: nil),
        Level(id: 2, name: "Level 2", rows: 10, cols: 15, pokemonTypes: 25, timeLimit: 300),
        // Add your custom levels here
        Level(id: 4, name: "Expert", rows: 12, cols: 18, pokemonTypes: 35, timeLimit: 180),
    ]
}
```

### Adding Pokemon Images

Currently using emoji placeholders. To add real Pokemon images:

1. Add images to `PikachuGame/Resources/Assets.xcassets/`
2. Name them: `pokemon_1.png`, `pokemon_2.png`, etc.
3. Update `CardView.swift`:

```swift
// Replace the emoji function with:
Image("pokemon_\(card.pokemonType)")
    .resizable()
    .scaledToFit()
    .frame(width: size * 0.7, height: size * 0.7)
```

### Customizing Board Size

Modify the level configuration:
- `rows`: Number of rows (must result in even total cards)
- `cols`: Number of columns
- `pokemonTypes`: Number of different Pokemon types to use

**Note**: `rows × cols` must be even (for pairs)

## 📱 Screens

### Home Screen
- Start Game button
- Records button
- Settings (level selection)

### Game Screen
- 10×15 card board (default)
- Score display
- Timer
- Restart button

### Records Screen
- List of all game records
- Sorted by score (highest first)
- Shows level, score, time, and date
- Clear all records option

## 🎨 Customization Guide

### Changing Colors

Edit the views to customize colors:
- Home screen gradient: `HomeView.swift`
- Card colors: `CardView.swift`
- Button colors: Each view file

### Adjusting Difficulty

In `Level.swift`:
- Increase `pokemonTypes` for more variety (harder)
- Add `timeLimit` for time pressure
- Increase board size for longer games

## 📦 Project Structure Details

### Models
- **Card**: Represents a single card with Pokemon type, position, and state
- **Level**: Configuration for each game level
- **GameRecord**: Stores player scores and game statistics

### Services
- **PathFinder**: Implements the Pikachu connection algorithm
- **LevelManager**: Loads and manages game levels
- **RecordManager**: Persists scores using UserDefaults

### ViewModels
- **GameViewModel**: Manages game state, board, scoring, and timer

### Views
- **HomeView**: Main menu with navigation
- **GameView**: Main gameplay screen with board
- **CardView**: Individual card component
- **RecordView**: Score history display
- **SettingsView**: Level selection

## 🐛 Troubleshooting

### Build Errors
- Ensure you're using Xcode 16.1+ with Swift 6.0
- Clean build folder: `Cmd + Shift + K`
- Rebuild: `Cmd + B`

### Game Issues
- If cards don't connect when they should, check the PathFinder logic
- If board doesn't display correctly, verify level configuration (even number of cards)

## 🔮 Future Enhancements

Planned features for future versions:
- [ ] Add real Pokemon images
- [ ] Sound effects and background music
- [ ] Hint system
- [ ] Shuffle remaining cards
- [ ] Multiplayer mode
- [ ] Achievements system
- [ ] Different themes
- [ ] Animation for connecting path
- [ ] Power-ups and special cards

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Development

Built with:
- SwiftUI for modern iOS UI
- MVVM architecture for clean code
- UserDefaults for data persistence
- Combine for reactive programming

---

**Version**: 1.0  
**Created**: February 25, 2026  
**Platform**: iOS 15.0+
