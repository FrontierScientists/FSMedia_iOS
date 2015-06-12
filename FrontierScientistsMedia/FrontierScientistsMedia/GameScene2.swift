//
//  GameScene2.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/10/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import SpriteKit

class GameScene2: SKScene {
    
    var uav = SKSpriteNode()
    var bg = SKSpriteNode()
    var tree = SKSpriteNode()
    var angle:CGFloat = 0.0
    var touched = false
    var touchPosition = CGPointMake(0, 0)
    
    override func didMoveToView(view: SKView) {
        var uavTexture = SKTexture(imageNamed: "Game/uav2.png")
        var bgTexture = SKTexture(imageNamed: "Game/bg.jpg")
        
        var moveBg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 6)
        var replaceBg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var moveBgForever = SKAction.repeatActionForever(SKAction.sequence([moveBg, replaceBg]))
        
        for var i:CGFloat = 0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(moveBgForever)
            self.addChild(bg)
        }
        
        uav = SKSpriteNode(texture: uavTexture)
        uav.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        uav.physicsBody = SKPhysicsBody(circleOfRadius: uav.size.height / 2)
        uav.physicsBody?.dynamic = true
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        self.addChild(uav)
        
        // Add in tree obsticles
        NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "makeTrees", userInfo: nil, repeats: true)
        
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        
        self.addChild(ground)
        
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        touched = true
        for touch: AnyObject in touches {
            touchPosition = touch.locationInNode(self)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Update to new touch location
        for touch: AnyObject in touches {
            touchPosition = touch.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Stop UAV moving actions when touch released
        touched = false
        angle = 0
        uav.runAction(SKAction.rotateToAngle(0, duration: 0.1))
    }
    
    override func update(currentTime: CFTimeInterval) {
        if touched {
            let divider = self.frame.width/3
            let rotateLeft = SKAction.rotateByAngle(0.1, duration: 0.1)
            let rotateRight = SKAction.rotateByAngle(-0.1, duration: 0.1)
            
            if touchPosition.x < divider {
                if angle > -0.2 {
                    angle = angle - 0.1
                    uav.runAction(rotateLeft)
                }
            } else {
                if angle < 0.2 {
                    angle = angle + 0.1
                    uav.runAction(rotateRight)
                }
            }
            uav.runAction(SKAction.moveBy(CGVectorMake(0, -angle*40), duration: 0.1))
        }

    }
    
    func makeTrees() {
        var treeTexture = SKTexture(imageNamed: "Game/tree.png")
        tree = SKSpriteNode(texture: treeTexture)
        let shortener = CGFloat(arc4random_uniform(200))
        tree.position = CGPointMake(self.frame.midX + self.frame.width, self.frame.minY - shortener)
        var moveTree = SKAction.moveByX(-self.frame.width*2, y: 0, duration: 3)
        var removeTree = SKAction.removeFromParent()
        var animateTree = SKAction.sequence([moveTree, removeTree])
        tree.runAction(animateTree)
        
        tree.physicsBody = SKPhysicsBody(texture: tree.texture, size: tree.size)
        tree.physicsBody?.dynamic = false
        
        self.addChild(tree)
    }
}
