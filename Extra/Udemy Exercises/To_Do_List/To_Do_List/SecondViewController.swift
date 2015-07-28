//
//  SecondViewController.swift
//  To_Do_List
//
//  Created by alandrews3 on 6/5/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var userEntryField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEntryField.delegate = self;
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func createItemButtonPressed(sender: AnyObject) {
        
        if(userEntryField.text != ""){
            toDoListTitles.append(userEntryField.text);
            userEntryField.text = "";
            saveListData();
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        userEntryField.resignFirstResponder();
        return true;
    }
    
    func saveListData(){
        
        var savingDict: NSMutableDictionary = ["toDoListTitles": toDoListTitles];
        savingDict.writeToFile(PATH, atomically: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

