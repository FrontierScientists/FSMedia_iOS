//
//  askascientist.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 5/21/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


class AskViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var thing: UILabel!
    @IBAction func sendMail(sender: AnyObject) {
        var subject_prefix = "[frontsci]"
        var recepient = ["sfarabaugh@alaska.edu"]
        var mailer = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        mailer.setToRecipients(recepient)
        mailer.setSubject(subject_prefix)
        presentViewController(mailer, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        thing.text = "You finally worked!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MFMailComposeViewControllerDelegate
    
    // 1
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

