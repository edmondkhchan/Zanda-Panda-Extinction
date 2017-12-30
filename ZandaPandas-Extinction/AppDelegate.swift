//
//  AppDelegate.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import UIKit
import iAd

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ChartboostDelegate {
    
    var window: UIWindow?
    var iAdBannerView: ADBannerView = ADBannerView()
    var iAdsUnlocked: Bool = false
    var lastAdDisplay: NSDate = NSDate()
    var interstitialAdInterval:Double = 150.0
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //Testing, remove for production
        //NSUserDefaults.standardUserDefaults().setInteger(8000, forKey: "ZPExtStarsCollected")
        //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ZPExtiAdsUnlocked")
        
        iAdsUnlocked = NSUserDefaults.standardUserDefaults().boolForKey("ZPExtiAdsUnlocked")
        
        let kChartboostAppID = "557978d843150f251d34278b";
        let kChartboostAppSignature = "8a5c74dea185f7ff981ae153dd940fa1e354877a";
        
        if(!iAdsUnlocked){
            Chartboost.startWithAppId(kChartboostAppID, appSignature: kChartboostAppSignature, delegate: self);
            Chartboost.setShouldRequestInterstitialsInFirstSession(false)
            Chartboost.cacheMoreApps(CBLocationHomeScreen)
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showChartboostAds()
    {
        Chartboost.showInterstitial(CBLocationHomeScreen);
    }
    
    func didFailToLoadInterstitial(location :String!, withError error: CBLoadError)
    {
        println("Failed to load interstitial")
    }
    
    func didDismissInterstitial(location :String! )
    {
        if(location == CBLocationHomeScreen)
        {
            Chartboost.cacheInterstitial(CBLocationMainMenu)
        }
        else if(location == CBLocationMainMenu)
        {
            Chartboost.cacheInterstitial(CBLocationGameOver)
        }
        else if(location == CBLocationGameOver)
        {
            Chartboost.cacheInterstitial(CBLocationLevelComplete)
        }
        else if(location == CBLocationLevelComplete)
        {
            Chartboost.cacheInterstitial(CBLocationHomeScreen)
        }
    }
}


