//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Katerina Utlik on 2/7/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        let game = EmojiMemoryGame()
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
