//
//  ViewController.swift
//  Control_Keyboard
//
//  Created by alandrews3 on 6/5/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var useerEntryField: UITextField!
 
    @IBOutlet weak var labelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.useerEntryField.delegate = self;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        labelOutlet.text = useerEntryField.text;
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder();
        
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

