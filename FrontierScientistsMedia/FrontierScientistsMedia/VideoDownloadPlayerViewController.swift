//
//  VideoDownloadPlayerViewController.swift
//  FSDemo
//
//  Created by alandrews3 on 5/22/15.
//  Copyright (c) 2015 Andrew Clark. All rights reserved.
//

import Foundation
import MediaPlayer
import MobileCoreServices

class MySwiftDownloadedVideoPlayer: UIViewController
{
    @IBOutlet var videoPlayerView: UIView!;
    var downloadedMoviePlayer: MPMoviePlayerController = MPMoviePlayerController.alloc();
    var videoFullPathString: String = String();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetVideoFrameToMatchNewOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil);

        playDownloadedVideo();
    }
    
    // Sets up and plays the downloaded video
    func playDownloadedVideo()
    {
        let URL  = NSURL.fileURLWithPath(videoFullPathString);
        
        self.downloadedMoviePlayer = MPMoviePlayerController(contentURL: URL);
        self.downloadedMoviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.downloadedMoviePlayer.movieSourceType = MPMovieSourceType.File;
        videoPlayerView.addSubview(self.downloadedMoviePlayer.view);
        self.downloadedMoviePlayer.play();
    }

    // Resets the view of the player in case of an orientation change
    func resetVideoFrameToMatchNewOrientation()
    {
        self.downloadedMoviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}
