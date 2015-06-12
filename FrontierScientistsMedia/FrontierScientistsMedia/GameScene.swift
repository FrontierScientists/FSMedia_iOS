//
//  GameScene.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/5/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var firstTouch = true
    var gameHasBegun = false
    var uav = SKSpriteNode()
    var bg = SKSpriteNode()
    var land = SKSpriteNode()
    var catcher = SKSpriteNode()
    var boat = SKSpriteNode()
    var wave = SKSpriteNode()
    var waveFg = SKSpriteNode()
    var angle:CGFloat = 0.0
    var touched = false
    var touchPosition = CGPointMake(0, 0)
    let interval:NSTimeInterval = 0.3
    var handPosition = CGPoint(x: 0, y: 0)
    
    override func didMoveToView(view: SKView) {
        var UAVTexture = SKTexture(imageNamed: "Game/uav.png")
        var bgTexture = SKTexture(imageNamed: "Game/bg.jpg")
        var landTexture = SKTexture(imageNamed: "Game/land.png")
        var boatTexture = SKTexture(imageNamed: "Game/boat.png")
        var waveTexture = SKTexture(imageNamed: "Game/wave.png")
        var waveFgTexture = SKTexture(imageNamed: "Game/waveFg.png")
        var catcherTexture = SKTexture(imageNamed: "Game/catcher.png")
        
        var moveWaveUp = SKAction.moveBy(CGVectorMake(0, 10), duration: 1.0)
        var moveWaveDown = SKAction.moveBy(CGVectorMake(0, -10), duration: 1.0)
        var moveWaveLeft = SKAction.moveByX(-5, y: 0, duration: 2.0)
        var moveWaveRight = SKAction.moveByX(5, y: 0, duration: 2.0)
        var moveBoatUp = SKAction.moveBy(CGVectorMake(0, 8), duration: 1.2)
        var moveBoatDown = SKAction.moveBy(CGVectorMake(0, -8), duration: 1.2)
        var rotateCatcherRight = SKAction.rotateByAngle(0.1, duration: 0.1)
        var rotateCatcherLeft = SKAction.rotateByAngle(-0.1, duration: 0.1)
        var moveWaveUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveWaveUp, moveWaveDown]))
        var moveWaveFgUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveWaveDown, moveWaveUp]))
        var moveWaveLeftAndRight = SKAction.repeatActionForever(SKAction.sequence([moveWaveLeft, moveWaveRight]))
        var moveWaveFgLeftAndRight = SKAction.repeatActionForever(SKAction.sequence([moveWaveRight, moveWaveLeft]))
        var moveBoatUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveBoatDown, moveBoatUp]))
        var shakeCatcher = SKAction.repeatActionForever(SKAction.sequence([rotateCatcherRight, rotateCatcherLeft]))
        
        for var i:CGFloat = 0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            land = SKSpriteNode(texture: landTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            land.position = CGPoint(x: landTexture.size().width/2 + landTexture.size().width * i, y: CGRectGetMinY(self.frame))
            bg.size.height = self.frame.height
            self.addChild(bg)
            self.addChild(land)
        }
        
        catcher = SKSpriteNode(texture: catcherTexture)
        boat = SKSpriteNode(texture: boatTexture)
        boat.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + 65)
        catcher.position = CGPointMake(CGRectGetMidX(self.frame), boat.position.y + 30 + catcher.size.height/2)
        catcher.runAction(SKAction.rotateToAngle(-0.05, duration: 0))
        catcher.runAction(shakeCatcher)
        catcher.runAction(moveBoatUpAndDown)
        boat.runAction(moveBoatUpAndDown)
        self.addChild(catcher)
        self.addChild(boat)
        
        for var i:CGFloat = 0; i < 3; i++ {
            wave = SKSpriteNode(texture: waveTexture)
            waveFg = SKSpriteNode(texture: waveFgTexture)
            wave.position = CGPoint(x: waveTexture.size().width/2 + waveTexture.size().width * i - 15, y: CGRectGetMinY(self.frame) + 10)
            waveFg.position = CGPoint(x: waveFgTexture.size().width/2 + waveFgTexture.size().width * i - 15, y: CGRectGetMinY(self.frame) - 5)
            wave.runAction(moveWaveUpAndDown)
            wave.runAction(moveWaveLeftAndRight)
            waveFg.runAction(moveWaveFgUpAndDown)
            waveFg.runAction(moveWaveFgLeftAndRight)
            self.addChild(wave)
            self.addChild(waveFg)
        }
        
        uav = SKSpriteNode(texture: UAVTexture)
        uav.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + CGRectGetMidY(self.frame)/2)
        
        uav.physicsBody = SKPhysicsBody(circleOfRadius: uav.size.height / 2)
        uav.physicsBody?.dynamic = true
        uav.physicsBody?.allowsRotation = false
        self.physicsWorld.gravity = CGVectorMake(0, -1)
        
        self.addChild(uav)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        touched = true
        if firstTouch {
            firstTouch = false
            gameHasBegun = true
            touched = false
        }        
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        if gameHasBegun {
            gameHasBegun = false
            NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "moveBoat", userInfo: nil, repeats: true)
            NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "moveCatcher", userInfo: nil, repeats: true)
        }
        
        if touched {
            let leftDivider = self.frame.width/3
            let rightDivider = leftDivider*2
            let rotateLeft = SKAction.rotateByAngle(0.1, duration: 0.2)
            let rotateRight = SKAction.rotateByAngle(-0.1, duration: 0.2)
        
            if touchPosition.x < leftDivider {
                if angle > -0.2 {
                    angle = angle - 0.1
                    uav.runAction(rotateLeft)
                }
            } else if touchPosition.x > rightDivider {
                if angle < 0.2 {
                    angle = angle + 0.1
                    uav.runAction(rotateRight)
                }
            }
            uav.physicsBody?.applyImpulse(CGVectorMake(angle, 1))
        }
        handPosition = CGPoint(x: catcher.position.x - 40, y: catcher.position.y + 25)
        let withinXBounds = uav.position.x > handPosition.x - 7 && uav.position.x < handPosition.x + 7
        let withinYBounds = uav.position.y > handPosition.y - 7 && uav.position.y < handPosition.y + 7
        if withinXBounds && withinYBounds {
            uav.runAction(SKAction.rotateToAngle(0, duration: 0))
            self.paused = true
            uav.position = handPosition
        }
    }
    
    func moveBoat() {
        var x:CGFloat = 0.0
        if boat.position.x <= self.frame.minX {
            x = 10.0
        } else if boat.position.x >= self.frame.maxX {
            x = -10.0
        } else {
            let left = CGFloat(arc4random_uniform(2))
            if left == 1 {
                x = -10.0
            } else {
                x = 10.0
            }
        }
        var moveBoatLeftOrRght = SKAction.moveByX(x, y: 0, duration: 0.3)
        boat.runAction(moveBoatLeftOrRght)
    }
    
    func moveCatcher() {
        var x:CGFloat = 0.0
        if catcher.position.x <= boat.position.x - 50 {
            x = 8.0
        } else if catcher.position.x >= boat.position.x + boat.position.x/2 {
            x = -8.0
        } else {
            let left = CGFloat(arc4random_uniform(2))
            if left == 1 {
                x = -8.0
            } else {
                x = 8.0
            }
        }
        var moveCatcherLeftOrRght = SKAction.moveByX(x, y: 0, duration: 0.3)
        catcher.runAction(moveCatcherLeftOrRght)
    }
}

