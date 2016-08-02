//: Playground - noun: a place where people can play

import UIKit
import Foundation

class FSVideo {
	var youtube: String
	var title: String
	
	init(title_ : String = "", youtube_: String = "") {
		title = title_
		youtube = youtube_
	}
}

class FSMapData {
	var lat: Double
	var long: Double
	
	init(lat_: Double = 0.0, long_: Double = 0.0) {
		lat = lat_
		long = long_
	}
}

class FSImage {
    var path: NSURL
    
    init(path_: NSURL = NSURL()) {
        //logic
        path = path_
        print("who cares:")
    }
}

class ResearchProject {
	
	var title: String
	var description: String
	var videos: [FSVideo]
	var mapData: FSMapData
    var image: UIImage
    var imagePath: String
	
    init(title_ : String, description_ : String, videos_:[FSVideo] = [], mapData_ : FSMapData = FSMapData(), image_: UIImage = UIImage(), imagePath_ : String = "") {
		title = title_
        title = title.stringByReplacingOccurrencesOfString("&#8217;",withString: "'")
		description = description_
		videos = videos_
		mapData = mapData_
        image = image_
        imagePath = imagePath_
	}
}

func ParseJSON() {
    // Load JSON from file
	let filePath = "/Library/Caches/downloaded.json"
    // get the contentData
	let jsonDownload = NSFileManager.defaultManager().contentsAtPath(filePath)
	// get the string
	var json: NSDictionary
    // Parse JSON
	do {
        // Translate NSData to JSON
        json = try NSJSONSerialization.JSONObjectWithData(jsonDownload!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        // Count the total number of posts
        let nPosts = json["count_total"]!.intValue
        // connect to the posts JSON
        let posts = json["posts"]
        // Interate over posts
        for i in 1...nPosts {
            // Save the title
            let title = posts![i-1]["title"]! as! String
            // The rest of the data is in custom fields
            let customFields = posts![i-1]["custom_fields"]
            // Save description
            let desc = customFields!!["project_description"]!![0] as! String
            // Save map data (lat and long)
            let mapString = customFields!!["longlat"]!![0] as! String
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
            var inString = customFields!!["videos"]!![0] as! String
            // Split video string
            pairArray = inString.componentsSeparatedByString("][")
            // Split string futher and save into FSVideo Array
            for i in 0...pairArray.count - 1 {
                let tempFSVideo = FSVideo()
                
                tempArray=pairArray[i].componentsSeparatedByString(", ")
                //
                tempArray[0] = tempArray[0].stringByReplacingOccurrencesOfString("[", withString: "")
                tempArray[1] = tempArray[1].stringByReplacingOccurrencesOfString("]", withString: "")
                
                tempFSVideo.title = tempArray[0]
                tempFSVideo.youtube = tempArray[1]
                myFSVideo.append(tempFSVideo)
            }
            // Save Image url
            var imagePath = customFields!!["preview_image"]!![0] as! String
            // check image path (some preview_images are missing the vm.site.com... we fix this here)
            if (imagePath.rangeOfString("http:") == nil) {
                // i hope this url is perma static
                imagePath = "http://fsci15.wpengine.com" + imagePath
            }
            // save image
            var image = UIImage()
            if (NSData(contentsOfURL: NSURL(string: imagePath)!) != nil) {
                image =  UIImage(data: NSData(contentsOfURL: NSURL(string: imagePath)!)!)!
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
        var i = 0
        for RP in RPMap {
            i += 1
            prettyPrint(RP)
        }
	} catch {
		print(error)
	}
    
}
// Used for debugging to print this class object
func prettyPrint (RPin: ResearchProject) {
    print(RPin.title)
    print(RPin.description)
    for video in RPin.videos {
        print(video.title)
        print(video.youtube)
    }
    print(RPin.mapData.lat)
    print(RPin.mapData.long)
    print(RPin.imagePath)
    print(RPin.image) 
}