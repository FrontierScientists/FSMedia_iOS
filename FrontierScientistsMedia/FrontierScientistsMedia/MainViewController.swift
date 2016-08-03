//  MainViewController.swift

import UIKit

/*
    This is the MainViewController class, responsable for handling some startup operations as well as display the main menu as a TableView.
*/
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
/*
    Outlets
*/
    @IBOutlet weak var mainMenu: UITableView!
    @IBOutlet var bindingBack: UIView!
    @IBOutlet var pageBack: UIView!
    @IBOutlet var shadow: UIImageView!
    @IBOutlet weak var loadingDialog: UIView!
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var splashScreen: UIView!
/*
    Class Constants
*/
    let sections = ["Research", "Videos", "Maps", "Articles", "Ask a Scientist", "About"]
    let icons = ["research_icon.png", "video_icon.png", "map_icon.png", "article_icon.png", "ask_a_scientist_icon.png", "about_icon.png"]
    
/*
    Class Functions
*/
    // viewDidAppear
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
		currentLinkedProject = -1
        mainMenu.reloadData()
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check the network before continuing
        dispatch_async(dispatch_get_main_queue()) {
            if !networkConnected {
                self.checkNetwork()
            } else if !connectedToServer {
                if cannotContinue {
                    let alert = UIAlertController(title: "Unable to connect to server.", message: "Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.handleNoServerConnection()
                }
            }

        }
        
        mainMenu.userInteractionEnabled = false // Start the menu off as unselectable
        
        // Format the splash screen
        let imageDimension = self.view.frame.width / 4
        let heightSpacer = self.view.frame.height / 4
        let fsLogo = UIImageView(frame: CGRectMake((self.view.frame.width / 2) - (imageDimension / 2), heightSpacer / 2, imageDimension, imageDimension))
        let arscLogo = UIImageView(frame: CGRectMake(imageDimension / 2, (self.view.frame.height / 2) + (heightSpacer / 2), imageDimension, imageDimension))
        let giLogo = UIImageView(frame: CGRectMake((self.view.frame.width / 2) + (imageDimension / 2), (self.view.frame.height / 2) + (heightSpacer / 2), imageDimension, imageDimension))
        fsLogo.image = UIImage(named: "fs_icon.png")
        arscLogo.image = UIImage(named: "arsc_icon.png")
        giLogo.image = UIImage(named: "gi_icon.png")
        splashScreen.addSubview(fsLogo)
        splashScreen.addSubview(arscLogo)
        splashScreen.addSubview(giLogo)
        // Hide the splash screen after 3 seconds
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("hideSplashScreen"), userInfo: nil, repeats: false)
        
        // Beautify.
        navigationController!.navigationBar.barTintColor = UIColor(red:153.0/255.0, green:75.0/255.0, blue:34.0/255.0, alpha:1.0)
        navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ChalkDuster", size: 20)!]
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.barStyle = UIBarStyle.Black
        loadingDialog.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "Frontier Scientists"
        mainMenu.rowHeight = 80
        mainMenu.separatorColor = UIColor.clearColor()
        mainMenu.backgroundColor = UIColor.clearColor()
        shadow.backgroundColor = UIColor(patternImage: UIImage(named: "drawer_shadow.png")!)
        bindingBack.backgroundColor = UIColor(patternImage: UIImage(named: "navigation_bg.jpg")!)
        pageBack.backgroundColor = UIColor(patternImage: UIImage(named: "page.jpeg")!)
        
        // Hide loading screen when done loading.
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.loadingScreen.hidden = true
            self.mainMenu.userInteractionEnabled = true // Make menu selectable when loading screen hides
        }
    }
    
/*
    TableView Functions
*/
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    // cellForRowAtIndexPath
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("section") as! CustomTableViewCell
        cell.cellImage.image = UIImage(named: icons[indexPath.row])
        cell.cellLabel.text = sections[indexPath.row]
        cell.cellLabel.font = UIFont(name: "Chalkduster", size: 20)
        cell.cellLabel.textColor = UIColorFromRGB(0x3E3535)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    // didSelectRowAtIndexPath
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        netStatus = reachability.currentReachabilityStatus()
        // Navigate to correct scene based on selected cell
        switch indexPath.row {
            case 0:
                performSegueWithIdentifier("research", sender: nil)
                break
            case 1:
                performSegueWithIdentifier("videos", sender: nil)
                break
            case 2:
                performSegueWithIdentifier("maps", sender: nil)
                break
            case 3:
                if (netStatus.rawValue == NOTREACHABLE) {
                    noInternetAlert("Articles")
                } else {
                    performSegueWithIdentifier("articles", sender: nil)
                }
                break
            case 4:
                performSegueWithIdentifier("ask", sender: nil)
                break
            default:
                if (netStatus.rawValue == NOTREACHABLE) {
                    noInternetAlert("About page")
                } else {
                    performSegueWithIdentifier("about", sender: nil)
                }
                break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // Deselect the selected row.
    }
    
/*
    Helper and Content Functions
*/
    // hideSplashScreen
    // This function quite simply hides the splash screen (duh)
    func hideSplashScreen() {
        self.splashScreen.hidden = true
    }
    // notInternetAlert
    // This function displays and dismisses an alert message (given)
    func noInternetAlert(things: String) {
        let ALERTMESSAGE = "No network connection was found. " + things + " unavailable.";
        let alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil);
        alert.show();
        delayDismissal(alert);
    }
    // checkNetwork
    // This function checks the network status and engages in dialog with the user until the network situation is resolved
    func checkNetwork() {
        var alert = UIAlertController()
        if (NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("projectData").path!) == nil) {
            alert = UIAlertController(title: "No internet connection.", message: "Internet required for initial startup.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: { (action: UIAlertAction) in
                netStatus = reachability.currentReachabilityStatus()
                if (netStatus.rawValue == NOTREACHABLE) {
                    self.checkNetwork()
                } else {
                    networkConnected = true
                }
            }))
        } else {
            alert = UIAlertController(title: "No internet connection.", message: "Content may not be up to date.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            displayOldData = true
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // handleNoServerConnection
    func handleNoServerConnection() {
        let alert = UIAlertController(title: "Unable to connect to server.", message: "Content may not be up to date.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}