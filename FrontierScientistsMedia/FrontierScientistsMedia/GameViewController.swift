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
    @IBOutlet weak var tapIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        tapIcon.image = UIImage(named: "Game/tap.png")
        var leftTutorialDivider = UIView(frame: CGRectMake(self.view.frame.width/3, 0, 1, self.view.frame.height))
        var rightTutorialDivider = UIView(frame: CGRectMake((self.view.frame.width/3)*2, 0, 1, self.view.frame.height))
        leftTutorialDivider.backgroundColor = UIColor.grayColor()
        rightTutorialDivider.backgroundColor = UIColor.grayColor()
        tapScreen.addSubview(leftTutorialDivider)
        tapScreen.addSubview(rightTutorialDivider)
        var leftTapIcon = UIImageView(image: UIImage(named: "Game/finger.png"))
        var leftArrow = UIImageView(image: UIImage(named: "Game/leftArrow.png"))
        var leftUAVIcon = UIImageView(image: UIImage(named: "Game/tutorialUAVIcon.png")?.imageRotatedByDegrees(-15, flip: false))
        var rightTapIcon = UIImageView(image: UIImage(named: "Game/finger.png"))
        var rightArrow = UIImageView(image: UIImage(named: "Game/rightArrow.png"))
        var rightUAVIcon = UIImageView(image: UIImage(named: "Game/tutorialUAVIcon.png")?.imageRotatedByDegrees(15, flip: false))
        leftTapIcon.frame = CGRectMake(self.view.frame.width/6 + 1, (self.view.frame.height/4)*3, self.view.frame.width/6 - 2, self.view.frame.width/6 - 2)
        leftArrow.frame = CGRectMake(1, (self.view.frame.height/4)*3, self.view.frame.width/6 - 2, self.view.frame.width/6 - 2)
        leftUAVIcon.frame = CGRectMake(self.view.frame.width/6 - (self.view.frame.width/3 - 2)/2, (self.view.frame.height/4)*3 - (self.view.frame.width/4 + 2), self.view.frame.width/3 - 2, self.view.frame.width/4)
        rightTapIcon.frame = CGRectMake((self.view.frame.width/3)*2 + 1, (self.view.frame.height/4)*3, self.view.frame.width/6 - 2, self.view.frame.width/6 - 2)
        rightArrow.frame = CGRectMake(self.view.frame.width - self.view.frame.width/6 + 1, (self.view.frame.height/4)*3, self.view.frame.width/6 - 2, self.view.frame.width/6 - 2)
        rightUAVIcon.frame = CGRectMake(self.view.frame.width - self.view.frame.width/6 - (self.view.frame.width/3 - 2)/2, (self.view.frame.height/4)*3 - (self.view.frame.width/4 + 2), self.view.frame.width/3 - 2, self.view.frame.width/4)
        tapScreen.addSubview(leftTapIcon)
        tapScreen.addSubview(leftArrow)
        tapScreen.addSubview(leftUAVIcon)
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

