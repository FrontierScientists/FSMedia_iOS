//
//  Downloader.swift
//  Scrubber
//
//  Created by Jonathan Newell on 6/1/16.
//  Copyright © 2016 Jonathan Newell. All rights reserved.

import UIKit
import Foundation

    var data : NSData?

    func downloadData () {
        // ########################
        // downloading
        print("Starting Download.....")
        let JSONAddress = "http://frontierscientists.com/api/get_posts/?post_type=projects&count=100"
         do {jsonDownload = try NSData(contentsOfURL: NSURL(string: JSONAddress)!, options: NSDataReadingOptions.DataReadingUncached)
         } catch {}
        // ########################
        // writing to file
        let filepath = "/downloaded.json"
        let fileMan = NSFileManager.defaultManager()
        let directory = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        let documentDir = directory[0] as! String
        var test = fileMan.createFileAtPath(documentDir + filepath, contents: jsonDownload, attributes: nil)
        ParseJSON()
		parseScientist()
}
func ParseJSON() {
	// Load JSON from file
	let filePath = "/downloaded.json"
	// get the contentData
	let fileMan = NSFileManager.defaultManager()
	let directory = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
	let documentDir = directory[0] as! String
	jsonDownload = fileMan.contentsAtPath(documentDir + filePath)!
	// get the string
	var json: NSDictionary
	// Parse JSON
	do {
		// Translate NSData to JSON
		//        print(String(jsonDownload))
		json = (try? NSJSONSerialization.JSONObjectWithData(jsonDownload, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
		// Count the total number of posts
		let nPosts = json["count_total"]!.intValue
		// connect to the posts JSON
		let posts = json["posts"]!
		// Interate over posts
		for i in 1...nPosts {
			// Save the title
			var title = posts[i-1]["title"]! as! String
			title = title.stringByReplacingOccurrencesOfString("&#8217;",withString: "'")
			// The rest of the data is in custom fields
			let customFields = posts[i-1]["custom_fields"]!! as! [String:[String]]
			// Save description
			let desc = customFields["project_description"]![0]
			// Save map data (lat and long)
			let mapString = customFields["longlat"]![0]
			var mapArray = mapString.componentsSeparatedByString(", ")
			// Some projects don't have map information, and only have a "TD"
			if (mapArray[0] == "TD") {
				mapArray[0] = String(62.89447956)
				mapArray.append(String(-152.756170369))
			}
			// Create FSMapData object for init the RP
			var mapData: FSMapData = FSMapData(lat_: Double(mapArray[0])!,long_: Double(mapArray[1])!)
			// Video Saving
			// Vars for string manipulation
			var pairArray: [String]
			var tempArray: [String]
			// Array of FSVideo
			var myFSVideo: [FSVideo] = []
			// Connect to videos string
			
			
			var inString = customFields["videos"]![0]
			// Split video string
			pairArray = inString.componentsSeparatedByString("][")
			// Split string futher and save into FSVideo Array
			for i in 0...pairArray.count - 1 {
				if (pairArray[i].containsString("PROMO")) {
					continue
				}
				let tempFSVideo = FSVideo()
				
				tempArray=pairArray[i].componentsSeparatedByString(", https")
				//
				tempArray[0] = tempArray[0].stringByReplacingOccurrencesOfString("[", withString: "")
				tempArray[1] = "https" + tempArray[1].stringByReplacingOccurrencesOfString("]", withString: "")
				
				tempFSVideo.title = tempArray[0]
				tempFSVideo.youtube = tempArray[1]
				myFSVideo.append(tempFSVideo)
			}
			// Save Image url
			var imagePath = customFields["preview_image"]![0]
			// check image path (some preview_images are missing the vm.site.com... we fix this here)
			if (imagePath.rangeOfString("http:") == nil) {
				// i hope this url is perma static
				imagePath = "http://fsci15.wpengine.com" + imagePath
			}
			// init file manager stuff, connect to ~/APP/Library
			let fileMan = NSFileManager.defaultManager()
			let directory = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
			let documentDir = directory[0]
			// make sure ~/APP/Library/Caches/Image exists
			do {
				try NSFileManager.defaultManager().createDirectoryAtPath(documentDir + "/Caches/Images/", withIntermediateDirectories: false, attributes: nil)
			} catch let error as NSError {
				error.description
			}
			// Download the image if we need to
			var image = UIImage()
			if (!fileMan.fileExistsAtPath(documentDir + "/Caches/Images/" + title + ".jpg")) {
				NSLog("downloaded File  " + title)
				print("downloaded File  " + title)
				// download image
				if (NSData(contentsOfURL: NSURL(string: imagePath)!) != nil) {
					image =  UIImage(data: NSData(contentsOfURL: NSURL(string: imagePath)!)!)!
				}
				// save image
				let filepath = "/Caches/Images/" + title + ".jpg"
				UIImagePNGRepresentation(image)!.writeToFile(documentDir + filepath, atomically: true)
			} else {
				NSLog("loaded local file  " + title)
				print("loaded local file  " + title)
				image = UIImage(data: NSData(contentsOfFile: documentDir + "/Caches/Images/" + title + ".jpg")!)!
			}
			
			// init this RP
			let RP = ResearchProject(title_: title, description_: desc, videos_: myFSVideo, mapData_: mapData, image_: image, imagePath_: imagePath)
			// Add it to the Global Map
			RPMap.append(RP)
			// use below for to print this research project
			//prettyPrint(RP)
		}
		// non-mutable array so sort in place (alphabetical)
		RPMap.sortInPlace{$0.title < $1.title}
		// use below to print research projects
		//        var i = 0
		//        for RP in RPMap {
		//            i += 1
		//            prettyPrint(RP)
		//        }
	}
	
}

func parseScientist () {
	var sciName: String
	var sciImage: UIImage
	var sciImageURL: String
	var sciBio: String
	
	var sciAddress = "http://frontierscientists.com/feed-scientists-is-on-call/?feedonly=true"
	var scientistData : NSData
	var scientistHTML : NSString
	do {scientistData = try NSData(contentsOfURL: NSURL(string: sciAddress)!, options: NSDataReadingOptions.DataReadingUncached)
		scientistHTML = NSString(data:scientistData, encoding: NSUTF8StringEncoding)!
		
		var tempArray = scientistHTML.componentsSeparatedByString("title=\"")
		var tempArray2 = tempArray[1].componentsSeparatedByString(",")
		sciName = tempArray2[0]
		tempArray2 = tempArray[1].componentsSeparatedByString("\" rel")
		sciBio = tempArray2[0]
		var replaceString = sciName + ", "
		sciBio = sciBio.stringByReplacingOccurrencesOfString(replaceString, withString: "")
		tempArray2 = tempArray[1].componentsSeparatedByString("src=\"")
		tempArray2 = tempArray2[1].componentsSeparatedByString("\"")
		sciImageURL = tempArray2[0]
		
		print(sciName + " -- " + sciBio + " -- " + sciImageURL)
		
		sciOnCall = FSScientist(name_:sciName,bio_:sciBio,imagePath_:sciImageURL)
		
	} catch {}
}