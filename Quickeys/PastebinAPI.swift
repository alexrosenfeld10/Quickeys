//
//  PastebinAPI.swift
//  Quickeys
//
//  Created by Alex Rosenfeld on 12/14/16.
//  Copyright © 2016 Alex Rosenfeld. All rights reserved.
//

import Foundation
import Cocoa

class PastebinAPI {
    
    let API_KEY = "sample-api-key"
    let url = NSURL(string: "http://pastebin.com/api/api_post.php")
    
    func postPasteRequest(urlEscapedContent: String) {
        
        var request = URLRequest(url: URL(string: "http://pastebin.com/api/api_post.php")!)
        request.httpMethod = "POST"
        let postString = "api_paste_code=\(urlEscapedContent)&api_dev_key=\(API_KEY)&api_option=paste"
        request.httpBody = postString.data(using: .utf8)
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
            pasteBoard.clearContents()
            if (responseString?.contains("pastebin.com"))! {
                pasteBoard.setString(responseString!, forType: NSStringPboardType)
            } else if (responseString?.contains("maximum"))! {
                // TODO display error message to user saying they've pasted too many times
                NSLog(responseString!)
                pasteBoard.setString("http://pastebin.com", forType: NSStringPboardType)
            } else {
                NSLog(responseString!)
                pasteBoard.setString("http://pastebin.com", forType: NSStringPboardType)
            }
        }
        task.resume()
    }
}
