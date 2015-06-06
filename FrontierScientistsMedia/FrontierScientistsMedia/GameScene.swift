//
//  GameScene.swift
//  FrontierScientistsMedia
//
//  Created by Jay Byam on 6/5/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        var birdTexture = SKTexture(imageNamed: "img/flappy1.png")
        var birdTexture2 = SKTexture(imageNamed: "img/flappy2.png")
        var bgTexture = SKTexture(imageNamed: "img/bg.png")
        
        var moveBg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        var replaceBg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var moveBgForever = SKAction.repeatActionForever(SKAction.sequence([moveBg, replaceBg]))
        
        for var i:CGFloat = 0; i < 3; i++ {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(moveBgForever)
            self.addChild(bg)
        }
        
        var animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        var makeBirdFlap = SKAction.repeatActionForever(animation)
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        
        self.addChild(bird)
        
        var ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        
        self.addChild(ground)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

