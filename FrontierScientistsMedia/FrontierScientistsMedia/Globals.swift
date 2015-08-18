//  Globals.swift
/* 
    These are the global constants and variables used throughout the project. 
    They are listed along with every file in which they are set or referenced.
*/

//  Global Constant                                                    Files Containing Constant
//  ---------------                                                    -------------------------

let group = dispatch_group_create()                                 // AppDelegate.swift
                                                                    // ViewController.swift

let iPadDeviceType = UIUserInterfaceIdiom.Pad                       // ArticlesTableViewController.swift
                                                                    // AskViewController.swift
                                                                    // VideoTableViewController.swift

let NOTREACHABLE: Int = 0                                           // AboutViewController.swift
                                                                    // AppDelegate.swift
                                                                    // AskViewController.swift
                                                                    // MapViewController.swift
                                                                    // VideoTableViewController.swift
                                                                    // ViewController.swift


//  Global Variable                                                    Files Containing Variable
//  ---------------                                                    -------------------------

var aboutCurrentImage = "about_icon.jpg"                            // AboutImageViewController.swift
                                                                    // AboutViewController.swift

var aboutInfo = [String: AnyObject]()                               // AboutViewController.swift
                                                                    // ContentUpdater.swift
                                                                    // ImageProcessor.swift

var cannotContinue = false                                          // AppDelegate.swift
                                                                    // ContentUpdater.swift
                                                                    // ViewController.swift

var connectedToServer = true                                        // ContentUpdater.swift
                                                                    // ViewController.swift

var currentLinkedProject = ""                                       // MapViewController.swift
                                                                    // ProjectView.swift
                                                                    // ResearchContainer.swift

var currentStoredImages = [String: NSData]()                        // ImageProcessor.swift

var displayOldData = false                                          // AppDelegate.swift
                                                                    // ContentUpdater.swift
                                                                    // ViewController.swift

var iosProjectData: Array<Dictionary<String, AnyObject>> = []       // ContentUpdater.swift
                                                                    // ProjectView.swift
                                                                    // VideoTableViewController.swift

var netStatus = reachability.currentReachabilityStatus()            // AboutViewController.swift
                                                                    // AppDelegate.swift
                                                                    // AskViewController.swift
                                                                    // MapViewController.swift
                                                                    // VideoTableViewController.swift
                                                                    // ViewController.swift

var networkConnected = true                                         // AppDelegate.swift
                                                                    // ViewController.swift

var orderedTitles = [String]()                                      // ContentUpdater.swift
                                                                    // MapViewController.swift
                                                                    // ProjectView.swift
                                                                    // ResearchContainer.swift
                                                                    // ResearchNavigationTableView.swift

var projectData = [String: [String: AnyObject]]()                   // ContentUpdater.swift
                                                                    // ImageProcessor.swift
                                                                    // MapViewController.swift
                                                                    // ProjectView.swift
                                                                    // ResearchNavigationTableView.swift

var projectTitle = ""                                               // ProjectView.swift
                                                                    // ResearchNavigationTableView.swift

var projectViewRef: ProjectView!                                    // ResearchContainer.swift
                                                                    // ResearchNavigationTableView.swift

var reachability = Reachability.reachabilityForInternetConnection() // AboutViewController.swift
                                                                    // AppDelegate.swift
                                                                    // AskViewController.swift
                                                                    // MapViewController.swift
                                                                    // VideoTableViewController.swift
                                                                    // ViewController.swift

var researchContainerRef = ResearchContainer()                      // ProjectView.swift
                                                                    // ResearchContainer.swift

var savedImages = [String]()                                        // ImageProcessor.swift

var scientistInfo = [String: String]()                              // AskViewController.swift
                                                                    // ContentUpdater.swift
                                                                    // ImageProcessor.swift

var selectedResearchProjectIndex: Int = 0                           // ProjectView.swift
                                                                    // VideoTableViewController.swift

var storedImages = [String: UIImage]()                              // AboutImageViewController.swift
                                                                    // AboutViewController.swift
                                                                    // AskViewController.swift
                                                                    // ImageProcessor.swift
                                                                    // MapViewController.swift
                                                                    // ProjectView.swift
                                                                    // ResearchNavigationTableView.swift

var videoTitleStatuses = [String: String]()                         // VideoDownloadHelper.swift
                                                                    // VideoTableViewController.swift