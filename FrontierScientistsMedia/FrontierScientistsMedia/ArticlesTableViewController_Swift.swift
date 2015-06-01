//
//  ArticlesTableViewController_Swift.swift
//  FSDemo
//
//  Created by alandrews3 on 5/13/15.
//  Copyright (c) 2015 Andrew Clark. All rights reserved.
//

import Foundation
import UIKit

let feed: String = "http://frontierscientists.com/feed";
var articleTitle: NSMutableString = NSMutableString();
var articleLink: NSMutableString = NSMutableString();
var element: String = "";
var selectedArtcileIndex: Int = 0;
var articleReadStatusFileDict: NSMutableDictionary = NSMutableDictionary.alloc();

class MySwiftArticlesTableViewController: UITableViewController, NSXMLParserDelegate{
    @IBOutlet var articleTableView: UITableView?;
    var posts = NSMutableArray();
    var parser = NSXMLParser.alloc();
    var articleReadStatusFilePath: String = NSHomeDirectory().stringByAppendingPathComponent("Library/Caches/ArticlesReadStatus.txt");
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        articleTableView?.delegate = self;
        articleTableView?.dataSource = self;
        
        self.view.backgroundColor = UIColor(patternImage:UIImage(named: "bg.png")!);
        self.title = "About Frontier Scientists";
        beginParsing();
        
        println("Above dict assignment");
        articleReadStatusFileDict = [NSString(string: "dummy"): NSNumber(int: 0)];
        
        if(!NSFileManager.defaultManager().fileExistsAtPath(articleReadStatusFilePath)){
            println("Above file create");
            createReadArticlesFileIfNone();
        }
        else{
            println("Above load");
            loadArticlesReadStatusFileToArticlesReadStatusDict();
        }
        
        println("Above update");
        updateArticlesReadStatusDict();
        println("Above save");
        saveArticlesReadStatusDictToArticlesReadStatusFile();
        
        println("Finished loading view");
    }
    
    // Table Section Functions
    //  numberOfSectionsInTableView(tableView: UITableView)
    //  heightForHeaderInSection section: Int)
    //
    //
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0.001;
    }
    
    // Table Cell Functions
    //  numberOfRowsInSection section: Int)
    //  cellForRowAtIndexPath indexPath: NSIndexPath)
    //  didSelectRowAtIndexPath indexPath: NSIndexPath)
    //
    //
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int{
        return 10;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if(UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType){
            return 160;
        }
        else{ // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            return 40;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell{
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ArticleTitle");
        
        cell.backgroundColor = UIColor.clearColor();
        cell.backgroundView = UIImageView(image: UIImage(named: "CellBorder.png"));
        cell.textLabel?.backgroundColor = UIColor.clearColor();
        cell.textLabel!.text = posts[indexPath.row]["title"] as? String;
        
        var accessoryImageView: UIImageView;
        
        if(articleHasBeenRead(indexPath.row)){
            accessoryImageView = UIImageView(image: UIImage(named: "Transition_Icon.png"));
        }
        else{
            accessoryImageView = UIImageView(image: UIImage(named: "new_icon-web.png"));
        }
        
        if(UIDevice.currentDevice().userInterfaceIdiom == iPadDeviceType){
            accessoryImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80);
            cell.textLabel?.font = UIFont(name: "Chalkduster", size: 30);
        }
        else{ // (UIDevice.currentDevice().userInterfaceIdiom.rawValue == iPhoneDeviceType)
            accessoryImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
            cell.textLabel?.font = UIFont(name: "Chalkduster", size: 20);
        }
        
        cell.accessoryView = accessoryImageView;
        
        var blackLine: UIView = UIView(frame: CGRectMake(0, cell.frame.size.height-6, self.view.frame.size.width, 2));
        blackLine.backgroundColor = UIColor.blackColor();
        cell.addSubview(blackLine);
        
        cell.contentView.layer.borderColor = UIColor.clearColor().CGColor;
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        selectedArtcileIndex = indexPath.row;
        
        var articleStoryLink = posts[indexPath.row]["link"] as! String;
        articleReadStatusFileDict[articleStoryLink] = NSNumber(int: 1);
        saveArticlesReadStatusDictToArticlesReadStatusFile();
        self.tableView.reloadData();
        performSegueWithIdentifier("RSSFeed", sender: self);
    }
    
    // readArticlesFile Functions
    //  createReadArticlesFileIfNone()
    //  loadArticlesReadStatusFileToArticlesReadStatusDict()
    //  saveArticlesReadStatusDictToArticlesReadStatusFile()
    //  updateArticlesReadStatusDict()
    //  articleHasBeenRead(index: Int) -> Bool
    //
    //
    
    func createReadArticlesFileIfNone(){
        let fileMgr = NSFileManager.defaultManager();
        
        if(!fileMgr.fileExistsAtPath(articleReadStatusFilePath)){
            if(!fileMgr.createFileAtPath(articleReadStatusFilePath, contents: nil, attributes: articleReadStatusFileDict as [NSObject: AnyObject])){
                println("Error! Creating articleReadStatusFile failed to create at \(articleReadStatusFilePath)");
            }
        }
    }
    
    func loadArticlesReadStatusFileToArticlesReadStatusDict(){
        var dict = NSMutableDictionary(contentsOfFile: articleReadStatusFilePath)!;
        articleReadStatusFileDict = dict;
    }
    
    func saveArticlesReadStatusDictToArticlesReadStatusFile(){
        articleReadStatusFileDict.writeToFile(articleReadStatusFilePath, atomically: true);
    }
    
    func updateArticlesReadStatusDict()
    {
        println("updateArticlesReadStatusDict");
        var newArticlesReadStatusDict: NSMutableDictionary = NSMutableDictionary.alloc();
        var dictHasBeenReadValue: NSNumber = 1;
        var articleStoryLink: NSString = "";
        
        articleStoryLink = posts[0]["link"] as! String;
        newArticlesReadStatusDict = [:];
        for ii in 0...posts.count-1{
            println("updateArticlesReadStatusDict, in for loop");
            articleStoryLink = posts[ii]["link"] as! String;
            
            if(articleReadStatusFileDict.objectForKey(articleStoryLink) != nil &&
                articleReadStatusFileDict.objectForKey(articleStoryLink)!.integerValue == dictHasBeenReadValue.integerValue){
                newArticlesReadStatusDict.setObject(NSNumber(int: 1), forKey: articleStoryLink);
            }
            else{
                newArticlesReadStatusDict.setObject(NSNumber(int: 0), forKey: articleStoryLink);
            }
        }
        articleReadStatusFileDict = newArticlesReadStatusDict;
    }
    
    func articleHasBeenRead(index: Int) -> Bool{
        println("articleHasBeenRead");
        var linkString: String = posts[index]["link"] as! String;
        
        if(articleReadStatusFileDict.objectForKey(linkString) != nil &&
            articleReadStatusFileDict.objectForKey(linkString)?.integerValue == NSNumber(int: 1)){
            return true;
        }
        else{
            return false;
        }
    }
    
    // Parser Functions
    //  parseErrorOccurred parseError: NSError)
    //  beginParsing()
    //  didStartElement elementName: String
    //  foundCharacters string: String?)
    //  didEndElement elementName: String
    //
    //
    
    // Gives the output of errors that occurr during parsing
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError){
        println("error = \(parseError.localizedDescription)");
    }
    
    // Begins the parsing of the XML file
    func beginParsing(){
        //println("beginParsing");
        posts = [];
        parser = NSXMLParser(contentsOfURL: NSURL(string: feed))!;
        parser.delegate = self;
        if(!parser.parse()){
            println("parser failed");
            println("error is \(parser.parserError)");
        }
    }
    
    // Called when a new element is found
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]){
        // println("didStartElement with \(elementName)");
        element = elementName;
        if(element == "item"){
            articleTitle = "";
            articleLink = "";
        }
    }
    
    // Called when a new char is found
    func parser(parser: NSXMLParser, foundCharacters string: String?){
        //println("foundCharacters");
        if(element == "title"){
            articleTitle.appendString(string!);
        }
        else if(element == "link"){
            articleLink.appendString(string!);
        }
    }
    
    // Called when the end of an element is found
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        //println("didEndElement with \(elementName)");
        
        if(elementName == "title"){
            println("title is \(articleTitle)");
        }
        else if(elementName == "link"){
            println("link is \(articleLink)");
        }
        
        if(elementName == "item"){
            if(!(articleTitle.isEqual(nil)) && !articleLink.isEqual(nil)){
                var dictionaryEntry: Dictionary = ["title": (articleTitle as String), "link": (articleLink as String)];
                posts.addObject(dictionaryEntry);
            }
        }
    }
    
    // Segue Functions
    //  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    //      RSSFeed, goes to the webview
    //
    //
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if(segue.identifier == "RSSFeed"){
            let avc = segue.destinationViewController as? MySwiftArticlesViewController;
            var str = posts[selectedArtcileIndex]["link"] as? String;
            
            str = str?.stringByReplacingOccurrencesOfString(" ", withString: "");
            str = str?.stringByReplacingOccurrencesOfString("\n", withString: "");
            str = str?.stringByReplacingOccurrencesOfString("   ", withString: "");
            str = str?.stringByReplacingOccurrencesOfString("\t", withString: "");
            
            avc?.articleLinkString = str;
            println(avc!.articleLinkString);
        }
    }
}