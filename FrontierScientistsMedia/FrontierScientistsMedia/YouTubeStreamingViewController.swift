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
        return fullUTubeUrl.stringByReplacingOccurrencesOfString("http://www.youtube.com/watch?v=", withString: "")
    }
}
