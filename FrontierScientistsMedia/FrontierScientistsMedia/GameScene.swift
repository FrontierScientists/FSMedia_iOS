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
    var touched = false
    var failed = false
    
    var container = SKNode()
    var bg = SKSpriteNode()
    var land = SKSpriteNode()
    var catcher = SKSpriteNode()
    var boat = SKSpriteNode()
    var wave = SKSpriteNode()
    var waveFg = SKSpriteNode()
    var uav = SKSpriteNode()
    
    var angle:CGFloat = 0.0
    var touchPosition = CGPointMake(0, 0)
    let interval:NSTimeInterval = 0.3
    var handPosition = CGPoint(x: 0, y: 0)
    
    var batteryLife:CGFloat = 100
    var battery = Battery(timeCapacity: 0, frameWidth: 0)
    var levelAltitude:CGFloat = 100
    var altitude = UILabel()
    
    var pauseMenu = SKNode()
    var pauseButton = SKSpriteNode()
    var pauseScreen = SKShapeNode()
    var movePauseMenuOff = SKAction()
    var movePauseMenuOn = SKAction()
    var pauseAnimationInterval:NSTimeInterval = 0.5
    
    var batteryTimer = NSTimer()
    
    override func didMoveToView(view: SKView) {
        // All textures declared here
        var UAVTexture = SKTexture(imageNamed: "Game/uav.png")
        var bgTexture = SKTexture(imageNamed: "Game/bg.jpg")
        var landTexture = SKTexture(imageNamed: "Game/land.png")
        var boatTexture = SKTexture(imageNamed: "Game/boat.png")
        var waveTexture = SKTexture(imageNamed: "Game/wave.png")
        var waveFgTexture = SKTexture(imageNamed: "Game/waveFg.png")
        var catcherTexture = SKTexture(imageNamed: "Game/catcher.png")
        var pauseButtonTexture = SKTexture(imageNamed: "Game/pause.png")
        // Actions declared here
        var moveWaveUp = SKAction.moveBy(CGVectorMake(0, 10), duration: 1.0)
        var moveWaveDown = SKAction.moveBy(CGVectorMake(0, -10), duration: 1.0)
        var moveWaveLeft = SKAction.moveByX(-5, y: 0, duration: 2.0)
        var moveWaveRight = SKAction.moveByX(5, y: 0, duration: 2.0)
        var moveBoatUp = SKAction.moveBy(CGVectorMake(0, 8), duration: 1.2)
        var moveBoatDown = SKAction.moveBy(CGVectorMake(0, -8), duration: 1.2)
        var rotateCatcherRight = SKAction.rotateByAngle(0.1, duration: 0.1)
        var rotateCatcherLeft = SKAction.rotateByAngle(-0.1, duration: 0.1)
        movePauseMenuOff = SKAction.moveByX(self.frame.width, y: 0, duration: pauseAnimationInterval)
        movePauseMenuOn = SKAction.moveByX(-self.frame.width, y: 0, duration: pauseAnimationInterval)
        var moveWaveUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveWaveUp, moveWaveDown]))
        var moveWaveFgUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveWaveDown, moveWaveUp]))
        var moveWaveLeftAndRight = SKAction.repeatActionForever(SKAction.sequence([moveWaveLeft, moveWaveRight]))
        var moveWaveFgLeftAndRight = SKAction.repeatActionForever(SKAction.sequence([moveWaveRight, moveWaveLeft]))
        var moveBoatUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveBoatDown, moveBoatUp]))
        var shakeCatcher = SKAction.repeatActionForever(SKAction.sequence([rotateCatcherRight, rotateCatcherLeft]))
        // The land and the background are displayed repeated 3 times across (accounts for differing screen sizes)
        for var i:CGFloat = 0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            land = SKSpriteNode(texture: landTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            land.position = CGPoint(x: landTexture.size().width/2 + landTexture.size().width * i, y: CGRectGetMinY(self.frame))
            bg.size.height = self.frame.height
            container.addChild(bg)
            container.addChild(land)
        }
        // The catcher and boat are then set up
        catcher = SKSpriteNode(texture: catcherTexture)
        boat = SKSpriteNode(texture: boatTexture)
        boat.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + 65)
        catcher.position = CGPointMake(CGRectGetMidX(self.frame), boat.position.y + 30 + catcher.size.height/2)
        catcher.runAction(SKAction.rotateToAngle(-0.05, duration: 0))
        catcher.runAction(shakeCatcher)
        catcher.runAction(moveBoatUpAndDown)
        boat.runAction(moveBoatUpAndDown)
        container.addChild(catcher)
        container.addChild(boat)
        // Here the waves are created and repeated 3 times (again for screen size purposes)
        for var i:CGFloat = 0; i < 3; i++ {
            wave = SKSpriteNode(texture: waveTexture)
            waveFg = SKSpriteNode(texture: waveFgTexture)
            wave.position = CGPoint(x: waveTexture.size().width/2 + waveTexture.size().width * i - 15, y: CGRectGetMinY(self.frame) + 10)
            waveFg.position = CGPoint(x: waveFgTexture.size().width/2 + waveFgTexture.size().width * i - 15, y: CGRectGetMinY(self.frame) - 5)
            wave.runAction(moveWaveUpAndDown)
            wave.runAction(moveWaveLeftAndRight)
            waveFg.runAction(moveWaveFgUpAndDown)
            waveFg.runAction(moveWaveFgLeftAndRight)
            container.addChild(wave)
            container.addChild(waveFg)
        }
        // The UAV information tools are added
        battery = Battery(timeCapacity: batteryLife, frameWidth: self.frame.width)
        self.view?.addSubview(battery.powerView)
        self.view?.addSubview(battery.batteryView)
        altitude = UILabel(frame: CGRectMake(1, 1, 60, 20))
        altitude.textAlignment = NSTextAlignment.Center
        self.view?.addSubview(altitude)
        // The pause button is added
        pauseButton = SKSpriteNode(texture: pauseButtonTexture)
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.position = CGPoint(x: pauseButton.frame.width/2, y: self.frame.height - pauseButton.frame.height/2 - 25)
        // The UAV itself is included
        uav = SKSpriteNode(texture: UAVTexture)
        uav.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + CGRectGetMidY(self.frame)/2)
        altitude.text = "ALT: " + String(stringInterpolationSegment: (uav.position.y / self.frame.height)*levelAltitude)
        uav.physicsBody = SKPhysicsBody(circleOfRadius: uav.size.height / 2)
        uav.physicsBody?.dynamic = true
        uav.physicsBody?.allowsRotation = false
        container.addChild(uav)
        // The gravity of the world is slowed to give the UAV a floating effect
        self.physicsWorld.gravity = CGVectorMake(0, -1)
        // Format the pause screen
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, CGRectMake(-self.frame.width, 0, self.frame.width, self.frame.height))
        pauseScreen.path = path
        pauseScreen.strokeColor = UIColor.whiteColor()
        pauseScreen.fillColor = UIColor.blackColor()
        pauseScreen.zPosition = 11
        pauseScreen.alpha = 0.5
        pauseMenu.addChild(pauseButton)
        pauseMenu.addChild(pauseScreen)
        // Add container to the main scene
        self.addChild(container)
        self.addChild(pauseMenu)
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
            if pauseButton.containsPoint(touchPosition) {
                touched = false
            }
        }
        if container.paused {
            touched = false
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
        if container.paused {
            pauseMenu.runAction(movePauseMenuOn)
            container.paused = false
            batteryTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "dropPower", userInfo: nil, repeats: true)
            self.physicsWorld.speed = 1
        }
        for touch: AnyObject in touches {
            touchPosition = touch.locationInNode(self)
            if pauseButton.containsPoint(touchPosition) {
                pauseMenu.runAction(movePauseMenuOff)
                container.paused = true
                batteryTimer.invalidate()
                self.physicsWorld.speed = 0
                break
            }
            
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        if gameHasBegun {
            gameHasBegun = false
            NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "moveBoat", userInfo: nil, repeats: true)
            NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "moveCatcher", userInfo: nil, repeats: true)
            batteryTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "dropPower", userInfo: nil, repeats: true)
        }
        if failed {
            self.paused = true
            
            // Display failure screen
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
            self.paused = true
            uav.position = handPosition
        }
        let frameHeight:CGFloat = self.frame.height
        altitude.text = "ALT: " + String(stringInterpolationSegment: ((Int)((uav.position.y / self.frame.height)*levelAltitude) + 4) / 5 * 5)
        
        // Check all failure conditions
        let offLeft = uav.position.x < (self.frame.minX - 10)
        let offRight = uav.position.x > (self.frame.maxX + 10)
        let offTop = uav.position.y < (self.frame.minY - 10)
        let offBottom = uav.position.y > (self.frame.maxY + 10)
        if offLeft || offRight || offTop {
            failed = true
        } else if offBottom {
            failed = true
            // Animate splash!!!
        }
//        if battery.percent <= 0 {
//            failed = true
//            // Animate fall and splash!!
//        }
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
    
    func dropPower() {
        battery.current = battery.current - 1
        battery.percent = battery.current/battery.capacity
        let oldHeight = battery.powerView.frame.height
        battery.powerView.frame.size.height = battery.powerHeight*battery.percent
        battery.powerView.frame.offset(dx: 0, dy: oldHeight - battery.powerView.frame.height)
        if battery.percent <= 0.2 {
            battery.powerView.backgroundColor = UIColor.redColor()
        }
    }

}

