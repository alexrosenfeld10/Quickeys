//
//  EventMonitor.swift
//  Quotes
//
//  Created by Alex Rosenfeld on 12/8/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Cocoa

public class EventMonitor {
    private var monitor: AnyObject?
    private let mask: NSEventMask
    private let handler: (NSEvent?) -> ()
    
    public init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject?
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
