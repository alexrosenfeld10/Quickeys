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
    
    var API_KEY = ""
    
    init() {
        API_KEY = Utility.valueForKey(from: "ApiKeys", named: "API_KEY")!
    }
    
    let url = NSURL(string: "http://pastebin.com/api/api_post.php")
    
    func postPasteRequest(urlEscapedContent: String, callback: @escaping (String) -> ()) {
        var request = URLRequest(url: URL(string: "http://pastebin.com/api/api_post.php")!)
        request.httpMethod = "POST"
        let postString = "api_paste_code=\(urlEscapedContent)&api_dev_key=\(API_KEY)&api_option=paste&api_paste_private=1&api_paste_expire_date=N"
        request.httpBody = postString.data(using: .utf8)
        if Reachability.isInternetAvailable() {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil
                    // check for fundamental networking error
                    else {
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
                    callback(responseString!)
                } else if (responseString?.contains("maximum"))! {
                    Utility.playFunkSound()
                    NSLog(responseString!)
                    callback("")
                } else {
                    Utility.playFunkSound()
                    NSLog(responseString!)
                    callback("")
                }
            }
            task.resume()
        } else {
            NSLog("No internet connection")
            Utility.playFunkSound()
        }
    }
}
