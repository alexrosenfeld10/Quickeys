//
//  PastebinAPI.swift
//  Quickeys
//
//  Created by Alex Rosenfeld on 12/14/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation

class PastebinAPI {
    
    var API_KEY = ""
    var player: AVAudioPlayer?
    
    init() {
        API_KEY = valueForAPIKey(named: "API_KEY")
    }
    
    let url = NSURL(string: "http://pastebin.com/api/api_post.php")
    
    func valueForAPIKey(named keyname:String) -> String {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        // TODO encrypt the api key, and decrypt before returning value
        return value
    }
    
    func postPasteRequest(urlEscapedContent: String) {
        
        var request = URLRequest(url: URL(string: "http://pastebin.com/api/api_post.php")!)
        request.httpMethod = "POST"
        let postString = "api_paste_code=\(urlEscapedContent)&api_dev_key=\(API_KEY)&api_option=paste&api_paste_private=1&api_paste_expire_date=N"
        request.httpBody = postString.data(using: .utf8)
        if Reachability.isInternetAvailable() {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    NSLog("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    NSLog("statusCode should be 200, but is \(httpStatus.statusCode)")
                    NSLog("response = \(response)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                
                let pasteBoard = NSPasteboard.general()
                if (responseString?.contains("pastebin.com"))! {
                    NSLog(responseString!)
                    pasteBoard.clearContents()
                    pasteBoard.setString(responseString!, forType: NSStringPboardType)
                } else if (responseString?.contains("maximum"))! {
                    self.playFunkSound()
                    NSLog(responseString!)
                } else {
                    self.playFunkSound()
                    NSLog(responseString!)
                }
            }
            task.resume()
        } else {
            NSLog("No internet connection")
            playFunkSound()
        }
    }
    
    func playFunkSound() {
        guard let url = Bundle.main.url(forResource: "Funk", withExtension: "aiff")
            else {
                NSLog("Unable to find Funk.aiff")
                return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player!.prepareToPlay()
            player!.play()
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
}
