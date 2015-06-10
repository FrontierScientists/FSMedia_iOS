//
//  GameScene.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/5/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var uav = SKSpriteNode()
    var bg = SKSpriteNode()
    var land = SKSpriteNode()
    var boat = SKSpriteNode()
    var wave = SKSpriteNode()
    var waveFg = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        var UAVTexture = SKTexture(imageNamed: "Game/uav.png")
        var bgTexture = SKTexture(imageNamed: "Game/bg.jpg")
        var landTexture = SKTexture(imageNamed: "Game/land.png")
        var boatTexture = SKTexture(imageNamed: "Game/boat.png")
        var waveTexture = SKTexture(imageNamed: "Game/wave.png")
        var waveFgTexture = SKTexture(imageNamed: "Game/waveFg.png")
        
        var moveWaveUp = SKAction.moveBy(CGVectorMake(0, 10), duration: 1.0)
        var moveWaveDown = SKAction.moveBy(CGVectorMake(0, -10), duration: 1.0)
        var moveWaveLeft = SKAction.moveByX(-5, y: 0, duration: 2.0)
        var moveWaveRight = SKAction.moveByX(5, y: 0, duration: 2.0)
        var moveBoatUp = SKAction.moveBy(CGVectorMake(0, 8), duration: 1.2)
        var moveBoatDown = SKAction.moveBy(CGVectorMake(0, -8), duration: 1.2)
        var moveWaveUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveWaveUp, moveWaveDown]))
        var moveWaveFgUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveWaveDown, moveWaveUp]))
        var moveWaveLeftAndRight = SKAction.repeatActionForever(SKAction.sequence([moveWaveLeft, moveWaveRight]))
        var moveWaveFgLeftAndRight = SKAction.repeatActionForever(SKAction.sequence([moveWaveRight, moveWaveLeft]))
        var moveBoatUpAndDown = SKAction.repeatActionForever(SKAction.sequence([moveBoatDown, moveBoatUp]))
        
        for var i:CGFloat = 0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            land = SKSpriteNode(texture: landTexture)
            waveFg = SKSpriteNode(texture: waveFgTexture)
            boat = SKSpriteNode(texture: boatTexture)
            wave = SKSpriteNode(texture: waveTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            land.position = CGPoint(x: landTexture.size().width/2 + landTexture.size().width * i, y: CGRectGetMinY(self.frame))
            boat.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMinY(self.frame) + 62)
            wave.position = CGPoint(x: waveTexture.size().width/2 + waveTexture.size().width * i - 15, y: CGRectGetMinY(self.frame) + 10)
            waveFg.position = CGPoint(x: waveFgTexture.size().width/2 + waveFgTexture.size().width * i - 15, y: CGRectGetMinY(self.frame) - 5)
            bg.size.height = self.frame.height
            wave.runAction(moveWaveUpAndDown)
            wave.runAction(moveWaveLeftAndRight)
            waveFg.runAction(moveWaveFgUpAndDown)
            waveFg.runAction(moveWaveFgLeftAndRight)
            boat.runAction(moveBoatUpAndDown)
            self.addChild(bg)
            self.addChild(land)
            self.addChild(boat)
            self.addChild(wave)
            self.addChild(waveFg)
        }
        
        uav = SKSpriteNode(texture: UAVTexture)
        uav.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + CGRectGetMidY(self.frame)/2)
        
        uav.physicsBody = SKPhysicsBody(circleOfRadius: uav.size.height / 2)
        uav.physicsBody?.dynamic = true
        uav.physicsBody?.allowsRotation = false
        
        self.addChild(uav)
        
        var ground = SKNode()
        ground.position = CGPointMake(0, boat.position.y + 35)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.runAction(moveBoatUpAndDown)
        
        self.addChild(ground)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        uav.physicsBody?.velocity = CGVectorMake(0, 0)
        uav.physicsBody?.applyImpulse(CGVectorMake(0, 20))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

