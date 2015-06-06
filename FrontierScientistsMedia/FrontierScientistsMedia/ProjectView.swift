//
//  ProjectView.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/4/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

@objc
protocol ProjectViewDelegate {
    optional func togglePanel()
    optional func collapsePanel()
}

class ProjectView: UIViewController {
    
    // Add IBOutlets to view contents (e.g. project image, text)
    var delegate: ProjectViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
