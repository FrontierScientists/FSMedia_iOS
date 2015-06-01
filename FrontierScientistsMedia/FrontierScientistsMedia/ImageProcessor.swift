//
//  ImageProcessor.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 5/28/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit

var storedImages = [String: UIImage]()
var savedImages = [String]()

func processImages() {
    createImageFolderIfNone()
    
    if NSUserDefaults.standardUserDefaults().objectForKey("storedImages") == nil {
        NSUserDefaults.standardUserDefaults().setObject([String: UIImage](), forKey: "storedImages")
    }
    // Process all project images
    for (title, data) in projectData {
        processImage(data["preview_image"] as! String)
    }
    // Process all about page people images
    for person in aboutInfo["people"] as! [[String: String]] {
        processImage(person["image"]!)
    }
    // Process all about page snippet images
    for snippet in aboutInfo["snippets"] as! [[String: String]] {
        processImage(snippet["image"]!)
    }
    // Process the Ask a Scientist image
    processImage(scientistInfo["image"]!)
    // Retrieve the data.
    var currentStoredImages = NSUserDefaults.standardUserDefaults().objectForKey("storedImages") as! [String: NSData]
    // Populate the storedImages dictionary, converting the data into UIImages
    for (title, imageData) in currentStoredImages {
        storedImages[title] = UIImage(data: imageData)
    }
    // Remove any images that need not be there.
    for title in storedImages.keys {
        if !contains(savedImages, title) {
            println("Deleting " + title + ".")
            storedImages[title] = nil
        }
    }
    // Restore the updated data.
    currentStoredImages = [String: NSData]()
    let IMAGEFILEPATH: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/Images");
    for (title, image) in storedImages {
        UIImagePNGRepresentation(image).writeToFile(IMAGEFILEPATH.stringByAppendingPathComponent(title), atomically: true)
        currentStoredImages[title] = UIImagePNGRepresentation(image)
    }
    NSUserDefaults.standardUserDefaults().setObject(currentStoredImages, forKey: "storedImages")
}

/*
    Content functions
*/
// processImage
// This function checks to see if the image of the passed path is already stored on the device.  If it is not, it is downloaded and stored.
func processImage(imagePath: String) {
    var currentStoredImages = NSUserDefaults.standardUserDefaults().objectForKey("storedImages") as! [String: NSData]
    let imageTitle = NSURL(string: imagePath)?.lastPathComponent
    savedImages.append(imageTitle!) // Add the image to the list of images to be saved, not purged.
    // Make sure it hasn't already been stored.
    if currentStoredImages[imageTitle!] == nil {
        println("Downloading " + imageTitle! + "...")
        println(imagePath)
        var image = UIImage.alloc();
        if(NSData(contentsOfURL: NSURL(string: imagePath)!) != nil){
            image =  UIImage(data: NSData(contentsOfURL: NSURL(string: imagePath)!)!)!
        }
        currentStoredImages[imageTitle!] = UIImagePNGRepresentation(image)
        println(imageTitle! + " now stored.")
    } else {
        println(imageTitle! + " already stored.")
    }
    NSUserDefaults.standardUserDefaults().setObject(currentStoredImages, forKey: "storedImages")
}

// createImageFileIfNone
// Creates the image file if it doesn't exist
func createImageFolderIfNone()
{
    let IMAGEFILEPATH: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/Images");
    var isDir = ObjCBool(true);
    println(IMAGEFILEPATH);
    if(!NSFileManager.defaultManager().fileExistsAtPath(IMAGEFILEPATH, isDirectory: &isDir)){
        if(!NSFileManager.defaultManager().createDirectoryAtPath(IMAGEFILEPATH, withIntermediateDirectories: false, attributes: nil, error: nil)){
            println("The images file failed to be created.");
        }
    }}