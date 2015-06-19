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
    
    let sections = ["opening","goal","people_intro"]
    let aboutDisplayableContent = aboutDisplayableContentFrameworkized()
//    let aboutContent = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "About Frontier Scientists"
        
        for var i:Int=0; i < aboutInfo["snippets"]!.count; i++  {
            aboutDisplayableContent.snippets.append((aboutInfo["snippets"]![i] as! [String: String])["text"]!)
            aboutDisplayableContent.imageKeys.append((aboutInfo["snippets"]![i] as! [String: String])["image"]!)
        }
        
        aboutTable.estimatedRowHeight = 110.0
        aboutTable.rowHeight = UITableViewAutomaticDimension
    }//end viewDidLoad
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count + aboutDisplayableContent.snippets.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let celll: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("opening") as! AboutTableViewCell
        println(indexPath.row)
        println("debug 1")
        if indexPath.row < sections.count{
        let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("opening") as! AboutTableViewCell
        println("debug 2")
        cell.openingLabel.text = aboutInfo[sections[indexPath.row]] as? String
        println("debug 3")
        cell.openingLabel.font = UIFont(name: "Chalkduster", size: 20)
        println("debug 4")
        cell.backgroundColor = UIColor.clearColor()
        println("debug 5")
            return cell
        }
        if (indexPath.row > sections.count) || (indexPath.row == sections.count) {
        println("debug 6")
        let cell: AboutTableViewCell = tableView.dequeueReusableCellWithIdentifier("snippets") as! AboutTableViewCell
        println("debug 7")
        cell.snippetLabel.text = aboutDisplayableContent.snippets[indexPath.row - sections.count]
        println("debug 8")
        cell.snippetLabel.font = UIFont(name: "Chalkduster", size: 20)
        cell.backgroundColor = UIColor.clearColor()
        return cell
        }
        return celll
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
class aboutDisplayableContentFrameworkized{
    var snippets = [""]
    var imageKeys = [""]
    var educators: String?
    
}

//Setting up a left bar button
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
//        aboutNavBar.leftBarButtonItem = UIBarButtonItem()
//        aboutNavBar.leftBarButtonItem!.title = "< MainMenu"
//        aboutNavBar.leftBarButtonItem!.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ChalkDuster", size: 20)!], forState: .Normal)