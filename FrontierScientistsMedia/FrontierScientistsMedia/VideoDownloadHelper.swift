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
    var myUrlSession: NSURLSession = NSURLSession();
    var session: NSURLSession = NSURLSession();
    
    
    // NSURLSession Functions
    //  executeBackgroundDownloadForURL()
    //  didResumeAtOffset fileOffset: Int64
    //  didWriteData bytesWritten: Int64
    //  didFinishDownloadingToURL location: NSURL
    //  didCompleteWithError error: NSError?
    //
    //
    
    // executeBackgroundDownloadForURL
    //
    func executeBackgroundDownloadForURL(){
        
        let IDENTIFIER: String = "com.scientistsfrontier.\(self.videoTitleString)";
        let sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(IDENTIFIER);
        self.session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil);

        print("self.videoQualityFolder: \(self.videoQualityFolder)");
        print("self.videoUrlString: \(self.videoUrlString)");
        
        let downloadTask: NSURLSessionTask = self.session.downloadTaskWithURL(NSURL(string: self.videoUrlString, relativeToURL: nil)!);
        
        print("downloadTask.taskIdentifier: \(downloadTask.taskIdentifier)");
        videoTitleStatuses[self.videoTitleString] = "\(downloadTask.taskIdentifier)";
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cancelDownloadNotification:",name:IDENTIFIER, object: nil);
        downloadTask.resume();
    }
    
    // didResumeAtOffset
    // Begins/Resumes the download
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        print("Got into didResumeAtOffset");
        print("downloadTask.taskIdentifier: \(downloadTask.taskIdentifier)");
    }
    
    // didWriteData
    // Called after downloading a chunk of the data
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        print("Got into didWriteData");
        videoTitleStatuses[self.videoTitleString] = "\(downloadTask.taskIdentifier)";
    }
    
    // didFinishDownloadingToURL
    // Called when finished downloading to a temporary url in memory
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){

        let LIBPATHSTRING: String = "Library/Caches/\(self.videoQualityFolder)/\(lastComponentOfUrlString(self.videoUrlString))";
        let VIDFILEPATHSTRING: String = NSHomeDirectory() + LIBPATHSTRING
        let urlPath: NSURL = NSURL(fileURLWithPath: VIDFILEPATHSTRING);
        print("\(urlPath.absoluteString)");
        var error: NSError?;
        var noErrorBool: Bool
        do {
            try NSFileManager.defaultManager().moveItemAtURL(location, toURL: urlPath)
            noErrorBool = true
        } catch let error1 as NSError {
            error = error1
            noErrorBool = false
        };
        if(noErrorBool){
            print("Write using NSURLSession is successful.");
        }
        else{
            print("Write using NSURLSession was NOT successful: \(error!.localizedDescription)");
            if(NSFileManager.defaultManager().fileExistsAtPath(location.absoluteString) == false){
                print("\(location) doesn't exist.");
            }
            if(NSFileManager.defaultManager().fileExistsAtPath(urlPath.absoluteString) == false){
                print("\(urlPath) doesn't exist.");
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            
            print("downloadTask.taskIdentifier: \(downloadTask.taskIdentifier)");
            
            self.session.invalidateAndCancel();
            NSNotificationCenter.defaultCenter().removeObserver(self);
            NSNotificationCenter.defaultCenter().postNotificationName("reloadVideosTableView", object: nil);
            videoTitleStatuses[self.videoTitleString] = "none";
        })
    }
    
    // didCompleteWithError
    // Called when an error stops the download
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?){
        
        if(error != nil){
            
            print("Download completed with error: \(error?.localizedDescription)");
        }
        else{
            
            print("Download finished successfully");
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self);
        dispatch_async(dispatch_get_main_queue(),{
            
                NSNotificationCenter.defaultCenter().postNotificationName("reloadVideosTableView", object: nil);
                videoTitleStatuses[self.videoTitleString] = "none";
        })
    }
    
    // Notification Functions
    //  cancelDownloadNotification(notification: NSNotification)
    //
    //
    
    // cancelDownloadNotification
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