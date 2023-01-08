//
//  MemoryGame.swift
//  Memorize
//
//  Created by Mateus Brandt on 27/12/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>

    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }

    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                print(chosenIndex)
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        } else {
            print("Couldn't find the choosen card on arary")
        }
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // add numberOfPairsOfCards x 2 to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        shuffle()
    }

    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let id: Int

        // MARK: - Bonus Time

        // This could give matching bonus points if the user matches the card before a certain amount of time passes during which the card is face up

        // Can be zero, which means: "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // How long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // The last time this car dwas turned face up (and is still face up)
        var lastFaceUpDate: Date?

        // The accumulated time this card has been face up in the past. (i.e. not including the current time it's been face up if its is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // How much time left befre the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        // Percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 00 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }

        // Wether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isFaceUp && bonusTimeRemaining > 0
        }
    
        // Wether we are currently face up, unmatched and have not yet used up the bonus windows
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // Called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // Called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        print(self)
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
