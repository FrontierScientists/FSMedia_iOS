//
//  GameViewController.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/5/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var scene2: GameScene2!
    @IBOutlet weak var tapScreen: UIView!
    
    @IBAction func next(sender: AnyObject) {
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene2 = GameScene2(size: skView.bounds.size)
        scene2!.scaleMode = .AspectFill
        skView.presentScene(scene2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
    
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene = GameScene(size: skView.bounds.size)
        scene!.scaleMode = .AspectFill
        skView.presentScene(scene)
        scene.paused = true
        
        // Format the tutorial tap screen
        // Add in the divider display lines
        var leftTutorialDivider = UIView(frame: CGRectMake(self.view.frame.width/3, 0, 1, self.view.frame.height))
        var rightTutorialDivider = UIView(frame: CGRectMake((self.view.frame.width/3)*2, 0, 1, self.view.frame.height))
        leftTutorialDivider.backgroundColor = UIColor.grayColor()
        rightTutorialDivider.backgroundColor = UIColor.grayColor()
        tapScreen.addSubview(leftTutorialDivider)
        tapScreen.addSubview(rightTutorialDivider)
        // Add in the arrows, tap icons and uav icons for the flying directions
        var leftTapIcon = UIImageView(image: UIImage(named: "Game/finger.png"))
        var leftArrow = UIImageView(image: UIImage(named: "Game/leftArrow.png"))
        var leftUAVIcon = UIImageView(image: UIImage(named: "Game/tutorialUAVIcon.png")?.imageRotatedByDegrees(-15, flip: false))
        var upTapIcon = UIImageView(image: UIImage(named: "Game/finger.png"))
        var upArrow = UIImageView(image: UIImage(named: "Game/upArrow.png"))
        var upUAVIcon = UIImageView(image: UIImage(named: "Game/tutorialUAVIcon.png"))
        var rightTapIcon = UIImageView(image: UIImage(named: "Game/finger.png"))
        var rightArrow = UIImageView(image: UIImage(named: "Game/rightArrow.png"))
        var rightUAVIcon = UIImageView(image: UIImage(named: "Game/tutorialUAVIcon.png")?.imageRotatedByDegrees(15, flip: false))
        
        let sixthWidth = self.view.frame.width/6
        let fourthWidth = self.view.frame.width/4
        let thridWidth = self.view.frame.width/3
        let halfWidth = self.view.frame.width/2
        let fourthHeight = self.view.frame.height/4
        
        leftTapIcon.frame = CGRectMake(sixthWidth + 1, fourthHeight*3, sixthWidth - 2, sixthWidth - 2)
        leftArrow.frame = CGRectMake(1, fourthHeight*3, sixthWidth - 2, sixthWidth - 2)
        leftUAVIcon.frame = CGRectMake(sixthWidth/2 + 1, fourthHeight*3 - (fourthWidth/2 + 2), sixthWidth - 2, fourthWidth/2)
        upTapIcon.frame = CGRectMake(halfWidth - (sixthWidth - 2)/2, fourthHeight*3, sixthWidth - 2, sixthWidth - 2)
        upArrow.frame = CGRectMake(halfWidth - (sixthWidth - 2)/2, fourthHeight*3 - sixthWidth - 2, sixthWidth - 2, sixthWidth - 2)
        upUAVIcon.frame = CGRectMake(halfWidth - sixthWidth/2, fourthHeight*3 - (sixthWidth - 2)*2 - 2, sixthWidth - 2, sixthWidth/2)
        rightTapIcon.frame = CGRectMake(thridWidth*2 + 1, fourthHeight*3, sixthWidth - 2, sixthWidth - 2)
        rightArrow.frame = CGRectMake(self.view.frame.width - sixthWidth + 1, fourthHeight*3, sixthWidth - 2, sixthWidth - 2)
        rightUAVIcon.frame = CGRectMake(self.view.frame.width - sixthWidth - (sixthWidth/2 + 1), fourthHeight*3 - (fourthWidth/2 + 2), sixthWidth - 2, fourthWidth/2)
        tapScreen.addSubview(leftTapIcon)
        tapScreen.addSubview(leftArrow)
        tapScreen.addSubview(leftUAVIcon)
        tapScreen.addSubview(upTapIcon)
        tapScreen.addSubview(upArrow)
        tapScreen.addSubview(upUAVIcon)
        tapScreen.addSubview(rightTapIcon)
        tapScreen.addSubview(rightArrow)
        tapScreen.addSubview(rightUAVIcon)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        tapScreen.hidden = true
        scene.paused = false
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

