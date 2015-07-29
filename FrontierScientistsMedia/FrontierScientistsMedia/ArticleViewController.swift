// ArticleViewController.swift

import Foundation
import UIKit

class ArticleViewController: UIViewController{
    @IBOutlet var webView: UIWebView!;
    var articleLinkString: String?;

    override func viewDidLoad(){
        
        var str: String = articleLinkString!;
        let url = NSURL(string: str);
        let request = NSURLRequest(URL: url!);
        webView.loadRequest(request);
        webView.scalesPageToFit = true;
        
        super.viewDidLoad();
    }
    
    // Button Functions
    //  goBack(AnyObject)
    //  goForward(AnyObject)
    //
    //
    
    // goBack
    //
    @IBAction func goBack(AnyObject){
        webView.goBack();
    }
    
    // goForward
    //
    @IBAction func goForward(AnyObject){
        webView.goForward();
    }
}