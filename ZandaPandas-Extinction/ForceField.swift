//
//  ForceField.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 26/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import SpriteKit

class ForceField: SKSpriteNode{
    var forceField = SKSpriteNode()
    var isForceFieldPrimary = true
    var isShieldForceField = false
    var forceFieldPrimaryTexture: SKTexture = SKTexture()
    var forceFieldSecondaryTexture: SKTexture = SKTexture()
    var currentMode: String = "Castle"
    
    override init(){
        super.init(texture:nil, color:UIColor.clearColor(), size:CGSizeMake(700, 300))
        
        var forceFieldNamePrimary:String = "ForceFieldGreen"
        var forceFieldNameSecondary:String = "ForceFieldGreen"
        
        //Force Field primary
        forceFieldPrimaryTexture = SKTexture(imageNamed:forceFieldNamePrimary)
        forceFieldPrimaryTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        //Force Field secondary
        forceFieldSecondaryTexture = SKTexture(imageNamed:forceFieldNameSecondary)
        forceFieldSecondaryTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        forceField = SKSpriteNode(texture: forceFieldPrimaryTexture)
        forceField.size.width = 700
        forceField.size.height = 300
        addChild(forceField)

    }
    
    init(selectedMode: String, fieldWidth: CGFloat, fieldHeight: CGFloat, isShield: Bool){
        super.init(texture:nil, color:UIColor.clearColor(), size:CGSizeMake(fieldWidth, fieldHeight))
        isShieldForceField = isShield
        
        var forceFieldNamePrimary:String = "ForceFieldGreen"
        var forceFieldNameSecondary:String = "ForceFieldGreen"
        currentMode = selectedMode
        
        if(selectedMode == "Pyramid"){
            if(isShield){
                forceFieldNamePrimary = "ForceFieldBlueShield"
                forceFieldNameSecondary = "ForceFieldRedShield"
            }else{
                forceFieldNamePrimary = "ForceFieldBlue"
                forceFieldNameSecondary = "ForceFieldRed"
            }
        }else if(selectedMode == "Castle"){
            if(isShield){
                forceFieldNamePrimary = "ForceFieldGreenShield"
                forceFieldNameSecondary = "ForceFieldOrangeShield"
            }else{
                forceFieldNamePrimary = "ForceFieldGreen"
                forceFieldNameSecondary = "ForceFieldOrange"
            }
        }else if(selectedMode == "Jurassic"){
            if(isShield){
                forceFieldNamePrimary = "ForceFieldBlueShield"
                forceFieldNameSecondary = "ForceFieldRedShield"
            }else{
                forceFieldNamePrimary = "ForceFieldBlue"
                forceFieldNameSecondary = "ForceFieldRed"
            }
        }else if(selectedMode == "IceAge"){
            if(isShield){
                forceFieldNamePrimary = "ForceFieldBlueShield"
                forceFieldNameSecondary = "ForceFieldRedShield"
            }else{
                forceFieldNamePrimary = "ForceFieldBlue"
                forceFieldNameSecondary = "ForceFieldRed"
            }
        }else if(selectedMode == "Stadium"){
            if(isShield){
                forceFieldNamePrimary = "ForceFieldOrangeShield"
                forceFieldNameSecondary = "ForceFieldBlackShield"
            }else{
                forceFieldNamePrimary = "ForceFieldOrange"
                forceFieldNameSecondary = "ForceFieldBlack"
            }
        }
        
        //Force Field primary
        forceFieldPrimaryTexture = SKTexture(imageNamed:forceFieldNamePrimary)
        forceFieldPrimaryTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        //Force Field secondary
        forceFieldSecondaryTexture = SKTexture(imageNamed:forceFieldNameSecondary)
        forceFieldSecondaryTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        forceField = SKSpriteNode(texture: forceFieldPrimaryTexture)
        forceField.size.width = fieldWidth
        forceField.size.height = fieldHeight
        addChild(forceField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Force Field init(coder:) has not been implemented")
    }
    
    func changeForceFieldImage(){
        if(isForceFieldPrimary){
            forceField.texture = forceFieldPrimaryTexture
        }else{
            forceField.texture = forceFieldSecondaryTexture
        }
    }
    
    func shieldEnded(){
        var forceFieldNamePrimary:String = "ForceFieldGreen"
        var forceFieldNameSecondary:String = "ForceFieldGreen"
        
        if(currentMode == "Pyramid"){
            forceFieldNamePrimary = "ForceFieldBlue"
            forceFieldNameSecondary = "ForceFieldRed"
        }else if(currentMode == "Castle"){
            forceFieldNamePrimary = "ForceFieldGreen"
            forceFieldNameSecondary = "ForceFieldOrange"
        }else if(currentMode == "Jurassic"){
            forceFieldNamePrimary = "ForceFieldBlue"
            forceFieldNameSecondary = "ForceFieldRed"
        }else if(currentMode == "IceAge"){
            forceFieldNamePrimary = "ForceFieldBlue"
            forceFieldNameSecondary = "ForceFieldRed"
        }else if(currentMode == "Stadium"){
            forceFieldNamePrimary = "ForceFieldOrange"
            forceFieldNameSecondary = "ForceFieldBlack"
        }
        
        //Force Field primary
        forceFieldPrimaryTexture = SKTexture(imageNamed:forceFieldNamePrimary)
        forceFieldPrimaryTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        //Force Field secondary
        forceFieldSecondaryTexture = SKTexture(imageNamed:forceFieldNameSecondary)
        forceFieldSecondaryTexture.filteringMode = SKTextureFilteringMode.Nearest
    }
}