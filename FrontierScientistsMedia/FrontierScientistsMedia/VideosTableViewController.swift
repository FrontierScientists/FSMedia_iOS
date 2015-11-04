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
    Actions
*/
    // openManageDownloadsView
    // The user pressed the upper-right-hand button
    @IBAction func openManageDownloadsView(sender: AnyObject) {
        let sectionCount: Int? = orderedTitles.count
        if (currentMode == WATCH) {
            // Open all sections
            for sectionIndex in 0...sectionCount!-1 {
                openSectionArray[sectionIndex] = "open"
            }
            // Switch to downloads view
            currentMode = MANAGE
            sender.setTitle("Done", forState: UIControlState.Normal)
        } else { // (currentMode == MANAGE)
            // Switch to downloads view
            currentMode = WATCH
            sender.setTitle("Manage Downloads", forState: UIControlState.Normal)
        }
        sender.setAttributedTitle(nil, forState: UIControlState.Normal)
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.tableView.reloadData()
    }
/*
    Class Constants
*/
    let MANAGE: String = "Manage_downloads"
    let WATCH: String = "Watch_videos"
    let CACHESDIRECTORYPATH: String = NSHomeDirectory() + "/Library/Caches/Images/"
/*
    Class Variables
*/
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
        // If the showSilentModeWarning archived file doesn't exist...
        if NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("showSilentModeWarning").path!) == nil {
            NSKeyedArchiver.archiveRootObject(true, toFile: getFileUrl("showSilentModeWarning").path!) // create it and set it to true.
        }
        if (NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("showSilentModeWarning").path!) as! Bool) {
            showSilentModeWarning()
        }
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage:UIImage(named: "bg.png")!)
        
        setAllVideoDownloadsToNone()
        createFolderNamed("MP4") // Calls to function in HelperFunctions.swift
        createFolderNamed("compressedMP4")
        
        let sectionCount: Int = orderedTitles.count
        for _ in 0...(sectionCount - 2) {
            openSectionArray.append("closed")
        }
        
        // Open a section if coming from a research project page
        if (selectedResearchProjectIndex != -1) {
            self.scrollPath = NSIndexPath(forRow: NSNotFound, inSection: selectedResearchProjectIndex)
            self.tableView.scrollToRowAtIndexPath(self.scrollPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            openSectionArray[selectedResearchProjectIndex] = "open"
            selectedResearchProjectIndex = -1
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
        return orderedTitles.count
    }
    
    // heightForHeaderInSection
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let project = orderedTitles[section]
        let sectionVideoCount: Int? = projectData[project]!["videos"]?.count
        if (sectionVideoCount == 0) {
            return 1
        } else {
            return 110.0
        }
    }
    // viewForHeaderInSection
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let project = orderedTitles[section]
        let sectionVideoCount: Int? = projectData[project]!["videos"]?.count
        
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
        let researchImageUrl = NSURL(fileURLWithPath: projectData[project]!["preview_image"] as! String)
        headerResearchImageView.image = UIImage(contentsOfFile: CACHESDIRECTORYPATH + "\(researchImageUrl.lastPathComponent!)")
        
        // The header label subview
        let headerTitleView: UILabel = UILabel(frame: CGRectMake(190, 5, self.view.frame.size.width - 190, 104))
        headerTitleView.text = project
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
        let project = orderedTitles[section]
        if (openSectionArray[section] == "open") {
            let sectionVideoCount: Int? = projectData[project]!["videos"]?.count
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
        let project = orderedTitles[indexPath.section]
        let videos = projectData[project]!["videos"] as! [String: [String: String]]
        let video = Array(videos.keys)[indexPath.row]
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        var videoDict: Dictionary = projectData[project]!["videos"]?[video] as! [String: String]
        let accessoryImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        // Cell background
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundView = UIImageView(image: UIImage(named: "CellBorder.png"))
        
        // Cell title
        let VIDEOTITLE: String = videoDict["title"]!
        cell.textLabel?.text = VIDEOTITLE
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 17)
        cell.textLabel?.textAlignment = NSTextAlignment.Left
        cell.textLabel?.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        
        // Apply differences for iPad and iPhone
        if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType) {
            accessoryImageView.frame = CGRectMake(0, 0, 60, 60)
        } else { // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            accessoryImageView.frame = CGRectMake(0, 0, 30, 30)
        }
        
        let VIDEOMP4URL: NSURL = NSURL(fileURLWithPath: videoDict["MP4"]!)
        let VIDEOCOMPRESSEDMP4URL: NSURL = NSURL(fileURLWithPath: videoDict["compressedMP4"]!)
        let MP4FILEPATH: String = CACHESDIRECTORYPATH + "MP4/\(VIDEOMP4URL.lastPathComponent)"
        let COMPRESSEDMP4FILEPATH: String = CACHESDIRECTORYPATH + "compressedMP4/\(VIDEOCOMPRESSEDMP4URL.lastPathComponent)"
        
        // Video is being downloaded
        if (videoTitleStatuses[VIDEOTITLE] != "none") {
            let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 5, 30, 30))
            activityIndicatorView.color = UIColor.blackColor()
            activityIndicatorView.startAnimating()
            cell.imageView?.image = UIImage(named: "blank_icon.png")
            cell.imageView?.addSubview(activityIndicatorView)
            accessoryImageView.image = UIImage(named: "cancel_icon.png")
            // Apply differences for iPad
            if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType) {
                activityIndicatorView.frame = CGRectMake(0, 10, 60, 60)
            }
        } else if (currentMode == MANAGE) { // Video managing options
            if ((VIDEOMP4URL != "" && NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH)) ||
               (VIDEOCOMPRESSEDMP4URL != "" && NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH))) {
                accessoryImageView.image = UIImage(named: "delete_icon-web.png")
            } else if (netStatus.rawValue != NOTREACHABLE &&
                (VIDEOMP4URL != "" || VIDEOCOMPRESSEDMP4URL != "")) {
                    accessoryImageView.image = UIImage(named: "download_icon-web.png")
            } else {
                // There is no downloaded video or network connection, so show nothing
                cell.textLabel?.textColor = UIColor.grayColor()
            }
        } else if (currentMode == WATCH) { // Video watching options
            if (netStatus.rawValue != NOTREACHABLE ||
                (NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH) && VIDEOMP4URL != "") ||
                (NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH) && VIDEOCOMPRESSEDMP4URL != "")) {
                    cell.textLabel?.textColor = UIColor.blackColor()
                    accessoryImageView.image = UIImage(named: "play_icon.png")
            } else {
                // There is no network connection, so show nothing
                cell.textLabel?.textColor = UIColor.grayColor()
            }
        } else { // Video can't be accessed
            cell.textLabel?.textColor = UIColor.grayColor()
        }
        
        cell.accessoryView = accessoryImageView
        return cell
    }
    // didSelectRowAtIndexPath
    // Cell has been selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let project = orderedTitles[indexPath.section]
        let videos = projectData[project]!["videos"] as! [String: [String: String]]
        let video = Array(videos.keys)[indexPath.row]
        var videoDict: Dictionary = projectData[project]!["videos"]?[video] as! [String: String]
        selectedIndexPath = indexPath
        let VIDEOTITLE: String = videoDict["title"]!
        let VIDEOMP4URL: NSURL = NSURL(fileURLWithPath: videoDict["MP4"]!)
        let VIDEOCOMPRESSEDMP4URL: NSURL = NSURL(fileURLWithPath: videoDict["compressedMP4"]!)
        let MP4FILEPATH: String = CACHESDIRECTORYPATH + "MP4/\(VIDEOMP4URL.lastPathComponent)"
        let COMPRESSEDMP4FILEPATH: String = CACHESDIRECTORYPATH + "compressedMP4/\(VIDEOCOMPRESSEDMP4URL.lastPathComponent)"
        
        // Video is being downloaded
        if (videoTitleStatuses[VIDEOTITLE] != "none") {
            cancel_Download_Alert(VIDEOTITLE)
            selectedResearchProjectIndex = -1
        } else if (currentMode == MANAGE) {
            if (VIDEOMP4URL != "" && NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH)) {
                delete_Video_Alert(MP4FILEPATH)
            } else if (VIDEOCOMPRESSEDMP4URL != "" && NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH)) {
                delete_Video_Alert(COMPRESSEDMP4FILEPATH)
            } else if (netStatus.rawValue != NOTREACHABLE &&
                VIDEOMP4URL != "") {
                HD_or_Compressed_Alert()
            }
            selectedResearchProjectIndex = indexPath.section
        } else if (currentMode == WATCH) {
            if(NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH) && VIDEOMP4URL != "") {
                playDownloadedVideo(MP4FILEPATH)
            } else if (NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH) && VIDEOCOMPRESSEDMP4URL != "") {
                playDownloadedVideo(COMPRESSEDMP4FILEPATH)
            } else if (netStatus.rawValue != NOTREACHABLE) {
                self.selectedVideoUrl = videoDict["utubeurl"]!
                self.performSegueWithIdentifier("YoutubeStreaming", sender: self)
            }
        }
    }
    
/*
    Helper and Content Functions
*/
    // getFileUrl
    // This function retrieves a valid url from the document directory.
    func getFileUrl(fileName: String) -> NSURL {
        let manager = NSFileManager.defaultManager()
        let dirURL = try? manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        return dirURL!.URLByAppendingPathComponent(fileName)
    }
    // noInternetConnectionAlert
    // This function simply displays and dismisses a "no internet" alert
    func noInternetConnectionAlert() {
        let ALERTMESSAGE = "No network connection was found. Some features are unavailable or limited."
        let alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil)
        alert.show()
        delayDismissal(alert)
    }
    // cancel_Download_Alert
    // Alert that asks the user if they are sure they want to cancel their in-progress download
    func cancel_Download_Alert(videoTitleString: String) {
        let alert = UIAlertController(title: "Download in Progress",
            message: "Cancel the download?",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel Download", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) in
                let IDENTIFIER: String = "com.scientistsfrontier.\(videoTitleString)"
                NSNotificationCenter.defaultCenter().postNotificationName(IDENTIFIER, object: nil)
        }))
        alert.addAction(UIAlertAction(title: "Continue Download", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // HD_or_Compressed_Alert
    // Alert that asks the user to choose between downloading the HD or compressed version of the video
    func HD_or_Compressed_Alert() {
        let project = orderedTitles[selectedIndexPath.section]
        let videos = projectData[project]!["videos"] as! [String: [String: String]]
        let video = Array(videos.keys)[selectedIndexPath.row]
        
        var videoDict: Dictionary = projectData[project]!["videos"]?[video] as! [String: String]
        let alert = UIAlertController(title: "Choose video quality",
            message: "",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "MP4", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) in
                self.selectedVideoQuality = "MP4"
                self.selectedVideoUrl = videoDict["MP4"]!
                self.downloadVideo()
        }))
        alert.addAction(UIAlertAction(title: "compressedMP4", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) in
                self.selectedVideoQuality = "compressedMP4"
                self.selectedVideoUrl = videoDict["compressedMP4"]!
                self.downloadVideo()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // showSilentModeWarning
    func showSilentModeWarning() {
        let alert = UIAlertController(title: "Make sure your device is not in Silent Mode",
            message: "If it is, you won't be able to hear the videos",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Don't show again", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) in
            NSKeyedArchiver.archiveRootObject(false, toFile: self.getFileUrl("showSilentModeWarning").path!)
        }))
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // downloadVideo
    // Downloads the chosen video at the chosen video quality
    func downloadVideo() {
        let project = orderedTitles[selectedIndexPath.section]
        let videos = projectData[project]!["videos"] as! [String: [String: String]]
        let video = Array(videos.keys)[selectedIndexPath.row]
        var videoDict: Dictionary = projectData[project]!["videos"]?[video] as! [String: String]
        let videoDownloadHelperHandle: VideoDownloadHelper = VideoDownloadHelper()
        videoDownloadHelperHandle.videoQualityFolder = selectedVideoQuality
        videoDownloadHelperHandle.videoTitleString = videoDict["title"]!
        videoDownloadHelperHandle.videoUrlString = videoDict[selectedVideoQuality]!
        videoDownloadHelperHandle.executeBackgroundDownloadForURL()
        self.tableView.reloadData()
    }
    // delete_Video_Alert
    // Alert that asks the user if they are sure they want to delete their downloaded video
    func delete_Video_Alert(videoFilePath: String) {
        let alert = UIAlertController(title: "About to delete video",
            message: "Are you sure?",
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) in
                self.deleteVideo(videoFilePath)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // deleteVideo
    // Deletes the selected downloaded video
    func deleteVideo(videoFilePath: String){
        do {
            try NSFileManager.defaultManager().removeItemAtPath(videoFilePath)
        } catch _ {
            // Nothing need be done with this exception.
        }
        self.tableView.reloadData()
    }
    // playDownloadedVideo
    // Plays a downloaded video
    func playDownloadedVideo(videoFilePath: String) {
        self.selectedVideoPath = videoFilePath
        self.performSegueWithIdentifier("playDownloadedVideo", sender: self)
    }
    // Reload the table's data
    @objc func reloadVideosTableView(notification: NSNotification) {
        self.tableView.reloadData();
    }
    // setAllVideoDownloadsToNone
    // Inits the state of the video downloads, because empty entries cause an error
    func setAllVideoDownloadsToNone() {
        let sectionCount: Int = orderedTitles.count
        for sectionIndex in 0...sectionCount-1 {
            let project = orderedTitles[sectionIndex]
            let sectionVideoCount: Int? = projectData[project]!["videos"]?.count
            if (sectionVideoCount > 0) {
                for rowIndex in 0...sectionVideoCount!-1 {
                    let videos = projectData[project]!["videos"] as! [String: [String: String]]
                    let video = Array(videos.keys)[rowIndex]
                    var videoDict: Dictionary = projectData[project]!["videos"]?[video] as! [String: String]
                    let videoTitle: String = videoDict["title"]!
                    videoTitleStatuses[videoTitle] = "none"
                }
            }
        }
    }
}