//  VideosTableViewController.swift

import Foundation
import UIKit
import MediaPlayer

/*
    This is the VideosTableViewController class, responsable for displaying and controlling the expandable TableView holding
    the video titles, catagorized under project titles. When a project title cell is selected the section is collapsed/
    expended to hide/reveal the video titles under that project. When a video title cell is selected the video is played, 
    from the device if downloaded and streamed if not downloaded.
*/
class VideosTableViewController: UITableViewController {
    

/*
    Outlets
*/
   // @IBOutlet weak var changeVidoesModeButton: UIButton!
    @IBOutlet var videoTableView: UITableView!

/*
    Class Constants
*/
    let MANAGE: String = "Manage_downloads"
    let WATCH: String = "Watch_videos"
    let CACHESDIRECTORYPATH: String = NSHomeDirectory() + "/Library/Caches/"
/*
    Class Variables
*/
    var watching: Bool = true
    
    var loadIsNotReloadBool: Bool = true
    var openSectionArray: Array<String> = ["closed"]
    var scrollPath: NSIndexPath = NSIndexPath(forRow: NSNotFound, inSection: NSNotFound)
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: NSNotFound, inSection: NSNotFound)
    var selectedVideoQuality: String = String()
    var selectedVideoPath: String = String()
    var selectedVideoUrl: String = String()
    var currentMode: String = "Watch_videos"
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideosTableView:", name:"reloadVideosTableView", object: nil)
        // Check if there is a network connection, and alert the user if there isn't
        reachability.startNotifier()
        netStatus = reachability.currentReachabilityStatus()
        if (netStatus.rawValue == NOTREACHABLE && loadIsNotReloadBool) {
            noInternetConnectionAlert()
            loadIsNotReloadBool = false
        }

        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage:UIImage(named: "bg.png")!)
        
        setAllVideoDownloadsToNone()
        createFolderNamed("MP4") // Calls to function in HelperFunctions.swift
        createFolderNamed("compressedMP4")
        
        let sectionCount: Int = RPMap.count
        for _ in 0...(sectionCount - 2) {
            openSectionArray.append("closed")
        }
        
        // Open a section if coming from a research project page
        if (currentLinkedProject != -1) {
            self.scrollPath = NSIndexPath(forRow: NSNotFound, inSection: currentLinkedProject)
            self.tableView.scrollToRowAtIndexPath(self.scrollPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            openSectionArray[currentLinkedProject] = "open"
            // currentLinkedProject = -1
        }
        
        // Apply differences for iPad and iPhone
        if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType) {
            //changeVidoesModeButton.frame = CGRectMake(0, 0, 320, 40)
        } else { // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            //changeVidoesModeButton.frame = CGRectMake(0, 0, 180, 20)
        }
    }
    // prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playDownloadedVideo") {
            let downloadedVideoPlayerView = segue.destinationViewController as? DownloadedVideoPlayerController
            downloadedVideoPlayerView?.videoFullPathString = self.selectedVideoPath
        } else if (segue.identifier == "YoutubeStreaming") {
            let youTubePlayerView = segue.destinationViewController as? YouTubeStreamingViewController
            youTubePlayerView?.uTubeUrl = self.selectedVideoUrl
        }
    }
    // viewWillTransitionToSize
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
    }
    
/*
    TableView Functions
*/
    // dropDownListToggle
    // Button command to open/close a section
    func dropDownListToggle(pressedButton: UIButton!) {
        if(openSectionArray[pressedButton.tag] == "open") {
            openSectionArray[pressedButton.tag] = "closed"
        } else { // (openSectionArray[pressedButton.tag] == "closed")
            openSectionArray[pressedButton.tag] = "open"
        }
        self.tableView.reloadData()
        selectedResearchProjectIndex = pressedButton.tag
        self.scrollPath = NSIndexPath(forRow: NSNotFound, inSection: selectedResearchProjectIndex)
        self.tableView.scrollToRowAtIndexPath(self.scrollPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    // numberOfSectionsInTableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return orderedTitles.count
        return RPMap.count
    }
    
    // heightForHeaderInSection
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let project = RPMap[section].title
        let sectionVideoCount: Int? = RPMap[section].videos.count
        if (sectionVideoCount == 0) {
            return 1
        } else {
            return 110.0
        }
    }
    // viewForHeaderInSection
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let project = RPMap[section].title
        let sectionVideoCount: Int? = RPMap[section].videos.count
        
        if (sectionVideoCount == 0) {
            return nil
        }
        
        // The main header view that all subviews will go into
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 110))
        headerView.backgroundColor = UIColor.clearColor()
        
        // The header background subview
        let headerBackgroundImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 110.0))
        headerBackgroundImageView.backgroundColor = UIColor(red:249.0/255.0 , green:244.0/255.0 , blue:174.0/255.0 , alpha:1.0)
        
        // The blue line seperating the headers
        let blueLineImageHeaderView: UIImageView =  UIImageView(frame: CGRectMake(0, headerView.frame.size.height-1, self.view.frame.size.width, 1))
        blueLineImageHeaderView.backgroundColor = UIColor.blueColor()
        
        // The arrow image subview
        let headerArrowImageView: UIImageView = UIImageView(frame: CGRect(x: 15, y: 20, width: 50, height: 50))
        headerArrowImageView.image = UIImage(named: "Transition_Icon.png")
        
        if (openSectionArray[section] == "open") {
            headerArrowImageView.transform = CGAffineTransformMakeRotation(-3.14/2); // ccw turn to point up
        } else { // (openSectionArray[section] == "closed")
            headerArrowImageView.transform = CGAffineTransformMakeRotation(3.14/2); // cw turn to point down
        }
        
        // The research image subview
        let headerResearchImageView: UIImageView = UIImageView(frame: CGRect(x: 70, y: 10, width: 110, height: 70))
        headerResearchImageView.image = RPMap[section].image
        
        // The header label subview
        let headerTitleView: UILabel = UILabel(frame: CGRectMake(190, 5, self.view.frame.size.width - 190, 104))
        headerTitleView.text = RPMap[section].title
        headerTitleView.textColor = UIColor.blackColor()
        headerTitleView.userInteractionEnabled = false
        headerTitleView.numberOfLines = 0
        headerTitleView.backgroundColor = UIColor.clearColor()
        
        // The button subview to open/close the dropdown list
        let headerButton: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 104.0))
        headerButton.backgroundColor = UIColor.clearColor()
        headerButton.tag = section
        headerButton.addTarget(self, action: "dropDownListToggle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Apply differences for iPad and iPhone
        if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType) {
            headerTitleView.font = UIFont(name: "Chalkduster", size: 25)
        } else { // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            headerTitleView.font = UIFont(name: "Chalkduster", size: 20)
        }
        
        // Add the subviews
        headerView.addSubview(headerBackgroundImageView)
        headerView.addSubview(blueLineImageHeaderView)
        headerView.addSubview(headerArrowImageView)
        headerView.addSubview(headerResearchImageView)
        headerView.addSubview(headerTitleView)
        headerView.addSubview(headerButton)
        
        return headerView
    }
    // heightForFooterInSection
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    // viewForFooterInSection
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerImageView: UIImageView =  UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 1))
        // The blue line seperating the headers when one is opened
        if (openSectionArray[section] == "open") {
            footerImageView.backgroundColor = UIColor.blueColor()
        } else { // (openSectionArray[section] == "closed")
            footerImageView.backgroundColor = UIColor.clearColor()
        }
        return footerImageView
    }
    // numberOfRowsInSection
    // Get the number of rows per section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let project = RPMap[section].title
        if (openSectionArray[section] == "open") {
            let sectionVideoCount: Int? = RPMap[section].videos.count
            return sectionVideoCount!
        } else {
            return 0
        }
    }
    // heightForRowAtIndexPath
    // Height for the table cells
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Apply differences for iPad and iPhone
        if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType) {
            return 90
        } else { // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            return 40
        }
    }
    // cellForRowAtIndexPath
    // Get the view for the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let video = RPMap[indexPath.section].videos[indexPath.row].youtube
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        let accessoryImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        // Cell background
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundView = UIImageView(image: UIImage(named: "CellBorder.png"))
        
        // Cell title
        cell.textLabel?.text = RPMap[indexPath.section].videos[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 17)
        cell.textLabel?.textAlignment = NSTextAlignment.Left
        cell.textLabel?.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        
        // Apply differences for iPad and iPhone
        if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType) {
            accessoryImageView.frame = CGRectMake(0, 0, 60, 60)
        } else { // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            accessoryImageView.frame = CGRectMake(0, 0, 30, 30)
        }
        cell.accessoryView = accessoryImageView
        return cell
    }
    // didSelectRowAtIndexPath
    // Cell has been selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.selectedVideoUrl = RPMap[indexPath.section].videos[indexPath.row].youtube
        self.performSegueWithIdentifier("YoutubeStreaming", sender: self)
    }
/*
    Helper and Content Functions
*/
    // noInternetConnectionAlert
    // This function simply displays and dismisses a "no internet" alert
    func noInternetConnectionAlert() {
        let ALERTMESSAGE = "No network connection was found. Some features are unavailable or limited."
        let alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil)
        alert.show()
        delayDismissal(alert)
    }
       // Reload the table's data
    @objc func reloadVideosTableView(notification: NSNotification) {
        self.tableView.reloadData();
    }
    // setAllVideoDownloadsToNone
    // Inits the state of the video downloads, because empty entries cause an error
    func setAllVideoDownloadsToNone() {
        let sectionCount: Int = RPMap.count
        for sectionIndex in 0...sectionCount-1 {
            let project = RPMap[sectionIndex].title
            let sectionVideoCount: Int? = RPMap[sectionIndex].videos.count
            if (sectionVideoCount > 0) {
                for rowIndex in 0...sectionVideoCount!-1 {
                    let video = RPMap[sectionIndex].videos[rowIndex].youtube
                    let videoTitle = RPMap[sectionIndex].videos[rowIndex].title
                    videoTitleStatuses[videoTitle] = "none"
                }
            }
        }
    }
}