//
//  ModeViewController.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import UIKit
import iAd

class ModeViewController: UIViewController, ADBannerViewDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, purchaseRefresh {
    var starsCollectedUIView: UIImageView = UIImageView()
    var starsCollectedLabel: UILabel = UILabel()
    var backgroundUIView: UIImageView = UIImageView()
    var loadingScreenUIView: UIImageView = UIImageView()
    
    var iAdBannerHeight: CGFloat = 40
    
    //Label Modes
    var castleLabel: UILabel = UILabel()
    var iceAgeLabel: UILabel = UILabel()
    var pyramidLabel: UILabel = UILabel()
    var stadiumLabel: UILabel = UILabel()
    var jurassicLabel: UILabel = UILabel()
    
    //Game Modes
    var castleModeButton: UIButton = UIButton()
    var iceAgeModeButton: UIButton = UIButton()
    var pyramidModeButton: UIButton = UIButton()
    var stadiumModeButton: UIButton = UIButton()
    var jurassicModeButton: UIButton = UIButton()
    
    var iceAgeLockedUIView: UIImageView = UIImageView()
    var pyramidLockedUIView: UIImageView = UIImageView()
    var stadiumLockedUIView: UIImageView = UIImageView()
    var jurassicLockedUIView: UIImageView = UIImageView()
    
    var iceAgeCostUIView: UIImageView = UIImageView()
    var pyramidCostUIView: UIImageView = UIImageView()
    var stadiumCostUIView: UIImageView = UIImageView()
    var jurassicCostUIView: UIImageView = UIImageView()
    
    var loadingScreenTimer: NSTimer = NSTimer()
    
    //Unlock confirmation
    var unlockBackgroundView: UIView = UIView()
    var confirmUIView: UIImageView = UIImageView()
    var confirmYesButton: UIButton = UIButton()
    var confirmNoButton: UIButton = UIButton()
    var confirmLabel: UILabel = UILabel()
    
    var backButton: UIButton = UIButton()
    var purchaseButton: UIButton = UIButton()
    
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    var castleModeUnlocked: Bool = true
    var iceAgeModeUnlocked: Bool = false
    var pyramidModeUnlocked: Bool = false
    var stadiumModeUnlocked: Bool = false
    var jurassicModeUnlocked: Bool = false
    var currentSelectedMode: String = "Casle"
    
    var scrollView: UIScrollView = UIScrollView()
    var containerView: UIView = UIView()
    var containerSize: CGSize = CGSize()
    
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
        
        //Refresh stars collected
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected > 0){
            starsCollectedLabel.text = NSString(format: "%i", starsCollected)
        }else{
            starsCollectedLabel.text = NSString(format: "0")
        }
        
        loadingScreenUIView.hidden = true
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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        var iAdSpace: CGFloat = 20
        
        if(!self.appdelegate().iAdsUnlocked){
            iAdSpace = 60
        }
        
        let originalWidth:CGFloat = 226
        let originalHeight:CGFloat = 70
        var newWidth:CGFloat = (bounds.width - 20)
        var newHeight:CGFloat = (newWidth / originalWidth) * originalHeight
        
        //Load background
        let backgroundImage = UIImage(named: "LaunchImage") as UIImage?
        backgroundUIView.image = backgroundImage
        backgroundUIView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        self.view.addSubview(backgroundUIView)
        
        //Stars collected Image View
        let starsCollectedUIImage: UIImage = UIImage(named: "StarsCollected")!
        starsCollectedUIView.image = starsCollectedUIImage
        starsCollectedUIView.frame = CGRectMake((bounds.width / 2) - 100, iAdSpace, 200, 40)
        self.view.addSubview(starsCollectedUIView)
        
        //Back button
        let backImage = UIImage(named: "BackButton") as UIImage?
        backButton.frame = CGRectMake(10, iAdSpace, 40, 40)
        backButton.setImage(backImage, forState: .Normal)
        backButton.addTarget(self, action: "backButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        
        //Purchase button
        let purchaseImage = UIImage(named: "PurchaseButton") as UIImage?
        purchaseButton.frame = CGRectMake(bounds.width - 50, iAdSpace, 40, 40)
        purchaseButton.setImage(purchaseImage, forState: .Normal)
        purchaseButton.addTarget(self, action: "purchaseButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(purchaseButton)
        
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected > 0){
            starsCollectedLabel.text = NSString(format: "%i", starsCollected)
        }else{
            starsCollectedLabel.text = NSString(format: "0")
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "ZPExtStarsCollected")
        }
        
        starsCollectedLabel.font = UIFont(name: "MarkerFelt-Thin", size: 25)
        starsCollectedLabel.textColor = UIColor.whiteColor()
        starsCollectedLabel.textAlignment = NSTextAlignment.Right
        starsCollectedLabel.frame = CGRectMake((bounds.width / 2) - 60, iAdSpace, 145, 40)
        self.view.addSubview(starsCollectedLabel)
        
        //Scrollview setup
        let startY: CGFloat = starsCollectedUIView.frame.origin.y + starsCollectedUIView.frame.height + 20
        let startX = (bounds.width / 2) - (newWidth / 2)
        containerSize = CGSize(width: bounds.width, height: (newHeight * 5) + 5)
        containerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: containerSize))
        containerView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)
        scrollView.frame = CGRect(x: 0, y: startY, width: bounds.width, height: bounds.height - startY)
        
        scrollView.contentSize = containerSize
        //scrollView.delegate = self
        scrollView.panGestureRecognizer.delaysTouchesBegan = scrollView.delaysContentTouches
        
        //Retrieve unlocked modes
        pyramidModeUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtPyramidModeUnlocked")
        iceAgeModeUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtIceAgeModeUnlocked")
        stadiumModeUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtStadiumModeUnlocked")
        jurassicModeUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtJurassicModeUnlocked")
        
        //Classic mode button
        let classicImage = UIImage(named: "ModeCastle") as UIImage?
        castleModeButton.frame = CGRectMake((bounds.width / 2) - (newWidth / 2), 0, newWidth, newHeight)
        castleModeButton.setImage(classicImage, forState: .Normal)
        castleModeButton.addTarget(self, action: "castleButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(castleModeButton)
        
        //Castle label
        castleLabel.text = "Castle"
        castleLabel.font = UIFont(name: "MarkerFelt-Thin", size: 36)
        castleLabel.textColor = UIColor.whiteColor()
        castleLabel.textAlignment = NSTextAlignment.Center
        castleLabel.frame = CGRectMake((bounds.width / 2) - 75, (newHeight / 2) - 18, 150, 40)
        containerView.addSubview(castleLabel)
        
        //Ice Age mode button
        let iceAgeImage = UIImage(named: "ModeIceAge") as UIImage?
        iceAgeModeButton.frame = CGRectMake((bounds.width / 2) - (newWidth / 2), castleModeButton.frame.origin.y + newHeight, newWidth, newHeight)
        iceAgeModeButton.setImage(iceAgeImage, forState: .Normal)
        iceAgeModeButton.addTarget(self, action: "iceAgeButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(iceAgeModeButton)
        
        //Ice Age label
        iceAgeLabel.text = "Ice Age"
        iceAgeLabel.font = UIFont(name: "MarkerFelt-Thin", size: 36)
        iceAgeLabel.textColor = UIColor.whiteColor()
        iceAgeLabel.textAlignment = NSTextAlignment.Center
        iceAgeLabel.frame = CGRectMake((bounds.width / 2) - 75, iceAgeModeButton.frame.origin.y + (newHeight / 2) - 18, 150, 40)
        containerView.addSubview(iceAgeLabel)
        
        //Ice Age Locked
        let iceAgeLockedImage: UIImage = UIImage(named: "Lock")!
        iceAgeLockedUIView.image = iceAgeLockedImage
        iceAgeLockedUIView.frame = CGRectMake(iceAgeModeButton.frame.origin.x + 2, iceAgeModeButton.frame.origin.y + 2, 30, 30)
        let iceAgeCostImage: UIImage = UIImage(named: "Cost250")!
        iceAgeCostUIView.image = iceAgeCostImage
        iceAgeCostUIView.frame = CGRectMake(iceAgeModeButton.frame.origin.x + 2, iceAgeModeButton.frame.origin.y + 34, 84, 30)
        
        if(iceAgeModeUnlocked){
            iceAgeLockedUIView.hidden = true
            iceAgeCostUIView.hidden = true
        }else{
            iceAgeLockedUIView.hidden = false
            iceAgeCostUIView.hidden = false
        }
        
        containerView.addSubview(iceAgeLockedUIView)
        containerView.addSubview(iceAgeCostUIView)
        
        //Pyramid mode button
        let pyramidImage = UIImage(named: "ModePyramid") as UIImage?
        pyramidModeButton.frame = CGRectMake((bounds.width / 2) - (newWidth / 2), iceAgeModeButton.frame.origin.y + newHeight, newWidth, newHeight)
        pyramidModeButton.setImage(pyramidImage, forState: .Normal)
        pyramidModeButton.addTarget(self, action: "pyramidButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(pyramidModeButton)
        
        //Pyramid label
        pyramidLabel.text = "Pyramid"
        pyramidLabel.font = UIFont(name: "MarkerFelt-Thin", size: 36)
        pyramidLabel.textColor = UIColor.whiteColor()
        pyramidLabel.textAlignment = NSTextAlignment.Center
        pyramidLabel.frame = CGRectMake((bounds.width / 2) - 75, pyramidModeButton.frame.origin.y + (newHeight / 2) - 18, 150, 40)
        containerView.addSubview(pyramidLabel)
        
        //Pyramid Locked
        let pyramidLockedImage: UIImage = UIImage(named: "Lock")!
        pyramidLockedUIView.image = pyramidLockedImage
        pyramidLockedUIView.frame = CGRectMake(pyramidModeButton.frame.origin.x + 2, pyramidModeButton.frame.origin.y + 2, 30, 30)
        let pyramidCostImage: UIImage = UIImage(named: "Cost250")!
        pyramidCostUIView.image = pyramidCostImage
        pyramidCostUIView.frame = CGRectMake(pyramidModeButton.frame.origin.x + 2, pyramidModeButton.frame.origin.y + 34, 84, 30)
        
        if(pyramidModeUnlocked){
            pyramidLockedUIView.hidden = true
            pyramidCostUIView.hidden = true
        }else{
            pyramidLockedUIView.hidden = false
            pyramidCostUIView.hidden = false
        }
        
        containerView.addSubview(pyramidLockedUIView)
        containerView.addSubview(pyramidCostUIView)
        
        //Stadium mode button
        let stadiumImage = UIImage(named: "ModeStadium") as UIImage?
        stadiumModeButton.frame = CGRectMake((bounds.width / 2) - (newWidth / 2), pyramidModeButton.frame.origin.y + newHeight, newWidth, newHeight)
        stadiumModeButton.setImage(stadiumImage, forState: .Normal)
        stadiumModeButton.addTarget(self, action: "stadiumButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(stadiumModeButton)
        
        //Stadium label
        stadiumLabel.text = "Stadium"
        stadiumLabel.font = UIFont(name: "MarkerFelt-Thin", size: 36)
        stadiumLabel.textColor = UIColor.whiteColor()
        stadiumLabel.textAlignment = NSTextAlignment.Center
        stadiumLabel.frame = CGRectMake((bounds.width / 2) - 75, stadiumModeButton.frame.origin.y + (newHeight / 2) - 18, 150, 40)
        containerView.addSubview(stadiumLabel)
        
        //Stadium Locked
        let stadiumLockedImage: UIImage = UIImage(named: "Lock")!
        stadiumLockedUIView.image = stadiumLockedImage
        stadiumLockedUIView.frame = CGRectMake(stadiumModeButton.frame.origin.x + 2, stadiumModeButton.frame.origin.y + 2, 30, 30)
        let stadiumCostImage: UIImage = UIImage(named: "Cost250")!
        stadiumCostUIView.image = stadiumCostImage
        stadiumCostUIView.frame = CGRectMake(stadiumModeButton.frame.origin.x + 2, stadiumModeButton.frame.origin.y + 34, 84, 30)
        
        if(stadiumModeUnlocked){
            stadiumLockedUIView.hidden = true
            stadiumCostUIView.hidden = true
        }else{
            stadiumLockedUIView.hidden = false
            stadiumCostUIView.hidden = false
        }
        
        containerView.addSubview(stadiumLockedUIView)
        containerView.addSubview(stadiumCostUIView)
        
        //Jurassic mode button
        let jurassicImage = UIImage(named: "ModeJurassic") as UIImage?
        jurassicModeButton.frame = CGRectMake((bounds.width / 2) - (newWidth / 2), stadiumModeButton.frame.origin.y + newHeight, newWidth, newHeight)
        jurassicModeButton.setImage(jurassicImage, forState: .Normal)
        jurassicModeButton.addTarget(self, action: "jurassicButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(jurassicModeButton)
        
        //Jurassic label
        jurassicLabel.text = "Jurassic"
        jurassicLabel.font = UIFont(name: "MarkerFelt-Thin", size: 36)
        jurassicLabel.textColor = UIColor.whiteColor()
        jurassicLabel.textAlignment = NSTextAlignment.Center
        jurassicLabel.frame = CGRectMake((bounds.width / 2) - 75, jurassicModeButton.frame.origin.y + (newHeight / 2) - 18, 150, 40)
        containerView.addSubview(jurassicLabel)
        
        //Jurassic Locked
        let jurassicLockedImage: UIImage = UIImage(named: "Lock")!
        jurassicLockedUIView.image = jurassicLockedImage
        jurassicLockedUIView.frame = CGRectMake(jurassicModeButton.frame.origin.x + 2, jurassicModeButton.frame.origin.y + 2, 30, 30)
        let jurassicCostImage: UIImage = UIImage(named: "Cost250")!
        jurassicCostUIView.image = jurassicCostImage
        jurassicCostUIView.frame = CGRectMake(jurassicModeButton.frame.origin.x + 2, jurassicModeButton.frame.origin.y + 34, 84, 30)
        
        if(jurassicModeUnlocked){
            jurassicLockedUIView.hidden = true
            jurassicCostUIView.hidden = true
        }else{
            jurassicLockedUIView.hidden = false
            jurassicCostUIView.hidden = false
        }
        
        containerView.addSubview(jurassicLockedUIView)
        containerView.addSubview(jurassicCostUIView)
        
        //Unlock components
        unlockBackgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        unlockBackgroundView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        unlockBackgroundView.hidden = true
        self.view.addSubview(unlockBackgroundView)
        
        let confirmUIImage: UIImage = UIImage(named: "Confirm")!
        confirmUIView.image = confirmUIImage
        confirmUIView.frame = CGRectMake((bounds.width / 2) - 113, (bounds.height / 2) - 75, 226, 150)
        confirmUIView.hidden = true
        
        confirmLabel.text = "Do you want to unlock this mode?"
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
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        self.view.addSubview(confirmUIView)
        self.view.addSubview(confirmLabel)
        self.view.addSubview(confirmYesButton)
        self.view.addSubview(confirmNoButton)
    }
    
    func confirmYesButtonAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        var remainingStars: Int = starsCollected - 250
        //Set char unlocked
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ZPExt" + currentSelectedMode + "ModeUnlocked")
        //Set remaining stars
        NSUserDefaults.standardUserDefaults().setInteger(remainingStars, forKey: "ZPExtStarsCollected")
        
        starsCollectedLabel.text = NSString(format: "%i", remainingStars)
        
        if(currentSelectedMode == "IceAge"){
            iceAgeModeUnlocked = true
            iceAgeLockedUIView.hidden = true
            iceAgeCostUIView.hidden = true
        }else if(currentSelectedMode == "Pyramid"){
            pyramidModeUnlocked = true
            pyramidLockedUIView.hidden = true
            pyramidCostUIView.hidden = true
        }else if(currentSelectedMode == "Stadium"){
            stadiumModeUnlocked = true
            stadiumLockedUIView.hidden = true
            stadiumCostUIView.hidden = true
        }else if(currentSelectedMode == "Jurassic"){
            jurassicModeUnlocked = true
            jurassicLockedUIView.hidden = true
            jurassicCostUIView.hidden = true
        }
        
        unlockBackgroundView.hidden = true
        confirmUIView.hidden = true
        confirmLabel.hidden = true
        confirmYesButton.hidden = true
        confirmNoButton.hidden = true
    }
    
    func confirmNoButtonAction(sender: UIButton!){
        unlockBackgroundView.hidden = true
        confirmUIView.hidden = true
        confirmLabel.hidden = true
        confirmYesButton.hidden = true
        confirmNoButton.hidden = true
    }
    
    func castleButtonAction(sender: UIButton!){
        NSUserDefaults.standardUserDefaults().setValue("Castle", forKey: "ZPExtSelectedMode")
        loadingScreen()
        //self.performSegueWithIdentifier("startGameSegue", sender: self)
    }
    
    func iceAgeButtonAction(sender: UIButton!){
        currentSelectedMode = "IceAge"
        
        if(iceAgeModeUnlocked){
            NSUserDefaults.standardUserDefaults().setValue("IceAge", forKey: "ZPExtSelectedMode")
            loadingScreen()
            //self.performSegueWithIdentifier("startGameSegue", sender: self)
        }else{
            //Load stars collected
            let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
            
            if (starsCollected >= 250){
                confirmLabel.text = "Do you want to unlock Ice Age mode?"
                
                unlockBackgroundView.hidden = false
                confirmUIView.hidden = false
                confirmLabel.hidden = false
                confirmYesButton.hidden = false
                confirmNoButton.hidden = false
            }else{
                //Show in-purchases
                var purchaseViewController = PurchaseViewController()
                
                self.providesPresentationContextTransitionStyle = true
                self.definesPresentationContext = true
                purchaseViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                purchaseViewController.preferredContentSize = CGSizeMake(226, 300)
                let popoverViewController = purchaseViewController.popoverPresentationController
                
                popoverViewController?.delegate = self
                popoverViewController?.sourceView = self.view
                self.presentViewController(purchaseViewController, animated: true, completion: nil)
            }
        }
    }
    
    func stadiumButtonAction(sender: UIButton!){
        currentSelectedMode = "Stadium"
        
        if(stadiumModeUnlocked){
            NSUserDefaults.standardUserDefaults().setValue("Stadium", forKey: "ZPExtSelectedMode")
            loadingScreen()
            //self.performSegueWithIdentifier("startGameSegue", sender: self)
        }else{
            //Load stars collected
            let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
            
            if (starsCollected >= 250){
                confirmLabel.text = "Do you want to unlock Stadium mode?"
                
                unlockBackgroundView.hidden = false
                confirmUIView.hidden = false
                confirmLabel.hidden = false
                confirmYesButton.hidden = false
                confirmNoButton.hidden = false
            }else{
                //Show in-purchases
                var purchaseViewController = PurchaseViewController()
                
                self.providesPresentationContextTransitionStyle = true
                self.definesPresentationContext = true
                purchaseViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                purchaseViewController.preferredContentSize = CGSizeMake(226, 300)
                let popoverViewController = purchaseViewController.popoverPresentationController
                
                popoverViewController?.delegate = self
                popoverViewController?.sourceView = self.view
                self.presentViewController(purchaseViewController, animated: true, completion: nil)
            }
        }
    }
    
    func pyramidButtonAction(sender: UIButton!){
        currentSelectedMode = "Pyramid"
        
        if(pyramidModeUnlocked){
            NSUserDefaults.standardUserDefaults().setValue("Pyramid", forKey: "ZPExtSelectedMode")
            loadingScreen()
            //self.performSegueWithIdentifier("startGameSegue", sender: self)
            
        }else{
            //Load stars collected
            let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
            
            if (starsCollected >= 250){
                confirmLabel.text = "Do you want to unlock Pyramid mode?"
                
                unlockBackgroundView.hidden = false
                confirmUIView.hidden = false
                confirmLabel.hidden = false
                confirmYesButton.hidden = false
                confirmNoButton.hidden = false
            }else{
                //Show in-purchases
                var purchaseViewController = PurchaseViewController()
                
                self.providesPresentationContextTransitionStyle = true
                self.definesPresentationContext = true
                purchaseViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                purchaseViewController.preferredContentSize = CGSizeMake(226, 300)
                let popoverViewController = purchaseViewController.popoverPresentationController
                
                popoverViewController?.delegate = self
                popoverViewController?.sourceView = self.view
                self.presentViewController(purchaseViewController, animated: true, completion: nil)
            }
        }
    }
    
    func jurassicButtonAction(sender: UIButton!){
        currentSelectedMode = "Jurassic"
        
        if(jurassicModeUnlocked){
            NSUserDefaults.standardUserDefaults().setValue("Jurassic", forKey: "ZPExtSelectedMode")
            loadingScreen()
            //self.performSegueWithIdentifier("startGameSegue", sender: self)
        }else{
            //Load stars collected
            let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
            
            if (starsCollected >= 250){
                confirmLabel.text = "Do you want to unlock Jurassic mode?"
                
                unlockBackgroundView.hidden = false
                confirmUIView.hidden = false
                confirmLabel.hidden = false
                confirmYesButton.hidden = false
                confirmNoButton.hidden = false
            }else{
                showPurchases()
            }
        }
    }
    
    func loadingScreen(){
        //Loading screen
        let loadingScreenImage = UIImage(named: "LoadingScreen") as UIImage?
        let loadingScreenOriginalWidth: CGFloat = 600
        let loadingScreenOriginalHeight: CGFloat = 1200
        var loadingScreenNewWidth:CGFloat = bounds.width
        var loadingScreenNewHeight:CGFloat = (loadingScreenNewWidth / loadingScreenOriginalWidth) * loadingScreenOriginalHeight
        loadingScreenUIView.image = loadingScreenImage
        var heightDifference: CGFloat = (loadingScreenNewHeight - bounds.height)/2
        loadingScreenUIView.frame = CGRectMake(0, -heightDifference, loadingScreenNewWidth, loadingScreenNewHeight)
        loadingScreenUIView.hidden = false
        self.view.addSubview(loadingScreenUIView)
        
        loadingScreenTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("loadingScreenFinish"), userInfo: nil, repeats: false)
    }
    
    @objc func loadingScreenFinish(){
        //loadingScreenUIView.hidden = true
        self.performSegueWithIdentifier("startGameSegue", sender: self)
    }
    
    func backButtonAction(sender: UIButton!){
        self.dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("unwindToMainMenu", sender: self)
        })
    }
    
    func purchaseButtonAction(sender: UIButton!){
        showPurchases()
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
    
    @IBAction func unwindToModeMenu(segue:UIStoryboardSegue){
        //println("back to unwindToModeMenu")
        //self.dismissViewControllerAnimated(false, completion: {})
        //self.performSegueWithIdentifier("unwindToMainMenu", sender: self)
        
        println("Mode stars refreshed")
        //Refresh stars collected
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected > 0){
            starsCollectedLabel.text = NSString(format: "%i", starsCollected)
        }else{
            starsCollectedLabel.text = NSString(format: "0")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}