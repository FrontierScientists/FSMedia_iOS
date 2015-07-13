//
//  ResearchContainer.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/4/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case panelCollapsed
    case panelExpanded
}

var researchContainerRef = ResearchContainer()
var projectViewRef: ProjectView!
var currentLinkedProject = ""
var firstTime = true

class ResearchContainer: UIViewController {
    
    @IBOutlet var openSwipe: UISwipeGestureRecognizer!
    @IBOutlet var closeSwipe: UISwipeGestureRecognizer!
    var researchNavigationController: UINavigationController!
    var projectView: ProjectView!
    var currentState: SlideOutState = .panelCollapsed
    var navigationViewController: ResearchNavigationTableView?
    let panelExpandedOffset: CGFloat = 60
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        researchContainerRef = self
        projectView = UIStoryboard.projectView()
        projectView.delegate = self
        projectViewRef = projectView
        
        researchNavigationController = UINavigationController(rootViewController: projectView)
        view.addSubview(researchNavigationController.view)
        addChildViewController(researchNavigationController)
        researchNavigationController.didMoveToParentViewController(self)
        
        projectView.delegate?.togglePanel?()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (currentState == .panelExpanded) {
            for touch: AnyObject in touches {
                var touchPosition = touch.locationInView(self.view)
                if (CGRectContainsPoint(projectView.view.bounds, touchPosition)) {
                    projectView.delegate?.togglePanel?()
                }
            }
        }
    }
    
    func orientationChanged() {
        if (currentState == .panelExpanded) {
            researchNavigationController.view.frame.size.width = self.view.frame.width
            animateProjectViewXPosition(targetPosition: CGRectGetWidth(researchNavigationController.view.frame) - panelExpandedOffset)
        } else {
            projectView.drawerButton.center.x = projectView.drawerButton.frame.width / 2
        }
    }
}

extension ResearchContainer: ProjectViewDelegate {

    func togglePanel() {
        let notAlreadyExpanded = (currentState != .panelExpanded)
        
        if notAlreadyExpanded {
            addPanelViewController()
        }
        animatePanel(shouldExpand: notAlreadyExpanded)
    }
    func addPanelViewController() {
        if (navigationViewController == nil) { // First time condition
            navigationViewController = UIStoryboard.navigationTableView()
            addChildSidePanelController(navigationViewController!)
        }
    }
    func addChildSidePanelController(sidePanelController: ResearchNavigationTableView) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    func animatePanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .panelExpanded
            animateProjectViewXPosition(targetPosition: CGRectGetWidth(researchNavigationController.view.frame) - panelExpandedOffset)
            if (self.projectView.shadow != nil) {
                UIView.animateWithDuration(0.3, animations: {
                    self.projectView.shadow.alpha = 0.5
                })
                projectView.drawerButton.transform = CGAffineTransformMakeRotation(-3.14)
                projectView.scrollView.userInteractionEnabled = false
            }
        } else {
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
    func animateProjectViewXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.researchNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
}


private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
    class func navigationTableView() -> ResearchNavigationTableView? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("NavigationTableView") as? ResearchNavigationTableView
    }
    
    class func projectView() -> ProjectView? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("ProjectView") as? ProjectView
    }
}