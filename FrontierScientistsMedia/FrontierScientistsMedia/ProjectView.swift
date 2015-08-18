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

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectText: UITextView!
    @IBOutlet weak var links: UITableView!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var drawerButton: UIButton!
    var linkTitles = ["Videos", "Maps"]
    var linkIcons = [UIImage(named: "video_icon.png"), UIImage(named: "map_icon.png")]
    var delegate: ProjectViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, self.view.bounds.width, researchContainerRef.view.bounds.height);
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
        drawerButton.transform = CGAffineTransformMakeRotation(-3.14)
    }
    
    @IBAction func drawerButtonPressed(sender: AnyObject) {
        delegate?.togglePanel?()
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

//noInternetConnectionAlert
//
func noVideosAlert() {
    let ALERTMESSAGE = "There are no videos for this research project. Would you still like to continue to videos?";
    var alert = UIAlertController(title: ALERTMESSAGE,
        message: "",
        preferredStyle: UIAlertControllerStyle.Alert);
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:nil))
    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler:
        {(action: UIAlertAction!) in
            selectedResearchProjectIndex = 0;
            researchContainerRef.performSegueWithIdentifier("videosLink", sender: nil)
    }));
    researchContainerRef.presentViewController(alert, animated: true, completion: nil);
}

// TableView Delegate
extension ProjectView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 { // Videos
            selectedResearchProjectIndex = find(orderedTitles, projectTitle)!
            if (projectData[projectTitle]!["videos"]?.count == 0) {
                noVideosAlert()
            }
            else{
                researchContainerRef.performSegueWithIdentifier("videosLink", sender: nil)
            }
        } else { // Maps
            currentLinkedProject = projectTitle
            researchContainerRef.performSegueWithIdentifier("mapsLink", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // Deselect the selected link
    }
}

