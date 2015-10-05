//
//  HelperFunctions.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/27/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

// UIColorFromRGB
// This function generated a UIColor object from an RGB value
func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// Returns the last component of a url string
func lastComponentOfUrlString(url: String) -> String {
    if (url != "") {
        let nsURL = NSURL(string: url)
        let compArray: Array = nsURL!.pathComponents!
        let compArraySize = compArray.count
        if (compArraySize > 1) {
            return compArray[compArraySize - 1]
        }
    }
    return "";
}

// createFolderNamed
// Creates the folder if it doesn't exist in the Library/Caches/ directory
func createFolderNamed(folderName: String) {
    let FOLDEREPATH: String = NSHomeDirectory() + "Library/Caches/\(folderName)"
    var isDir = ObjCBool(true)
    NSFileManager.defaultManager().fileExistsAtPath(FOLDEREPATH, isDirectory: &isDir)
    do {
        try NSFileManager.defaultManager().createDirectoryAtPath(FOLDEREPATH, withIntermediateDirectories: false, attributes: nil)
    } catch let error as NSError {
        error.description
    }
}

func delayDismissal(alert: UIAlertView) {
    // Delay the dismissal by 5 seconds
    let delay = 3.0 * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    dispatch_after(time, dispatch_get_main_queue(), {
        alert.dismissWithClickedButtonIndex(-1, animated: true)
    })
}