//
//  QuotesViewController.swift
//  Quotes
//
//  Created by Alex Rosenfeld on 12/8/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

// Quote class

class QuotesViewController: NSViewController {
    // Lets and vars
    let quotes = Quote.all
    var currentQuoteIndex: Int = 0 {
        didSet {
            updateQuote()
        }
    }
    
    // Outlets
    @IBOutlet var textLabel: NSTextField!
    
    // Overrides
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        currentQuoteIndex = 0
    }
    
    // Functinos
    
    func updateQuote() {
        textLabel.stringValue = String(describing: quotes[currentQuoteIndex])
    }

}

// Actions extension

extension QuotesViewController {
    // MARK: Actions
    @IBAction func goLeft(_ sender: NSButton) {
        currentQuoteIndex = (currentQuoteIndex - 1 + quotes.count) % quotes.count
    }
    
    @IBAction func goRight(_ sender: NSButton) {
        currentQuoteIndex = (currentQuoteIndex + 1 + quotes.count) % quotes.count
    }
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared().terminate(sender)
    }
}
