// ###############################################################
// These are the global constants and variables used throughout the project.
// They are listed along with every file in which they are set or referenced.
// ###############################################################
var jsonDownload : NSData = NSData ()
var RPMap : [ResearchProject] = []
var sciOnCall : FSScientist = FSScientist ()

let group = dispatch_group_create()

let iPadDeviceType = UIUserInterfaceIdiom.Pad

let NOTREACHABLE: Int = 0

var cannotContinue = false

var connectedToServer = true

var currentLinkedProject = -1

var currentStoredImages = [String: NSData]()

var displayOldData = false

var netStatus = reachability.currentReachabilityStatus()

var networkConnected = true

var orderedTitles = [String]()

var projectViewRef: ProjectView!

var reachability = Reachability.reachabilityForInternetConnection()

var researchContainerRef = ResearchContainer()

var scientistInfo = [String: String]()

var videoTitleStatuses = [String: String]()