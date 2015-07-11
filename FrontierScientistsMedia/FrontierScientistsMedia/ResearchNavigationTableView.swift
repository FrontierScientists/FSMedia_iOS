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

var projectTitle = ""

class ResearchNavigationTableView: UIViewController {
    
    @IBOutlet weak var navigationTableView: UITableView!
    @IBOutlet weak var binding: UIView!
    @IBOutlet weak var page: UIView!
    @IBOutlet weak var shadow: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTableView.separatorColor = UIColor.clearColor()
        navigationTableView.backgroundColor = UIColor.clearColor()
        shadow.backgroundColor = UIColor(patternImage: UIImage(named: "drawer_shadow.png")!)
        binding.backgroundColor = UIColor(patternImage: UIImage(named: "navigation_bg.jpg")!)
        page.backgroundColor = UIColor(patternImage: UIImage(named: "page.jpeg")!)
        
        println("ResearchNavigationTableView: viewDidLoad")

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
        var projectTitle = orderedTitles[indexPath.row]
        var imageTitle = (projectData[projectTitle]!["preview_image"] as! String).lastPathComponent
        var image:UIImage = storedImages[imageTitle]!
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.15, 0.225))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.cellLabel.text = projectTitle
        cell.imageView?.image = scaledImage
        cell.cellLabel.font = UIFont(name: "Chalkduster", size: 17)
        cell.cellLabel.textColor = UIColorFromRGB(0x3E3535)
        cell.cellLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}

// TableView Delegate
extension ResearchNavigationTableView: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        projectTitle = orderedTitles[indexPath.row]
        var imageTitle = (projectData[projectTitle]!["preview_image"] as! String).lastPathComponent
        var projectText = (projectData[projectTitle]!["project_description"] as! String)
        var image:UIImage = storedImages[imageTitle]!
        projectViewRef.projectImage.image = image
        projectViewRef.projectText.text = projectText
        projectViewRef.projectText.setContentOffset(CGPointZero, animated: false) // Start text at top
        projectViewRef.scrollView.setContentOffset(CGPointMake(0, -64), animated: false) // Start scroll view at top (below naviagtion bar)
        projectViewRef.delegate?.togglePanel?()
        projectViewRef.scrollView.userInteractionEnabled = true
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}