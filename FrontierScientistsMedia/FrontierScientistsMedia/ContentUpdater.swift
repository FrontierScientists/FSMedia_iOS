//
//  ContentUpdater.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/28/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

var projectData = [String: [String: AnyObject]]()
var scientistInfo = [String: String]()
var aboutInfo = [String: AnyObject]()
var orderedTitles = [String]()

func updateContent() {
    let filePath = "http://frontsci.arsc.edu/frontsci/frontSciData.json"
    
    // Load content.
    if NSUserDefaults.standardUserDefaults().objectForKey("projectData") != nil { // There has been data previously stored.
        let nextUpdateString = NSUserDefaults.standardUserDefaults().objectForKey("nextUpdate") as! String
        let nextUpdateDate = NSDate(dateString: nextUpdateString)
        let today = NSDate()
        
        if today.compare(nextUpdateDate) != NSComparisonResult.OrderedAscending { // If the next update date is either before today or is today, an update is needed.
            println("Updating stored data...")
            loadDataFromJson(filePath)
        } else {
            println("Data is current.  No update needed.")
        }
    } else { // There is no previously stored data.
        println("Retrieving data for first time...")
        loadDataFromJson(filePath)
    }
    projectData = NSUserDefaults.standardUserDefaults().objectForKey("projectData") as! Dictionary
    scientistInfo = NSUserDefaults.standardUserDefaults().objectForKey("scientist") as! Dictionary
    aboutInfo = NSUserDefaults.standardUserDefaults().objectForKey("about") as! Dictionary
    for title in sorted(projectData.keys.array) {
        orderedTitles.append(title)
    }
}

/*
    Content Function
*/
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
