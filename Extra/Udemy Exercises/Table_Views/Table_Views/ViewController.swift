//
//  ViewController.swift
//  Table_Views
//
//  Created by alandrews3 on 6/5/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    
    var cellContent = ["Rob", "Kirsten", "Tom", "Ralph"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return cellContent.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let CELL = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell");
        
        CELL.textLabel?.text = cellContent[indexPath.row];
        
        return CELL;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

