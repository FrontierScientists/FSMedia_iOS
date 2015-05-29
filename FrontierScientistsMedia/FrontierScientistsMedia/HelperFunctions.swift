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
