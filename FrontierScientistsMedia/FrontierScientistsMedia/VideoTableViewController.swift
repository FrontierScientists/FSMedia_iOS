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

class MySwiftVideoTableViewController: UITableViewController
{
    @IBOutlet weak var changeVidoesModeButton: UIButton!
    @IBOutlet var videoTableView: UITableView!
    var openSectionArray: Array<String> = ["closed"];
    var selectedResearchProjectIndex: Int = 0;
    var scrollPath: NSIndexPath = NSIndexPath(forRow: NSNotFound, inSection: NSNotFound);
    var selectedIndexPath: NSIndexPath = NSIndexPath(forRow: NSNotFound, inSection: NSNotFound);
    var selectedVideoQuality: String = String();
    var selectedVideoPath: String = String();
    var selectedVideoUrl: String = String();
    var currentMode: String = "Watch_videos";
    let MANAGE: String = "Manage_downloads";
    let WATCH: String = "Watch_videos";
    
    override func viewDidLoad(){
        
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadVideosTableView:",name:"reloadVideosTableView", object: nil);
        
        super.viewDidLoad();
        self.view.backgroundColor = UIColor(patternImage:UIImage(named: "bg.png")!);
        self.navigationController?.navigationBar.setBackgroundImage((UIImage(named: "nav_bar_bg.png")), forBarMetrics: UIBarMetrics.Default);
        self.navigationController?.navigationBar.translucent = false;
        setAllVideoDownloadsToNone();
        
        createFolderNamed("MP4"); // Calls to function in HelperFunctions.swift
        createFolderNamed("compressedMP4");
        
        var sectionCount: Int = iosProjectData.count;
        for sectionIndex in 0...sectionCount-2{
            openSectionArray.append("closed");
        }
        
        if(selectedResearchProjectIndex != -1){
            self.scrollPath = NSIndexPath(forRow: NSNotFound, inSection: selectedResearchProjectIndex);
            self.tableView.scrollToRowAtIndexPath(self.scrollPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true);
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
    
    // Table Section Functions
    //  numberOfSectionsInTableView:(UITableView *)tableView
    //  heightForHeaderInSection section: Int)
    //  viewForHeaderInSection section: Int)
    //  heightForFooterInSection section: Int)
    //  viewForFooterInSection section: Int)
    //
    //
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return iosProjectData.count;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        var sectionVideoCount: Int? = iosProjectData[section]["videos"]?.count;
        if(sectionVideoCount == 0){
            return 1;
        }
        else{
            return 110.0
        }
    }
    
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
        headerBackgroundImageView.backgroundColor = UIColor.yellowColor();
        
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
        headerResearchImageView.image = UIImage(contentsOfFile: NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/Images/".stringByAppendingPathComponent(getImageOrVideoName(researchImageUrl))));
        

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
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 1;
    }
    
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
    //  dropDownListToggle(pressedButton: UIButton!)
    //  numberOfRowsInSection section: Int)
    //  cellForRowAtIndexPath indexPath: NSIndexPath)
    //  didSelectRowAtIndexPath indexPath: NSIndexPath)
    //
    //
    
    // Button command to change the currentMode
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
    
    // Get the view for the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell");
        var videoDict: Dictionary = iosProjectData[indexPath.section]["videos"]?[indexPath.row] as! [String: String];
        
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
            cell.accessoryView?.frame = CGRectMake(0, 0, 68, 68);
        }
        else{ // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34);
        }
        
        let VIDEOMP4URL: String = videoDict["MP4"]!;
        let VIDEOCOMPRESSEDMP4URL: String = videoDict["compressedMP4"]!;
        
        if(videoTitleForDownloadStatusDictionary[VIDEOTITLE] != "none"){
            var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40));
            activityIndicatorView.color = UIColor.blackColor();
            activityIndicatorView.startAnimating();
            cell.accessoryView = activityIndicatorView;
        }
        else if(currentMode == MANAGE && (VIDEOMP4URL != "" || VIDEOCOMPRESSEDMP4URL != "")){
            let MP4FILEPATH: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/MP4/\(getImageOrVideoName(VIDEOMP4URL))");
            let COMPRESSEDMP4FILEPATH: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/compressedMP4/\(getImageOrVideoName(VIDEOCOMPRESSEDMP4URL))");
            
            var accessoryImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40));
            
            if(NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH) ||
               NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH)){
                accessoryImageView.image = UIImage(named: "delete_icon-web.png");
            }
            else{
                accessoryImageView.image = UIImage(named: "download_icon-web.png");
            }
            cell.accessoryView = accessoryImageView;
        }
        else if(currentMode == WATCH){
            
            cell.textLabel?.textColor = UIColor.blackColor();
        }
        else{
            // Current mode is MANAGE, and this cell has no download available
            cell.textLabel?.textColor = UIColor.grayColor();
        }
        return cell;
    }
    
    // Cell has been selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        var videoDict: Dictionary = iosProjectData[indexPath.section]["videos"]?[indexPath.row] as! [String: String];
        selectedIndexPath = indexPath;
        let VIDEOTITLE: String = videoDict["title"]!;
        let VIDEOMP4URL: String = videoDict["MP4"]!;
        let VIDEOCOMPRESSEDMP4URL: String = videoDict["compressedMP4"]!;
        let MP4FILEPATH: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/MP4/\(getImageOrVideoName(VIDEOMP4URL))");
        let COMPRESSEDMP4FILEPATH: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/compressedMP4/\(getImageOrVideoName(VIDEOCOMPRESSEDMP4URL))");
        
        if(currentMode == MANAGE && videoTitleForDownloadStatusDictionary[VIDEOTITLE] != "none"){
            cancel_Download_Alert(VIDEOTITLE);
            selectedResearchProjectIndex = -1;
        }
        else if(currentMode == MANAGE && MP4FILEPATH.lastPathComponent != "MP4"){
            if(NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH)){
                println("path: \(MP4FILEPATH)");
                delete_Video_Alert(MP4FILEPATH);
            }
            else if(NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH)){
                println("path: \(COMPRESSEDMP4FILEPATH)");
                delete_Video_Alert(COMPRESSEDMP4FILEPATH);
            }
            else{ // No video is currently downloaded
                HD_or_Compressed_Alert();
            }
            selectedResearchProjectIndex = indexPath.section;
        }
        else if(currentMode == WATCH){
            if(NSFileManager.defaultManager().fileExistsAtPath(MP4FILEPATH) && MP4FILEPATH.lastPathComponent != "MP4"){
                playDownloadedVideo(MP4FILEPATH);
            }
            else if(NSFileManager.defaultManager().fileExistsAtPath(COMPRESSEDMP4FILEPATH) && COMPRESSEDMP4FILEPATH.lastPathComponent != "compressedMP4"){
                playDownloadedVideo(COMPRESSEDMP4FILEPATH);
            }
            else{ // stream video
                // stream video
                self.selectedVideoUrl = videoDict["utubeurl"]!;
                self.performSegueWithIdentifier("YoutubeStreaming", sender: self);
            }
        }
        else{
            // Mode is MANAGE, and the video isn't downloadable. Do nothing
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
    
    // Deletes the selected downloaded video
    func deleteVideo(videoFilePath: String){
        NSFileManager.defaultManager().removeItemAtPath(videoFilePath, error: nil);
        self.tableView.reloadData();
    }
    
    // Plays a downloaded video
    func playDownloadedVideo(videoFilePath: String){
        self.selectedVideoPath = videoFilePath;
        self.performSegueWithIdentifier("playDownloadedVideo", sender: self);
    }
    
    // Utility and Button Functions
    //  getImageOrVideoName:(NSString *)url
    //  reloadVideosTableView(notification: NSNotification)
    //  openManageDownloadsView(sender: AnyObject)
    //
    //
    
    // Returns the last component of a url
    func getImageOrVideoName(url: String) -> String{
        if(url != ""){
            let compArray: Array = url.pathComponents;
            let compArraySize = compArray.count;
            if(compArraySize > 1){
                return compArray[compArraySize - 1];
            }
        }
        return "";
    }

    // Reload the table's data
    @objc func reloadVideosTableView(notification: NSNotification){
        self.tableView.reloadData();
    }
    
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
            // Close all sections
            for sectionIndex in 0...sectionCount!-1{
                openSectionArray[sectionIndex] = "closed";
            }
            
            // Switch to downloads view
            currentMode = WATCH;
            sender.setTitle("Manage Downloads", forState: UIControlState.Normal);
        }
        sender.setAttributedTitle(nil, forState: UIControlState.Normal)
        sender.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        self.tableView.reloadData();
    }
    
    // Segue Functions
    //  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    //      playDownloadedVideo, goes to the video player
    //      YoutubeStreaming, goes to the YTPlayer
    //
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