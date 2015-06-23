//
//  AboutImageViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 6/22/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import Foundation


class AboutImageViewController: UIViewController{
    

    @IBOutlet weak var bigImage: UIImageView!
    
    override func viewDidLoad() {
        println(aboutCurrentImage)
        bigImage.image = storedImages[aboutCurrentImage]

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}