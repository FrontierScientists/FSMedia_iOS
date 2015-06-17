//
//  GameBattery.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/15/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

class Battery {
    
    let powerWidth:CGFloat = 21
    let powerHeight:CGFloat = 56
    
    var batteryView = UIImageView(image: UIImage(named: "Game/battery.png")) // CHANGE TO NODES!!!!!
    var powerView = UIView()
    var capacity:CGFloat = 0.0
    var current:CGFloat = 0.0
    var percent:CGFloat = 0.0
    
    init(timeCapacity: CGFloat, frameWidth: CGFloat) {
        self.batteryView.frame = CGRectMake(frameWidth - self.powerWidth - 28, 0, self.powerWidth + 42, self.powerHeight + 29)
        self.powerView = UIView(frame: CGRectMake(frameWidth - 28, 19, self.powerWidth, self.powerHeight))
        self.powerView.backgroundColor = UIColor.greenColor()
        self.capacity = timeCapacity
        self.current = self.capacity
    }
}
