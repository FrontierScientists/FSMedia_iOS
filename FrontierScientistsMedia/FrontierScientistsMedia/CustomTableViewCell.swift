//
//  CustomTableViewCell.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/21/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    // This override draws in a custom separator with the desired dimensions
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor) // Set color to black
        CGContextSetLineWidth(context, 2) // Set width to 2
        CGContextMoveToPoint(context, 0, self.bounds.size.height)
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height)
        CGContextStrokePath(context)
    }
}
