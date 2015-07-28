//
//  ViewController.swift
//  Is_It_Prime
//
//  Created by alandrews3 on 6/4/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userEntryTextField: UITextField!
    @IBOutlet weak var isPrimeOutputResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressedButton(sender: AnyObject) {
        
        var number = userEntryTextField.text.toInt();
        var numberIsPrime_bool = true;
        
        if(number == nil || number == 1){
            
            numberIsPrime_bool = false;
        }
        else if(number == 2){
         
            numberIsPrime_bool = true;
        }
        else{
            
            var numberAsDouble = Double(number!);
            var sqrtOfNumber = sqrt(numberAsDouble);
            for var ii = 2.0; ii < sqrtOfNumber; ++ii{
                
                if(numberAsDouble % ii == 0){
                    
                    numberIsPrime_bool = false;
                }
            }
        }
        
        if(number == 0){
            
            isPrimeOutputResultLabel.text = "Nobody knows...";
        }
        else if(numberIsPrime_bool){
            
            isPrimeOutputResultLabel.text = "\(number!) is prime!";
        }
        else if(!numberIsPrime_bool && number != nil){
            
            isPrimeOutputResultLabel.text = "\(number!) is not prime!";
        }
        else{
            isPrimeOutputResultLabel.text = "Enter a number!";
        }
    }
}

