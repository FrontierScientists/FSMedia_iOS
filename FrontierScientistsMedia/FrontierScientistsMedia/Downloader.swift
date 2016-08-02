//
//  Downloader.swift
//  Scrubber
//
//  Created by Jonathan Newell on 6/1/16.
//  Copyright © 2016 Jonathan Newell. All rights reserved.

import UIKit
import Foundation

    var data : NSData?

    func downloadData () {
        // ########################
        // downloading
        print("hello")
        let JSONAddress = "https://frontierscientists.com/api/get_posts/?post_type=projects&count=100"
         do { jsonDownload = try NSData(contentsOfURL: NSURL(string: JSONAddress)!, options: NSDataReadingOptions.DataReadingUncached)
         } catch {
            
        }
        // ########################
        // writing to file
        let filepath = "/Library/Caches/downloaded.json"
        NSFileManager.defaultManager().createFileAtPath(filepath, contents: jsonDownload, attributes: nil)
        ParseJSON()
    }
