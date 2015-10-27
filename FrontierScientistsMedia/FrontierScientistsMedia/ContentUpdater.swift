// ContentUpdater.swift

import UIKit

/*
    This is the updateContent function, called from the AppDelegate.swift file in the application function.
    This function handles the updating of the data received from the frontSciData.json file, retreiving new
    and updated data when needed and propegating those updates to the stored files on the device.  This function
    uses NSKeyedArchiveer and NSKeyedUnarchiver to store the data in files on the device in dictionary form.
*/
func updateContent() {
    let filePath = "http://frontsci.arsc.edu/frontsci/frontSciData.json"
    
    if NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("projectData").path!) != nil { // There has been data previously stored.
        let nextUpdateString = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("nextUpdate").path!) as! String
        let nextUpdateDate = NSDate(dateString: nextUpdateString)
        let today = NSDate()
        
        // If the next update date is either before today or is today, an update is needed.
        if today.compare(nextUpdateDate) != NSComparisonResult.OrderedAscending { 
            if displayOldData { // Set in the checkNetwork function in ViewController.swift
                print("Displaying old content")
            } else {
                print("Updating stored data...")
                loadDataFromJson(filePath)
            }
        } else {
            print("Data is current.  No update needed.")
        }
    } else { // There is no previously stored data.
        print("Retrieving data for first time...")
        loadDataFromJson(filePath)
    }
    
    // If this is the first time retreiving data (there is none already present) but the server could not be connected to,
    // there is nothing further to be done.  cannotContinue is set to true here and handled in ViewController.swift.
    if (!connectedToServer && NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("projectData").path!) == nil) {
        cannotContinue = true
        return
    }
    
    // Each of the global dictionaries responsable for holding the data are set here from the archived data to be used
    // throughout the application for the remainder of the instance of the application.
    projectData = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("projectData").path!) as! Dictionary
    scientistInfo = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("scientist").path!) as! Dictionary
    for title in projectData.keys.sort() { // orderedTitles is populated by sorting the titles from projectData
        orderedTitles.append(title)
    }
}

/*
    Helper and Content Functions
*/
// loadDataFromJson
// This function establishes a connection with the VM, loads the content of frontSciData.json into a dictionary and saves data from that dictionary into storage.
// If a connection cannot be made, it simply sets connectionToServer to false.
func loadDataFromJson(filePath: String) {
    let data: NSData? = NSData(contentsOfURL: NSURL(string: filePath)!)
    if (data == nil) {
        print("Error: Could not update data because the downloaded json data was nil")
        connectedToServer = false
        return
    }
    let jsonDict: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
    // Load data into persistant storage
    NSKeyedArchiver.archiveRootObject(jsonDict["project_data"]!, toFile: getFileUrl("projectData").path!)
    NSKeyedArchiver.archiveRootObject(jsonDict["next_update"]!, toFile: getFileUrl("nextUpdate").path!)
    NSKeyedArchiver.archiveRootObject(jsonDict["scientist"]!, toFile: getFileUrl("scientist").path!)
}
// getFileUrl
// This function retrieves a valid url from the document directory.
func getFileUrl(fileName: String) -> NSURL {
    let manager = NSFileManager.defaultManager()
    let dirURL = try? manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    return dirURL!.URLByAppendingPathComponent(fileName)
}

