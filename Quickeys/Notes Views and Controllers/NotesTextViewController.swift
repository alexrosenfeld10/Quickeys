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
        }
        else {
            super.keyDown(with: event)
        }
    }
}
