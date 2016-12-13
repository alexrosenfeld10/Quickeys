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
    
    let defaults = UserDefaults.standard
    
    let GOOGLE_TITLE = "Google"
    let GOOGLE_URL = "https://www.google.com/search?q="
    
    let WOLFRAM_TITLE = "Wolfram Alpha"
    let WOLFRAM_URL = "https://www.wolframalpha.com/input/?i="
    
    let GOOGLEMAPS_TITLE = "Google Maps"
    let GOOGLEMAPS_URL = "https://www.google.com/maps/search/"
    
    let YOUTUBE_TITLE = "Youtube"
    let YOUTUBE_URL = "https://www.youtube.com/results?search_query="
    
    // Outlets
    
    @IBOutlet var inputText: NSTextView!
    @IBOutlet weak var searchTarget: NSPopUpButton!
    
    // Overrides
    
    override func viewDidLoad() {
        // Receive previous sessions data
        if let savedUserInputTextData = defaults.string(forKey: "userInputTextData")
        {
            inputText.insertText(savedUserInputTextData, replacementRange: inputText.rangeForUserTextChange)
        }
    }
    
    override func viewDidDisappear() {
        // Save the user input data. This occurs on leaving the view or on closing the app.
        defaults.set(getAllTextFromView(), forKey: "userInputTextData")
        if let savedUserInputTextData = defaults.string(forKey: "userInputTextData")
        {
            NSLog("Saved " + savedUserInputTextData)
        }
    }
    
    // Functions
    
    func getAllTextFromView() -> String {
        return inputText.attributedString().string
    }
    
    func getHighlightedOrAllTextFromView() -> String {
        if let selectedText = inputText.attributedSubstring(forProposedRange: inputText.selectedRange(), actualRange: nil)?.string {
            return selectedText
        } else {
            return getAllTextFromView()
        }
    }
    
    func copyTextFromView() {
        let pasteBoard = NSPasteboard.general()
        pasteBoard.clearContents()
        pasteBoard.setString(getHighlightedOrAllTextFromView(), forType: NSStringPboardType)
    }
    
    func urlEscapeText(txt: String) -> String {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return txt.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)!
    }
    
    func searchTextOnWebsite(website: String) {
        // Set our destination url
        var BASE_URL = ""
        switch website {
        case GOOGLE_TITLE:
            BASE_URL = GOOGLE_URL
            break
        case WOLFRAM_TITLE:
            BASE_URL = WOLFRAM_URL
            break
        case GOOGLEMAPS_TITLE:
            BASE_URL = GOOGLEMAPS_URL
            break
        case YOUTUBE_TITLE:
            BASE_URL = YOUTUBE_URL
            break
        default:
            NSLog("Unknown website string: " + website)
            return
        }
        
        let url_text = urlEscapeText(txt: getHighlightedOrAllTextFromView())
        
        if let url = URL(string: BASE_URL + url_text), NSWorkspace.shared().open(url) {
            NSLog("browser opened successfully")
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
    
    @IBAction func searchClicked(_ sender: NSButton) {
        searchTextOnWebsite(website: (searchTarget.selectedItem?.title)!)
    }
    
    @IBAction func clearTextClicked(_ sender: NSButton) {
        inputText.textStorage?.mutableString.setString("")
    }
    
    @IBAction func copyTextClicked(_ sender: NSButton) {
        copyTextFromView()
    }
    
    @IBAction func cutTextClicked(_ sender: NSButton) {
        copyTextFromView()
        let textRange = inputText.selectedRange()
        if (textRange.length == 0){
            inputText.textStorage?.mutableString.setString("")
        } else {
            inputText.textStorage?.mutableString.deleteCharacters(in: textRange)
        }
    }
}
