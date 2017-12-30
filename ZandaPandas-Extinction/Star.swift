//
//  Star.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import SpriteKit

class Star: SKSpriteNode{
    var starTexture = SKTexture()
    var starMain: SKSpriteNode = SKSpriteNode()
    var hasPassed = false
    
    
    override init(){
        starTexture = SKTexture(imageNamed:"Star")
        starMain = SKSpriteNode(texture: starTexture)
        super.init(texture:nil, color:UIColor.clearColor(), size:CGSizeMake(40, 40))
        starMain.size.width = 40
        starMain.size.height = 40
        starMain.zPosition = -1
        
        addChild(starMain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Star init(coder:) has not been implemented")
    }
}