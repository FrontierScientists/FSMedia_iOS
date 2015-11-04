//  VideoDownloadHelper.swift

import Foundation

/*
    This is the VideoDownloadHelper class, containing helper NSURLSession and Notification functions used during the
    video download process.
*/
class VideoDownloadHelper: NSURLSession, NSURLSessionDownloadDelegate {
    
/*
    Class Variables
*/
    var videoUrlString: String = String()
    var videoQualityFolder: String = String()
    var videoTitleString: String = String()
    var myUrlSession: NSURLSession = NSURLSession()
    var session: NSURLSession = NSURLSession()
    
/*
    NSURLSession Functions
*/
    // executeBackgroundDownloadForURL
    func executeBackgroundDownloadForURL() {
        let IDENTIFIER: String = "com.scientistsfrontier.\(self.videoTitleString)"
        let sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(IDENTIFIER)
        self.session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        let downloadTask: NSURLSessionTask = self.session.downloadTaskWithURL(NSURL(string: self.videoUrlString, relativeToURL: nil)!)
        videoTitleStatuses[self.videoTitleString] = "\(downloadTask.taskIdentifier)"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cancelDownloadNotification:",name:IDENTIFIER, object: nil)
        downloadTask.resume()
    }
    // didWriteData
    // Called after downloading a chunk of the data
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        videoTitleStatuses[self.videoTitleString] = "\(downloadTask.taskIdentifier)"
    }
    // didFinishDownloadingToURL
    // Called when finished downloading to a temporary url in memory
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let LIBPATHSTRING: String = "/Library/Caches/\(self.videoQualityFolder)/\(lastComponentOfUrlString(self.videoUrlString))"
        let VIDFILEPATHSTRING: String = NSHomeDirectory() + LIBPATHSTRING
        let urlPath: NSURL = NSURL(fileURLWithPath: VIDFILEPATHSTRING)
        
        // Handle error
        var error: NSError?
        var noErrorBool: Bool
        do {
            try NSFileManager.defaultManager().moveItemAtURL(location, toURL: urlPath)
            noErrorBool = true
        } catch let error1 as NSError {
            error = error1
            noErrorBool = false
        }
        
        if (noErrorBool) {
            print("Write using NSURLSession is successful.");
        } else {
            print("Write using NSURLSession was NOT successful: \(error!.localizedDescription)")
            if (NSFileManager.defaultManager().fileExistsAtPath(location.absoluteString) == false) {
                print("\(location) doesn't exist.")
            }
            if (NSFileManager.defaultManager().fileExistsAtPath(urlPath.absoluteString) == false) {
                print("\(urlPath) doesn't exist.")
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.session.invalidateAndCancel()
            NSNotificationCenter.defaultCenter().removeObserver(self)
            NSNotificationCenter.defaultCenter().postNotificationName("reloadVideosTableView", object: nil)
            videoTitleStatuses[self.videoTitleString] = "none"
        })
    }
    // didCompleteWithError
    // Called when an error stops the download
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if (error != nil) {
            print("Download completed with error: \(error?.localizedDescription)")
        } else {
            print("Download finished successfully")
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().postNotificationName("reloadVideosTableView", object: nil)
                videoTitleStatuses[self.videoTitleString] = "none"
        })
    }
    
/*
    Notification Functions
*/
    // cancelDownloadNotification
    // Receives the notification from the video table to cancel an in-progress download
    @objc func cancelDownloadNotification(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue(),{
            if (self.session.configuration.identifier == notification.name) {
                self.session.invalidateAndCancel()
                NSNotificationCenter.defaultCenter().postNotificationName("reloadVideosTableView", object: nil)
            }
        })
    }
}