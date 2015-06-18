//
//  aboutViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 6/9/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var aboutTable: UITableView!
    @IBOutlet weak var aboutNavBar: UINavigationItem!
    
    let sections = ["opening","goal","snippets","people_intro"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "About Frontier Scientists"
        
//        for (var x=0; x<4; x++) {
        let snippet0_text:String = (aboutInfo["snippets"]![0] as! [String: String])["text"]!
        println(snippet0_text)
        let snippet1_text:String = (aboutInfo["snippets"]![1] as! [String: String])["text"]!
        println(snippet1_text)
        let snippet2_text:String = (aboutInfo["snippets"]![2] as! [String: String])["text"]!
        println(snippet2_text)
//        }
        
        aboutTable.estimatedRowHeight = 100.0
        aboutTable.rowHeight = UITableViewAutomaticDimension
    }//end viewDidLoad
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("goal") as! AboutTableViewCell
        cell.aboutLabel.text = aboutInfo[sections[indexPath.row]] as? String
        cell.aboutLabel.font = UIFont(name: "Chalkduster", size: 20)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


//Setting up a left bar button
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
//        aboutNavBar.leftBarButtonItem = UIBarButtonItem()
//        aboutNavBar.leftBarButtonItem!.title = "< MainMenu"
//        aboutNavBar.leftBarButtonItem!.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ChalkDuster", size: 20)!], forState: .Normal)