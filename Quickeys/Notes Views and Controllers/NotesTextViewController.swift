//
//  NotesTextViewController.swift
//  Quickeys
//
//  Created by Alex Rosenfeld on 12/12/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

class NotesTextViewController: NSTextView {
    
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    override open func keyDown(with event: NSEvent) {
        if (event.keyCode == 53){
            appDelegate.togglePopover(sender: nil)
        } else if (event.keyCode == 36 && event.modifierFlags.contains(.command)) {
            NSLog("Command enter pressed")
            
        } else if (event.keyCode == 36 && event.modifierFlags.contains(.option)) {
            NSLog("alt/option enter pressed")
        }
        else {
            super.keyDown(with: event)
        }
    }
}
