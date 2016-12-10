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
    
}

// Actions extension

extension NotesViewController {
    // Actions
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared().terminate(sender)
    }
    
    @IBAction func searchWithGoogle(_ sender: NSButton) {
        var text = inputText.attributedString().string
        text = text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        if let url = URL(string: "https://www.google.com/search?q=" + text), NSWorkspace.shared().open(url) {
            NSLog("browser opened successfully with google")
        } else {
            NSLog("browser failed to open")
            
        }
    }
}
