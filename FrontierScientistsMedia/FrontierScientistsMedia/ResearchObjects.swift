import UIKit
import Foundation
// ###############################################################
// RP class contains all the information needed for a given RP
// ###############################################################
class ResearchProject {
	var title: String
	var description: String
	var videos: [FSVideo]
	var mapData: FSMapData
	var image: UIImage
	var imagePath: String
	// ......................
	init(title_ : String, description_ : String, videos_:[FSVideo] = [], mapData_ : FSMapData = FSMapData(), image_: UIImage = UIImage(), imagePath_ : String = "") {
		title = title_
		title = title.stringByReplacingOccurrencesOfString("&#8217;",withString: "'")
		description = description_
		videos = videos_
		mapData = mapData_
		image = image_
		imagePath = imagePath_
	}
	// Used for debugging to print this class object
	func prettyPrint () {
		print("title:  " + title)
		print("description:  " + description)
		for video in videos {
			print("video title:  " + video.title)
			print("youtube link:  " + video.youtube)
		}
		print("mapData.lat:  " + String(mapData.lat))
		print("mapData.long:  " + String(mapData.long))
		print("imagePath:  " + imagePath)
	}
}
// ###############################################################
class FSVideo {
	var youtube: String
	var title: String
	// ......................
	init(title_ : String = "", youtube_: String = "") {
		title = title_
		youtube = youtube_
	}
}
// ###############################################################
class FSMapData {
	var lat: Double
	var long: Double
	// ......................
	init(lat_: Double = 0.0, long_: Double = 0.0) {
		lat = lat_
		long = long_
	}
}
// ###############################################################
class FSScientist {
    var name: String
    var bio: String
    var image: UIImage
    var imagePath: String
	// ......................
	// allows global declaration of sciOnCall
	init() {
		name = ""
		bio = ""
		image = UIImage()
		imagePath = ""
	}
	// ......................
    init(name_: String, bio_: String,imagePath_: String) {
        name = name_
        bio = bio_
        imagePath = imagePath_
        // init file manager stuff, connect to ~/APP/Library
        let fileMan = NSFileManager.defaultManager()
        let directory = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        let documentDir = directory[0]
        // make sure ~/APP/Library/Caches/Image exists
        var tempImage = UIImage()
        if (!fileMan.fileExistsAtPath(documentDir + "/Caches/Images/" + name + ".jpg")) {
            NSLog("downloaded File  " + name)
            print("downloaded File  " + name)
            // download image
            if (NSData(contentsOfURL: NSURL(string: imagePath)!) != nil) {
                tempImage =  UIImage(data: NSData(contentsOfURL: NSURL(string: imagePath)!)!)!
            }
            // save image
            let filepath = "/Caches/Images/" + name + ".jpg"
            UIImagePNGRepresentation(tempImage)!.writeToFile(documentDir + filepath, atomically: true)
        } else {
            NSLog("loaded local file  " + name)
            print("loaded local file  " + name)
            tempImage = UIImage(data: NSData(contentsOfFile: documentDir + "/Caches/Images/" + name + ".jpg")!)!
        }
        image = tempImage
    }
}