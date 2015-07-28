//
//  FirstViewController.swift
//  To_Do_List
//
//  Created by alandrews3 on 6/5/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

var toDoListTitles = ["Item0", "Item1", "Item2", "Item3"];
let PATH: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/toDoList.txt");

class FirstViewController: UIViewController, UITableViewDelegate, NSFileManagerDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if(NSFileManager.defaultManager().fileExistsAtPath(PATH)){
            
            loadListData();
        }
        else{
            
            var d: Dictionary = ["toDoListTitles": toDoListTitles];
            NSFileManager.defaultManager().createFileAtPath(PATH, contents: nil, attributes: d);
        }
        println(PATH);
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return toDoListTitles.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let CELL = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        CELL.textLabel?.text = toDoListTitles[indexPath.row];
        
        return CELL;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
            toDoListTitles.removeAtIndex(indexPath.row);
            saveListData();
            self.myTableView.reloadData();
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.myTableView.reloadData();
    }
    
    func saveListData(){
        
        var savingDict: NSMutableDictionary = ["toDoListTitles": toDoListTitles];
        savingDict.writeToFile(PATH, atomically: true);
    }
    
    func loadListData(){
        
        var loadingDict: NSMutableDictionary = NSMutableDictionary(contentsOfFile: PATH)!;
        toDoListTitles = loadingDict.objectForKey("toDoListTitles") as! Array;
        self.myTableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

