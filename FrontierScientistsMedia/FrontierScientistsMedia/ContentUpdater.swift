//
//  ContentUpdater.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/28/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

var projectData = [String: [String: AnyObject]]()
var iosProjectData: Array<Dictionary<String, AnyObject>> = [];
var scientistInfo = [String: String]()
var aboutInfo = [String: AnyObject]()
var orderedTitles = [String]()

func updateContent() {
    //let filePath = "http://frontsci.arsc.edu/frontsci/frontSciData.json"
    let filePath = "http://frontsci.arsc.edu/frontsci/devFrontSciData.json"
    
    // Load content.
    if NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("projectData").path!) != nil { // There has been data previously stored.
        let nextUpdateString = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("nextUpdate").path!) as! String
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
    
    projectData = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("projectData").path!) as! Dictionary
    iosProjectData = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("iosProjectData").path!) as! [[String: AnyObject]]
    scientistInfo = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("scientist").path!) as! Dictionary
    aboutInfo = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("about").path!) as! Dictionary
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
    let data: NSData? = NSData(contentsOfURL: NSURL(string: filePath)!)
    if(data == nil){
        println("Error: Could not update data because the downloaded json data was nil")
        return
    }
    var error: NSError?
    var jsonDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
    // Load data into persistant storage
    NSKeyedArchiver.archiveRootObject(jsonDict["android"]!, toFile: getFileUrl("projectData").path!)
    NSKeyedArchiver.archiveRootObject(jsonDict["ios"]!, toFile: getFileUrl("iosProjectData").path!)
    NSKeyedArchiver.archiveRootObject(jsonDict["next_update"]!, toFile: getFileUrl("nextUpdate").path!)
    NSKeyedArchiver.archiveRootObject(jsonDict["scientist"]!, toFile: getFileUrl("scientist").path!)
    NSKeyedArchiver.archiveRootObject(jsonDict["about"]!, toFile: getFileUrl("about").path!) 
}

/*
    Helper Function
*/
// getFileUrl
// This function retrieves a valid url from the document directory.
func getFileUrl(fileName: String) -> NSURL {
    let manager = NSFileManager.defaultManager()
    let dirURL = manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)
    return dirURL!.URLByAppendingPathComponent(fileName)
}

