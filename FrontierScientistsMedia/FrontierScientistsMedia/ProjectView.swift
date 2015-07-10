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

    @IBOutlet weak var scrollView: UIScrollView!
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
        links.separatorColor = UIColor.clearColor()
        projectTitle = orderedTitles[0]
        var imageTitle = (projectData[projectTitle]!["preview_image"] as! String).lastPathComponent
        var text = (projectData[projectTitle]!["project_description"] as! String)
        var image:UIImage = storedImages[imageTitle]!
        projectImage.image = image
        projectText.text = text
        
        if currentLinkedProject != "" {
            // Go to that page
            projectTitle = currentLinkedProject
            var imageTitle = (projectData[projectTitle]!["preview_image"] as! String).lastPathComponent
            var text = (projectData[projectTitle]!["project_description"] as! String)
            var currentImage:UIImage = storedImages[imageTitle]!
            projectImage.image = currentImage
            projectText.text = text
            projectText.setContentOffset(CGPointZero, animated: false) // Start text at top
            scrollView.setContentOffset(CGPointMake(0, -64), animated: false) // Start scroll view at top (below naviagtion bar)
            delegate?.togglePanel?()
            scrollView.userInteractionEnabled = true
            currentLinkedProject = ""
        }
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
            selectedResearchProjectIndex = find(orderedTitles, projectTitle)!
            researchContainerRef.performSegueWithIdentifier("videosLink", sender: nil)
        } else { // Maps
            currentLinkedProject = projectTitle
            researchContainerRef.performSegueWithIdentifier("mapsLink", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // Deselect the selected link
    }
}
