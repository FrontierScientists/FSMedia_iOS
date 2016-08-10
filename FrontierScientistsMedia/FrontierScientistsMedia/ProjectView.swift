import UIKit
// ###############################################################
@objc
protocol ProjectViewDelegate {
    optional func togglePanel()
    optional func collapsePanel()
}
// ###############################################################
//    This is the ProjectView class, responsable for displaying the preview image and project description for
//    each project, as specified in projectData.
//    Included are a link to the Videos section, which will open to the listing for the current project, and a
//    link to the Maps section, which will open zoomed in on the expanded marker for the current project.
// ###############################################################
class ProjectView: UIViewController {
// ###############################################################
// Outlets
// ###############################################################
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectText: UITextView!
    @IBOutlet weak var links: UITableView!
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var drawerButton: UIButton!
// ###############################################################
// Actions
// ###############################################################
    @IBAction func drawerButtonPressed(sender: AnyObject) {
        delegate?.togglePanel?()
    }
// ###############################################################
// Class Variables
// ###############################################################
    var linkTitles = ["Videos", "Maps"]
    var linkIcons = [UIImage(named: "video_icon.png"), UIImage(named: "map_icon.png")]
    var delegate: ProjectViewDelegate?
// ###############################################################
// Functions
// ###############################################################
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial setup and beautification
        self.view.frame = CGRectMake(0, 0, self.view.bounds.width, researchContainerRef.view.bounds.height)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        projectText.backgroundColor = UIColor.clearColor()
        projectText.font = UIFont(name: "Chalkduster", size: 17)
        links.backgroundColor = UIColor.clearColor()
        links.separatorColor = UIColor.clearColor()

        let text = RPMap[0].description

        let image:UIImage = RPMap[0].image

        projectImage.image = image
        projectText.text = text
        drawerButton.transform = CGAffineTransformMakeRotation(-3.14)
    }
    // noVideosAlert
    // This function alerts the user when there are no videos available for the current project. The options given are
    // to continue to the Videos section or stay on the current page.
    func noVideosAlert() {
        let ALERTMESSAGE = "There are no videos for this research project. Would you still like to continue to videos?"
        let alert = UIAlertController(title: ALERTMESSAGE, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler:nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) in
            researchContainerRef.performSegueWithIdentifier("videosLink", sender: nil)
        }));
        researchContainerRef.presentViewController(alert, animated: true, completion: nil)
    }
}
// ###############################################################
// TableView Functions
// ###############################################################
// TableView Data Source
extension ProjectView: UITableViewDataSource {
    // numberOfSectionsInTableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    // cellForRowAtIndexPath
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("link")! 
        cell.textLabel?.text = linkTitles[indexPath.row]
        cell.imageView?.image = linkIcons[indexPath.row]
        cell.textLabel!.font = UIFont(name: "Chalkduster", size: 17)
        cell.textLabel!.textColor = UIColorFromRGB(0x3E3535)
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}
// TableView Delegate
extension ProjectView: UITableViewDelegate {
    // didSelectRowAtIndexPath
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 { // Videos
            if (RPMap[currentLinkedProject].videos.count == 0) {
                noVideosAlert()
            } else {
                print(RPMap[currentLinkedProject].title)
                researchContainerRef.performSegueWithIdentifier("videosLink", sender: nil)
            }
        } else { // Maps
            researchContainerRef.performSegueWithIdentifier("mapsLink", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // Deselect the selected link
    }
}
