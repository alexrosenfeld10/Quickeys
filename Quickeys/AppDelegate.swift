//
//  AppDelegate.swift
//  Quickies
//
//  Created by Alex Rosenfeld on 12/4/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?
    
    // Launch function
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            button.image = NSImage(named: "statusIcon")
            button.image?.isTemplate = true // best for dark mode
            button.action = #selector(AppDelegate.togglePopover(sender:))
        }
        
        popover.contentViewController = NotesViewController(nibName: "NotesViewController", bundle: nil)
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start()
        
    }

    // Termination function
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    //Helper functions
    
    func togglePopover(sender: AnyObject?) {
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





