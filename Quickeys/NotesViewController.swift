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
    
}

// Actions extension

extension NotesViewController {
    // Actions
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared().terminate(sender)
    }
    
    @IBAction func searchWithGoogle(_ sender: NSButton) {
        let allText = inputText.attributedString().string
        var url_text = ""
        if let selectedText = inputText.attributedSubstring(forProposedRange: inputText.selectedRange(), actualRange: nil)?.string {
            url_text = urlEscapeText(txt: selectedText)
        } else {
            url_text = urlEscapeText(txt: allText)
        }
        
        if let url = URL(string: "https://www.google.com/search?q=" + url_text), NSWorkspace.shared().open(url) {
            NSLog("browser opened successfully with google")
        } else {
            NSLog("browser failed to open")
            
        }
    }
}
