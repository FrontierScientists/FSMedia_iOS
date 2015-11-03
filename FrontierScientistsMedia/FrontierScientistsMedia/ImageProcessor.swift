//  ImageProcessor.swift

import UIKit

/*
    This is the processImages function, called from the AppDelegate.swift file in the application function.
    This function goes through all of the image data in the project:
        projectData - project images
        scientistInfo - scientist image
    When all images in the data are confirmed as present on the device (downloaded if not previously present),
    the storedImages dictionary is updated and the images on the device that are not specified in the data are
    deleted.
*/
func processImages() {
    createFolderNamed("Images") // Call to function in HelperFunctions.swift
    if NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("storedImages").path!) == nil {
        NSKeyedArchiver.archiveRootObject([String: UIImage](), toFile: getFileUrl("storedImages").path!)
    }
    // Retrieve the data.
    currentStoredImages = NSKeyedUnarchiver.unarchiveObjectWithFile(getFileUrl("storedImages").path!) as! [String: NSData]
    // Process all project images
    for (_, data) in projectData {
        processImage(data["preview_image"] as! String)
    }
    // Process the Ask a Scientist image
    processImage(scientistInfo["image"]!)
    // Populate the storedImages dictionary, converting the data into UIImages
    for (title, imageData) in currentStoredImages {
        storedImages[title] = UIImage(data: imageData)
    }
    // Remove any images that need not be there.
    for title in storedImages.keys {
        if !savedImages.contains(title) {
            print("Deleting " + title + ".")
            storedImages[title] = nil
        }
    }
    // Restore the updated data.
    currentStoredImages = [String: NSData]()
    let IMAGEFILEPATH: String = NSHomeDirectory() + "/Library/Caches/Images/"
    for (title, image) in storedImages {
        UIImagePNGRepresentation(image)!.writeToFile(IMAGEFILEPATH + title, atomically: true)
        currentStoredImages[title] = UIImagePNGRepresentation(image)
    }
    NSKeyedArchiver.archiveRootObject(currentStoredImages, toFile: getFileUrl("storedImages").path!)
}

/*
    Content functions
*/
// processImage
// This function checks to see if the image of the passed path is already stored on the device.  If it is not, it is downloaded and stored.
func processImage(imagePath: String) {
    let imageTitle = NSURL(string: imagePath)?.lastPathComponent
    savedImages.append(imageTitle!) // Add the image to the list of images to be saved, not purged.
    // Make sure it hasn't already been stored.
    if currentStoredImages[imageTitle!] == nil {
        print("Downloading " + imageTitle! + "...")
        print(imagePath)
        var image = UIImage()
        if (NSData(contentsOfURL: NSURL(string: imagePath)!) != nil) {
            image =  UIImage(data: NSData(contentsOfURL: NSURL(string: imagePath)!)!)!
        }
        currentStoredImages[imageTitle!] = UIImagePNGRepresentation(image)
        print(imageTitle! + " now stored.")
    } else {
        print(imageTitle! + " already stored.")
    }
}