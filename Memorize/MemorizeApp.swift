//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Mateus Brandt on 26/12/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()

    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
