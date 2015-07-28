//
//  ViewController.swift
//  How_Many_Fingers
//
//  Created by alandrews3 on 6/3/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberEntryField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    var randomNumber: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomNumber = Int(arc4random_uniform(20)) + 1;
        println(randomNumber);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func guessButton(sender: AnyObject) {
        var userAnswer = numberEntryField.text?.toInt();
        println(userAnswer);
        if(userAnswer != nil && userAnswer == randomNumber){
            answerLabel.text = "Right!";
            randomNumber = Int(arc4random_uniform(20)) + 1;
        }
        else{
            answerLabel.text = "Wrong!";
        }
        numberEntryField.text = "";
    }
}

