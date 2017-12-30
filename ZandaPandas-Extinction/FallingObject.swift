//
//  FallingObject.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import SpriteKit

class FallingObject: SKSpriteNode{
    var fallingObjectTexture = SKTexture()
    var fallingObjectMain: SKSpriteNode = SKSpriteNode()
    var isFallingObjectPrimary = true
    var hasPassed = false
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    override init(){
        fallingObjectTexture = SKTexture(imageNamed:"FallingMeteorBlue")
        fallingObjectMain = SKSpriteNode(texture: fallingObjectTexture)
        
        var originalWidth: CGFloat = 150
        var originalHeight: CGFloat = 200
        var fallingObjectWidth: CGFloat = (bounds.width/4) - 20
        var fallingObjectHeight: CGFloat = (fallingObjectWidth / originalWidth) * originalHeight
        
        super.init(texture:nil, color:UIColor.clearColor(), size:CGSizeMake(fallingObjectWidth, fallingObjectHeight))
        fallingObjectMain.size.width = fallingObjectWidth
        fallingObjectMain.size.height = fallingObjectHeight
        fallingObjectMain.zPosition = -1
        addChild(fallingObjectMain)
    }
    
    init(selectedMode: String, isPrimary: Bool){
        var fallingObjectName:String = "FallingMeteorBlue"
        
        if(selectedMode == "Jurassic"){
            if(isPrimary){
                fallingObjectName = "FallingMeteorBlue"
            }else{
                fallingObjectName = "FallingMeteorRed"
            }
        }else if(selectedMode == "Castle"){
            if(isPrimary){
                fallingObjectName = "FallingObjectSpiritGreen"
            }else{
                fallingObjectName = "FallingObjectSpiritOrange"
            }
        }else if(selectedMode == "Pyramid"){
            if(isPrimary){
                fallingObjectName = "FallingScarabBlue"
            }else{
                fallingObjectName = "FallingScarabRed"
            }
        }else if(selectedMode == "IceAge"){
            if(isPrimary){
                fallingObjectName = "FallingIceBergBlue"
            }else{
                fallingObjectName = "FallingIceBergRed"
            }
        }else if(selectedMode == "Stadium"){
            if(isPrimary){
                fallingObjectName = "FallingBasketBallOrange"
            }else{
                fallingObjectName = "FallingBasketBallBlack"
            }
        }
        
        var originalWidth: CGFloat = 150
        var originalHeight: CGFloat = 200
        var fallingObjectWidth: CGFloat = (bounds.width/4) - 30
        var fallingObjectHeight: CGFloat = (fallingObjectWidth / originalWidth) * originalHeight
        
        isFallingObjectPrimary = isPrimary
        fallingObjectTexture = SKTexture(imageNamed:fallingObjectName)
        fallingObjectMain = SKSpriteNode(texture: fallingObjectTexture)
        super.init(texture:nil, color:UIColor.clearColor(), size:CGSizeMake(fallingObjectWidth, fallingObjectHeight))
        fallingObjectMain.size.width = fallingObjectWidth
        fallingObjectMain.size.height = fallingObjectHeight
        fallingObjectMain.zPosition = -1
        addChild(fallingObjectMain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Falling object init(coder:) has not been implemented")
    }
}
