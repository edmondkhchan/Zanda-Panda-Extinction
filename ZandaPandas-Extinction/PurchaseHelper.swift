//
//  PurchaseHelper.swift
//  ZandaPandas-Extinction
//
//  Created by Edmond Chan on 24/05/2015.
//  Copyright (c) 2015 Edmond Chan. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

protocol purchaseFinishedRefresh{
    func refreshPurchaseDelegate()
    func enablePurchaseButtonDelegate()
}

class PurchaseHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    var request: SKProductsRequest?
    var queue: SKPaymentQueue = SKPaymentQueue.defaultQueue()
    var canMakePayment: Bool = false
    
    //IAP
    var zpProductList = [SKProduct]()
    var zpProduct = SKProduct()
    
    var delegate:purchaseFinishedRefresh?
    
    class var defaultHelper: PurchaseHelper{
        
        struct Static{
            static let instance: PurchaseHelper = PurchaseHelper()
        }
        
        return Static.instance
    }
    
    override init(){
        super.init()
    }
    
    func appdelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    func initPurchase(){
        //Set IAPS
        if(SKPaymentQueue.canMakePayments()){
            //println("IAP is enabled, loading")
            var productID:NSSet = NSSet(objects: "com.edmond.chan.ZandaPandasExt.Add1000Stars", "com.edmond.chan.ZandaPandasExt.Add250Stars", "com.edmond.chan.ZandaPandasExt.Add3000Stars", "com.edmond.chan.ZandaPandasExt.Add8000Stars")
            var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID)
            request.delegate = self
            request.start()
        }else{
            println("please enable IAPS")
        }
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var myProducts = response.products
        
        for product in myProducts{
            var currency_format = NSNumberFormatter()
            currency_format.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            currency_format.locale = product.priceLocale
            
            zpProductList.append(product as SKProduct)
        }
        
        canMakePayment = true
        delegate?.enablePurchaseButtonDelegate()
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        
        for transaction:AnyObject in transactions{
            var trans = transaction as SKPaymentTransaction
            println(trans.error)
            
            switch trans.transactionState{
            case .Purchased:
                let prodID = zpProduct.productIdentifier
                switch prodID {
                case "com.edmond.chan.ZandaPandasExt.Add250Stars":
                    //println("buy 250 stars")
                    buy250Stars()
                case "com.edmond.chan.ZandaPandasExt.Add1000Stars":
                    //println("buy 1000 stars")
                    buy1000Stars()
                case "com.edmond.chan.ZandaPandasExt.Add3000Stars":
                    //println("buy 3000 stars")
                    buy3000Stars()
                case "com.edmond.chan.ZandaPandasExt.Add8000Stars":
                    //println("buy 8000 stars")
                    buy8000Stars()
                default:
                    println("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break
            case .Failed:
                //println("buy error")
                    queue.finishTransaction(trans)
                    break
                case .Purchasing:
                    //println("purchasing state")
                    break
                default:
                    //println("default")
                    break
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction){
        //println("finish trans")
    }
    
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) {
        //println("remove trans")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        //println("Transactions Restored")
        
    }
    
    func buyProduct(currentProduct: SKProduct){
        zpProduct = currentProduct
        var pay = SKPayment(product: currentProduct)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    func buy250Stars(){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        var updatedStarsBalance: Int = starsCollected + 250
        //Set remaining stars
        NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ZPExtiAdsUnlocked")
        appdelegate().iAdsUnlocked = true
        delegate?.refreshPurchaseDelegate()
    }
    
    func buy1000Stars(){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        var updatedStarsBalance: Int = starsCollected + 1000
        //Set remaining stars
        NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ZPExtiAdsUnlocked")
        appdelegate().iAdsUnlocked = true
        delegate?.refreshPurchaseDelegate()
    }
    
    func buy3000Stars(){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        var updatedStarsBalance: Int = starsCollected + 3000
        //Set remaining stars
        NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ZPExtiAdsUnlocked")
        appdelegate().iAdsUnlocked = true
        delegate?.refreshPurchaseDelegate()
    }
    
    func buy8000Stars(){
        //Load stars collected
        let starsCollected = NSUserDefaults.standardUserDefaults().integerForKey("ZPExtStarsCollected")
        
        var updatedStarsBalance: Int = starsCollected + 8000
        //Set remaining stars
        NSUserDefaults.standardUserDefaults().setInteger(updatedStarsBalance, forKey: "ZPExtStarsCollected")
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ZPExtiAdsUnlocked")
        appdelegate().iAdsUnlocked = true
        delegate?.refreshPurchaseDelegate()
    }
}