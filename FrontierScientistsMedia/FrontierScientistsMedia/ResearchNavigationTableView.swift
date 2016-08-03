//  ResearchNavigationTableView.swift

import UIKit

@objc
protocol ResearchNavigationTableViewDelegate {
    func projectSelected(title: String, image: UIImage)
}

/*
    This is the ResearchNavigationTableView class, responsable for displaying the research project titles in
    a TableView. When a cell is selected, the panel is toggled and the ProjectView with the information of the
    specified project is displayed.
*/
class ResearchNavigationTableView: UIViewController {
    
/*
    Outlets
*/
    @IBOutlet weak var navigationTableView: UITableView!
    @IBOutlet weak var binding: UIView!
    @IBOutlet weak var page: UIView!
    @IBOutlet weak var shadow: UIImageView!
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Beautification
        navigationTableView.separatorColor = UIColor.clearColor()
        navigationTableView.backgroundColor = UIColor.clearColor()
        shadow.backgroundColor = UIColor(patternImage: UIImage(named: "drawer_shadow.png")!)
        binding.backgroundColor = UIColor(patternImage: UIImage(named: "navigation_bg.jpg")!)
        page.backgroundColor = UIColor(patternImage: UIImage(named: "page.jpeg")!)
    }
}

/*
    TableView Functions
*/
// TableView Data Source
extension ResearchNavigationTableView: UITableViewDataSource {
    // numberOfSectionsInTableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return projectData.keys.count
        return RPMap.count
    }
    // cellForRowAtIndexPath
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cell setup with current project image and title
        let cell: CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("project") as! CustomTableViewCell
        let projectTitle = RPMap[indexPath.row].title
        let image:UIImage = RPMap[indexPath.row].image
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.15, 0.225))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.cellLabel.text = projectTitle
        cell.imageView?.image = scaledImage
        cell.cellLabel.font = UIFont(name: "Chalkduster", size: 17)
        cell.cellLabel.textColor = UIColorFromRGB(0x3E3535)
        cell.cellLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
}
// TableView Delegate
extension ResearchNavigationTableView: UITableViewDelegate {
    // didSelectRowAtIndexPath
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        projectTitle = RPMap[indexPath.row].title

        currentLinkedProject = indexPath.row

        // Set the referenced ProjectView with the selected project's information
        projectViewRef.projectImage.image = RPMap[indexPath.row].image
        projectViewRef.projectText.text = RPMap[indexPath.row].description
        
        projectViewRef.projectText.setContentOffset(CGPointZero, animated: false) // Start text at top
        projectViewRef.scrollView.setContentOffset(CGPointMake(0, -64), animated: false) // Start scroll view at top (below naviagtion bar)
        projectViewRef.delegate?.togglePanel?()
        projectViewRef.drawerButton.center.x = 30
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}