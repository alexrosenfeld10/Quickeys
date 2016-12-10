//
//  Quote.swift
//  Quotes
//
//  Created by Alex Rosenfeld on 12/8/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Foundation


struct Quote {
    let text: String
    let author: String
    
    static let all: [Quote] = [
        Quote(text: "Never put off until tomorrow what you can do the day after tomorrow.", author: "Mark Twain"),
        Quote(text: "Efficiency is doing better what is already being done.", author: "Peter Drucker"),
        Quote(text: "To infinity and beyond!", author: "Buzz Lightyear"),
        Quote(text: "May the Force be with you.", author: "Han Solo"),
        Quote(text: "Simplicity is the ultimate sophistication", author: "Leonardo da Vinci"),
        Quote(text: "It’s not just what it looks like and feels like. Design is how it works.", author: "Steve Jobs")
    ]
}

// MARK: - Printable

extension Quote : CustomStringConvertible {
    
    var description: String {
        return "\"\(text)\" — \(author)"
    }
}
