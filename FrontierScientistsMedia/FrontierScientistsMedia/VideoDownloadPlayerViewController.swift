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

class MySwiftDownloadedVideoPlayer: UIViewController{
    @IBOutlet var videoPlayerView: UIView!
    var downloadedMoviePlayer: MPMoviePlayerController = MPMoviePlayerController()
    var videoFullPathString: String = String();
    
    override func viewDidLoad(){
        super.viewDidLoad();
        self.navigationController?.navigationBar.translucent = false;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetVideoFrameToMatchNewOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil);
        playDownloadedVideo();
    }
    
    // playDownloadedVideo
    // Sets up and plays the downloaded video
    func playDownloadedVideo(){
        let URL  = NSURL.fileURLWithPath(videoFullPathString);
        self.downloadedMoviePlayer = MPMoviePlayerController(contentURL: URL);
        self.downloadedMoviePlayer.view.frame = self.view.bounds;//CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.downloadedMoviePlayer.scalingMode = MPMovieScalingMode.Fill;
        self.downloadedMoviePlayer.movieSourceType = MPMovieSourceType.File;
        videoPlayerView.addSubview(self.downloadedMoviePlayer.view);
        self.downloadedMoviePlayer.play();
    }

    // resetVideoFrameToMatchNewOrientation
    // Resets the view of the player in case of an orientation change
    func resetVideoFrameToMatchNewOrientation(){
        self.downloadedMoviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.downloadedMoviePlayer.scalingMode = MPMovieScalingMode.Fill;
    }
}
