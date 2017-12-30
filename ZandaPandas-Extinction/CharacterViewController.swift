//
//  CharacterViewController.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import UIKit
import iAd
import AVFoundation

class CharacterViewController: UIViewController, ADBannerViewDelegate, UIPopoverPresentationControllerDelegate, purchaseRefresh {
    //var characterMap: Dictionary<String, [UIImage]> = Dictionary<String, [UIImage]>()
    var characterMap: Dictionary<String, [String]> = Dictionary<String, [String]>()
    var characterArray: [String] = []
    var characterCost: [Int] = []
    var characterUnlock: [Bool] = []
    var leftButton: UIButton = UIButton()
    var rightButton: UIButton = UIButton()
    var exitButton: UIButton = UIButton()
    var selectButton: UIButton = UIButton()
    var unlockButton: UIButton = UIButton()
    var currentImageList: [UIImage] = []
    
    //Character label
    var characterLabel: UILabel = UILabel()
    
    //Background Image View
    var backgroundUIView: UIImageView = UIImageView()
    var characterTitleUIView: UIImageView = UIImageView()
    
    var selectedUIView: UIImageView = UIImageView()
    var frontLeftUIView: UIImageView = UIImageView()
    var frontRightUIView: UIImageView = UIImageView()
    var frontMidLeftUIView: UIImageView = UIImageView()
    var frontMidRightUIView: UIImageView = UIImageView()
    var backMidLeftUIView: UIImageView = UIImageView()
    var backMidRightUIView: UIImageView = UIImageView()
    var backLeftUIView: UIImageView = UIImageView()
    var backRightUIView: UIImageView = UIImageView()
    var furthestBackLeftUIView: UIImageView = UIImageView()
    var furthestBackRightUIView: UIImageView = UIImageView()
    var selectedChar: Int = 0
    
    var costStarUIView: UIImageView = UIImageView()
    var starsCollectedUIView: UIImageView = UIImageView()
    var lockedUIView: UIImageView = UIImageView()
    var starsCollectedLabel: UILabel = UILabel()
    
    //Unlock confirmation
    var unlockBackgroundView: UIView = UIView()
    var confirmUIView: UIImageView = UIImageView()
    var confirmYesButton: UIButton = UIButton()
    var confirmNoButton: UIButton = UIButton()
    var confirmLabel: UILabel = UILabel()
    var purchaseButton: UIButton = UIButton()
    
    var zandaUnlocked: Bool = true
    var pharaohUnlocked: Bool = false
    var pandaUnlocked: Bool = false
    var mummyUnlocked: Bool = false
    var ghostUnlocked: Bool = false
    var nappyUnlocked: Bool = false
    var alienUnlocked: Bool = false
    var snowmanUnlocked: Bool = false
    var trexUnlocked: Bool = false
    var generalUnlocked: Bool = false
    var dragonUnlocked: Bool = false
    
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    //Audio player
    var chooseCharacterAudioPlayer:AVAudioPlayer = AVAudioPlayer()
    var chooseCharacterSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ChooseCharacter", ofType: "wav")!)
    
    //iAd banner
    var iAdBannerView:ADBannerView = ADBannerView()
    
    func appdelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!self.appdelegate().iAdsUnlocked){
            iAdBannerView.delegate = self
            iAdBannerView = self.appdelegate().iAdBannerView
            iAdBannerView.frame = CGRect.zeroRect
            view.addSubview(iAdBannerView)
            
            let currentTime = NSDate()
            var elapsedTime: Double = currentTime.timeIntervalSinceDate(appdelegate().lastAdDisplay)
            
            if(elapsedTime > appdelegate().interstitialAdInterval){
                //Display interstitial ad every 2-3 minutes. Configurable
                appdelegate().lastAdDisplay = NSDate()
                appdelegate().showChartboostAds()
            }else if(elapsedTime < 0){
                appdelegate().lastAdDisplay = NSDate()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(!self.appdelegate().iAdsUnlocked){
            iAdBannerView.delegate = nil
            iAdBannerView.removeFromSuperview()
        }
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.view?.addSubview(banner)
        self.view?.layoutIfNeeded()
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("Failed to retrieve ad")
        banner.removeFromSuperview()
        self.view?.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var iAdSpace: CGFloat = 20
        
        if(!self.appdelegate().iAdsUnlocked){
            iAdSpace = 60
        }
        
        //reset
        characterMap = Dictionary<String, [String]>()
        //characterMap = Dictionary<String, [UIImage]>()
        
        selectedChar = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtSelectedChar")
        
        pharaohUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtPharaohUnlocked")
        pandaUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtPandaUnlocked")
        mummyUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtMummyUnlocked")
        ghostUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtGhostUnlocked")
        nappyUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtNappyUnlocked")
        alienUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtAlienUnlocked")
        snowmanUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtSnowmanUnlocked")
        trexUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtTrexUnlocked")
        generalUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtGeneralUnlocked")
        dragonUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtDragonUnlocked")
        
        characterUnlock.append(zandaUnlocked)
        characterUnlock.append(pharaohUnlocked)
        characterUnlock.append(pandaUnlocked)
        characterUnlock.append(mummyUnlocked)
        characterUnlock.append(ghostUnlocked)
        characterUnlock.append(nappyUnlocked)
        characterUnlock.append(snowmanUnlocked)
        characterUnlock.append(alienUnlocked)
        characterUnlock.append(trexUnlocked)
        characterUnlock.append(generalUnlocked)
        characterUnlock.append(dragonUnlocked)
        
        //Load background
        let backgroundImage = UIImage(named: "LaunchImage") as UIImage?
        backgroundUIView.image = backgroundImage
        backgroundUIView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        self.view.addSubview(backgroundUIView)
        
        //Left button
        let leftImage = UIImage(named: "LeftButton") as UIImage?
        leftButton.frame = CGRectMake(35, bounds.size.height - 125, 40, 40)
        leftButton.setImage(leftImage, forState: .Normal)
        leftButton.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(leftButton)
        
        //Right button
        let rightImage = UIImage(named: "RightButton") as UIImage?
        rightButton.frame = CGRectMake((bounds.size.width - 75), bounds.size.height - 125, 40, 40)
        rightButton.setImage(rightImage, forState: .Normal)
        rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(rightButton)
        
        //Back button
        let backImage = UIImage(named: "BackButton") as UIImage?
        exitButton.frame = CGRectMake(10, iAdSpace, 40, 40)
        exitButton.setImage(backImage, forState: .Normal)
        exitButton.addTarget(self, action: "exitButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(exitButton)
        
        //Purchase button
        let purchaseImage = UIImage(named: "PurchaseButton") as UIImage?
        purchaseButton.frame = CGRectMake(bounds.width - 50, iAdSpace, 40, 40)
        purchaseButton.setImage(purchaseImage, forState: .Normal)
        purchaseButton.addTarget(self, action: "purchaseButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(purchaseButton)
        
        //Select button
        let selectCharImage = UIImage(named: "SelectButton") as UIImage?
        selectButton.frame = CGRectMake((bounds.size.width / 2) - 30, bounds.size.height - 125, 60, 40)
        selectButton.setImage(selectCharImage, forState: .Normal)
        selectButton.addTarget(self, action: "selectButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(selectButton)
        
        //Unlock button
        let unlockImage = UIImage(named: "UnlockButton") as UIImage?
        unlockButton.frame = CGRectMake((bounds.size.width / 2) - 30, bounds.size.height - 125, 60, 40)
        unlockButton.setImage(unlockImage, forState: .Normal)
        unlockButton.addTarget(self, action: "unlockButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(unlockButton)
        unlockButton.hidden = true
        
        //Stars collected Image View
        let starsCollectedUIImage: UIImage = UIImage(named: "StarsCollected")!
        starsCollectedUIView.image = starsCollectedUIImage
        starsCollectedUIView.frame = CGRectMake((bounds.width / 2) - 100, iAdSpace, 200, 40)
        self.view.addSubview(starsCollectedUIView)
        
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected > 0){
            starsCollectedLabel.text = NSString(format: "%i", starsCollected)
        }else{
            starsCollectedLabel.text = NSString(format: "0")
        }
        
        starsCollectedLabel.font = UIFont(name: "MarkerFelt-Thin", size: 25)
        starsCollectedLabel.textColor = UIColor.whiteColor()
        starsCollectedLabel.textAlignment = NSTextAlignment.Right
        starsCollectedLabel.frame = CGRectMake((bounds.width / 2) - 60, iAdSpace, 145, 40)
        self.view.addSubview(starsCollectedLabel)
        
        let originalWidth:CGFloat = 700
        let originalHeight:CGFloat = 150
        var newWidth:CGFloat = (bounds.width - 20)
        var newHeight:CGFloat = (newWidth / originalWidth) * originalHeight
        
        //Load character title image
        let characterTitleImage = UIImage(named: "CharacterTitle") as UIImage?
        characterTitleUIView.image = characterTitleImage
        characterTitleUIView.frame = CGRectMake((bounds.width / 2) - (newWidth / 2), starsCollectedUIView.frame.origin.y + starsCollectedUIView.frame.height + 10, newWidth, newHeight)
        self.view.addSubview(characterTitleUIView)
        
        characterLabel.font = UIFont(name: "MarkerFelt-Thin", size: 35)
        characterLabel.textColor = UIColor.whiteColor()
        characterLabel.textAlignment = NSTextAlignment.Center
        characterLabel.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 140, 145, 90)
        self.view.addSubview(characterLabel)
        
        //Load audio player
        chooseCharacterAudioPlayer = AVAudioPlayer(contentsOfURL: chooseCharacterSound, error: nil)
        chooseCharacterAudioPlayer.prepareToPlay()
        
        loadCharacters()
    }
    
    func leftButtonAction(sender: UIButton!){
        //Stop animation
        selectedUIView.stopAnimating()
        
        var currentSelectedChar: Int = selectedChar - 1
        if(currentSelectedChar < 0){
            currentSelectedChar = characterArray.count - 1
        }
        
        selectedChar = currentSelectedChar
        
        var frontLeftChar: Int = currentSelectedChar - 1
        var frontMidLeftChar: Int = currentSelectedChar - 2
        var backMidLeftChar: Int = currentSelectedChar - 3
        var backLeftChar: Int = currentSelectedChar - 4
        var furthestBackLeftChar: Int = currentSelectedChar - 5
        var furthestBackRightChar: Int = currentSelectedChar - 6
        var backRightChar: Int = currentSelectedChar - 7
        var backMidRightChar: Int = currentSelectedChar - 8
        var frontMidRightChar: Int = currentSelectedChar - 9
        var frontRightChar: Int = currentSelectedChar - 10
        
        if(frontRightChar < 0){
            frontRightChar = characterArray.count + frontRightChar
        }
        if(frontMidRightChar < 0){
            frontMidRightChar = characterArray.count + frontMidRightChar
        }
        if(backMidRightChar < 0){
            backMidRightChar = characterArray.count + backMidRightChar
        }
        if(backRightChar < 0){
            backRightChar = characterArray.count + backRightChar
        }
        if(furthestBackRightChar < 0){
            furthestBackRightChar = characterArray.count + furthestBackRightChar
        }
        if(furthestBackLeftChar < 0){
            furthestBackLeftChar = characterArray.count + furthestBackLeftChar
        }
        if(backLeftChar < 0){
            backLeftChar = characterArray.count + backLeftChar
        }
        if(backMidLeftChar < 0){
            backMidLeftChar = characterArray.count + backMidLeftChar
        }
        if(frontMidLeftChar < 0){
            frontMidLeftChar = characterArray.count + frontMidLeftChar
        }
        if(frontLeftChar < 0){
            frontLeftChar = characterArray.count + frontLeftChar
        }
        
        let furthestBackLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[furthestBackLeftChar]]?.first ?? "")!
        let furthestBackRightUIImage: UIImage = UIImage(named: characterMap[characterArray[furthestBackRightChar]]?.first ?? "")!
        furthestBackLeftUIView.image = furthestBackLeftUIImage
        furthestBackRightUIView.image = furthestBackRightUIImage
        
        let backLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[backLeftChar]]?.first ?? "")!
        let backRightUIImage: UIImage = UIImage(named: characterMap[characterArray[backRightChar]]?.first ?? "")!
        backLeftUIView.image = backLeftUIImage
        backRightUIView.image = backRightUIImage
        
        let backMidLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[backMidLeftChar]]?.first ?? "")!
        let backMidRightUIImage: UIImage = UIImage(named: characterMap[characterArray[backMidRightChar]]?.first ?? "")!
        backMidLeftUIView.image = backMidLeftUIImage
        backMidRightUIView.image = backMidRightUIImage
        
        let frontMidLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[frontMidLeftChar]]?.first ?? "")!
        let frontMidRightUIImage: UIImage = UIImage(named: characterMap[characterArray[frontMidRightChar]]?.first ?? "")!
        frontMidLeftUIView.image = frontMidLeftUIImage
        frontMidRightUIView.image = frontMidRightUIImage
        
        let frontLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[frontLeftChar]]?.first ?? "")!
        let frontRightUIImage: UIImage = UIImage(named: characterMap[characterArray[frontRightChar]]?.first ?? "")!
        frontLeftUIView.image = frontLeftUIImage
        frontRightUIView.image = frontRightUIImage
        
        /*furthestBackLeftUIView.image = characterMap[characterArray[furthestBackLeftChar]]?.first
        furthestBackRightUIView.image = characterMap[characterArray[furthestBackRightChar]]?.first
        
        backLeftUIView.image = characterMap[characterArray[backLeftChar]]?.first
        backRightUIView.image = characterMap[characterArray[backRightChar]]?.first
        
        backMidLeftUIView.image = characterMap[characterArray[backMidLeftChar]]?.first
        backMidRightUIView.image = characterMap[characterArray[backMidRightChar]]?.first
        
        frontMidLeftUIView.image = characterMap[characterArray[frontMidLeftChar]]?.first
        frontMidRightUIView.image = characterMap[characterArray[frontMidRightChar]]?.first
        
        frontLeftUIView.image = characterMap[characterArray[frontLeftChar]]?.first
        frontRightUIView.image = characterMap[characterArray[frontRightChar]]?.first*/
        
        var characterImages = characterMap[characterArray[currentSelectedChar]]
        var characterAnimationImages: [UIImage] = []
        if let characterStrings = characterImages as [String]!{
            for characterImageString in characterStrings{
                let characterImage: UIImage = UIImage(named: characterImageString)!
                characterAnimationImages.append(characterImage)
            }
        }
        
        selectedUIView.animationImages = characterAnimationImages
        //selectedUIView.animationImages = characterMap[characterArray[currentSelectedChar]]
        selectedUIView.startAnimating()
        
        //Cost star image view
        if(characterCost[currentSelectedChar] == 250){
            let starUIImage: UIImage = UIImage(named: "Cost250")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }
        else if(characterCost[currentSelectedChar] == 500){
            let starUIImage: UIImage = UIImage(named: "Cost500")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }else if(characterCost[currentSelectedChar] == 1000){
            let starUIImage: UIImage = UIImage(named: "Cost1000")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }
        
        if(characterUnlock[currentSelectedChar]){
            costStarUIView.hidden = true
            selectButton.hidden = false
            unlockButton.hidden = true
            lockedUIView.hidden = true
        }
        else{
            costStarUIView.hidden = false
            selectButton.hidden = true
            unlockButton.hidden = false
            lockedUIView.hidden = false
        }
        
        chooseCharacterAudioPlayer.play()
    }
    
    func rightButtonAction(sender: UIButton!){
        //Stop animation
        selectedUIView.stopAnimating()
        
        var currentSelectedChar: Int = selectedChar + 1
        if(currentSelectedChar >= characterArray.count){
            currentSelectedChar = 0
        }
        
        selectedChar = currentSelectedChar
        
        var frontRightChar: Int = currentSelectedChar + 1
        var frontMidRightChar: Int = currentSelectedChar + 2
        var backMidRightChar: Int = currentSelectedChar + 3
        var backRightChar: Int = currentSelectedChar + 4
        var furthestBackRightChar: Int = currentSelectedChar + 5
        var furthestBackLeftChar: Int = currentSelectedChar + 6
        var backLeftChar: Int = currentSelectedChar + 7
        var backMidLeftChar: Int = currentSelectedChar + 8
        var frontMidLeftChar: Int = currentSelectedChar + 9
        var frontLeftChar: Int = currentSelectedChar + 10
        
        if(frontRightChar >= characterArray.count){
            frontRightChar = frontRightChar - characterArray.count
        }
        if(frontMidRightChar >= characterArray.count){
            frontMidRightChar = frontMidRightChar - characterArray.count
        }
        if(backMidRightChar >= characterArray.count){
            backMidRightChar = backMidRightChar - characterArray.count
        }
        if(backRightChar >= characterArray.count){
            backRightChar = backRightChar - characterArray.count
        }
        if(furthestBackRightChar >= characterArray.count){
            furthestBackRightChar = furthestBackRightChar - characterArray.count
        }
        if(furthestBackLeftChar >= characterArray.count){
            furthestBackLeftChar = furthestBackLeftChar - characterArray.count
        }
        if(backLeftChar >= characterArray.count){
            backLeftChar = backLeftChar - characterArray.count
        }
        if(backMidLeftChar >= characterArray.count){
            backMidLeftChar = backMidLeftChar - characterArray.count
        }
        if(frontMidLeftChar >= characterArray.count){
            frontMidLeftChar = frontMidLeftChar - characterArray.count
        }
        if(frontLeftChar >= characterArray.count){
            frontLeftChar = frontLeftChar - characterArray.count
        }
        
        /*NSLog("currentSelectedChar: %i", currentSelectedChar)
        NSLog("frontRightChar: %i", frontRightChar)
        NSLog("midRightChar: %i", midRightChar)
        NSLog("backRightChar: %i", backRightChar)
        NSLog("backLeftChar: %i", backLeftChar)
        NSLog("midLeftChar: %i", midLeftChar)
        NSLog("frontLeftChar: %i", frontLeftChar)*/
        
        let furthestBackLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[furthestBackLeftChar]]?.first ?? "")!
        let furthestBackRightUIImage: UIImage = UIImage(named: characterMap[characterArray[furthestBackRightChar]]?.first ?? "")!
        furthestBackLeftUIView.image = furthestBackLeftUIImage
        furthestBackRightUIView.image = furthestBackRightUIImage
        
        let backLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[backLeftChar]]?.first ?? "")!
        let backRightUIImage: UIImage = UIImage(named: characterMap[characterArray[backRightChar]]?.first ?? "")!
        backLeftUIView.image = backLeftUIImage
        backRightUIView.image = backRightUIImage
        
        let backMidLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[backMidLeftChar]]?.first ?? "")!
        let backMidRightUIImage: UIImage = UIImage(named: characterMap[characterArray[backMidRightChar]]?.first ?? "")!
        backMidLeftUIView.image = backMidLeftUIImage
        backMidRightUIView.image = backMidRightUIImage
        
        let frontMidLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[frontMidLeftChar]]?.first ?? "")!
        let frontMidRightUIImage: UIImage = UIImage(named: characterMap[characterArray[frontMidRightChar]]?.first ?? "")!
        frontMidLeftUIView.image = frontMidLeftUIImage
        frontMidRightUIView.image = frontMidRightUIImage
        
        let frontLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[frontLeftChar]]?.first ?? "")!
        let frontRightUIImage: UIImage = UIImage(named: characterMap[characterArray[frontRightChar]]?.first ?? "")!
        frontLeftUIView.image = frontLeftUIImage
        frontRightUIView.image = frontRightUIImage
        
        /*furthestBackLeftUIView.image = characterMap[characterArray[furthestBackLeftChar]]?.first
        furthestBackRightUIView.image = characterMap[characterArray[furthestBackRightChar]]?.first
        
        backLeftUIView.image = characterMap[characterArray[backLeftChar]]?.first
        backRightUIView.image = characterMap[characterArray[backRightChar]]?.first
        
        backMidLeftUIView.image = characterMap[characterArray[backMidLeftChar]]?.first
        backMidRightUIView.image = characterMap[characterArray[backMidRightChar]]?.first
        
        frontMidLeftUIView.image = characterMap[characterArray[frontMidLeftChar]]?.first
        frontMidRightUIView.image = characterMap[characterArray[frontMidRightChar]]?.first
        
        frontLeftUIView.image = characterMap[characterArray[frontLeftChar]]?.first
        frontRightUIView.image = characterMap[characterArray[frontRightChar]]?.first*/
        
        var characterImages = characterMap[characterArray[currentSelectedChar]]
        var characterAnimationImages: [UIImage] = []
        if let characterStrings = characterImages as [String]!{
            for characterImageString in characterStrings{
                let characterImage: UIImage = UIImage(named: characterImageString)!
                characterAnimationImages.append(characterImage)
            }
        }
        
        selectedUIView.animationImages = characterAnimationImages
        //selectedUIView.animationImages = characterMap[characterArray[currentSelectedChar]]
        selectedUIView.startAnimating()
        
        //Cost star image view
        if(characterCost[currentSelectedChar] == 250){
            let starUIImage: UIImage = UIImage(named: "Cost250")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }
        else if(characterCost[currentSelectedChar] == 500){
            let starUIImage: UIImage = UIImage(named: "Cost500")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }else if(characterCost[currentSelectedChar] == 1000){
            let starUIImage: UIImage = UIImage(named: "Cost1000")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }
        
        if(characterUnlock[currentSelectedChar]){
            costStarUIView.hidden = true
            selectButton.hidden = false
            unlockButton.hidden = true
            lockedUIView.hidden = true
        }
        else{
            costStarUIView.hidden = false
            selectButton.hidden = true
            unlockButton.hidden = false
            lockedUIView.hidden = false
        }
        
        chooseCharacterAudioPlayer.play()
    }
    
    func selectButtonAction(sender: UIButton!){
        NSUserDefaults.standardUserDefaults().setInteger(selectedChar, forKey: "ZPExtSelectedChar")
        self.dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("unwindToMainMenu2", sender: self)
        })
    }
    
    func purchaseButtonAction(sender: UIButton!){
        showPurchases()
    }
    
    func unlockButtonAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected >= characterCost[selectedChar]){
            unlockBackgroundView.hidden = false
            confirmUIView.hidden = false
            confirmYesButton.hidden = false
            confirmNoButton.hidden = false
            confirmLabel.hidden = false
        }else{
            showPurchases()
        }
    }
    
    func refreshDelegate(){
        //Refresh stars collected
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected > 0){
            starsCollectedLabel.text = NSString(format: "%i", starsCollected)
        }else{
            starsCollectedLabel.text = NSString(format: "0")
        }
    }
    
    func showPurchases(){
        //Show in-purchases
        var purchaseViewController = PurchaseViewController()
        purchaseViewController.delegate = self
        
        let systemVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        
        if(systemVersion >= 8.0){
            self.providesPresentationContextTransitionStyle = true
            self.definesPresentationContext = true
            purchaseViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        }else{
            self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        }
        
        purchaseViewController.preferredContentSize = CGSizeMake(226, 300)
        
        if purchaseViewController.respondsToSelector("popoverPresentationController"){
            let popoverViewController = purchaseViewController.popoverPresentationController
            
            popoverViewController?.delegate = self
            popoverViewController?.sourceView = self.view
        }
        
        self.presentViewController(purchaseViewController, animated: true, completion: nil)
    }
    
    func confirmYesButtonAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        var remainingStars: Int = starsCollected - characterCost[selectedChar]
        //Set char unlocked
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ZPExt" + characterArray[selectedChar] + "Unlocked")
        //Set remaining stars
        NSUserDefaults.standardUserDefaults().setInteger(remainingStars, forKey: "ZPExtStarsCollected")
        
        starsCollectedLabel.text = NSString(format: "%i", remainingStars)
        
        unlockBackgroundView.hidden = true
        confirmUIView.hidden = true
        confirmYesButton.hidden = true
        confirmNoButton.hidden = true
        confirmLabel.hidden = true
        costStarUIView.hidden = true
        selectButton.hidden = false
        unlockButton.hidden = true
        lockedUIView.hidden = true
        
        //Unlock character
        if(characterArray[selectedChar] == "Pharaoh"){
            pharaohUnlocked = true
        }else if(characterArray[selectedChar] == "Panda"){
            pandaUnlocked = true
        }else if(characterArray[selectedChar] == "Mummy"){
            mummyUnlocked = true
        }else if(characterArray[selectedChar] == "Ghost"){
            ghostUnlocked = true
        }else if(characterArray[selectedChar] == "Nappy"){
            nappyUnlocked = true
        }else if(characterArray[selectedChar] == "Alien"){
            alienUnlocked = true
        }else if(characterArray[selectedChar] == "Snowman"){
            snowmanUnlocked = true
        }else if(characterArray[selectedChar] == "Trex"){
            trexUnlocked = true
        }else if(characterArray[selectedChar] == "General"){
            generalUnlocked = true
        }else if(characterArray[selectedChar] == "Dragon"){
            dragonUnlocked = true
        }
        
        let pandaCharacter: String = characterArray[selectedChar]
        let pandaUIImage1: String = pandaCharacter + "Running1"
        let pandaUIImage2: String = pandaCharacter + "Running2"
        var pandaArray: [String] = []
        //let pandaUIImage1: UIImage = UIImage(named: pandaCharacter + "Running1")!
        //let pandaUIImage2: UIImage = UIImage(named: pandaCharacter + "Running2")!
        //var pandaArray: [UIImage] = []
        pandaArray.append(pandaUIImage1)
        pandaArray.append(pandaUIImage2)
        characterMap[pandaCharacter] = pandaArray
        
        var characterImages = characterMap[pandaCharacter]
        var characterAnimationImages: [UIImage] = []
        if let characterStrings = characterImages as [String]!{
            for characterImageString in characterStrings{
                let characterImage: UIImage = UIImage(named: characterImageString)!
                characterAnimationImages.append(characterImage)
            }
        }
        
        selectedUIView.animationImages = characterAnimationImages
        //selectedUIView.animationImages = characterMap[pandaCharacter]
        selectedUIView.startAnimating()
    }
    
    func confirmNoButtonAction(sender: UIButton!){
        unlockBackgroundView.hidden = true
        confirmUIView.hidden = true
        confirmYesButton.hidden = true
        confirmNoButton.hidden = true
        confirmLabel.hidden = true
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.Custom
    }
    
    func exitButtonAction(sender: UIButton!){
        self.dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("unwindToMainMenu2", sender: self)
        })
    }
    
    func loadCharacters(){
        //Add zanda
        if(zandaUnlocked){
            let zandaUIImage1: String = "ZandaRunning1"
            let zandaUIImage2: String = "ZandaRunning2"
            var zandaArray: [String] = []
            //let zandaUIImage1: UIImage = UIImage(named: "ZandaRunning1")!
            //let zandaUIImage2: UIImage = UIImage(named: "ZandaRunning2")!
            //var zandaArray: [UIImage] = []
            zandaArray.append(zandaUIImage1)
            zandaArray.append(zandaUIImage2)
            characterMap["Zanda"] = zandaArray
        }else{
            let zandaUIImage: String = "ZandaRunningMasked"
            var zandaArray: [String] = []
            //let zandaUIImage: UIImage = UIImage(named: "ZandaRunningMasked")!
            //var zandaArray: [UIImage] = []
            zandaArray.append(zandaUIImage)
            characterMap["Zanda"] = zandaArray
        }
        
        //Add nappy panda
        if(nappyUnlocked){
            //let nappyUIImage1: UIImage = UIImage(named: "NappyRunning1")!
            //let nappyUIImage2: UIImage = UIImage(named: "NappyRunning2")!
            //var nappyArray: [UIImage] = []
            let nappyUIImage1: String = "NappyRunning1"
            let nappyUIImage2: String = "NappyRunning2"
            var nappyArray: [String] = []
            nappyArray.append(nappyUIImage1)
            nappyArray.append(nappyUIImage2)
            characterMap["Nappy"] = nappyArray
        }else{
            //let nappyUIImage: UIImage = UIImage(named: "NappyRunningMasked")!
            //var nappyArray: [UIImage] = []
            let nappyUIImage: String = "NappyRunningMasked"
            var nappyArray: [String] = []
            nappyArray.append(nappyUIImage)
            characterMap["Nappy"] = nappyArray
        }
        
        //Add alien panda
        if(alienUnlocked){
            //let alienUIImage1: UIImage = UIImage(named: "AlienRunning1")!
            //let alienUIImage2: UIImage = UIImage(named: "AlienRunning2")!
            //var alienArray: [UIImage] = []
            let alienUIImage1: String = "AlienRunning1"
            let alienUIImage2: String = "AlienRunning2"
            var alienArray: [String] = []
            alienArray.append(alienUIImage1)
            alienArray.append(alienUIImage2)
            characterMap["Alien"] = alienArray
        }else{
            //let alienUIImage: UIImage = UIImage(named: "AlienRunningMasked")!
            //var alienArray: [UIImage] = []
            let alienUIImage: String = "AlienRunningMasked"
            var alienArray: [String] = []
            alienArray.append(alienUIImage)
            characterMap["Alien"] = alienArray
        }
        
        //Add snowman panda
        if(snowmanUnlocked){
            let snowmanUIImage1: String = "SnowmanRunning1"
            let snowmanUIImage2: String = "SnowmanRunning2"
            var snowmanArray: [String] = []
            //let snowmanUIImage1: UIImage = UIImage(named: "SnowmanRunning1")!
            //let snowmanUIImage2: UIImage = UIImage(named: "SnowmanRunning2")!
            //var snowmanArray: [UIImage] = []
            snowmanArray.append(snowmanUIImage1)
            snowmanArray.append(snowmanUIImage2)
            characterMap["Snowman"] = snowmanArray
        }else{
            let snowmanUIImage: String = "SnowmanRunningMasked"
            var snowmanArray: [String] = []
            //let snowmanUIImage: UIImage = UIImage(named: "SnowmanRunningMasked")!
            //var snowmanArray: [UIImage] = []
            snowmanArray.append(snowmanUIImage)
            characterMap["Snowman"] = snowmanArray
        }
        
        //Add Trex panda
        if(trexUnlocked){
            let trexUIImage1: String = "TrexRunning1"
            let trexUIImage2: String = "TrexRunning2"
            var trexArray: [String] = []
            //let trexUIImage1: UIImage = UIImage(named: "TrexRunning1")!
            //let trexUIImage2: UIImage = UIImage(named: "TrexRunning2")!
            //var trexArray: [UIImage] = []
            trexArray.append(trexUIImage1)
            trexArray.append(trexUIImage2)
            characterMap["Trex"] = trexArray
        }else{
            let trexUIImage: String = "TrexRunningMasked"
            var trexArray: [String] = []
            //let trexUIImage: UIImage = UIImage(named: "TrexRunningMasked")!
            //var trexArray: [UIImage] = []
            trexArray.append(trexUIImage)
            characterMap["Trex"] = trexArray
        }
        
        //Add mummy panda
        if(mummyUnlocked){
            let mummyUIImage1: String = "MummyRunning1"
            let mummyUIImage2: String = "MummyRunning2"
            var mummyArray: [String] = []
            //let mummyUIImage1: UIImage = UIImage(named: "MummyRunning1")!
            //let mummyUIImage2: UIImage = UIImage(named: "MummyRunning2")!
            //var mummyArray: [UIImage] = []
            mummyArray.append(mummyUIImage1)
            mummyArray.append(mummyUIImage2)
            characterMap["Mummy"] = mummyArray
        }else{
            let mummyUIImage: String = "MummyRunningMasked"
            var mummyArray: [String] = []
            //let mummyUIImage: UIImage = UIImage(named: "MummyRunningMasked")!
            //var mummyArray: [UIImage] = []
            mummyArray.append(mummyUIImage)
            characterMap["Mummy"] = mummyArray
        }
        
        //Add pharaoh panda
        if(pharaohUnlocked){
            let pharaohUIImage1: String = "PharaohRunning1"
            let pharaohUIImage2: String = "PharaohRunning2"
            var pharaohArray: [String] = []
            //let pharaohUIImage1: UIImage = UIImage(named: "PharaohRunning1")!
            //let pharaohUIImage2: UIImage = UIImage(named: "PharaohRunning2")!
            //var pharaohArray: [UIImage] = []
            pharaohArray.append(pharaohUIImage1)
            pharaohArray.append(pharaohUIImage2)
            characterMap["Pharaoh"] = pharaohArray
        }else{
            let pharaohUIImage: String = "PharaohRunningMasked"
            var pharaohArray: [String] = []
            //let pharaohUIImage: UIImage = UIImage(named: "PharaohRunningMasked")!
            //var pharaohArray: [UIImage] = []
            pharaohArray.append(pharaohUIImage)
            characterMap["Pharaoh"] = pharaohArray
        }
        
        //Add panda panda
        if(pandaUnlocked){
            let pandaUIImage1: String = "PandaRunning1"
            let pandaUIImage2: String = "PandaRunning2"
            var pandaArray: [String] = []
            //let pandaUIImage1: UIImage = UIImage(named: "PandaRunning1")!
            //let pandaUIImage2: UIImage = UIImage(named: "PandaRunning2")!
            //var pandaArray: [UIImage] = []
            pandaArray.append(pandaUIImage1)
            pandaArray.append(pandaUIImage2)
            characterMap["Panda"] = pandaArray
        }else{
            let pandaUIImage: String = "PandaRunningMasked"
            var pandaArray: [String] = []
            //let pandaUIImage: UIImage = UIImage(named: "PandaRunningMasked")!
            //var pandaArray: [UIImage] = []
            pandaArray.append(pandaUIImage)
            characterMap["Panda"] = pandaArray
        }
        
        //Add general panda
        if(generalUnlocked){
            let generalUIImage1: String = "GeneralRunning1"
            let generalUIImage2: String = "GeneralRunning2"
            var generalArray: [String] = []
            //let generalUIImage1: UIImage = UIImage(named: "GeneralRunning1")!
            //let generalUIImage2: UIImage = UIImage(named: "GeneralRunning2")!
            //var generalArray: [UIImage] = []
            generalArray.append(generalUIImage1)
            generalArray.append(generalUIImage2)
            characterMap["General"] = generalArray
        }else{
            let generalUIImage: String = "GeneralRunningMasked"
            var generalArray: [String] = []
            //let generalUIImage: UIImage = UIImage(named: "GeneralRunningMasked")!
            //var generalArray: [UIImage] = []
            generalArray.append(generalUIImage)
            characterMap["General"] = generalArray
        }
        
        //Add ghost panda
        if(ghostUnlocked){
            let ghostUIImage1: String = "GhostRunning1"
            let ghostUIImage2: String = "GhostRunning2"
            var ghostArray: [String] = []
            //let ghostUIImage1: UIImage = UIImage(named: "GhostRunning1")!
            //let ghostUIImage2: UIImage = UIImage(named: "GhostRunning2")!
            //var ghostArray: [UIImage] = []
            ghostArray.append(ghostUIImage1)
            ghostArray.append(ghostUIImage2)
            characterMap["Ghost"] = ghostArray
        }else{
            let ghostUIImage: String = "GhostRunningMasked"
            var ghostArray: [String] = []
            //let ghostUIImage: UIImage = UIImage(named: "GhostRunningMasked")!
            //var ghostArray: [UIImage] = []
            ghostArray.append(ghostUIImage)
            characterMap["Ghost"] = ghostArray
        }
        
        //Add dragon panda
        if(dragonUnlocked){
            let dragonUIImage1: String = "DragonRunning1"
            let dragonUIImage2: String = "DragonRunning2"
            var dragonArray: [String] = []
            //let dragonUIImage1: UIImage = UIImage(named: "DragonRunning1")!
            //let dragonUIImage2: UIImage = UIImage(named: "DragonRunning2")!
            //var dragonArray: [UIImage] = []
            dragonArray.append(dragonUIImage1)
            dragonArray.append(dragonUIImage2)
            characterMap["Dragon"] = dragonArray
        }else{
            let dragonUIImage: String = "DragonRunningMasked"
            var dragonArray: [String] = []
            //let dragonUIImage: UIImage = UIImage(named: "DragonRunningMasked")!
            //var dragonArray: [UIImage] = []
            dragonArray.append(dragonUIImage)
            characterMap["Dragon"] = dragonArray
        }
        
        characterArray.append("Zanda")
        characterArray.append("Pharaoh")
        characterArray.append("Panda")
        characterArray.append("Mummy")
        characterArray.append("Ghost")
        characterArray.append("Nappy")
        characterArray.append("Snowman")
        characterArray.append("Alien")
        characterArray.append("Trex")
        characterArray.append("General")
        characterArray.append("Dragon")
        
        characterCost.append(0)
        characterCost.append(250)
        characterCost.append(250)
        characterCost.append(250)
        characterCost.append(250)
        characterCost.append(250)
        characterCost.append(250)
        characterCost.append(250)
        characterCost.append(250)
        characterCost.append(500)
        characterCost.append(500)
        
        var currentSelectedChar: Int = selectedChar
        var frontRightChar: Int = selectedChar + 1
        var frontMidRightChar: Int = selectedChar + 2
        var backMidRightChar: Int = selectedChar + 3
        var backRightChar: Int = selectedChar + 4
        var furthestBackRightChar: Int = selectedChar + 5
        var furthestBackLeftChar: Int = selectedChar + 6
        var backLeftChar: Int = selectedChar + 7
        var backMidLeftChar: Int = selectedChar + 8
        var frontMidLeftChar: Int = selectedChar + 9
        var frontLeftChar: Int = selectedChar + 10
        
        if(frontRightChar >= characterArray.count){
            frontRightChar = frontRightChar - characterArray.count
        }
        if(frontMidRightChar >= characterArray.count){
            frontMidRightChar = frontMidRightChar - characterArray.count
        }
        if(backMidRightChar >= characterArray.count){
            backMidRightChar = backMidRightChar - characterArray.count
        }
        if(backRightChar >= characterArray.count){
            backRightChar = backRightChar - characterArray.count
        }
        if(furthestBackRightChar >= characterArray.count){
            furthestBackRightChar = furthestBackRightChar - characterArray.count
        }
        if(furthestBackLeftChar >= characterArray.count){
            furthestBackLeftChar = furthestBackLeftChar - characterArray.count
        }
        if(backLeftChar >= characterArray.count){
            backLeftChar = backLeftChar - characterArray.count
        }
        if(backMidLeftChar >= characterArray.count){
            backMidLeftChar = backMidLeftChar - characterArray.count
        }
        if(frontMidLeftChar >= characterArray.count){
            frontMidLeftChar = frontMidLeftChar - characterArray.count
        }
        if(frontLeftChar >= characterArray.count){
            frontLeftChar = frontLeftChar - characterArray.count
        }
        
        let furthestBackLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[furthestBackLeftChar]]?.first ?? "")!
        furthestBackLeftUIView.image = furthestBackLeftUIImage
        furthestBackLeftUIView.frame = CGRectMake((bounds.width / 2) - 15 - 18, (bounds.size.height / 2) - 66, 36, 48)
        
        let furthestBackRightUIImage: UIImage = UIImage(named: characterMap[characterArray[furthestBackRightChar]]?.first ?? "")!
        furthestBackRightUIView.image = furthestBackRightUIImage
        furthestBackRightUIView.frame = CGRectMake((bounds.width / 2) + 15 - 18, (bounds.size.height / 2) - 66, 36, 48)
        
        let backLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[backLeftChar]]?.first ?? "")!
        backLeftUIView.image = backLeftUIImage
        backLeftUIView.frame = CGRectMake((bounds.width / 2) - 45 - 21, (bounds.size.height / 2) - 64, 42, 56)
        
        let backRightUIImage: UIImage = UIImage(named: characterMap[characterArray[backRightChar]]?.first ?? "")!
        backRightUIView.image = backRightUIImage
        backRightUIView.frame = CGRectMake((bounds.width / 2) + 45 - 21, (bounds.size.height / 2) - 64, 42, 56)
        
        let backMidLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[backMidLeftChar]]?.first ?? "")!
        backMidLeftUIView.image = backMidLeftUIImage
        backMidLeftUIView.frame = CGRectMake((bounds.width / 2) - 80 - 24, (bounds.size.height / 2) - 60, 48, 64)
        
        let backMidRightUIImage: UIImage = UIImage(named: characterMap[characterArray[backMidRightChar]]?.first ?? "")!
        backMidRightUIView.image = backMidRightUIImage
        backMidRightUIView.frame = CGRectMake((bounds.width / 2) + 80 - 24, (bounds.size.height / 2) - 60, 48, 64)
        
        let frontMidLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[frontMidLeftChar]]?.first ?? "")!
        frontMidLeftUIView.image = frontMidLeftUIImage
        frontMidLeftUIView.frame = CGRectMake((bounds.width / 2) - 85 - 27, (bounds.size.height / 2) - 45, 54, 72)
        
        let frontMidRightUIImage: UIImage = UIImage(named: characterMap[characterArray[frontMidRightChar]]?.first ?? "")!
        frontMidRightUIView.image = frontMidRightUIImage
        frontMidRightUIView.frame = CGRectMake((bounds.width / 2) + 85 - 27, (bounds.size.height / 2) - 45, 54, 72)
        
        let frontLeftUIImage: UIImage = UIImage(named: characterMap[characterArray[frontLeftChar]]?.first ?? "")!
        frontLeftUIView.image = frontLeftUIImage
        frontLeftUIView.frame = CGRectMake((bounds.width / 2) - 55 - 32, (bounds.size.height / 2) - 30, 63, 84)
        
        let frontRightUIImage: UIImage = UIImage(named: characterMap[characterArray[frontRightChar]]?.first ?? "")!
        frontRightUIView.image = frontRightUIImage
        frontRightUIView.frame = CGRectMake((bounds.width / 2) + 55 - 32, (bounds.size.height / 2) - 30, 63, 84)
        
        var characterImages = characterMap[characterArray[currentSelectedChar]]
        var characterAnimationImages: [UIImage] = []
        if let characterStrings = characterImages as [String]!{
            for characterImageString in characterStrings{
                let characterImage: UIImage = UIImage(named: characterImageString)!
                characterAnimationImages.append(characterImage)
            }
        }
        
        selectedUIView.animationImages = characterAnimationImages
        //selectedUIView.animationImages = characterMap[characterArray[currentSelectedChar]]
        selectedUIView.frame = CGRectMake((bounds.width / 2) - 36, bounds.height / 2 - 30, 72, 96)
        
        //Locked image
        let lockedImage: UIImage = UIImage(named: "Lock")!
        lockedUIView.image = lockedImage
        lockedUIView.frame = CGRectMake((bounds.width / 2) - 15, bounds.height / 2 + 3, 30, 30)
        
        //Cost star image view
        if(characterCost[currentSelectedChar] == 250){
            let starUIImage: UIImage = UIImage(named: "Cost250")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }
        else if(characterCost[currentSelectedChar] == 500){
            let starUIImage: UIImage = UIImage(named: "Cost500")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }else if(characterCost[currentSelectedChar] == 1000){
            let starUIImage: UIImage = UIImage(named: "Cost1000")!
            costStarUIView.image = starUIImage
            costStarUIView.frame = CGRectMake((bounds.width / 2) - 42, (bounds.height / 2) + 70, 84, 30)
        }
        
        if(characterUnlock[currentSelectedChar] == true){
            costStarUIView.hidden = true
            selectButton.hidden = false
            unlockButton.hidden = true
            lockedUIView.hidden = true
            selectedUIView.startAnimating()
        }
        else{
            costStarUIView.hidden = false
            selectButton.hidden = true
            unlockButton.hidden = false
            lockedUIView.hidden = false
        }
        
        //Unlock components
        unlockBackgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        unlockBackgroundView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        unlockBackgroundView.hidden = true
        
        let confirmUIImage: UIImage = UIImage(named: "Confirm")!
        confirmUIView.image = confirmUIImage
        confirmUIView.frame = CGRectMake((bounds.width / 2) - 113, (bounds.height / 2) - 75, 226, 150)
        confirmUIView.hidden = true
        
        confirmLabel.text = "Do you want to unlock this character?"
        confirmLabel.font = UIFont(name: "MarkerFelt-Thin", size: 20)
        confirmLabel.textColor = UIColor.whiteColor()
        confirmLabel.textAlignment = NSTextAlignment.Center
        confirmLabel.numberOfLines = 0
        confirmLabel.frame = CGRectMake((bounds.width / 2) - 100, (bounds.height / 2) - 60, 200, 65)
        confirmLabel.hidden = true
        
        //Yes button
        let confirmYesImage = UIImage(named: "ConfirmYesButton") as UIImage?
        confirmYesButton.frame = CGRectMake((bounds.width / 2) - 85, (bounds.height / 2) + 25, 60, 40)
        confirmYesButton.setImage(confirmYesImage, forState: .Normal)
        confirmYesButton.addTarget(self, action: "confirmYesButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        confirmYesButton.hidden = true
        
        //No button
        let confirmNoImage = UIImage(named: "ConfirmNoButton") as UIImage?
        confirmNoButton.frame = CGRectMake((bounds.width / 2) + 25, (bounds.height / 2) + 25, 60, 40)
        confirmNoButton.setImage(confirmNoImage, forState: .Normal)
        confirmNoButton.addTarget(self, action: "confirmNoButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        confirmNoButton.hidden = true
        
        self.view.addSubview(furthestBackLeftUIView)
        self.view.addSubview(furthestBackRightUIView)
        self.view.addSubview(backLeftUIView)
        self.view.addSubview(backRightUIView)
        self.view.addSubview(backMidLeftUIView)
        self.view.addSubview(backMidRightUIView)
        self.view.addSubview(frontMidLeftUIView)
        self.view.addSubview(frontMidRightUIView)
        self.view.addSubview(frontLeftUIView)
        self.view.addSubview(frontRightUIView)
        self.view.addSubview(selectedUIView)
        self.view.addSubview(costStarUIView)
        self.view.addSubview(unlockBackgroundView)
        self.view.addSubview(confirmUIView)
        self.view.addSubview(confirmLabel)
        self.view.addSubview(confirmYesButton)
        self.view.addSubview(confirmNoButton)
        //self.view.addSubview(lockedUIView)
    }
    
    func startAnimation() -> Void {
        selectedUIView.animationImages = currentImageList
        selectedUIView.startAnimating()
    }
    
    func stopAnimation() -> Void {
        selectedUIView.stopAnimating()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
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