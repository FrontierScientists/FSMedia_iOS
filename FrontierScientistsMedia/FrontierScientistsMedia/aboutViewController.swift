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

//    let sections = [aboutInfo["goal"] as! String,aboutInfo["opening"] as! String]
    let sections = ["goal","opening"]
    let icons = ["research_icon.png", "video_icon.png", "map_icon.png", "article_icon.png", "ask_a_scientist_icon.png", "about_icon.png", "RiR_plainyellow_iphone.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //r 153 g 75 b 34
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
//Define the nav bar colors
        // UIColor(red:153.0, green:75.0, blue:34.0, alpha:1.0)
        // make nav bar brown
        navigationController!.navigationBar.barTintColor = UIColor(red:153.0/255.0, green:75.0/255.0, blue:34.0/255.0, alpha:1.0)
        // makes title font ChalkDuster
        navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "ChalkDuster", size: 20)!]
        // makes all of the text in the bar white
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        // makes topmost bar stuff white
        navigationController!.navigationBar.barStyle = UIBarStyle.Black
        
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
        
//        aboutNavBar.leftBarButtonItem = UIBarButtonItem()
//        println("debug 1")
//        aboutNavBar.leftBarButtonItem!.title = "< MainMenu"
//        println("debug 2")
//        aboutNavBar.leftBarButtonItem!.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ChalkDuster", size: 20)!], forState: .Normal)
//        println("debug 3")

        self.title = "About Frontier Scientists"
//        aboutTable.rowHeight = 200
       // Beautify.


    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("goal") as! CustomTableViewCell
//        cell.cellImage.image = UIImage(named: icons[indexPath.row])
        cell.aboutLabel.text = aboutInfo[sections[indexPath.row]] as? String
        cell.aboutLabel.font = UIFont(name: "Chalkduster", size: 20)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}