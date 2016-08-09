import UIKit
// ###############################################################
// These are the extensions made to various classes in order to more easily achieve
// tasks in this project.
// ###############################################################
// This extension for NSDate allows for easier NSDate creation from a String.
extension NSDate {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "MM/dd/yyyy"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}
// ###############################################################
// This extension for String allows for random access by index and range-based substrings.
// ###############################################################
extension String {
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
}