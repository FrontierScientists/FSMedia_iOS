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
    @IBOutlet weak var links: UITableView!
    var linkTitles = ["Videos", "Maps"]
    var linkIcons = [UIImage(named: "video_icon.png"), UIImage(named: "map_icon.png")]
    var delegate: ProjectViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        projectText.backgroundColor = UIColor.clearColor()
        projectText.font = UIFont(name: "Chalkduster", size: 17)
        links.backgroundColor = UIColor.clearColor()
    }
}

// TableView Data Source
extension ProjectView: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("link") as! UITableViewCell
        cell.textLabel?.text = linkTitles[indexPath.row]
        cell.imageView?.image = linkIcons[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Chalkduster", size: 17)
        cell.textLabel!.textColor = UIColorFromRGB(0x3E3535)
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}

// TableView Delegate
extension ProjectView: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 { // Videos
            selectedResearchProjectIndex = indexPath.row
            navigationController?.pushViewController(MySwiftVideoTableViewController(), animated: true)
        } else { // Maps
            
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // Deselect the selected link
    }
}
