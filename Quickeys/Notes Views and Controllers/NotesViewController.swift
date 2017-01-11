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
    
    // Outlets
    
    @IBOutlet var inputText: NotesTextViewController!
    @IBOutlet weak var searchTarget: NSPopUpButton!
    @IBOutlet weak var searchWithMenu: NSMenu!
    @IBOutlet weak var pastebinButton: NSButton!
    
    // Overrides
    
    override func awakeFromNib() {
        inputText.notesTextViewControllerDelegate = self
        populateMenuItems()
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
        let BASE_URL = (Utility.arrayFromSource(from: "Urls")?[searchTarget.indexOfSelectedItem] as! NSDictionary).allValues[0] as! String
        let url_text = urlEscapeText(txt: getHighlightedOrAllTextFromView())
        
        if let url = URL(string: BASE_URL + url_text), NSWorkspace.shared().open(url) {
            NSLog("browser opened successfully")
        } else {
            NSLog("browser failed to open")
        }
    }
    
    func populateMenuItems() {
        searchWithMenu.removeAllItems()
        
        if let menuItems = Utility.arrayFromSource(from: "Urls") {
            for case let menuItem as NSDictionary in menuItems {
                searchWithMenu.addItem(withTitle: menuItem.allKeys[0] as! String, action: nil, keyEquivalent: "")
            }
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
        if let target = searchTarget.selectedItem {
            searchTextOnWebsite(website: (target.title))
        } else {
            NSLog("No search targets in searchTarget menu")
        }
    }
    
    @IBAction func pastebinClicked(_ sender: AnyObject) {
        let text = getHighlightedOrAllTextFromView()
        if !text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty {
            pastebinAPI.postPasteRequest(urlEscapedContent: urlEscapeText(txt: text))
        } else {
            Utility.playFunkSound()
        }
    }
}
