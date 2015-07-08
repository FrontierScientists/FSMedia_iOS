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
var notFirstTime = false

class ResearchContainer: UIViewController {
    
    var researchNavigationController: UINavigationController!
    var projectView: ProjectView!
    var currentState: SlideOutState = .panelCollapsed
    var navigationViewController: ResearchNavigationTableView?
    let panelExpandedOffset: CGFloat = 60
    @IBAction func showProjects(sender: AnyObject) {
        if notFirstTime {
            projectView.delegate?.togglePanel?()
            if (currentState == .panelExpanded) {
                projectView.scrollView.userInteractionEnabled = false
            }
        }
    }
    @IBAction func goToMenu(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        notFirstTime = false
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
        currentState = .panelExpanded
        
        if currentLinkedProject != "" {
            // Go to that page
            currentLinkedProject = ""
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (currentState == .panelExpanded) {
            for touch: AnyObject in touches {
                var touchPosition = touch.locationInView(self.view)
                if (CGRectContainsPoint(projectView.view.bounds, touchPosition)) {
                    projectView.delegate?.togglePanel?()
                    projectView.scrollView.userInteractionEnabled = true
                    projectView.projectText.setContentOffset(CGPointZero, animated: false) // Start text at top
                    notFirstTime = true
                }
            }
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
        if (navigationViewController == nil) {
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
        } else {
            animateProjectViewXPosition(targetPosition: 0) { finished in
                self.currentState = .panelCollapsed
                
                self.navigationViewController!.view.removeFromSuperview()
                self.navigationViewController = nil;
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
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func navigationTableView() -> ResearchNavigationTableView? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("NavigationTableView") as? ResearchNavigationTableView
    }
    
    class func projectView() -> ProjectView? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("ProjectView") as? ProjectView
    }
}