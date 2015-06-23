//
//  aboutViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 6/9/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

var aboutCurrentImage = "Petroglyphs_SodSurveyingPatrickLance.jpg"


class aboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var aboutTable: UITableView!
   
//    @IBAction func snippetImageClick(sender: AnyObject) {
//        performSegueWithIdentifier("myimage", sender: nil)
//    }
    @IBAction func snippetImageClick(sender: AnyObject) {
        aboutCurrentImage = aboutDisplayableContent.imageKeys[sender.tag - sections.count]
        performSegueWithIdentifier("myimage", sender: nil)
    }
    
    let sections = ["opening","goal","people_intro"]
    let aboutDisplayableContent = aboutDisplayableContentFrameworkized()
//    let aboutContent = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "About Frontier Scientists"
        
        for var i:Int=0; i < aboutInfo["snippets"]!.count; i++  {
            aboutDisplayableContent.snippets.append((aboutInfo["snippets"]![i] as! [String: String])["text"]!)


            let tempImageKey = NSURL(string: (aboutInfo["snippets"]![i] as! [String: String])["image"]!)!.lastPathComponent
            aboutDisplayableContent.imageKeys.append(tempImageKey!)
            
        }
        
        aboutTable.estimatedRowHeight = 110.0
        aboutTable.rowHeight = UITableViewAutomaticDimension
    }//end viewDidLoad
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count + aboutDisplayableContent.snippets.count
    }


    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        aboutCurrentImage = aboutDisplayableContent.imageKeys[indexPath.row - sections.count]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let celll: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("opening") as! AboutTableViewCell
        
        if indexPath.row < sections.count{
        let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("opening") as! AboutTableViewCell
        cell.openingLabel.text = aboutInfo[sections[indexPath.row]] as? String
        cell.openingLabel.font = UIFont(name: "Chalkduster", size: 20)
        cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        
        if (indexPath.row > sections.count) || (indexPath.row == sections.count) {
        let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("snippets") as! AboutTableViewCell
        cell.snippetLabel.text = aboutDisplayableContent.snippets[indexPath.row - sections.count]
//        let tempImageKey = NSURL(string: aboutDisplayableContent.imageKeys[indexPath.row - sections.count])!.lastPathComponent
        cell.snippetImage.setImage(storedImages[aboutDisplayableContent.imageKeys[indexPath.row - sections.count]],forState: .Normal)
        cell.snippetLabel.font = UIFont(name: "Chalkduster", size: 20)
        cell.backgroundColor = UIColor.clearColor()
            
            let exclusionPath = UIBezierPath(rect: CGRectMake(0, 0, 170, 120))
            cell.snippetLabel.textContainer.exclusionPaths = [exclusionPath]
        cell.snippetImage.tag = indexPath.row
    
        return cell
        }
        return celll
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
class aboutDisplayableContentFrameworkized{
    var snippets = [""]
    var imageKeys = [""]
    var educators: String?
    
}

//Setting up a left bar button
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
//        aboutNavBar.leftBarButtonItem = UIBarButtonItem()
//        aboutNavBar.leftBarButtonItem!.title = "< MainMenu"
//        aboutNavBar.leftBarButtonItem!.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ChalkDuster", size: 20)!], forState: .Normal)