
//
//  ViewController.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import UIKit
import iAd
import GameKit

class ViewController: UIViewController, ADBannerViewDelegate, UIPopoverPresentationControllerDelegate,GKGameCenterControllerDelegate, UIScrollViewDelegate, purchaseRefresh  {
    var starsCollectedUIView: UIImageView = UIImageView()
    var starsCollectedLabel: UILabel = UILabel()
    var playGameButton: UIButton = UIButton()
    var rateGameButton: UIButton = UIButton()
    var characterButton: UIButton = UIButton()
    var powerUpButton: UIButton = UIButton()
    var leaderboardButton: UIButton = UIButton()
    var versionLabel: UILabel = UILabel()
    
    var purchaseButton: UIButton = UIButton()
    
    //Background Image View
    var backgroundUIView: UIImageView = UIImageView()
    var zandaPandasUIView: UIImageView = UIImageView()
    
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    //iAd banner
    var iAdBannerView:ADBannerView = ADBannerView()
    
    var scrollView: UIScrollView = UIScrollView()
    var scrollHeight: CGFloat = 215
    var containerView: UIView = UIView()
    var containerSize: CGSize = CGSize()
    
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
        //NSLog("viewcontroller main menu")
        var iAdSpace: CGFloat = 20
        
        if(!self.appdelegate().iAdsUnlocked){
            appdelegate().lastAdDisplay = NSDate()
            appdelegate().showChartboostAds()
            iAdSpace = 60
        }
        
        let originalWidth:CGFloat = 700
        let originalHeight:CGFloat = 450
        var newWidth:CGFloat = (bounds.width - 20)
        var newHeight:CGFloat = (newWidth / originalWidth) * originalHeight
        
        //Load Char
        let selectedChar = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtSelectedChar")
        
        if(selectedChar == 0){
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "ZPExtSelectedChar")
        }
        
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
        
        //Purchase button
        let purchaseImage = UIImage(named: "PurchaseButton") as UIImage?
        purchaseButton.frame = CGRectMake(bounds.width - 50, iAdSpace, 40, 40)
        purchaseButton.setImage(purchaseImage, forState: .Normal)
        purchaseButton.addTarget(self, action: "purchaseButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(purchaseButton)
        
        //Load Zanda Panda main image
        let zandaPandasImage = UIImage(named: "MainImage") as UIImage?
        zandaPandasUIView.image = zandaPandasImage
        zandaPandasUIView.frame = CGRectMake((bounds.width / 2) - (newWidth / 2), starsCollectedUIView.frame.origin.y + 45, newWidth, newHeight)
        self.view.addSubview(zandaPandasUIView)
        
        //Scrollview setup
        let startY: CGFloat = zandaPandasUIView.frame.origin.y + zandaPandasUIView.frame.height + 5
        let startX = (bounds.width / 2) - (newWidth / 2)
        containerSize = CGSize(width: bounds.width, height: scrollHeight + 5)
        containerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: containerSize))
        containerView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)
        scrollView.frame = CGRect(x: 0, y: startY, width: bounds.width, height: bounds.height - startY)
        
        scrollView.contentSize = containerSize
        //scrollView.delegate = self
        scrollView.panGestureRecognizer.delaysTouchesBegan = scrollView.delaysContentTouches
        
        let playGameImage = UIImage(named: "PlayMenuButton") as UIImage?
        playGameButton.frame = CGRectMake((bounds.width / 2) - 113, 0, 226, 35)
        playGameButton.setImage(playGameImage, forState: .Normal)
        playGameButton.addTarget(self, action: "playButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(playGameButton)
        
        let characterGameImage = UIImage(named: "CharacterMenuButton") as UIImage?
        characterButton.frame = CGRectMake((bounds.width / 2) - 113, playGameButton.frame.origin.y + 45, 226, 35)
        characterButton.setImage(characterGameImage, forState: .Normal)
        characterButton.addTarget(self, action: "characterButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(characterButton)
        
        /*let PowerUpGameImage = UIImage(named: "PowerUpMenuButton") as UIImage?
        powerUpButton.frame = CGRectMake((bounds.width / 2) - 113, characterButton.frame.origin.y + 45, 226, 35)
        powerUpButton.setImage(PowerUpGameImage, forState: .Normal)
        powerUpButton.addTarget(self, action: "powerUpButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(powerUpButton)
        
        let leaderboardImage = UIImage(named: "LeaderboardMenuButton") as UIImage?
        leaderboardButton.frame = CGRectMake((bounds.width / 2) - 113, powerUpButton.frame.origin.y + 45, 226, 35)
        leaderboardButton.setImage(leaderboardImage, forState: .Normal)
        leaderboardButton.addTarget(self, action: "leaderboardButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(leaderboardButton)*/
        
        let leaderboardImage = UIImage(named: "LeaderboardMenuButton") as UIImage?
        leaderboardButton.frame = CGRectMake((bounds.width / 2) - 113, characterButton.frame.origin.y + 45, 226, 35)
        leaderboardButton.setImage(leaderboardImage, forState: .Normal)
        leaderboardButton.addTarget(self, action: "leaderboardButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(leaderboardButton)
        
        let rateGameImage = UIImage(named: "RateMenuButton") as UIImage?
        rateGameButton.frame = CGRectMake((bounds.width / 2) - 113, leaderboardButton.frame.origin.y + 45, 226, 35)
        rateGameButton.setImage(rateGameImage, forState: .Normal)
        rateGameButton.addTarget(self, action: "rateButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(rateGameButton)
        
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        //Game center
        authenticateLocalPlayer()
    }
    
    func rateButtonAction(sender: UIButton!){
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1003758920")!)
    }
    
    func playButtonAction(sender: UIButton!){
        self.performSegueWithIdentifier("playSegue", sender: self)
    }
    
    func characterButtonAction(sender: UIButton!){
        self.performSegueWithIdentifier("characterSegue", sender: self)
    }
    
    func powerUpButtonAction(sender: UIButton!){
        self.performSegueWithIdentifier("powerUpSegue", sender: self)
    }
    
    func leaderboardButtonAction(sender: UIButton!){
        showLeader()
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
    
    //Show leaderboard screens
    func showLeader(){
        var rootViewController = self.view.window?.rootViewController
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        rootViewController?.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer(){
        var localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if((viewController) != nil){
                self.presentViewController(viewController, animated: true, completion: nil)
            }else{
                //println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToMainMenu(segue:UIStoryboardSegue){
        println("unwindToMainMenu stars refreshed")
        
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        if (starsCollected > 0){
            starsCollectedLabel.text = NSString(format: "%i", starsCollected)
        }else{
            starsCollectedLabel.text = NSString(format: "0")
        }
        
        //interAd = ADInterstitialAd()
        //interAd.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}