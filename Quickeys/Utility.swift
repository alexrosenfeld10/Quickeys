//
//  Utility.swift
//  Quickeys
//
//  Created by Alex Rosenfeld on 1/4/17.
//  Copyright © 2017 Alex Rosenfeld. All rights reserved.
//

import Foundation
import AVFoundation

public class Utility {
    
    static var player = AVAudioPlayer()
    
    class func valueForKey(from source: String, named keyname:String) -> String? {
        let filePath = Bundle.main.path(forResource: source, ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }
    
    class func playFunkSound() {
        guard let url = Bundle.main.url(forResource: "Funk", withExtension: "aiff")
            else {
                NSLog("Unable to find Funk.aiff")
                return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
}
