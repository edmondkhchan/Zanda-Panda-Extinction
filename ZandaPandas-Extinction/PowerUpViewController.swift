//
//  PowerUpViewController.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import UIKit
import iAd
import AVFoundation

class PowerUpViewController: UIViewController, ADBannerViewDelegate, UIPopoverPresentationControllerDelegate, UIScrollViewDelegate, purchaseRefresh {
    var iAdBannerHeight: CGFloat = 40
    
    var exitButton: UIButton = UIButton()
    
    //Background Image View
    var backgroundUIView: UIImageView = UIImageView()
    var powerUpTitleUIView: UIImageView = UIImageView()
    
    var starsCollectedUIView: UIImageView = UIImageView()
    var starsCollectedLabel: UILabel = UILabel()
    
    var fastPowerUpCost: Int = 25
    var fastPowerUpUIView: UIImageView = UIImageView()
    var fastCostUIView: UIImageView = UIImageView()
    var buyFastPowerUpButton: UIButton = UIButton()
    var bananaPeelThrowCost: Int = 15
    var bananaPeelThrowUIView: UIImageView = UIImageView()
    var bananaPeelThrowCostUIView: UIImageView = UIImageView()
    var buyBananaPeelThrowButton: UIButton = UIButton()
    var shrinkPowerUpCost: Int = 15
    var shrinkPowerUpUIView: UIImageView = UIImageView()
    var shrinkCostUIView: UIImageView = UIImageView()
    var buyShrinkPowerUpButton: UIButton = UIButton()
    var powerUpComboX3Cost: Int = 150
    var powerUpComboX3UIView: UIImageView = UIImageView()
    var comboX3CostUIView: UIImageView = UIImageView()
    var buyComboX3PowerUpButton: UIButton = UIButton()
    var powerUpComboX5Cost: Int = 240
    var powerUpComboX5UIView: UIImageView = UIImageView()
    var comboX5CostUIView: UIImageView = UIImageView()
    var buyComboX5PowerUpButton: UIButton = UIButton()
    var powerUpComboX10Cost: Int = 450
    var powerUpComboX10UIView: UIImageView = UIImageView()
    var comboX10CostUIView: UIImageView = UIImageView()
    var buyComboX10PowerUpButton: UIButton = UIButton()
    
    var purchaseButton: UIButton = UIButton()
    
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    var scrollView: UIScrollView = UIScrollView()
    var scrollHeight: CGFloat = 380
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
        
        //Load background
        let backgroundImage = UIImage(named: "LaunchImage") as UIImage?
        backgroundUIView.image = backgroundImage
        backgroundUIView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        self.view.addSubview(backgroundUIView)
        
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
        
        //Load power up title image
        let powerUpTitleImage = UIImage(named: "PowerUpTitle") as UIImage?
        powerUpTitleUIView.image = powerUpTitleImage
        powerUpTitleUIView.frame = CGRectMake((bounds.width / 2) - (newWidth / 2), starsCollectedUIView.frame.origin.y + starsCollectedUIView.frame.height + 5, newWidth, newHeight)
        self.view.addSubview(powerUpTitleUIView)
        
        //Scrollview setup
        let startY: CGFloat = powerUpTitleUIView.frame.origin.y + powerUpTitleUIView.frame.height + 5
        let startX = (bounds.width / 2) - (newWidth / 2)
        containerSize = CGSize(width: bounds.width, height: scrollHeight + 5)
        containerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: containerSize))
        containerView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)
        scrollView.frame = CGRect(x: 0, y: startY, width: bounds.width, height: bounds.height - startY)
        
        scrollView.contentSize = containerSize
        //scrollView.delegate = self
        scrollView.panGestureRecognizer.delaysTouchesBegan = scrollView.delaysContentTouches
        
        //Fast power up image
        let fastPowerUpImage = UIImage(named: "FastPowerUpButton") as UIImage?
        fastPowerUpUIView.image = fastPowerUpImage
        fastPowerUpUIView.frame = CGRectMake((bounds.size.width/2) - 120, 0, 60, 60)
        scrollView.addSubview(fastPowerUpUIView)
        
        let star25UIImage: UIImage = UIImage(named: "Cost25")!
        fastCostUIView.image = star25UIImage
        fastCostUIView.frame = CGRectMake(fastPowerUpUIView.frame.origin.x - 12, fastPowerUpUIView.frame.origin.y + 62, 84, 30)
        scrollView.addSubview(fastCostUIView)
        
        //Buy fast power up button
        let buyFastPowerUpImage = UIImage(named: "BuyButton") as UIImage?
        buyFastPowerUpButton.frame = CGRectMake(fastCostUIView.frame.origin.x + 24, fastCostUIView.frame.origin.y + 32, 36, 30)
        buyFastPowerUpButton.setImage(buyFastPowerUpImage, forState: .Normal)
        buyFastPowerUpButton.addTarget(self, action: "buyFastPowerUpAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(buyFastPowerUpButton)
        
        //Banana peel power up image
        let bananaPeelThrowImage = UIImage(named: "BananaPeelThrowButton") as UIImage?
        bananaPeelThrowUIView.image = bananaPeelThrowImage
        bananaPeelThrowUIView.frame = CGRectMake((bounds.size.width/2) - 30, 0, 60, 60)
        scrollView.addSubview(bananaPeelThrowUIView)
        
        let star15BananaPeelUIImage: UIImage = UIImage(named: "Cost15")!
        bananaPeelThrowCostUIView.image = star15BananaPeelUIImage
        bananaPeelThrowCostUIView.frame = CGRectMake(bananaPeelThrowUIView.frame.origin.x - 12, bananaPeelThrowUIView.frame.origin.y + 62, 84, 30)
        scrollView.addSubview(bananaPeelThrowCostUIView)
        
        //Buy banana peel power up button
        let buyBananaPeelImage = UIImage(named: "BuyButton") as UIImage?
        buyBananaPeelThrowButton.frame = CGRectMake(bananaPeelThrowCostUIView.frame.origin.x + 24, bananaPeelThrowCostUIView.frame.origin.y + 32, 36, 30)
        buyBananaPeelThrowButton.setImage(buyBananaPeelImage, forState: .Normal)
        buyBananaPeelThrowButton.addTarget(self, action: "buyBananaPeelThrowAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(buyBananaPeelThrowButton)
        
        //Shrink power up image
        let shrinkPowerUpImage = UIImage(named: "ShrinkPowerUpButton") as UIImage?
        shrinkPowerUpUIView.image = shrinkPowerUpImage
        shrinkPowerUpUIView.frame = CGRectMake((bounds.size.width/2) + 60, 0, 60, 60)
        scrollView.addSubview(shrinkPowerUpUIView)
        
        let star15ShrinkUIImage: UIImage = UIImage(named: "Cost15")!
        shrinkCostUIView.image = star15ShrinkUIImage
        shrinkCostUIView.frame = CGRectMake(shrinkPowerUpUIView.frame.origin.x - 12, shrinkPowerUpUIView.frame.origin.y + 62, 84, 30)
        scrollView.addSubview(shrinkCostUIView)
        
        //Buy shrink power up button
        let buyShrinkPowerUpImage = UIImage(named: "BuyButton") as UIImage?
        buyShrinkPowerUpButton.frame = CGRectMake(shrinkCostUIView.frame.origin.x + 24, shrinkCostUIView.frame.origin.y + 32, 36, 30)
        buyShrinkPowerUpButton.setImage(buyShrinkPowerUpImage, forState: .Normal)
        buyShrinkPowerUpButton.addTarget(self, action: "buyShrinkPowerUpAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(buyShrinkPowerUpButton)
        
        var powerUpComboX3UIView: UIImageView = UIImageView()
        var comboX3CostUIView: UIImageView = UIImageView()
        var buyComboX3PowerUpButton: UIButton = UIButton()
        
        //Combo x 3 power up image
        let comboX3PowerUpImage = UIImage(named: "PowerUpComboX3") as UIImage?
        powerUpComboX3UIView.image = comboX3PowerUpImage
        powerUpComboX3UIView.frame = CGRectMake(30, buyShrinkPowerUpButton.frame.origin.y + buyShrinkPowerUpButton.frame.height + 5, 80, 80)
        scrollView.addSubview(powerUpComboX3UIView)
        
        let star150UIImage: UIImage = UIImage(named: "Cost150")!
        comboX3CostUIView.image = star150UIImage
        comboX3CostUIView.frame = CGRectMake(powerUpComboX3UIView.frame.origin.x + powerUpComboX3UIView.frame.width + 20, powerUpComboX3UIView.frame.origin.y + 25, 84, 30)
        scrollView.addSubview(comboX3CostUIView)
        
        //Buy combo x3 power up button
        let buyComboX3PowerUpImage = UIImage(named: "BuyButton") as UIImage?
        buyComboX3PowerUpButton.frame = CGRectMake(comboX3CostUIView.frame.origin.x + comboX3CostUIView.frame.width + 10, comboX3CostUIView.frame.origin.y, 36, 30)
        buyComboX3PowerUpButton.setImage(buyComboX3PowerUpImage, forState: .Normal)
        buyComboX3PowerUpButton.addTarget(self, action: "buyComboX3PowerUpAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(buyComboX3PowerUpButton)
        
        //Combo x 5 power up image
        let comboX5PowerUpImage = UIImage(named: "PowerUpComboX5") as UIImage?
        powerUpComboX5UIView.image = comboX5PowerUpImage
        powerUpComboX5UIView.frame = CGRectMake(30, powerUpComboX3UIView.frame.origin.y + powerUpComboX3UIView.frame.height + 5, 80, 80)
        scrollView.addSubview(powerUpComboX5UIView)
        
        let star240UIImage: UIImage = UIImage(named: "Cost240")!
        comboX5CostUIView.image = star240UIImage
        comboX5CostUIView.frame = CGRectMake(powerUpComboX5UIView.frame.origin.x + powerUpComboX5UIView.frame.width + 20, powerUpComboX5UIView.frame.origin.y + 25, 84, 30)
        scrollView.addSubview(comboX5CostUIView)
        
        //Buy combo x5 power up button
        let buyComboX5PowerUpImage = UIImage(named: "BuyButton") as UIImage?
        buyComboX5PowerUpButton.frame = CGRectMake(comboX5CostUIView.frame.origin.x + comboX5CostUIView.frame.width + 10, comboX5CostUIView.frame.origin.y, 36, 30)
        buyComboX5PowerUpButton.setImage(buyComboX5PowerUpImage, forState: .Normal)
        buyComboX5PowerUpButton.addTarget(self, action: "buyComboX5PowerUpAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(buyComboX5PowerUpButton)
        
        //Combo x10 power up image
        let comboX10PowerUpImage = UIImage(named: "PowerUpComboX10") as UIImage?
        powerUpComboX10UIView.image = comboX10PowerUpImage
        powerUpComboX10UIView.frame = CGRectMake(30, powerUpComboX5UIView.frame.origin.y + powerUpComboX5UIView.frame.height + 5, 80, 80)
        scrollView.addSubview(powerUpComboX10UIView)
        
        let star450UIImage: UIImage = UIImage(named: "Cost450")!
        comboX10CostUIView.image = star450UIImage
        comboX10CostUIView.frame = CGRectMake(powerUpComboX10UIView.frame.origin.x + powerUpComboX10UIView.frame.width + 20, powerUpComboX10UIView.frame.origin.y + 25, 84, 30)
        scrollView.addSubview(comboX10CostUIView)
        
        //Buy combo x10 power up button
        let buyComboX10PowerUpImage = UIImage(named: "BuyButton") as UIImage?
        buyComboX10PowerUpButton.frame = CGRectMake(comboX10CostUIView.frame.origin.x + comboX10CostUIView.frame.width + 10, comboX10CostUIView.frame.origin.y, 36, 30)
        buyComboX10PowerUpButton.setImage(buyComboX10PowerUpImage, forState: .Normal)
        buyComboX10PowerUpButton.addTarget(self, action: "buyComboX10PowerUpAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(buyComboX10PowerUpButton)
        
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
    }
    
    func buyFastPowerUpAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected >= fastPowerUpCost){
            var updatedStarsBalance: Int = starsCollected - fastPowerUpCost
            //Set remaining stars
            NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
            
            if (updatedStarsBalance > 0){
                starsCollectedLabel.text = NSString(format: "%i", updatedStarsBalance)
            }else{
                starsCollectedLabel.text = NSString(format: "0")
            }
            
            //Load shrink power up
            let fastPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtFastPowerUps")
            
            var updatedPowerUpBalance: Int = fastPowerUps + 1
            //Set shrink power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedPowerUpBalance, forKey: "ZPExtFastPowerUps")
        }else{
            showPurchases()
        }
    }
    
    func buyShrinkPowerUpAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected >= shrinkPowerUpCost){
            var updatedStarsBalance: Int = starsCollected - shrinkPowerUpCost
            //Set remaining stars
            NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
            
            if (updatedStarsBalance > 0){
                starsCollectedLabel.text = NSString(format: "%i", updatedStarsBalance)
            }else{
                starsCollectedLabel.text = NSString(format: "0")
            }
            
            //Load shrink power up
            let shrinkPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtShrinkPowerUps")
            
            var updatedPowerUpBalance: Int = shrinkPowerUps + 1
            //Set shrink power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedPowerUpBalance, forKey: "ZPExtShrinkPowerUps")
        }else{
            showPurchases()
        }
    }
    
    func buyBananaPeelThrowAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected >= bananaPeelThrowCost){
            var updatedStarsBalance: Int = starsCollected - bananaPeelThrowCost
            //Set remaining stars
            NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
            
            if (updatedStarsBalance > 0){
                starsCollectedLabel.text = NSString(format: "%i", updatedStarsBalance)
            }else{
                starsCollectedLabel.text = NSString(format: "0")
            }
            
            //Load banana peel power up
            let bananaPeelPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtBananaPeelPowerUps")
            
            var updatedPowerUpBalance: Int = bananaPeelPowerUps + 1
            //Set banana peel power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedPowerUpBalance, forKey: "ZPExtBananaPeelPowerUps")
        }else{
            showPurchases()
        }
    }
    
    func buyComboX3PowerUpAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected >= powerUpComboX3Cost){
            var updatedStarsBalance: Int = starsCollected - powerUpComboX3Cost
            //Set remaining stars
            NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
            
            if (updatedStarsBalance > 0){
                starsCollectedLabel.text = NSString(format: "%i", updatedStarsBalance)
            }else{
                starsCollectedLabel.text = NSString(format: "0")
            }
            
            //Load shrink power up
            let fastPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtFastPowerUps")
            
            var updatedFastPowerUpBalance: Int = fastPowerUps + 3
            //Set shrink power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedFastPowerUpBalance, forKey: "ZPExtFastPowerUps")
            
            //Load shrink power up
            let shrinkPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtShrinkPowerUps")
            
            var updatedShrinkPowerUpBalance: Int = shrinkPowerUps + 3
            //Set shrink power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedShrinkPowerUpBalance, forKey: "ZPExtShrinkPowerUps")
        }else{
            showPurchases()
        }
    }
    
    func buyComboX5PowerUpAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected >= powerUpComboX5Cost){
            var updatedStarsBalance: Int = starsCollected - powerUpComboX5Cost
            //Set remaining stars
            NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
            
            if (updatedStarsBalance > 0){
                starsCollectedLabel.text = NSString(format: "%i", updatedStarsBalance)
            }else{
                starsCollectedLabel.text = NSString(format: "0")
            }
            
            //Load shrink power up
            let fastPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtFastPowerUps")
            
            var updatedFastPowerUpBalance: Int = fastPowerUps + 5
            //Set shrink power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedFastPowerUpBalance, forKey: "ZPExtFastPowerUps")
            
            //Load shrink power up
            let shrinkPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtShrinkPowerUps")
            
            var updatedShrinkPowerUpBalance: Int = shrinkPowerUps + 5
            //Set shrink power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedShrinkPowerUpBalance, forKey: "ZPExtShrinkPowerUps")
        }else{
            showPurchases()
        }
    }
    
    func buyComboX10PowerUpAction(sender: UIButton!){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected >= powerUpComboX10Cost){
            var updatedStarsBalance: Int = starsCollected - powerUpComboX10Cost
            //Set remaining stars
            NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
            
            if (updatedStarsBalance > 0){
                starsCollectedLabel.text = NSString(format: "%i", updatedStarsBalance)
            }else{
                starsCollectedLabel.text = NSString(format: "0")
            }
            
            //Load shrink power up
            let fastPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtFastPowerUps")
            
            var updatedFastPowerUpBalance: Int = fastPowerUps + 10
            //Set shrink power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedFastPowerUpBalance, forKey: "ZPExtFastPowerUps")
            
            //Load shrink power up
            let shrinkPowerUps = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtShrinkPowerUps")
            
            var updatedShrinkPowerUpBalance: Int = shrinkPowerUps + 10
            //Set shrink power up balance
            NSUserDefaults.standardUserDefaults().setInteger(updatedShrinkPowerUpBalance, forKey: "ZPExtShrinkPowerUps")
        }else{
            showPurchases()
        }
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
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.Custom
    }
    
    func exitButtonAction(sender: UIButton!){
        self.dismissViewControllerAnimated(true, completion: {
            self.performSegueWithIdentifier("unwindToMainMenu3", sender: self)
        })
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