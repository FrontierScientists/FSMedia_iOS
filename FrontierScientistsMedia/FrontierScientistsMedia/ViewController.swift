//
//  ViewController.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/15/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainMenu: UITableView!
    @IBOutlet var bindingBack: UIView!
    @IBOutlet var pageBack: UIView!
    @IBOutlet var shadow: UIImageView!
    
    var sections = ["Research", "Videos", "Maps", "Articles", "Ask a Scientist", "About"]
    var icons = ["research_icon.png", "video_icon.png", "map_icon.png", "article_icon.png", "ask_a_scientist_icon.png", "about_icon.png"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("section") as CustomTableViewCell
        cell.cellImage.image = UIImage(named: icons[indexPath.row])
        cell.cellLabel.text = sections[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Frontier Scientists"
        mainMenu.rowHeight = 80
        mainMenu.separatorColor = UIColor.clearColor()
        mainMenu.backgroundColor = UIColor.clearColor()
        shadow.backgroundColor = UIColor(patternImage: UIImage(named: "drawer_shadow.png")!)
        bindingBack.backgroundColor = UIColor(patternImage: UIImage(named: "navigation_bg.jpg")!)
        pageBack.backgroundColor = UIColor(patternImage: UIImage(named: "page.jpeg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

