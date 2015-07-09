//
//  ArticlesViewController.swift
//  FSDemo
//
//  Created by alandrews3 on 5/13/15.
//  Copyright (c) 2015 Andrew Clark. All rights reserved.
//

import Foundation
import UIKit

class MySwiftArticlesViewController: UIViewController{
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