//
//  AskViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 5/21/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class AskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var askTableView: UITableView!
    var iPhoneFontSize:CGFloat = 20
    var iPadFontSize:CGFloat = 35
    
    @IBAction func scientistBioClicked(sender: AnyObject) {
        netStatus = reachability.currentReachabilityStatus();
        if(netStatus.value == NOTREACHABLE){
            noVideoAlert();
        }
        else{
            println("Ask A Scientist: image button")
            performSegueWithIdentifier("scientist_bio",sender: nil)
        }
    }
    @IBAction func sendMail(sender: AnyObject) {
        
        netStatus = reachability.currentReachabilityStatus();
        if(netStatus.value == NOTREACHABLE){
            noEmailAlert();
        }
        else{
            println("Ask A Scientists: I am the bottom button")
            var subject_prefix = "[frontsci]"
            var recepient = ["liz@frontierscientists.com"]
            var mailer = MFMailComposeViewController()
            mailer.mailComposeDelegate = self
            mailer.setToRecipients(recepient)
            mailer.setSubject(subject_prefix)
            presentViewController(mailer, animated: true, completion: nil)
        }
    }

    // MFMailComposeViewControllerDelegate
    // 1
func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    dismissViewControllerAnimated(true, completion: nil)
    }
    
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let avc = segue.destinationViewController as? YouTubeStreaming;
        avc?.uTubeUrl=scientistInfo["video"]!
    }
    
override func viewDidLoad() {
        super.viewDidLoad()
        println("Ask A Scientist: View Did Load")
    
        askTableView.estimatedRowHeight = 110.0
        askTableView.rowHeight = UITableViewAutomaticDimension

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "Ask A Scientist"
    
    netStatus = reachability.currentReachabilityStatus();
    if(netStatus.value == NOTREACHABLE){
        noInternetAlert();
    }
}

    func noInternetAlert(){
        
        let ALERTMESSAGE = "No network connection was found. Email and scientist bio video are unavailable.";
        var alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil);
        alert.show();
        
        // Delay the dismissal by 5 seconds
        let delay = 3.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
    func noEmailAlert(){
        
        let ALERTMESSAGE = "No network connection was found. Email cannot be sent.";
        var alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil);
        alert.show();
        
        // Delay the dismissal by 5 seconds
        let delay = 3.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
    func noVideoAlert(){
        
        let ALERTMESSAGE = "No network connection was found. Video cannot stream.";
        var alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil);
        alert.show();
        
        // Delay the dismissal by 5 seconds
        let delay = 3.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
}

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let celll: AskTableViewCell = tableView.dequeueReusableCellWithIdentifier("pageBlurb") as! AskTableViewCell
    switch indexPath.row
    {case 0:
            println("case 0")
            let cell: AskTableViewCell = tableView.dequeueReusableCellWithIdentifier("pageBlurb") as! AskTableViewCell
                cell.pageBlurb.font = UIFont(name: "ChalkDuster", size: iPhoneFontSize)
            cell.backgroundColor = UIColor.clearColor()
//            cell.pageBlurb.font = UIFont(name: "ChalkDuster", size: iPadFontSize)
            return cell
    case 1:
        println("case 1")
        let cell: AskTableViewCell = tableView.dequeueReusableCellWithIdentifier("biography") as! AskTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        // replacing default elements
        // Biography
        cell.scientistBio.text = scientistInfo["bio"]
//         Name
        cell.scientistName.text = scientistInfo["name"]
//        Image
        let scientist_image_key = NSURL(string: scientistInfo["image"]!)?.lastPathComponent
        cell.scientistImage.setImage(storedImages[scientist_image_key!]!,forState: .Normal)
        
        // Prelim testing for Resizing for iPad vs iPhone
        if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType)
        {println("This is an iPad")
            //scientist_image.frame = CGRectMake(100, 100, 300, 300)
            //
            cell.scientistName.font = UIFont(name: "ChalkDuster", size: 35)
            cell.scientistBio.font = UIFont(name: "ChalkDuster", size: 35)
        }
        else
            {println("This is an iPhone")
            cell.scientistName.font = UIFont(name: "ChalkDuster", size: iPhoneFontSize)
            cell.scientistBio.font = UIFont(name: "ChalkDuster", size: iPhoneFontSize)
        }
        return cell
    case 2:
        println("case 2")
        let cell: AskTableViewCell = tableView.dequeueReusableCellWithIdentifier("askAScientist") as! AskTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        return cell
    default:
        return celll}
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
