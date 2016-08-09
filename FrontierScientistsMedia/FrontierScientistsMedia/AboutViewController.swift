import Foundation
import UIKit

// ###############################################################
// This is the AboutViewController, a simple class responsable for displaying the About page in a WebView.
// ###############################################################
class AboutViewController: UIViewController {
// ###############################################################
// Outlets
// ###############################################################
    @IBOutlet weak var webView: UIWebView!
// ###############################################################
// Variables
// ###############################################################
    let link = "http://frontierscientists.com/about/"
// ###############################################################
// UIViewController Functions
// ###############################################################
    // viewDidLoad
    override func viewDidLoad() {
        let url = NSURL(string: link)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.scalesPageToFit = true
        super.viewDidLoad()
    }
}