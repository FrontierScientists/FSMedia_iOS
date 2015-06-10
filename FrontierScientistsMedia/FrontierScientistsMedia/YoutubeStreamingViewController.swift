//
//  YoutubeStreamingViewController.swift
//  FSDemo
//
//  Created by alandrews3 on 5/26/15.
//  Copyright (c) 2015 Andrew Clark. All rights reserved.
//

import Foundation
import UIKit

class YouTubeStreaming: UIViewController{
    var uTubeUrl: String = String();
    @IBOutlet weak var YouTubeStreamingView: YTPlayerView!;
    
    override func viewDidLoad(){
        super.viewDidLoad();
        self.navigationController?.navigationBar.setBackgroundImage((UIImage(named: "nav_bar_bg.png")), forBarMetrics: UIBarMetrics.Default);
        
        println("uTubeUrl: \(uTubeUrl)");
        
        YouTubeStreamingView.loadWithVideoId(getUTubeUrlId(uTubeUrl));
    }
    
    func getUTubeUrlId(fullUTubeUrl: String) -> String{
        var urlArray: Array = fullUTubeUrl.pathComponents
        var arraySize: Int = urlArray.count;
        return urlArray[arraySize-1].stringByReplacingOccurrencesOfString("watch?v=", withString: "");
    }
}
