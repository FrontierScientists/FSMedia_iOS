//
//  ViewController.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/15/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    var sections = ["Research", "Videos", "Maps", "Articles", "Ask a Scientist", "About"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "section")
        cell.textLabel?.text = sections[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

