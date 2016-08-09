//  DownloadedVideoPlayerController.swift

import Foundation
import MediaPlayer
import MobileCoreServices

/*
    This is the DownlopadVideoPlayerController class, obviously responsable for playing downloaded videos in a video
    player.
*/
class DownloadedVideoPlayerController: UIViewController {
    
/*
    Outlets
*/
    @IBOutlet var videoPlayerView: UIView!
/*
    Class Variables
*/
    var downloadedMoviePlayer: MPMoviePlayerController = MPMoviePlayerController()
    var videoFullPathString: String = String()
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Quick initial setup
        self.navigationController?.navigationBar.translucent = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DownloadedVideoPlayerController.resetVideoFrameToMatchNewOrientation), name: UIDeviceOrientationDidChangeNotification, object: nil)
        // Play video
        playDownloadedVideo()
    }
    
/*
    Helper and Content Functions
*/
    // playDownloadedVideo
    // Sets up and plays the downloaded video
    func playDownloadedVideo() {
        let URL  = NSURL.fileURLWithPath(videoFullPathString)
        self.downloadedMoviePlayer = MPMoviePlayerController(contentURL: URL)
        self.downloadedMoviePlayer.view.frame = self.view.bounds
        self.downloadedMoviePlayer.scalingMode = MPMovieScalingMode.Fill
        self.downloadedMoviePlayer.movieSourceType = MPMovieSourceType.File
        videoPlayerView.addSubview(self.downloadedMoviePlayer.view)
        self.downloadedMoviePlayer.play()
    }
    // resetVideoFrameToMatchNewOrientation
    // Resets the view of the player in case of an orientation change
    func resetVideoFrameToMatchNewOrientation() {
        self.downloadedMoviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.downloadedMoviePlayer.scalingMode = MPMovieScalingMode.Fill
    }
}
