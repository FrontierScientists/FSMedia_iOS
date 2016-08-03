//: Playground - noun: a place where people can play

import UIKit

var homePage = "http://frontierscientists.com"

var jsonDownload = try NSData(contentsOfURL: NSURL(string: homePage)!, options: NSDataReadingOptions.DataReadingUncached)

var mystring = NSString(data: jsonDownload, encoding:NSUTF8StringEncoding)

//print(mystring)

mystring?.containsString("scientist-on-call")

var string_array = mystring?.componentsSeparatedByString("<div class=\"textwidget\"><div class=\"scientist-on-call\">")

var scientist_section = string_array?[1].componentsSeparatedByString("</div></div>")

print(scientist_section![0])
