//
//  PurchaseViewController.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

protocol purchaseRefresh{
    func refreshDelegate()
}

class PurchaseViewController: UIViewController, purchaseFinishedRefresh{
    var purchaseUIView: UIImageView = UIImageView()
    var closeButton: UIButton = UIButton()
    var buy250Button: UIButton = UIButton()
    var buy1000Button: UIButton = UIButton()
    var buy3000Button: UIButton = UIButton()
    var buy8000Button: UIButton = UIButton()
    
    var star250Label: UILabel = UILabel()
    var star1000Label: UILabel = UILabel()
    var star3000Label: UILabel = UILabel()
    var star8000Label: UILabel = UILabel()
    
    var delegate: purchaseRefresh?
    
    //var restorePurchaseButton: UIButton = UIButton()
    var bounds: CGRect = UIScreen.mainScreen().bounds
    
    //IAP
    var zpProductList = [SKProduct]()
    var zpProduct = SKProduct()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        PurchaseHelper.defaultHelper.delegate = self
        PurchaseHelper.defaultHelper.initPurchase()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        //Stars collected Image View
        let purchaseUIImage: UIImage = UIImage(named: "Purchase")!
        purchaseUIView.image = purchaseUIImage
        purchaseUIView.frame = CGRectMake((bounds.width / 2) - 113, (bounds.height / 2) - 150, 226, 300)
        self.view.addSubview(purchaseUIView)
        
        //Close button
        let closeImage = UIImage(named: "CloseButton") as UIImage?
        closeButton.frame = CGRectMake((bounds.width / 2) + 113, (bounds.height / 2) - 180, 30, 30)
        closeButton.setImage(closeImage, forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(closeButton)
        
        //Buy 250 stars button
        let buy250Image = UIImage(named: "BuyButton") as UIImage?
        buy250Button.frame = CGRectMake((bounds.width / 2) + 60, (bounds.height / 2) - 130, 35, 30)
        buy250Button.setImage(buy250Image, forState: .Normal)
        buy250Button.addTarget(self, action: "buy250ButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        buy250Button.enabled = false
        self.view.addSubview(buy250Button)
        
        //Buy 1000 stars button
        let buy1000Image = UIImage(named: "BuyButton") as UIImage?
        buy1000Button.frame = CGRectMake((bounds.width / 2) + 60, (bounds.height / 2) - 76, 35, 30)
        buy1000Button.setImage(buy1000Image, forState: .Normal)
        buy1000Button.addTarget(self, action: "buy1000ButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        buy1000Button.enabled = false
        self.view.addSubview(buy1000Button)
        
        //Buy 3000 stars button
        let buy3000Image = UIImage(named: "BuyButton") as UIImage?
        buy3000Button.frame = CGRectMake((bounds.width / 2) + 60, (bounds.height / 2) - 24, 35, 30)
        buy3000Button.setImage(buy3000Image, forState: .Normal)
        buy3000Button.addTarget(self, action: "buy3000ButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        buy3000Button.enabled = false
        self.view.addSubview(buy3000Button)
        
        //Buy 8000 stars button
        let buy8000Image = UIImage(named: "BuyButton") as UIImage?
        buy8000Button.frame = CGRectMake((bounds.width / 2) + 60, (bounds.height / 2) + 28, 35, 30)
        buy8000Button.setImage(buy8000Image, forState: .Normal)
        buy8000Button.addTarget(self, action: "buy8000ButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        buy8000Button.enabled = false
        self.view.addSubview(buy8000Button)
    }
    
    func refreshPurchaseDelegate(){
        delegate?.refreshDelegate()
    }
    
    func enablePurchaseButtonDelegate(){
        zpProductList = PurchaseHelper.defaultHelper.zpProductList
        if(PurchaseHelper.defaultHelper.canMakePayment){
            for product in zpProductList{
                var currency_format = NSNumberFormatter()
                currency_format.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                currency_format.locale = product.priceLocale
                
                if(product.productIdentifier == "com.edmond.chan.ZandaPandasExt.Add250Stars"){
                    star250Label.text = currency_format.stringFromNumber(product.price)!
                    star250Label.font = UIFont(name: "MarkerFelt-Thin", size: 13)
                    star250Label.textColor = UIColor.blackColor()
                    star250Label.textAlignment = NSTextAlignment.Center
                    star250Label.frame = CGRectMake((bounds.width / 2) - 40, buy250Button.frame.origin.y + buy250Button.frame.height - 10, 80, 15)
                    self.view.addSubview(star250Label)
                }else if(product.productIdentifier == "com.edmond.chan.ZandaPandasExt.Add1000Stars"){
                    star1000Label.text = currency_format.stringFromNumber(product.price)!
                    star1000Label.font = UIFont(name: "MarkerFelt-Thin", size: 13)
                    star1000Label.textColor = UIColor.blackColor()
                    star1000Label.textAlignment = NSTextAlignment.Center
                    star1000Label.frame = CGRectMake((bounds.width / 2) - 40, buy1000Button.frame.origin.y + buy1000Button.frame.height - 10, 80, 15)
                    self.view.addSubview(star1000Label)
                }else if(product.productIdentifier == "com.edmond.chan.ZandaPandasExt.Add3000Stars"){
                    star3000Label.text = currency_format.stringFromNumber(product.price)!
                    star3000Label.font = UIFont(name: "MarkerFelt-Thin", size: 13)
                    star3000Label.textColor = UIColor.blackColor()
                    star3000Label.textAlignment = NSTextAlignment.Center
                    star3000Label.frame = CGRectMake((bounds.width / 2) - 40, buy3000Button.frame.origin.y + buy3000Button.frame.height - 10, 80, 15)
                    self.view.addSubview(star3000Label)
                }else if(product.productIdentifier == "com.edmond.chan.ZandaPandasExt.Add8000Stars"){
                    star8000Label.text = currency_format.stringFromNumber(product.price)!
                    star8000Label.font = UIFont(name: "MarkerFelt-Thin", size: 13)
                    star8000Label.textColor = UIColor.blackColor()
                    star8000Label.textAlignment = NSTextAlignment.Center
                    star8000Label.frame = CGRectMake((bounds.width / 2) - 40, buy8000Button.frame.origin.y + buy8000Button.frame.height - 10, 80, 15)
                    self.view.addSubview(star8000Label)
                }
            }
            
            buy250Button.enabled = true
            buy1000Button.enabled = true
            buy3000Button.enabled = true
            buy8000Button.enabled = true
        }else{
            buy250Button.enabled = false
            buy1000Button.enabled = false
            buy3000Button.enabled = false
            buy8000Button.enabled = false
        }
    }
    
    func closeButtonAction(sender: UIButton!){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func buy250ButtonAction(sender: UIButton!){
        //In-purchase events
        for product in zpProductList{
            var prodID = product.productIdentifier
            //println(prodID)
            if(prodID == "com.edmond.chan.ZandaPandasExt.Add250Stars"){
                PurchaseHelper.defaultHelper.delegate = self
                PurchaseHelper.defaultHelper.buyProduct(product)
                break
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func buy1000ButtonAction(sender: UIButton!){
        //In-purchase events
        for product in zpProductList{
            var prodID = product.productIdentifier
            if(prodID == "com.edmond.chan.ZandaPandasExt.Add1000Stars"){
                PurchaseHelper.defaultHelper.delegate = self
                PurchaseHelper.defaultHelper.buyProduct(product)
                break
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func buy3000ButtonAction(sender: UIButton!){
        //In-purchase events
        for product in zpProductList{
            var prodID = product.productIdentifier
            if(prodID == "com.edmond.chan.ZandaPandasExt.Add3000Stars"){
                PurchaseHelper.defaultHelper.delegate = self
                PurchaseHelper.defaultHelper.buyProduct(product)
                break
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func buy8000ButtonAction(sender: UIButton!){
        //In-purchase events
        for product in zpProductList{
            var prodID = product.productIdentifier
            if(prodID == "com.edmond.chan.ZandaPandasExt.Add8000Stars"){
                PurchaseHelper.defaultHelper.buyProduct(product)
                break
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

