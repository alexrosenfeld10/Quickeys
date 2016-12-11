//
//  NotesViewController.swift
//  Quickies
//
//  Created by Alex Rosenfeld on 12/8/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

// Notes View Controller class

class NotesViewController: NSViewController {
    // Lets and vars
    
    let GOOGLE_URL = "https://www.google.com/search?q="
    let GOOGLE_NAME = "Google"
    
    let WOLFRAM_URL = "https://www.wolframalpha.com/input/?i="
    let WOLFRAM_NAME = "Wolfram"
    
    // Outlets
    @IBOutlet var inputText: NSTextView!
    
    // Overrides
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
    // Functions
    
    func urlEscapeText(txt: String) -> String{
        return txt.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    func searchTextOnWebsite(website: String) {
        // Set our destination url
        var BASE_URL = ""
        switch website {
        case GOOGLE_NAME:
            BASE_URL = GOOGLE_URL
            break
        case WOLFRAM_NAME:
            BASE_URL = WOLFRAM_URL
            break
        default:
            NSLog("Unknown website string" + website)
            return
        }
        
        let allText = inputText.attributedString().string
        var url_text = ""
        
        if let selectedText = inputText.attributedSubstring(forProposedRange: inputText.selectedRange(), actualRange: nil)?.string {
            url_text = urlEscapeText(txt: selectedText)
        } else {
            url_text = urlEscapeText(txt: allText)
        }
        
        if let url = URL(string: BASE_URL + url_text), NSWorkspace.shared().open(url) {
            NSLog("browser opened successfully with google")
        } else {
            NSLog("browser failed to open")
            
        }
    }
}

// Actions extension

extension NotesViewController {
    // Actions
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared().terminate(sender)
    }
    
    @IBAction func searchWithGoogleButtonClick(_ sender: NSButton) {
        searchTextOnWebsite(website: GOOGLE_NAME)
    }
    
    @IBAction func searchWithWolframButtonClick(_ sender: NSButton) {
        searchTextOnWebsite(website: WOLFRAM_NAME)
    }
    
}
