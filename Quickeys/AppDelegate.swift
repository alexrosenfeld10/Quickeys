//
//  AppDelegate.swift
//  Quickies
//
//  Created by Alex Rosenfeld on 12/4/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa
import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?
    
    // Launch function
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        LaunchAtLogin.isEnabled = true
        NSApp.activate(ignoringOtherApps: true)
        
        if let button = statusItem.button {
            button.image = NSImage(named: "statusIcon")
            button.image?.isTemplate = true // best for dark mode
            button.action = #selector(AppDelegate.togglePopover(sender:))
        }
        
        statusItem.highlightMode = false
        
        popover.contentViewController = NotesViewController(nibName: "NotesViewController", bundle: nil)
        popover.behavior = .transient

        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start()
        
        let shortcut = MASShortcut.init(keyCode: kVK_ANSI_8, modifierFlags: NSEvent.ModifierFlags(rawValue: UInt(NSEvent.ModifierFlags.command.rawValue + NSEvent.ModifierFlags.shift.rawValue)))
        
        MASShortcutMonitor.shared().register(shortcut, withAction: {
            self.togglePopover(sender: self)
        })
    }
    
    // Termination function
    
    func applicationWillTerminate(_ aNotification: Notification) {
        MASShortcutMonitor.shared().unregisterAllShortcuts()
    }
    
    
    // Helper functions
    
    @objc func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: AnyObject?){
        eventMonitor?.start()
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
}





