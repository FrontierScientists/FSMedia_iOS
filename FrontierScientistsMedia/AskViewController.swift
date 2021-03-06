import Foundation
import UIKit
import MessageUI
// ###############################################################
// This is the AskViewController class, responsable for displaying the on-call scientist's information
//  and providing a way to contact that scientist.  The information displayed comes from the
//  scientistInfo dictionary populated in ContentUpdater.swift.  This class uses a MFMailComposeView to
//  display an email client.
// ###############################################################
class AskViewController: UIViewController, MFMailComposeViewControllerDelegate {
// ###############################################################
// Outlets
// ###############################################################
    @IBOutlet weak var intro: UITextView!
    @IBOutlet weak var scientist: UIButton!
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var exclusion: UIView!
    @IBAction func imageTapped(sender: AnyObject) {
		print("image tapped")
    }
    @IBAction func sendMail(sender: AnyObject) {
        netStatus = reachability.currentReachabilityStatus();
        if (netStatus.rawValue == NOTREACHABLE) {
            displayAlert("Email cannot be sent.")
        } else {
            let subject_prefix = "[frontsci]"
            let recepient = ["liz@frontierscientists.com"]
            let mailer = MFMailComposeViewController()
            mailer.mailComposeDelegate = self
            mailer.setToRecipients(recepient)
            mailer.setSubject(subject_prefix)
            presentViewController(mailer, animated: true, completion: nil)
        }
    }
// ###############################################################
// Class Functions
// ###############################################################
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial beautification and setup
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "Ask A Scientist"
        intro.font = UIFont(name: "Chalkduster", size: 14)
		
        scientist.setImage(sciOnCall.image, forState: UIControlState.Normal)
        name.font = UIFont(name: "Chalkduster", size: 14)
        name.text = "Name: " + sciOnCall.name
		
        // Make the text wrap around the image
        let exclusionPath = UIBezierPath(rect: exclusion.bounds)
        bio.textContainer.exclusionPaths = [exclusionPath]
        bio.font = UIFont(name: "Chalkduster", size: 14)
        bio.text = "Background: " + sciOnCall.bio
		
        // Let the user know what will not be available without internet connection
        netStatus = reachability.currentReachabilityStatus()
        if (netStatus.rawValue == NOTREACHABLE) {
            displayAlert("Email and scientist bio video are unavailable. Connect to the internet")
        }
    }
// ###############################################################
// MFMailComposeView Functions
// ###############################################################
    // mailComposeController
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
// ###############################################################    
    // displayAlert
    func displayAlert(message: String) {
        let alert = UIAlertView(title: "", message: "No network connection was found.  " + message, delegate: self, cancelButtonTitle: nil)
        alert.show()
        delayDismissal(alert)
    }
}
