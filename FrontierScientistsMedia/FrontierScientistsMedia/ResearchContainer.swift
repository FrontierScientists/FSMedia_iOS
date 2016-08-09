//  ResearchContainer.swift

import UIKit
import Foundation
import QuartzCore

enum SlideOutState {
    case panelCollapsed
    case panelExpanded
}

/*
    This is the ResearchContainer class, responsable for handling the two different components
    of the Research section: ResearchNavigationTableView and ProjectView. The two scenes interact
    with each other through TableView cell selection, an open/close drawer button and swipe gestures.
    The side panel is the ResearchNavigationTableView.
*/
class ResearchContainer: UIViewController {
    
/*
    Outlets
*/
    @IBOutlet var openSwipe: UISwipeGestureRecognizer!
    @IBOutlet var closeSwipe: UISwipeGestureRecognizer!
/*
    Actions
*/
    @IBAction func showProjects(sender: AnyObject) {
        projectView.delegate?.togglePanel?()
    }
    @IBAction func openDrawer(sender: AnyObject) { // On swipe
        if (currentState == .panelCollapsed) {
            projectView.delegate?.togglePanel!()
        }
    }
    @IBAction func closeDrawer(sender: AnyObject) { // On swipe
        if (currentState == .panelExpanded) {
            projectView.delegate?.togglePanel!()
        }
    }
/*
    Class Variables
*/
    var researchNavigationController: UINavigationController!
    var projectView: ProjectView!
    var currentState: SlideOutState = .panelCollapsed
    var navigationViewController: ResearchNavigationTableView?
    var panelExpandedOffset: CGFloat = 60
    var firstTime = true
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Formalities: set UIStoryboard components
        researchContainerRef = self
        projectView = UIStoryboard.projectView()
        projectView.delegate = self
        projectViewRef = projectView
        
        researchNavigationController = UINavigationController(rootViewController: projectView)
        view.addSubview(researchNavigationController.view)
        addChildViewController(researchNavigationController)
        researchNavigationController.didMoveToParentViewController(self)
        
        self.projectView.delegate?.togglePanel?() // Toggle first to initialize the navigationViewController
        
        if currentLinkedProject != -1 {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                let index = currentLinkedProject
                let rowToSelect:NSIndexPath = NSIndexPath(forRow: index, inSection: 0)
                self.navigationViewController?.navigationTableView.scrollToRowAtIndexPath(rowToSelect, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                self.navigationViewController!.tableView(self.navigationViewController!.navigationTableView, didSelectRowAtIndexPath: rowToSelect)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.6 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    self.projectView.projectText.setContentOffset(CGPointZero, animated: false)
                }
                // currentLinkedProject = -1
            }
        } else {
            // The purpose of this delay is to allow the project view to properly load before opening the drawer for initial display.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.navigationViewController!.tableView(self.navigationViewController!.navigationTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                self.projectView.delegate?.togglePanel?() // Toggle again to start the display with the drawer open
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ResearchContainer.orientationChanged), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    // touchesBegan
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (currentState == .panelExpanded) {
            for touch: AnyObject in touches {
                let touchPosition = touch.locationInView(self.view)
                if (CGRectContainsPoint(projectView.view.bounds, touchPosition)) {
                    projectView.delegate?.togglePanel?()
                }
            }
        }
    }
    
/*
    Helper and Content Functions
*/
    // orientationChanged
    // This function resets the width of the ResearchNavigationTableView component due to abnormal constaint performance
    // on the occurance of an oriantation change.
    func orientationChanged() {
        if (currentState == .panelExpanded) {
            researchNavigationController.view.frame.size.width = self.view.frame.width
            animateProjectViewXPosition(targetPosition: CGRectGetWidth(researchNavigationController.view.frame) - panelExpandedOffset)
        }
    }
}

// ProjectView Delegate
extension ResearchContainer: ProjectViewDelegate {
    // togglePanel
    // This function ensures the ResearchNavigationTableView controller is added to the ResearchContainer and animates 
    // the panel to open or close.
    func togglePanel() {
        let notAlreadyExpanded = (currentState != .panelExpanded)
        
        if notAlreadyExpanded {
            addPanelViewController()
        }
        animatePanel(shouldExpand: notAlreadyExpanded)
    }
    // addPanelViewController
    // This function only executes its content on the first time it is called. It simply adds the 
    // ResearchNavigationTableView controller to the ResearchContainer.
    func addPanelViewController() {
        if (navigationViewController == nil) { // First time condition
            navigationViewController = UIStoryboard.navigationTableView()
            addChildSidePanelController(navigationViewController!)
        }
    }
    // addChildSidePanelController
    func addChildSidePanelController(sidePanelController: ResearchNavigationTableView) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    // animatePanel
    // This function is called when the side panel is to be closed or opened (collapsed or expanded). It ensures proper
    // animations in both cases.
    func animatePanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) { // When closed (being opened)
            currentState = .panelExpanded
            animateProjectViewXPosition(targetPosition: CGRectGetWidth(researchNavigationController.view.frame) - panelExpandedOffset)
            if (self.projectView.shadow != nil) {
                UIView.animateWithDuration(0.3, animations: {
                    self.projectView.shadow.alpha = 0.5
                })
                projectView.drawerButton.transform = CGAffineTransformMakeRotation(-3.14)
                projectView.scrollView.userInteractionEnabled = false
            }
        } else { // When opened (being closed)
            self.currentState = .panelCollapsed
            animateProjectViewXPosition(targetPosition: 0)
            UIView.animateWithDuration(0.3, animations: {
                self.projectView.shadow.alpha = 0.0
            })
            projectView.drawerButton.transform = CGAffineTransformMakeRotation(-3.14*2)
            projectView.scrollView.userInteractionEnabled = true
            if firstTime {
                firstTime = false
                projectView.projectText.setContentOffset(CGPointZero, animated: false) // Start text at top
            }
        }
    }
    // animateProjectViewXPosition
    // This is the animation function for the panel, called for opening and closing. It is a simple call to
    // UIView.animateWithDuration().
    func animateProjectViewXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.researchNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
}

/*
    UIStoryboard Extension
*/
private extension UIStoryboard {
    // mainStoryboard
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    // This component is for the ResearchNavigationTableView
    class func navigationTableView() -> ResearchNavigationTableView? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("NavigationTableView") as? ResearchNavigationTableView
    }
    // This component is for the ProjectView
    class func projectView() -> ProjectView? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("ProjectView") as? ProjectView
    }
}