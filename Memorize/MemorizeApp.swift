//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Mateus Brandt on 26/12/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
