import UIKit
// ###############################################################
//
// ###############################################################
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
// ###############################################################
// Outlets
// ###############################################################
    @IBOutlet weak var mainMenu: UITableView!
    @IBOutlet var bindingBack: UIView!
    @IBOutlet var pageBack: UIView!
    @IBOutlet var shadow: UIImageView!
    @IBOutlet weak var loadingDialog: UIView!
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var splashScreen: UIView!
// ###############################################################
//	Variables
    let sections = ["Research", "Videos", "Maps", "Articles", "Ask a Scientist", "About"]
    let icons = ["research_icon.png", "video_icon.png", "map_icon.png", "article_icon.png", "ask_a_scientist_icon.png", "about_icon.png"]
	var alertDisplaying = false
// ###############################################################
    // viewDidAppear
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
		currentLinkedProject = -1
        mainMenu.reloadData()
    }
	// ***************************************************************
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check the network before continuing
        dispatch_async(dispatch_get_main_queue()) {
            if !networkConnected {
				self.displayNetworkAlert()
			}
        }
		// ............
		// Start the menu off as unselectable
        mainMenu.userInteractionEnabled = false
		// ............
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
		// ............
        // Hide the splash screen after 1.5 seconds
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("hideSplashScreen"), userInfo: nil, repeats: false)
        // ............
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
        // ............
        // Hide loading screen when done loading.
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.loadingScreen.hidden = true
            // Make menu selectable when loading screen hides
            self.mainMenu.userInteractionEnabled = true 
        }
    }
	// ***************************************************************
	// hideSplashScreen quite simply hides the splash screen (duh)
	func hideSplashScreen() {
		self.splashScreen.hidden = true
	}
	// ***************************************************************
	// checkNetwork checks the network status and engages in dialog with the user until the network situation is resolved
	func displayNetworkAlert() {
		var alert = UIAlertController()
		alert = UIAlertController(title: "No internet connection.", message: "This app requiures an internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
		let tryAgain = UIAlertAction( title: "Try again", style: UIAlertActionStyle.Default) {
				(action) in
				print("Retry Downloads")
				self.retryDownload()
				self.viewDidLoad()
			}
		let close = UIAlertAction( title: "Close", style: UIAlertActionStyle.Destructive) {
				(action) in
				exit(86)
			}
		alert.addAction(tryAgain)
		alert.addAction(close)
		self.presentViewController(alert, animated: true, completion: nil)
	}
	// ***************************************************************
	// noInternetAlert handles when a user tries to select "Articles" or "About"
	func noInternetAlert(things: String) {
		let ALERTMESSAGE = "No network connection was found. " + things + " unavailable.";
		let alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil);
		alert.show();
		delayDismissal(alert);
	}
	// ***************************************************************
	// retryDownload
	func retryDownload() {
		dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
			// Check for network connection
			reachability.startNotifier();
			netStatus = reachability.currentReachabilityStatus();
			networkConnected = netStatus.rawValue != NOTREACHABLE
			// if there is no network connections, fail the async download
			if (!networkConnected) {
				return
			}
			downloadData()
			print("Download Complete")
			// If there was an error connecting to the server on the very first launch of the application (no data present),
			// the processImages function is skipped and the error dialog is presented from MainViewController.swift
			if !cannotContinue {
				print("UI Ready!")
			}
		}
	}
// ###############################################################
// TableView Functions
// ###############################################################
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
	// ***************************************************************
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
	// ***************************************************************
    // didSelectRowAtIndexPath
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        netStatus = reachability.currentReachabilityStatus()
        // Navigate to correct scene based on selected cell
        switch indexPath.row {
            case 0:
                performSegueWithIdentifier("research", sender: nil)
                break
            case 1:
				if (netStatus.rawValue == NOTREACHABLE) {
					noInternetAlert("Videos")
				} else {
					performSegueWithIdentifier("videos", sender: nil)
				}
                break
            case 2:
				if (netStatus.rawValue == NOTREACHABLE) {
					noInternetAlert("Maps")
				} else {
					performSegueWithIdentifier("maps", sender: nil)
				}
                break
            case 3:
                if (netStatus.rawValue == NOTREACHABLE) {
                    noInternetAlert("Articles")
                } else {
                    performSegueWithIdentifier("articles", sender: nil)
                }
                break
            case 4:
				if (netStatus.rawValue == NOTREACHABLE) {
					noInternetAlert("Ask a Scientist")
				} else {
					performSegueWithIdentifier("ask", sender: nil)
				}
                break
            default:
                if (netStatus.rawValue == NOTREACHABLE) {
                    noInternetAlert("About page")
                } else {
                    performSegueWithIdentifier("about", sender: nil)
                }
                break
        }
		// Deselect the selected row.
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}