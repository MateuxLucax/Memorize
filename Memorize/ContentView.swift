//
//  ContentView.swift
//  Memorize
//
//  Created by Mateus Brandt on 26/12/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 76))]) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
            .foregroundColor(.red)
        }
        .padding(.horizontal)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 16.0)

            if card.isFaceUp {
                shape.fill(.white)
                shape.strokeBorder(lineWidth: 4.0)
                Text(card.content).font(.largeTitle)
            } else {
                shape.fill(.red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()

        ContentView(viewModel: game)
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
    }
}
