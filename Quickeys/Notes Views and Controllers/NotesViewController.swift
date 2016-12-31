//
//  NotesViewController.swift
//  Quickies
//
//  Created by Alex Rosenfeld on 12/8/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

// Notes View Controller class

class NotesViewController: NSViewController, NotesTextViewControllerDelegate {
    
    // Lets and vars
    
    let pastebinAPI = PastebinAPI()
    
    let defaults = UserDefaults.standard
    
    let FIXED_WIDTH = CGFloat(372)
    let MIN_HEIGHT = CGFloat(169)
    let MAX_HEIGHT = CGFloat(500)
    
    let GOOGLE_TITLE = "Google"
    let GOOGLE_URL = "https://www.google.com/search?q="
    
    let WOLFRAM_TITLE = "Wolfram Alpha"
    let WOLFRAM_URL = "https://www.wolframalpha.com/input/?i="
    
    let GOOGLEMAPS_TITLE = "Google Maps"
    let GOOGLEMAPS_URL = "https://www.google.com/maps/search/"
    
    let YOUTUBE_TITLE = "Youtube"
    let YOUTUBE_URL = "https://www.youtube.com/results?search_query="
    
    // Outlets
    
    @IBOutlet var inputText: NotesTextViewController!
    @IBOutlet weak var searchTarget: NSPopUpButton!
    
    // Overrides
    
    override func awakeFromNib() {
        inputText.notesTextViewControllerDelegate = self
    }
    
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
    
    override func mouseDragged(with theEvent: NSEvent) {
        let currentLocation = NSEvent.mouseLocation()
        let screenFrame = NSScreen.main()?.frame
        
        var newY = screenFrame!.size.height - currentLocation.y
        
        if newY < MIN_HEIGHT {
            newY = MIN_HEIGHT
        }
        
        if newY > MAX_HEIGHT {
            newY = MAX_HEIGHT
        }
        
        let appDelegate : AppDelegate = NSApplication.shared().delegate as! AppDelegate
        appDelegate.popover.contentSize = NSSize(width: FIXED_WIDTH, height: newY)
    }
    
    // Delegate functions
    
    func NotesTextViewiewControllerCommandEnterPressed() {
        searchClicked(self)
    }
    
    func NotesTextViewiewControllerAltOptionEnterPressed() {
        pastebinClicked(self)
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
    
    @IBAction func searchClicked(_ sender: AnyObject) {
        searchTextOnWebsite(website: (searchTarget.selectedItem?.title)!)
    }
    
    @IBAction func pastebinClicked(_ sender: AnyObject) {
        pastebinAPI.postPasteRequest(urlEscapedContent: urlEscapeText(txt: getHighlightedOrAllTextFromView()))
    }
}
