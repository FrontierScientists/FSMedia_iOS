//
//  Extensions.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/28/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

// This extension for NSDate allows for easier NSDate creation from a String.
extension NSDate {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "MM/dd/yyyy"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}
