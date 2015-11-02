//  YouTubeStreamingViewController.swift

import Foundation
import UIKit

/*
    This is the YouTubeStreamingViewController class. It simply loads the specified URL to the YouTubeStreamingView.
*/
class YouTubeStreamingViewController: UIViewController {
    
/*
    Outlets
*/
    @IBOutlet weak var YouTubeStreamingView: YTPlayerView!
/*
    Class Variables
*/
    var uTubeUrl: String = String()
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        YouTubeStreamingView.loadWithVideoId(getUTubeUrlId(uTubeUrl))
    }
    
/*
    Helper and Content Functions
*/
    // getUTubeUrlId
    // This function takes the full URL and parses out and returns the YouTube Id.
    func getUTubeUrlId(fullUTubeUrl: String) -> String {
        let nsURL = NSURL(string: fullUTubeUrl)
        var urlArray: Array = nsURL!.pathComponents!
        let arraySize: Int = urlArray.count
        return urlArray[arraySize-1].stringByReplacingOccurrencesOfString("watch?v=", withString: "")
    }
}
