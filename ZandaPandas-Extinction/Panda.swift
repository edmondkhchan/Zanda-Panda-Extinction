//
//  Panda.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import SpriteKit

class Panda: SKSpriteNode{
    var panda = SKSpriteNode()
    var isPandaRunning = false
    var isPandaShakingLeft = false
    var isPandaRunningLeft = false
    var pandaTexture: SKTexture = SKTexture()
    var pandaMovingTexture: SKTexture = SKTexture()
    
    override init(){
        super.init(texture:nil, color:UIColor.clearColor(), size:CGSizeMake(32,40))
        
        //Panda
        pandaTexture = SKTexture(imageNamed:"ZandaRunning1")
        pandaTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        //Panda Moving
        pandaMovingTexture = SKTexture(imageNamed:"ZandaRunning2")
        pandaMovingTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        panda = SKSpriteNode(texture: pandaTexture)
        panda.size.width = 48
        panda.size.height = 64
        panda.physicsBody = SKPhysicsBody(circleOfRadius:panda.size.height/2.0)
        panda.physicsBody?.dynamic = false
        panda.physicsBody?.allowsRotation = false
        addChild(panda)
    }
    
    init(character: String){
        super.init(texture:nil, color:UIColor.clearColor(), size:CGSizeMake(32,40))
        
        //Panda
        pandaTexture = SKTexture(imageNamed:character + "Running1")
        pandaTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        //Panda Moving
        pandaMovingTexture = SKTexture(imageNamed:character + "Running2")
        pandaMovingTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        panda = SKSpriteNode(texture: pandaTexture)
        panda.size.width = 48
        panda.size.height = 64
        panda.physicsBody = SKPhysicsBody(circleOfRadius:panda.size.height/2.0)
        panda.physicsBody?.dynamic = false
        panda.physicsBody?.allowsRotation = false
        addChild(panda)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Panda init(coder:) has not been implemented")
    }
    
    func breathe(){
        //let breatheOut = SKAction.moveByX(0, y: -2, duration: 1)
        //let breatheIn = SKAction.moveByX(0, y: 2, duration: 1)
        //let breath = SKAction.sequence([breatheOut, breatheIn])
        //panda.runAction(SKAction.repeatActionForever(breath))
    }
    
    func changeRunningImage(){
        if(isPandaShakingLeft){
            panda.texture = pandaMovingTexture
        }else{
            panda.texture = pandaTexture
        }
    }
    
    func changeDirection(){
        panda.xScale = panda.xScale * -1
    }
    
    func stop(){
        panda.removeAllActions()
    }
    
    func shrinkPanda(willShrink: Bool){
        if(willShrink){
            panda.size.width = 24
            panda.size.height = 32
            self.size.width = 12
            self.size.height = 16
            panda.physicsBody = SKPhysicsBody(circleOfRadius:panda.size.height/2.0)
            panda.physicsBody?.dynamic = false;
            panda.physicsBody?.allowsRotation = false
        }else{
            panda.size.width = 48
            panda.size.height = 64
            self.size.width = 32
            self.size.height = 40
            panda.physicsBody = SKPhysicsBody(circleOfRadius:panda.size.height/2.0)
            panda.physicsBody?.dynamic = false;
            panda.physicsBody?.allowsRotation = false
        }
    }
}