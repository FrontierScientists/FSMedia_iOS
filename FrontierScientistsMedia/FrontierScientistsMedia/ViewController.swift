//
//  ViewController.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/15/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

var reachability = Reachability.reachabilityForInternetConnection();
var netStatus = reachability.currentReachabilityStatus();
let NOTREACHABLE: Int = 0;

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainMenu: UITableView!
    @IBOutlet var bindingBack: UIView!
    @IBOutlet var pageBack: UIView!
    @IBOutlet var shadow: UIImageView!
    @IBOutlet weak var loadingDialog: UIView!
    @IBOutlet weak var loadingScreen: UIView!
    
    let sections = ["Research", "Videos", "Maps", "Articles", "Ask a Scientist", "About", "UAV Challenge"]
    let icons = ["research_icon.png", "video_icon.png", "map_icon.png", "article_icon.png", "ask_a_scientist_icon.png", "about_icon.png", "uavIcon.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Beautify.
        loadingDialog.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = "Frontier Scientists"
        mainMenu.rowHeight = 80
        mainMenu.separatorColor = UIColor.clearColor()
        mainMenu.backgroundColor = UIColor.clearColor()
        shadow.backgroundColor = UIColor(patternImage: UIImage(named: "drawer_shadow.png")!)
        bindingBack.backgroundColor = UIColor(patternImage: UIImage(named: "navigation_bg.jpg")!)
        pageBack.backgroundColor = UIColor(patternImage: UIImage(named: "page.jpeg")!)
        
        // Hide loading screen when done loading.
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.loadingScreen.hidden = true
            }
        }
    }
    
    func noArticlesAlert(){
        
        println("noArticlesAlert triggered.");
        let ALERTMESSAGE = "No network connection was found. Articles are unavailable.";
        var alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil);
        alert.show();
        
        // Delay the dismissal by 5 seconds
        let delay = 2.0 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("section") as! CustomTableViewCell
        cell.cellImage.image = UIImage(named: icons[indexPath.row])
        cell.cellLabel.text = sections[indexPath.row]
        cell.cellLabel.font = UIFont(name: "Chalkduster", size: 20)
        cell.cellLabel.textColor = UIColorFromRGB(0x3E3535)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        switch indexPath.row {
            case 0:
                performSegueWithIdentifier("research", sender: nil)
                break
            case 1:
                performSegueWithIdentifier("videos", sender: nil)
                break
            case 2:
                performSegueWithIdentifier("maps", sender: nil)
                break
            case 3:
                netStatus = reachability.currentReachabilityStatus();
                if(netStatus.value == NOTREACHABLE){
                    noArticlesAlert();
                }
                else{
                    performSegueWithIdentifier("articles", sender: nil)
                }
                break
            case 4:
                performSegueWithIdentifier("ask", sender: nil)
                break
            case 5:
                performSegueWithIdentifier("about", sender: nil)
            default:
                performSegueWithIdentifier("game", sender:nil)
                break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // Deselect the selected row.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}