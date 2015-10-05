// ArticlesTableViewController.swift

import Foundation
import UIKit

/*
    This is the ArticlesTableViewController class, responsable for parsing the articles feed and displaying
    the articles in a TableView.
*/
class ArticlesTableViewController: UITableViewController, NSXMLParserDelegate{
    
/*
    Outlets
*/
    @IBOutlet var articleTableView: UITableView?
/*
    Class Constants
*/
    let feed: String = "http://frontierscientists.com/feed"
/*
    Class Variables
*/
    var articleLink: String = ""
    var articleReadStatusFileDict: NSMutableDictionary = NSMutableDictionary()
    var articleReadStatusFilePath: String = NSHomeDirectory() + "Library/Caches/ArticlesReadStatus.txt"
    var articleTitle: NSMutableString = NSMutableString()
    var element: String = ""
    var parser = NSXMLParser()
    var posts = [[String(): String()]]
    var selectedArtcileIndex: Int = 0
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        self.view.backgroundColor = UIColor(patternImage:UIImage(named: "bg.png")!)
        self.title = "Articles"
        
        beginParsing()
        articleReadStatusFileDict = [NSString(string: "dummy"): NSNumber(int: 0)]
        if (!NSFileManager.defaultManager().fileExistsAtPath(articleReadStatusFilePath)) {
            createReadArticlesFileIfNone()
        } else {
            loadArticlesReadStatusFileToArticlesReadStatusDict()
        }
        updateArticlesReadStatusDict()
        saveArticlesReadStatusDictToArticlesReadStatusFile()
        print("Finished loading articles.")
    }
    // prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "RSSFeed") {
            let avc = segue.destinationViewController as? ArticleViewController
            var str = posts[selectedArtcileIndex]["link"]
            // Ready link for use in WebView
            str = str?.stringByReplacingOccurrencesOfString(" ", withString: "")
            str = str?.stringByReplacingOccurrencesOfString("\n", withString: "")
            str = str?.stringByReplacingOccurrencesOfString("   ", withString: "")
            str = str?.stringByReplacingOccurrencesOfString("\t", withString: "")
            // Set link string
            avc?.articleLinkString = str
        }
    }
    
/*
    TableView Functions
*/
    // numberOfSectionsInTableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // heightForHeaderInSection
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    // numberOfRowsInSection
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        return 10
    }
    // heightForRowAtIndexPath
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType) {
            return 80
        } else { // iPhone
            return 40
        }
    }
    // cellForRowAtIndexPath
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Initialize cell
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ArticleTitle")
        // Format cell
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIImageView(image: UIImage(named: "CellBorder.png"))
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.textLabel!.text = posts[indexPath.row]["title"]!
        cell.contentView.layer.borderColor = UIColor.clearColor().CGColor
        // Include "new" icon only when article is unread
        var accessoryImageView: UIImageView
        if (articleHasBeenRead(indexPath.row)) {
            accessoryImageView = UIImageView(image: UIImage(named: "Transition_Icon.png"))
        } else {
            accessoryImageView = UIImageView(image: UIImage(named: "new_icon-web.png"))
        }
        // Change image text sizes based on screen size
        if (UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType) {
            accessoryImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            cell.textLabel?.font = UIFont(name: "Chalkduster", size: 30)
        } else { // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            accessoryImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            cell.textLabel?.font = UIFont(name: "Chalkduster", size: 20)
        }
        cell.accessoryView = accessoryImageView
        
        return cell
    }
    // didSelectRowAtIndexPath
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArtcileIndex = indexPath.row
        let articleStoryLink = posts[indexPath.row]["link"]!
        articleReadStatusFileDict[articleStoryLink] = NSNumber(int: 1)
        saveArticlesReadStatusDictToArticlesReadStatusFile()
        self.tableView.reloadData()
        performSegueWithIdentifier("RSSFeed", sender: self)
    }
    
/*
    Helper and Content Functions
*/
    // createReadArticlesFileIfNone
    // This function creates a new "read articles" file if there is not one already present on the device.
    func createReadArticlesFileIfNone() {
        let fileMgr = NSFileManager.defaultManager()
        if (!fileMgr.fileExistsAtPath(articleReadStatusFilePath)) {
            if (!fileMgr.createFileAtPath(articleReadStatusFilePath, contents: nil, attributes: articleReadStatusFileDict as [String : AnyObject])) {
                print("Error! Creating articleReadStatusFile failed to create at \(articleReadStatusFilePath)")
            }
        }
    }
    // loadArticlesReadStatusFileToArticlesReadStatusDict
    // This function loads the contents of the "read articles" file in to the articleReadStatusFileDict
    func loadArticlesReadStatusFileToArticlesReadStatusDict() {
        articleReadStatusFileDict = NSMutableDictionary(contentsOfFile: articleReadStatusFilePath)!
    }
    // saveArticlesReadStatusDictToArticlesReadStatusFile
    // This function saves the articleReadStatusFileDict data back into a file on the device
    func saveArticlesReadStatusDictToArticlesReadStatusFile() {
        articleReadStatusFileDict.writeToFile(articleReadStatusFilePath, atomically: true)
    }
    // updateArticlesReadStatusDict
    // This function updates the articleReadStatusFileDict after a new article has been viewed
    func updateArticlesReadStatusDict() {
        var newArticlesReadStatusDict: NSMutableDictionary = NSMutableDictionary()
        let dictHasBeenReadValue: NSNumber = 1
        var articleStoryLink: NSString = ""
        newArticlesReadStatusDict = [:]
        for ii in 0...posts.count-1 {
            articleStoryLink = posts[ii]["link"]!
            
            if (articleReadStatusFileDict.objectForKey(articleStoryLink) != nil &&
                articleReadStatusFileDict.objectForKey(articleStoryLink)!.integerValue == dictHasBeenReadValue.integerValue) {
                newArticlesReadStatusDict.setObject(NSNumber(int: 1), forKey: articleStoryLink)
            } else {
                newArticlesReadStatusDict.setObject(NSNumber(int: 0), forKey: articleStoryLink)
            }
        }
        articleReadStatusFileDict = newArticlesReadStatusDict
    }
    // articleHasBeenRead
    // This function returns a bool based on whether or not the article at the passed index has been viewed
    func articleHasBeenRead(index: Int) -> Bool {
        let linkString: String = posts[index]["link"]!
        if (articleReadStatusFileDict.objectForKey(linkString) != nil &&
            articleReadStatusFileDict.objectForKey(linkString)?.integerValue == NSNumber(int: 1)) {
            return true
        }
        return false
    }
    
/*
    Parser Functions
*/
    // parseErrorOccurred
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("error = \(parseError.localizedDescription)")
    }
    // beginParsing
    // This function begins the XML parsing process
    func beginParsing() {
        posts = []
        parser = NSXMLParser(contentsOfURL: NSURL(string: feed)!)!
        parser.delegate = self
        if (!parser.parse()) {
            print("parser failed")
            print("error is \(parser.parserError)")
        }
    }
    // didStartElement
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName
        if (element == "item") {
            articleTitle = ""
            articleLink = ""
        }
    }
    // foundCharacters
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if (element == "title") {
            articleTitle.appendString(string)
        } else if (element == "link") {
            articleLink.appendString(string)
        }
    }
    // didEndElement
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName == "item") {
            if (!(articleTitle.isEqual(nil)) && !articleLink.isEqual(nil)) {
                let dictionaryEntry: Dictionary = ["title": (articleTitle as String), "link": (articleLink as String)]
                posts.append(dictionaryEntry)
            }
        }
    }
}