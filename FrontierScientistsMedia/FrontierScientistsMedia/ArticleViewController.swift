// ArticleViewController.swift

import Foundation
import UIKit

/*
    This is the ArticleViewController class, responsable for displaying a WebView of the selected article from 
    the TableView of ArticlesTableViewController.  In addition to the simple WebView, there is a toolbar 
    implemented at the bottom of the view, back and forward buttons for web navigation.
*/
class ArticleViewController: UIViewController {
    
/*
    Outlets
*/
    @IBOutlet var webView: UIWebView!
/*
    Actions
*/
    @IBAction func goBack(_: AnyObject){
        webView.goBack() // Navigate back in WebView
    }
    @IBAction func goForward(_: AnyObject){
        webView.goForward() // Navigate forward in WebView
    }
/*
    Class Variables
*/
    var articleLinkString: String?

/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        // The articleLinkString is set in ArticlesTableViewController before the segue to this controller.
        let url = NSURL(string: articleLinkString!)
        print(articleLinkString)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        webView.scalesPageToFit = true
        super.viewDidLoad()
    }
}