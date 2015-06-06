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

class ResearchContainer: UIViewController {
    
    var researchNavigationController: UINavigationController!
    var projectView: ProjectView!
    var currentState: SlideOutState = .panelCollapsed
    var navigationViewController: ResearchNavigationTableView?
    let panelExpandedOffset: CGFloat = 60
    @IBAction func showProjects(sender: AnyObject) {
        projectView.delegate?.togglePanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectView = UIStoryboard.projectView()
        projectView.delegate = self
        
        researchNavigationController = UINavigationController(rootViewController: projectView)
        view.addSubview(researchNavigationController.view)
        addChildViewController(researchNavigationController)
        researchNavigationController.didMoveToParentViewController(self)
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
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(researchNavigationController.view.frame) - panelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .panelCollapsed
                
                self.navigationViewController!.view.removeFromSuperview()
                self.navigationViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
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