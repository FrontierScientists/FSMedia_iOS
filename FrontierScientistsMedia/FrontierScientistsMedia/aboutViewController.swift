//
//  aboutViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 6/9/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit
import MessageUI

var aboutCurrentImage = "about_icon.jpg"


class aboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet var aboutTable: UITableView!
   
//    @IBAction func snippetImageClick(sender: AnyObject) {
//        performSegueWithIdentifier("myimage", sender: nil)
//    }
    @IBAction func snippetImageClick(sender: AnyObject) {
        aboutCurrentImage = aboutDisplayableContent.imageKeys[sender.tag - sections.count]
        performSegueWithIdentifier("myimage", sender: nil)
    }
    
    @IBAction func emailDevs(sender: AnyObject) {
        var subject_prefix = "[frontsci]"
        var recepient = ["sfarabaugh@alaska.edu"]
        var mailer = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        mailer.setToRecipients(recepient)
        mailer.setSubject(subject_prefix)
        presentViewController(mailer, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    let sections = ["opening","goal"]
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
        
        for var ii:Int=0; ii < aboutInfo["people"]!.count; ii++ {
            aboutDisplayableContent.people.append((aboutInfo["people"]![ii] as! [String: String])["text"]!)
            let tempImageKey = NSURL(string: (aboutInfo["people"]![ii] as! [String: String])["image"]!)!.lastPathComponent
            aboutDisplayableContent.imageKeys.append(tempImageKey!)
        }

        aboutTable.estimatedRowHeight = 110.0
        aboutTable.rowHeight = UITableViewAutomaticDimension
    }//end viewDidLoad
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("debug numORows")
        return sections.count + aboutDisplayableContent.snippets.count + aboutDisplayableContent.people.count + 1

    }
//
//    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        aboutCurrentImage = aboutDisplayableContent.imageKeys[indexPath.row - sections.count]
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let devCell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("contactDevs") as! AboutTableViewCell
        
        // One Liners
        if (indexPath.row < sections.count){
            let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("opening") as! AboutTableViewCell
            cell.openingLabel.text = aboutInfo[sections[indexPath.row]] as? String
            cell.openingLabel.font = UIFont(name: "Chalkduster", size: 20)
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        
        else{
            if (indexPath.row < sections.count + aboutDisplayableContent.snippets.count){
                let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("snippets") as! AboutTableViewCell
                cell.snippetLabel.text = aboutDisplayableContent.snippets[indexPath.row - sections.count]
                cell.snippetImage.setImage(storedImages[aboutDisplayableContent.imageKeys[indexPath.row - sections.count]],forState: .Normal)
                cell.snippetLabel.font = UIFont(name: "Chalkduster", size: 20)
                cell.backgroundColor = UIColor.clearColor()
            
                let exclusionPath = UIBezierPath(rect: CGRectMake(0, 0, 170, 120))
                cell.snippetLabel.textContainer.exclusionPaths = [exclusionPath]
                cell.snippetImage.tag = indexPath.row
                return cell
            
            }
            if (indexPath.row == sections.count + aboutDisplayableContent.snippets.count){
                let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("people") as! AboutTableViewCell
                cell.peopleLabel.text = aboutDisplayableContent.people[indexPath.row - aboutDisplayableContent.snippets.count - sections.count]
                cell.peopleImage.setImage(storedImages[aboutDisplayableContent.imageKeys[indexPath.row - sections.count]],forState: .Normal)
                cell.peopleLabel.font = UIFont(name: "Chalkduster", size: 20)
                cell.backgroundColor = UIColor.clearColor()
                
                let exclusionPath = UIBezierPath(rect: CGRectMake(0, 0, 170, 120))
                cell.peopleLabel.textContainer.exclusionPaths = [exclusionPath]
                cell.peopleImage.tag = indexPath.row
                
                return cell
            }
            
            if (indexPath.row > sections.count + aboutDisplayableContent.snippets.count){
                if (indexPath.row < sections.count + aboutDisplayableContent.snippets.count + aboutDisplayableContent.people.count){
                    let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("people") as! AboutTableViewCell
                    cell.peopleLabel.text = aboutDisplayableContent.people[indexPath.row - aboutDisplayableContent.snippets.count - sections.count]
                    cell.peopleLabel.font = UIFont(name: "Chalkduster", size: 20)
                    cell.peopleImage.setImage(storedImages[aboutDisplayableContent.imageKeys[indexPath.row - sections.count]],forState: .Normal)
                
                    cell.backgroundColor = UIColor.clearColor()
                
                    let exclusionPath = UIBezierPath(rect: CGRectMake(0, 0, 170, 120))
                    cell.peopleLabel.textContainer.exclusionPaths = [exclusionPath]
                    cell.peopleImage.tag = indexPath.row
                
                    return cell
                    }
                else {
                    devCell.backgroundColor = UIColor.clearColor()
                    devCell.contactDevs.tag = indexPath.row
                    
                return devCell}
            }
            
            
            return devCell
        }

    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
class aboutDisplayableContentFrameworkized{
    var snippets = [String]()
    var imageKeys = [String]()
    var people = [String]()
    
}

//Setting up a left bar button
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
//        aboutNavBar.leftBarButtonItem = UIBarButtonItem()
//        aboutNavBar.leftBarButtonItem!.title = "< MainMenu"
//        aboutNavBar.leftBarButtonItem!.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ChalkDuster", size: 20)!], forState: .Normal)