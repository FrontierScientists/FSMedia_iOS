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
    
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectText: UITextView!
    var delegate: ProjectViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        projectText.backgroundColor = UIColor.clearColor()
        projectText.font = UIFont(name: "Chalkduster", size: 17)
    }
    
}
