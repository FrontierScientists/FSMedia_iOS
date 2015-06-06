//
//  ResearchNavigationTableView.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/4/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

@objc
protocol ResearchNavigationTableViewDelegate {
    func projectSelected(title: String, image: UIImage)
}

class ResearchNavigationTableView: UIViewController {
    
    @IBOutlet weak var navigationTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTableView.reloadData()
    }
}

// TableView Data Source
extension ResearchNavigationTableView: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectData.keys.array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("project") as! CustomTableViewCell
        cell.imageView?.image = UIImage(named: "research_icon.png")
        cell.cellLabel.text = "Testing"
        cell.cellLabel.font = UIFont(name: "Chalkduster", size: 20)
        cell.cellLabel.textColor = UIColorFromRGB(0x3E3535)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}

// TableView Delegate
extension ResearchNavigationTableView: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Reset stuff in ProjectView
    }
}