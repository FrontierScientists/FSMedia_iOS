//
//  VideoTableViewController.swift
//  FSDemo
//
//  Created by alandrews3 on 5/18/15.
//  Copyright (c) 2015 Andrew Clark. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

var videoTitleForDownloadStatusDictionary: Dictionary<String, String> = ["video_title": "downloadTask.id"];
var selectedResearchProjectIndex: Int = 0;

class MySwiftVideoTableViewController: UITableViewController
{
    @IBOutlet weak var changeVidoesModeButton: UIButton!
    @IBOutlet var videoTableView: UITableView!
    var loadIsNotReloadBool: Bool = true;
    var openSectionArray: Array<String> = ["closed"];
    var scrollPath: NSIndexPath = NSIndexPath(forRow: NSNotFound, inSection: NSNotFound);
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: NSNotFound, inSection: NSNotFound);
    var selectedVideoQuality: String = String();
    var selectedVideoPath: String = String();
    var selectedVideoUrl: String = String();
    var currentMode: String = "Watch_videos";
    let MANAGE: String = "Manage_downloads";
    let WATCH: String = "Watch_videos";
    let CACHESDIRECTORYPATH: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/");
    
    
    override func viewDidLoad(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideosTableView:",name:"reloadVideosTableView", object: nil);
        
        
        // Check if there is a network connection, and alert the user if there isn't
        reachability.startNotifier();
        netStatus = reachability.currentReachabilityStatus();
        if(netStatus.value == NOTREACHABLE && loadIsNotReloadBool)
        {
            noInternetConnectionAlert();
            loadIsNotReloadBool = false;
        }
        
        super.viewDidLoad();
        self.view.backgroundColor = UIColor(patternImage:UIImage(named: "bg.png")!);
        
        setAllVideoDownloadsToNone();
        createFolderNamed("MP4"); // Calls to function in HelperFunctions.swift
        createFolderNamed("compressedMP4");
        
        var sectionCount: Int = iosProjectData.count;
        for sectionIndex in 0...sectionCount-2{
            openSectionArray.append("closed");
        }
        
        // Open a section if coming from a research project page
        if(selectedResearchProjectIndex != -1){
            println("The research project index is " + String(selectedResearchProjectIndex));
            self.scrollPath = NSIndexPath(forRow: NSNotFound, inSection: selectedResearchProjectIndex);
            self.tableView.scrollToRowAtIndexPath(self.scrollPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true);
            openSectionArray[selectedResearchProjectIndex] = "open";
            selectedResearchProjectIndex = -1;
        }
        
        // Apply differences for iPad and iPhone
        if(UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType){
            changeVidoesModeButton.frame = CGRectMake(0, 0, 320, 40);
        }
        else{ // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            changeVidoesModeButton.frame = CGRectMake(0, 0, 180, 20);
        }
    }
    
    //noInternetConnectionAlert
    //
    func noInternetConnectionAlert(){
        
        println("noInternetConnectionAlert triggered in video table.");
        let ALERTMESSAGE = "No network connection was found. Some features are unavailable or limited.";
        var alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil);
        alert.show();
        
        // Delay the dismissal
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
    //orientationChangeUpdate
    //
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        self.tableView.reloadData();
    }
    
    // Table Section Functions
    //  dropDownListToggle(pressedButton: UIButton!)
    //  numberOfSectionsInTableView:(UITableView *)tableView
    //  heightForHeaderInSection section: Int)
    //  viewForHeaderInSection section: Int)
    //  heightForFooterInSection section: Int)
    //  viewForFooterInSection section: Int)
    //
    //
    
    //dropDownListToggle
    // Button command to open/close a section
    func dropDownListToggle(pressedButton: UIButton!){
        if(openSectionArray[pressedButton.tag] == "open"){
            openSectionArray[pressedButton.tag] = "closed";
        }
        else{ //(openSectionArray[pressedButton.tag] == "closed")
            openSectionArray[pressedButton.tag] = "open";
        }
        
        self.tableView.reloadData();
        selectedResearchProjectIndex = pressedButton.tag;
        self.scrollPath = NSIndexPath(forRow: NSNotFound, inSection: selectedResearchProjectIndex);
        self.tableView.scrollToRowAtIndexPath(self.scrollPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true);
    }
    
    // numberOfSectionsInTableView
    //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return iosProjectData.count;
    }
    
    // heightForHeaderInSection
    //
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        var sectionVideoCount: Int? = iosProjectData[section]["videos"]?.count;
        if(sectionVideoCount == 0){
            return 1;
        }
        else{
            return 110.0
        }
    }
    
    // viewForHeaderInSection
    //
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        //println("viewForHeaderInSection");
        var sectionVideoCount: Int? = iosProjectData[section]["videos"]?.count;
        
        if(sectionVideoCount == 0){
            return nil;
        }
        
        // The main header view that all subviews will go into
        var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 110));
        headerView.backgroundColor = UIColor.clearColor();
        
        // The header background subview
        var headerBackgroundImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 110.0));
//        headerBackgroundImageView.backgroundColor = UIColor.yellowColor();
        headerBackgroundImageView.backgroundColor = UIColor(red:249.0/255.0 , green:244.0/255.0 , blue:174.0/255.0 , alpha:1.0)
        // The blue line seperating the headers
        var blueLineImageHeaderView: UIImageView =  UIImageView(frame: CGRectMake(0, headerView.frame.size.height-1, self.view.frame.size.width, 1));
        blueLineImageHeaderView.backgroundColor = UIColor.blueColor();
        
        // The arrow image subview
        var headerArrowImageView: UIImageView = UIImageView(frame: CGRect(x: 15, y: 20, width: 50, height: 50));
        headerArrowImageView.image = UIImage(named: "Transition_Icon.png");
        if(openSectionArray[section] == "open"){
            headerArrowImageView.transform = CGAffineTransformMakeRotation(-3.14/2); // ccw turn to point up
        }
        else{ //(openSectionArray[section] == "closed")
            headerArrowImageView.transform = CGAffineTransformMakeRotation(3.14/2); // cw turn to point down
        }
        
        // The research image subview
        let headerResearchImageView: UIImageView = UIImageView(frame: CGRect(x: 70, y: 10, width: 110, height: 70));
        let researchImageUrl: String = iosProjectData[section]["preview_image"] as! String;
        headerResearchImageView.image = UIImage(contentsOfFile: CACHESDIRECTORYPATH.stringByAppendingPathComponent("Images/\(researchImageUrl.lastPathComponent)"));
        

        // The header label subview
        var headerTitleView: UILabel = UILabel(frame: CGRectMake(190, 5, self.view.frame.size.width - 190, 104));
        var researchTitle: String = iosProjectData[section]["title"] as! String;
        headerTitleView.text = researchTitle;
        headerTitleView.textColor = UIColor.blackColor();
        headerTitleView.userInteractionEnabled = false;
        headerTitleView.numberOfLines = 0;
        headerTitleView.backgroundColor = UIColor.clearColor();
        
        // The button subview to open/close the dropdown list
        var headerButton: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 104.0));
        headerButton.backgroundColor = UIColor.clearColor();
        headerButton.tag = section;
        headerButton.addTarget(self, action: "dropDownListToggle:", forControlEvents: UIControlEvents.TouchUpInside);
        
        // Apply differences for iPad and iPhone
        if(UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType){
            headerTitleView.font = UIFont(name: "Chalkduster", size: 25);
        }
        else{ // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            headerTitleView.font = UIFont(name: "Chalkduster", size: 20);
        }
        
        // Add the subviews
        headerView.addSubview(headerBackgroundImageView);
        headerView.addSubview(blueLineImageHeaderView);
        headerView.addSubview(headerArrowImageView);
        headerView.addSubview(headerResearchImageView);
        headerView.addSubview(headerTitleView);
        headerView.addSubview(headerButton);
        
        return headerView;
    }
    
    // heightForFooterInSection
    //
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 1;
    }
    
    // viewForFooterInSection
    //
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerImageView: UIImageView =  UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 1));
        // The blue line seperating the headers when one is opened
        if(openSectionArray[section] == "open"){
            footerImageView.backgroundColor = UIColor.blueColor();
        }
        else{ //(openSectionArray[section] == "closed")
            footerImageView.backgroundColor = UIColor.clearColor();
        }
        return footerImageView;
    }
    
    // Table Cell Functions
    //  numberOfRowsInSection section: Int)
    //  heightForRowAtIndexPath indexPath: NSIndexPath)
    //  cellForRowAtIndexPath indexPath: NSIndexPath)
    //  didSelectRowAtIndexPath indexPath: NSIndexPath)
    //
    //

    // numberOfRowsInSection
    // Get the number of rows per section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(openSectionArray[section] == "open"){
            var sectionVideoCount: Int? = iosProjectData[section]["videos"]?.count;
            return sectionVideoCount!;
        }
        else{
            return 0;
        }
    }
    
    // heightForRowAtIndexPath
    // Height for the table cells
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Apply differences for iPad and iPhone
        if(UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType){
            return 90;
        }
        else{ // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            return 40;
        }
    }
    
    // cellForRowAtIndexPath
    // Get the view for the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        netStatus = reachability.currentReachabilityStatus();
        if(netStatus.value == NOTREACHABLE)
        {
            //noInternetConnectionAlert();
        }
        
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell");
        var videoDict: Dictionary = iosProjectData[indexPath.section]["videos"]?[indexPath.row] as! [String: String];
        var accessoryImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
        
        // cell background
        cell.backgroundColor = UIColor.clearColor();
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        cell.backgroundView = UIImageView(image: UIImage(named: "CellBorder.png"));
        
        // cell title
        let VIDEOTITLE: String = videoDict["title"]!;
        cell.textLabel?.text = VIDEOTITLE;
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 17);
        cell.textLabel?.textAlignment = NSTextAlignment.Left;
        cell.textLabel?.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        
        // Apply differences for iPad and iPhone
        if(UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType){
            accessoryImageView.frame = CGRectMake(0, 0, 60, 60);
        }
        else{ // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            accessoryImageView.frame = CGRectMake(0, 0, 30, 30);
        }
        
        let VIDEOMP4URL: String = videoDict["MP4"]!;
        let VIDEOCOMPRESSEDMP4URL: String = videoDict["compressedMP4"]!;
        let MP4FILEPATH: String = CACHESDIRECTORYPATH.stringByAppendingPathComponent("MP4/\(VIDEOMP4URL.lastPathComponent)");
        let COMPRESSEDMP4FILEPATH: String = CACHESDIRECTORYPATH.stringByAppendingPathComponent("compressedMP4/\(VIDEOCOMPRESSEDMP4URL.lastPathComponent)");
        
        // Video is being downloaded
        if(videoTitleForDownloadStatusDictionary[VIDEOTITLE] != "none"){
            
            var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 5, 30, 30));
            activityIndicatorView.color = UIColor.blackColor();
            activityIndicatorView.startAnimating();
            cell.imageView?.image = UIImage(named: "blank_icon.png");
            cell.imageView?.addSubview(activityIndicatorView);
            accessoryImageView.image = UIImage(named: "cancel_icon.png");
            // Apply differences for iPad
            if(UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType){
                activityIndicatorView.frame = CGRectMake(0, 10, 60, 60);
            }
        }
        // Video managing options
        else if(currentMode == MANAGE){
            
            if((VIDEOMP4URL != "" && NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH)) ||
               (VIDEOCOMPRESSEDMP4URL != "" && NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH))){
                
                println("MP4FILEPATH: \(MP4FILEPATH)");
                    accessoryImageView.image = UIImage(named: "delete_icon-web.png");
            }
            else if(netStatus.value != NOTREACHABLE &&
                (VIDEOMP4URL != "" || VIDEOCOMPRESSEDMP4URL != "")){
                    
                    accessoryImageView.image = UIImage(named: "download_icon-web.png");
            }
            else{
                // There is no downloaded video or network connection, so show nothing
                cell.textLabel?.textColor = UIColor.grayColor();
            }
        }
        // Video watching options
        else if(currentMode == WATCH){
            
            if(netStatus.value != NOTREACHABLE ||
                (NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH) && VIDEOMP4URL != "") ||
                (NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH) && VIDEOCOMPRESSEDMP4URL != "")){
        
                    cell.textLabel?.textColor = UIColor.blackColor();
                    accessoryImageView.image = UIImage(named: "play_icon.png");
            }
            else{
                // There is no network connection, so show nothing
                cell.textLabel?.textColor = UIColor.grayColor();
            }
        }
        // Video can't be accessed
        else{
            cell.textLabel?.textColor = UIColor.grayColor();
        }
        
        cell.accessoryView = accessoryImageView;
        return cell;
    }
    
    // didSelectRowAtIndexPath
    // Cell has been selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        var videoDict: Dictionary = iosProjectData[indexPath.section]["videos"]?[indexPath.row] as! [String: String];
        selectedIndexPath = indexPath;
        let VIDEOTITLE: String = videoDict["title"]!;
        let VIDEOMP4URL: String = videoDict["MP4"]!;
        let VIDEOCOMPRESSEDMP4URL: String = videoDict["compressedMP4"]!;
        let MP4FILEPATH: String = CACHESDIRECTORYPATH.stringByAppendingPathComponent("MP4/\(VIDEOMP4URL.lastPathComponent)");
        let COMPRESSEDMP4FILEPATH: String = CACHESDIRECTORYPATH.stringByAppendingPathComponent("compressedMP4/\(VIDEOCOMPRESSEDMP4URL.lastPathComponent)");
        
        // Video is being downloaded
        if(videoTitleForDownloadStatusDictionary[VIDEOTITLE] != "none"){
            
            cancel_Download_Alert(VIDEOTITLE);
            selectedResearchProjectIndex = -1;
        }
        else if(currentMode == MANAGE){
            
            if(VIDEOMP4URL != "" && NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH)){
                delete_Video_Alert(MP4FILEPATH);
            }
            else if(VIDEOCOMPRESSEDMP4URL != "" && NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH)){
                delete_Video_Alert(COMPRESSEDMP4FILEPATH);
            }
            else if(netStatus.value != NOTREACHABLE &&
                VIDEOMP4URL != ""){
                HD_or_Compressed_Alert();
            }
            selectedResearchProjectIndex = indexPath.section;
        }
        else if(currentMode == WATCH){
            if(NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH) && VIDEOMP4URL != ""){
                playDownloadedVideo(MP4FILEPATH);
            }
            else if(NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH) && VIDEOCOMPRESSEDMP4URL != ""){
                playDownloadedVideo(COMPRESSEDMP4FILEPATH);
            }
            else if(netStatus.value != NOTREACHABLE){
                self.selectedVideoUrl = videoDict["utubeurl"]!;
                self.performSegueWithIdentifier("YoutubeStreaming", sender: self);
            }
        }
    }
    
    // Cell Selection and Alert Functions
    //  cancel_Download_Alert(videoTitleString: String)
    //  HD_or_Compressed_Alert()
    //  downloadVideo()
    //  delete_Video_Alert(videoFilePath: String)
    //  deleteVideo(videoFilePath: String)
    //  playDownloadedVideo(videoFilePath: String)
    //
    //
    
    // cancel_Download_Alert
    // Alert that asks the user if they are sure they want to cancel their in-progress download
    func cancel_Download_Alert(videoTitleString: String){
        var alert = UIAlertController(title: "Download in Progress",
            message: "Cancel the download?",
            preferredStyle: UIAlertControllerStyle.Alert);
        
        alert.addAction(UIAlertAction(title: "Cancel Download", style: UIAlertActionStyle.Default, handler:
            {(action: UIAlertAction!) in
                println("cancel_the_download alert");
                let IDENTIFIER: String = "com.scientistsfrontier.\(videoTitleString)";
                NSNotificationCenter.defaultCenter().postNotificationName(IDENTIFIER, object: nil);
        }));
        alert.addAction(UIAlertAction(title: "Continue Download", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    // HD_or_Compressed_Alert
    // Alert that asks the user to choose between downloading the HD or compressed version of the video
    func HD_or_Compressed_Alert(){
        var videoDict: Dictionary = iosProjectData[self.selectedIndexPath.section]["videos"]?[self.selectedIndexPath.row] as! [String: String];
        var alert = UIAlertController(title: "Choose video quality",
            message: "",
            preferredStyle: UIAlertControllerStyle.Alert);
    
        alert.addAction(UIAlertAction(title: "MP4", style: UIAlertActionStyle.Default, handler:
            {(action: UIAlertAction!) in
                self.selectedVideoQuality = "MP4";
                self.selectedVideoUrl = videoDict["MP4"]!;
                self.downloadVideo();
        }));
        alert.addAction(UIAlertAction(title: "compressedMP4", style: UIAlertActionStyle.Default, handler:
            {(action: UIAlertAction!) in
                self.selectedVideoQuality = "compressedMP4";
                self.selectedVideoUrl = videoDict["compressedMP4"]!;
                self.downloadVideo();
        }));
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    // downloadVideo
    // Downloads the chosen video at the chosen video quality
    func downloadVideo(){
        
        var videoDict: Dictionary = iosProjectData[self.selectedIndexPath.section]["videos"]?[self.selectedIndexPath.row] as! [String: String];
        var videoDownloadHelperHandle: videoDownloadHelper = videoDownloadHelper.alloc();
        videoDownloadHelperHandle.videoQualityFolder = selectedVideoQuality;
        videoDownloadHelperHandle.videoTitleString = videoDict["title"]!;
        videoDownloadHelperHandle.videoUrlString = videoDict[selectedVideoQuality]!;
        videoDownloadHelperHandle.executeBackgroundDownloadForURL();
        self.tableView.reloadData();
    }
    
    // delete_Video_Alert
    // Alert that asks the user if they are sure they want to delete their downloaded video
    func delete_Video_Alert(videoFilePath: String){
        var alert = UIAlertController(title: "About to delete video",
            message: "Are you sure?",
            preferredStyle: UIAlertControllerStyle.Alert);
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:
            {(action: UIAlertAction!) in
                self.deleteVideo(videoFilePath);
        }));
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    // deleteVideo
    // Deletes the selected downloaded video
    func deleteVideo(videoFilePath: String){
        NSFileManager.defaultManager().removeItemAtPath(videoFilePath, error: nil);
        self.tableView.reloadData();
    }
    
    // playDownloadedVideo
    // Plays a downloaded video
    func playDownloadedVideo(videoFilePath: String){
        self.selectedVideoPath = videoFilePath;
        self.performSegueWithIdentifier("playDownloadedVideo", sender: self);
    }
    
    // Utility and Button Functions
    //  reloadVideosTableView(notification: NSNotification)
    //  openManageDownloadsView(sender: AnyObject)
    //
    //

    // Reload the table's data
    @objc func reloadVideosTableView(notification: NSNotification){
        self.tableView.reloadData();
    }
    
    // setAllVideoDownloadsToNone
    // Inits the state of the video downloads, because empty entries cause an error
    func setAllVideoDownloadsToNone(){
        var sectionCount: Int = iosProjectData.count;
        for sectionIndex in 0...sectionCount-1{
            var sectionVideoCount: Int? = iosProjectData[sectionIndex]["videos"]?.count;
            if(sectionVideoCount > 0){
                for rowIndex in 0...sectionVideoCount!-1{
                    var videoDict: Dictionary = iosProjectData[sectionIndex]["videos"]?[rowIndex] as! [String: String];
                    var videoTitle: String = videoDict["title"]!;
                    videoTitleForDownloadStatusDictionary[videoTitle] = "none";
                }
            }
        }
    }
    
    // openManageDownloadsView
    // The user pressed the upper-right-hand button
    @IBAction func openManageDownloadsView(sender: AnyObject){
        var sectionCount: Int? = iosProjectData.count;
        if(currentMode == WATCH){
            // Open all sections
            for sectionIndex in 0...sectionCount!-1{
                openSectionArray[sectionIndex] = "open";
            }
            
            // Switch to downloads view
            currentMode = MANAGE;
            sender.setTitle("Done", forState: UIControlState.Normal);
        }
        else{ // (currentMode == MANAGE)
            
            // Switch to downloads view
            currentMode = WATCH;
            sender.setTitle("Manage Downloads", forState: UIControlState.Normal);
        }
        sender.setAttributedTitle(nil, forState: UIControlState.Normal)
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        self.tableView.reloadData();
    }
    
    // Segue Functions
    //  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    //      playDownloadedVideo, goes to the video player
    //      YoutubeStreaming, goes to the YTPlayer
    //
    //
    
    // prepareForSegue
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if(segue.identifier == "playDownloadedVideo"){
            let downloadedVideoPlayerView = segue.destinationViewController as? MySwiftDownloadedVideoPlayer;
            println("selectedVideoPath: \(selectedVideoPath)");
            downloadedVideoPlayerView?.videoFullPathString = self.selectedVideoPath;
        }
        else if(segue.identifier == "YoutubeStreaming"){
            let youTubePlayerView = segue.destinationViewController as? YouTubeStreaming;
            youTubePlayerView?.uTubeUrl = self.selectedVideoUrl;
        }
    }
}