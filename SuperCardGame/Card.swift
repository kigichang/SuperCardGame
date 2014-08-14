//
//  Card.swift
//  SuperCardGame
//
//  Created by kigi on 8/13/14.
//  Copyright (c) 2014 classroomM. All rights reserved.
//

import Foundation

enum Rank: Int, Printable {
    case Ace = 1, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King
    
    
    var description: String {
        switch self.toRaw() {
        case 10: return "10"
        case 1 : return "A"
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "\(self.toRaw())"
        }
    }
}

enum Suit: Int, Printable {
    //case Spade = "♠️", Club = "♣️", Heart = "♥️", Diamond = "♦️"
    case Club = 1, Diamond, Heart, Spade
    
    
    var description: String {
        switch self {
        case .Club: return "♣️"
        case .Spade: return "♠️"
        case .Heart: return "♥️"
        case .Diamond: return "♦️"
        }
    }
}

struct Card : Printable {
    let rank = Rank.Ace
    let suit = Suit.Spade
    
    init(rank: Rank,suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
    init(rank: Int, suit: Int) {
        self.rank = Rank.fromRaw(rank)!
        self.suit = Suit.fromRaw(suit)!
        
    }
    
    var description : String {
        return "\(rank)\(suit)"
    }
    
    static func rand() -> Card {
        
        let r = Int((arc4random() % 13) + 1)
        let s = Int((arc4random() % 4 ) + 1)
        
        return Card(rank: r, suit: s)
    }
}