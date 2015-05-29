//
//  ViewController.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/15/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

var projectData = [String: [String: AnyObject]]()
var scientistInfo = [String: String]()
var aboutInfo = [String: AnyObject]()
var orderedTitles = [String]()
var scientistImage = UIImage()
var storedImages = [String: UIImage]()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainMenu: UITableView!
    @IBOutlet var bindingBack: UIView!
    @IBOutlet var pageBack: UIView!
    @IBOutlet var shadow: UIImageView!
    @IBOutlet weak var loadingDialog: UIView!
    
    let sections = ["Research", "Videos", "Maps", "Articles", "Ask a Scientist", "About"]
    let icons = ["research_icon.png", "video_icon.png", "map_icon.png", "article_icon.png", "ask_a_scientist_icon.png", "about_icon.png"]
    let filePath = "http://frontsci.arsc.edu/frontsci/frontSciData.json"
    var savedImages = [String]()
    
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
                performSegueWithIdentifier("articles", sender: nil)
                break
            case 4:
                performSegueWithIdentifier("ask", sender: nil)
                break
            default:
                performSegueWithIdentifier("about", sender:nil)
                break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // Deselect the selected row.
    }
    
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
        
        // Load content.
        let group = dispatch_group_create()
        // This first task ensures that data is loaded and stored and that the global variables are set.
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if NSUserDefaults.standardUserDefaults().objectForKey("projectData") != nil { // There has been data previously stored.
                let nextUpdateString = NSUserDefaults.standardUserDefaults().objectForKey("nextUpdate")! as! String
                let nextUpdateDate = NSDate(dateString: nextUpdateString)
                let today = NSDate()
                
                if today.compare(nextUpdateDate) != NSComparisonResult.OrderedAscending { // If the next update date is either before today or is today, an update is needed.
                    println("Updating stored data...")
                    self.loadDataFromJson(self.filePath)
                } else {
                    println("Data is current.  No update needed.")
                }
            } else { // There is no previously stored data.
                println("Retrieving data for first time...")
                self.loadDataFromJson(self.filePath)
            }
            projectData = NSUserDefaults.standardUserDefaults().objectForKey("projectData") as! Dictionary
            scientistInfo = NSUserDefaults.standardUserDefaults().objectForKey("scientist") as! Dictionary
            aboutInfo = NSUserDefaults.standardUserDefaults().objectForKey("about") as! Dictionary
        }
        // This second task waits for the first to finish then downloads all the photos mentioned in the stored dictionaries, lastly hiding the loading animation.
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if NSUserDefaults.standardUserDefaults().objectForKey("storedImages") == nil {
                NSUserDefaults.standardUserDefaults().setObject([String: UIImage](), forKey: "storedImages")
            }
            // Process all project images
            for (title, data) in projectData {
                self.processImage(data["preview_image"] as! String)
            }
            // Process all about page people images
            for person in aboutInfo["people"] as! [[String: String]] {
                self.processImage(person["image"]!)
            }
            // Process all about page snippet images
            for snippet in aboutInfo["snippets"] as! [[String: String]] {
                self.processImage(snippet["image"]!)
            }
            // Retrieve the data and store the images as UIImages.
            var currentStoredImages = NSUserDefaults.standardUserDefaults().objectForKey("storedImages") as! [String: NSData]
            for (title, imageData) in currentStoredImages {
                storedImages[title] = UIImage(data: imageData)
            }
            // Remove any images that need not be there.
            self.removeOldImages()
            // Hide the loading dialog.
            println("UI Ready!")
            self.loadingDialog.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/*
    Helper Functions
*/
    // UIColorFromRGB
    // This function generated a UIColor object from an RGB value
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    // loadDataFromJson
    // This function establishes a connection with the VM, loads the content of frontSciData.json into a dictionary and saves data from that dictionary into storage.
    func loadDataFromJson(filePath: String) {
        let data: NSData = NSData(contentsOfURL: NSURL(string: filePath)!)!
        var error: NSError?
        var jsonDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        // Load data into persistant storage
        NSUserDefaults.standardUserDefaults().setObject(jsonDict["android"], forKey: "projectData")
        NSUserDefaults.standardUserDefaults().setObject(jsonDict["next_update"], forKey: "nextUpdate")
        NSUserDefaults.standardUserDefaults().setObject(jsonDict["scientist"], forKey: "scientist")
        NSUserDefaults.standardUserDefaults().setObject(jsonDict["about"], forKey: "about")
    }
    // processImage
    // This function checks to see if the image of the passed path is already stored on the device.  If it is not, it is downloaded and stored.
    func processImage(imagePath: String) {
        var currentStoredImages = NSUserDefaults.standardUserDefaults().objectForKey("storedImages") as! [String: NSData]
        let imageTitle = NSURL(string: imagePath)?.lastPathComponent
        savedImages.append(imageTitle!) // Add the image to the list of images to be saved, not purged.
        // Make sure it hasn't already been stored.
        if currentStoredImages[imageTitle!] == nil {
            println("Downloading " + imageTitle! + "...")
            let image =  UIImage(data: NSData(contentsOfURL: NSURL(string: imagePath)!)!)
            currentStoredImages[imageTitle!] = UIImagePNGRepresentation(image)
            println(imageTitle! + " now stored.")
        } else {
            println(imageTitle! + " already stored.")
        }
        NSUserDefaults.standardUserDefaults().setObject(currentStoredImages, forKey: "storedImages")
    }
    // removeOldImages
    // This function removes all images stored on the device that are not mentioned in the current JSON file.
    func removeOldImages() {
        for (title, image) in storedImages {
            if !contains(savedImages, title) {
                println("Deleting " + title + ".")
                storedImages[title] = nil
            }
        }
    }
}

/*
    Extension
*/
// This extension for NSDate allows for easier NSDate creation from a String.
extension NSDate {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "MM/dd/yyyy"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}