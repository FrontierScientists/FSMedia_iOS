//
//  VideoDownloadHelper.swift
//  FSDemo
//
//  Created by alandrews3 on 5/20/15.
//  Copyright (c) 2015 Andrew Clark. All rights reserved.
//

import Foundation

class videoDownloadHelper: NSURLSession, NSURLSessionDownloadDelegate
{
    var videoUrlString: String = String();
    var videoQualityFolder: String = String();
    var videoTitleString: String = String();
    var myUrlSession: NSURLSession = NSURLSession.alloc();
    var session: NSURLSession = NSURLSession.alloc();
    
    
    // NSURLSession Functions
    //  executeBackgroundDownloadForURL()
    //  didResumeAtOffset fileOffset: Int64
    //  didWriteData bytesWritten: Int64
    //  didFinishDownloadingToURL location: NSURL
    //  didCompleteWithError error: NSError?
    //
    //
    
    func executeBackgroundDownloadForURL(){
        
        let IDENTIFIER: String = "com.scientistsfrontier.\(self.videoTitleString)";
        var sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(IDENTIFIER);
        self.session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil);

        println("self.videoQualityFolder: \(self.videoQualityFolder)");
        println("self.videoUrlString: \(self.videoUrlString)");
        var filePath: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/\(self.videoQualityFolder)/\(self.videoUrlString)");
        
        
        var downloadTask: NSURLSessionTask = self.session.downloadTaskWithURL(NSURL(string: self.videoUrlString, relativeToURL: nil)!);
        
        println("downloadTask.taskIdentifier: \(downloadTask.taskIdentifier)");
        videoTitleForDownloadStatusDictionary[self.videoTitleString] = "\(downloadTask.taskIdentifier)";
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cancelDownloadNotification:",name:IDENTIFIER, object: nil);
        downloadTask.resume();
    }
    
    // Begins/Resumes the download
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        println("Got into didResumeAtOffset");
        println("downloadTask.taskIdentifier: \(downloadTask.taskIdentifier)");
    }
    
    // Called after downloading a chunk of the data
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        println("Got into didWriteData");
        videoTitleForDownloadStatusDictionary[self.videoTitleString] = "\(downloadTask.taskIdentifier)";
    }
    
    // Called when finished downloading to a temporary url in memory
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){

        let LIBPATHSTRING: String = "Library/Caches/\(self.videoQualityFolder)/\(lastComponentOfUrlString(self.videoUrlString))";
        let VIDFILEPATHSTRING: String = NSHomeDirectory().stringByAppendingPathComponent(LIBPATHSTRING);
        var urlPath: NSURL = NSURL(fileURLWithPath: VIDFILEPATHSTRING)!;
        println("\(urlPath.absoluteString)");
        var error: NSError?;
        var noErrorBool: Bool = NSFileManager.defaultManager().moveItemAtURL(location, toURL: urlPath, error: &error);
        if(noErrorBool){
            println("Write using NSURLSession is successful.");
        }
        else{
            println("Write using NSURLSession was NOT successful: \(error!.localizedDescription)");
            if(NSFileManager.defaultManager().fileExistsAtPath(location.absoluteString!) == false){
                println("\(location) doesn't exist.");
            }
            if(NSFileManager.defaultManager().fileExistsAtPath(urlPath.absoluteString!) == false){
                println("\(urlPath) doesn't exist.");
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            
            println("downloadTask.taskIdentifier: \(downloadTask.taskIdentifier)");
            
            self.session.invalidateAndCancel();
            NSNotificationCenter.defaultCenter().removeObserver(self);
            NSNotificationCenter.defaultCenter().postNotificationName("reloadVideosTableView", object: nil);
            videoTitleForDownloadStatusDictionary[self.videoTitleString] = "none";
        })
    }
    
    // Called when an error stops the download
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?){
        
        if(error != nil){
            
            println("Download completed with error: \(error?.localizedDescription)");
        }
        else{
            
            println("Download finished successfully");
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self);
        dispatch_async(dispatch_get_main_queue(),{
            
                NSNotificationCenter.defaultCenter().postNotificationName("reloadVideosTableView", object: nil);
                videoTitleForDownloadStatusDictionary[self.videoTitleString] = "none";
        })
    }
    
    // Notification Functions
    //  cancelDownloadNotification(notification: NSNotification)
    //
    //
    
    // Receives the notification from the video table to cancel an in-progress download
    @objc func cancelDownloadNotification(notification: NSNotification){
        
        dispatch_async(dispatch_get_main_queue(),{
            if(self.session.configuration.identifier == notification.name){
                self.session.invalidateAndCancel();
                NSNotificationCenter.defaultCenter().postNotificationName("reloadVideosTableView", object: nil);
            }
        })
    }
}