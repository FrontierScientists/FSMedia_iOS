//: Playground - noun: a place where people can play

import UIKit

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
    print(tempArray[1])
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
} catch {}
