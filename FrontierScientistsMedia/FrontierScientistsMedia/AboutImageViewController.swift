//
//  AboutImageViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 6/22/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import Foundation


class AboutImageViewController: UIViewController, UIScrollViewDelegate{


    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(aboutCurrentImage)
        imageView = UIImageView(image: storedImages[aboutCurrentImage])
        
        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.backgroundColor = UIColor.blueColor()
        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = 2.0
    }
    override func viewDidAppear(animated: Bool) {
        scrollView.scrollEnabled = true
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}