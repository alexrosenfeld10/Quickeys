//
//  NotesTextViewController.swift
//  Quickeys
//
//  Created by Alex Rosenfeld on 12/12/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

protocol NotesTextViewControllerDelegate {
    func NotesTextViewiewControllerCommandEnterPressed()
    func NotesTextViewiewControllerAltOptionEnterPressed()
}

class NotesTextViewController: NSTextView {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    var notesTextViewControllerDelegate: NotesTextViewControllerDelegate?
        
    override open func keyDown(with event: NSEvent) {
        if (event.keyCode == 53){
            appDelegate.togglePopover(sender: nil)
        } else if (event.keyCode == 36 && event.modifierFlags.contains(NSEvent.ModifierFlags.command)) {
            NSLog("Command enter pressed")
            self.notesTextViewControllerDelegate?.NotesTextViewiewControllerCommandEnterPressed()
        } else if (event.keyCode == 36 && event.modifierFlags.contains(NSEvent.ModifierFlags.option)) {
            NSLog("alt/option enter pressed")
            self.notesTextViewControllerDelegate?.NotesTextViewiewControllerAltOptionEnterPressed()
        } else {
            super.keyDown(with: event)
        }
    }
}
