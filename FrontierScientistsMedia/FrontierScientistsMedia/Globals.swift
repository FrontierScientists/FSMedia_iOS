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
                                                                    // VideoTableViewController.swift

let NOTREACHABLE: Int = 0                                           // AppDelegate.swift
                                                                    // AskViewController.swift
                                                                    // MapViewController.swift
                                                                    // VideoTableViewController.swift
                                                                    // ViewController.swift

//  Global Variable                                                    Files Containing Variable
//  ---------------                                                    -------------------------

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

var netStatus = reachability.currentReachabilityStatus()            // AppDelegate.swift
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
                                                                    // VideoTableViewController.swift

var projectData = [String: [String: AnyObject]]()                   // ContentUpdater.swift
                                                                    // ImageProcessor.swift
                                                                    // MapViewController.swift
                                                                    // ProjectView.swift
                                                                    // ResearchNavigationTableView.swift
                                                                    // VideoTableViewController.swift

var projectTitle = ""                                               // MapViewController.swift
                                                                    // ProjectView.swift
                                                                    // ResearchNavigationTableView.swift

var projectViewRef: ProjectView!                                    // ResearchContainer.swift
                                                                    // ResearchNavigationTableView.swift

var reachability = Reachability.reachabilityForInternetConnection() // AppDelegate.swift
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

var storedImages = [String: UIImage]()                              // AskViewController.swift
                                                                    // ImageProcessor.swift
                                                                    // MapViewController.swift
                                                                    // ProjectView.swift
                                                                    // ResearchNavigationTableView.swift

var videoTitleStatuses = [String: String]()                         // VideoDownloadHelper.swift
                                                                    // VideoTableViewController.swift