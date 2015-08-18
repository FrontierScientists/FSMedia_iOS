// AboutViewController.swift

import Foundation
import UIKit

/*
    This is the AboutViewController, a simple class responsable for displaying the About page in a WebView.
*/
class AboutViewController: UIViewController {
    
/*
    Outlets
*/
    @IBOutlet weak var webView: UIWebView!
/*
    Class Constants
*/
    let link = "http://fsci15.alpinewp.com/about/"
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        let url = NSURL(string: link)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.scalesPageToFit = true
        super.viewDidLoad()
    }
}