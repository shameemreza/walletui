//
//  Card.swift
//  WalletUI
//
//  Created by Shameem Reza on 13/3/22.
//

import SwiftUI

// MARK: BANK CARDS MODEL

struct Card: Identifiable {
    var id = UUID().uuidString
    var name: String
    var cardNumber: String
    var cardImage: String
}


// MARK: - CARD SAMPLE DATA

var cards: [Card] = [
    Card(name: "Benjamin Miles", cardNumber: "4929 0958 237 63677", cardImage: "card1"),
    Card(name: "Steven Vance", cardNumber: "4179 2863 0168 7150", cardImage: "card2"),
    Card(name: "Jonathan Hayes", cardNumber: "4716 2394 4688 5700", cardImage: "card3"),
    Card(name: "Eldon Allen", cardNumber: "5295 8066 4295 5853", cardImage: "card4"),
]
