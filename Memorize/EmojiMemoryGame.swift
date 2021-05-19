//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Katerina Utlik on 2/8/21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    private var currentTheme: Theme
    
    init() {
        currentTheme = Theme.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(with: currentTheme)
    }

    private static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()

        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards ?? Int.random(in: 1...4)) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var theme: (color: Color, accentColor: Color?, name: String) {
        return (currentTheme.color, currentTheme.accentColor, currentTheme.name)
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func startNewGame() {
        currentTheme = Theme.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(with: currentTheme)
    }
}

struct Theme {
    var name: String
    var emojis: Array<String>
    var numberOfPairsOfCards: Int?
    var color: Color
    var accentColor: Color?

    static let themes: [Theme] = [
        Theme(name: "halloween", emojis: ["👻","🎃","🕷","🤡","👾","💀","😈","🫀"], numberOfPairsOfCards: Int.random(in: 1...4), color: .orange, accentColor: .pink),
        Theme(name: "flower", emojis: ["🌷","🌹","🌺","🌸","🌼","🌻","🌿"], color: .pink),
        Theme(name: "animal", emojis: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐷"], color: .yellow),
        Theme(name: "wather", emojis: ["🌪","🌈","☀️","🌤","⛅️","🌥","☁️","🌦","🌧","❄️"], color: .blue),
        Theme(name: "fruit", emojis: ["🍏","🍎","🍐","🍊","🍋","🍌","🍑","🥭","🍍","🥝"], color: .green),
        Theme(name: "car", emojis: ["🚗","🚕","🚙","🚌","🏎","🚓","🛻","🚘","🚍"], color: .red),
    ]
}
