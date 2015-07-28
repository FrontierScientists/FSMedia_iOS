//
//  ViewController.swift
//  Learning_Swift
//
//  Created by alandrews3 on 6/3/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var blah: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func catAgeButton(sender: AnyObject) {
        var catAgeInt = blah.text.toInt();
        if(catAgeInt != nil){
            var catAgeIntResult = catAgeInt!*7;
            labelOutlet.text = "Your cat's cat age is \(catAgeIntResult)";
        }
        else{
            labelOutlet.text = "Enter a value first!";
        }
    }


    
}

