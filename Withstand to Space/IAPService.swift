//
//  IAPService.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 15.12.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import Foundation
import StoreKit
import SpriteKit

class IAPService: NSObject {
    
    weak var mainScene: GameScene?
    weak var purchaseScene: PurchaseScene?
    
    private override init() {}
    static var shared = IAPService()
    
    
//    static var instance: IAPService?
    
//    static var sharedInstance: IAPService {
//        if instance == nil {
//            instance = IAPService()
//        }
//        return instance!
//    }
    
    private var products = [SKProduct]()
    private let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products: Set<String> = [IAPProduct.trioProduct.rawValue,
                             IAPProduct.rougeProduct.rawValue,
                             IAPProduct.invisibleProduct.rawValue,
                             IAPProduct.deleteAds.rawValue]
        if (SKPaymentQueue.canMakePayments()) {
            let request = SKProductsRequest(productIdentifiers: products)
            request.delegate = self
            request.start()
        } else {
            //print("enable in-app purchases!")
        }
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        //print("start purcahse")
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first
            else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        //print("restoring purchases")
        paymentQueue.restoreCompletedTransactions()
    }
    
    func dispose() {
        //IAPService.instance = nil
    }
    
    deinit {
        //print("IAPService deinit")
    }
    
    
}  // class

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        if response.products.isEmpty {
            //print("There is not prodicts to purchase.")
        } else {
            //purchaseScene?.stopAcitvityIndicator()
            mainScene?.stopNewAcitvityIndicator()
            purchaseScene?.stopNewAcitvityIndicator()
            purchaseScene?.canBuy = true
            mainScene?.canBuy = true
            for product in response.products {
                //print(product.localizedTitle)
                //print(product.price)
                //print(product.priceLocale)
                if product.productIdentifier == IAPProduct.trioProduct.rawValue {
                    trioPrice = priceStringForProducts(item: product)!
                    purchaseScene?.trioPurchaseLabel.text = "T + 1000  -  \(trioPrice)"
                    mainScene?.trioPurchaseLabel.text = "T + 1000  -  \(trioPrice)"
                } else if product.productIdentifier == IAPProduct.rougeProduct.rawValue {
                    doublePrice = priceStringForProducts(item: product)!
                    purchaseScene?.rougePurchaseLabel.text = "D + 1000  -  \(doublePrice)"
                    mainScene?.rougePurchaseLabel.text = "D + 1000  -  \(doublePrice)"
                } else if product.productIdentifier == IAPProduct.invisibleProduct.rawValue {
                    invisiblePrice = priceStringForProducts(item: product)!
                    purchaseScene?.invisiblePurchaseLabel.text = "I + 1000  -  \(invisiblePrice)"
                    mainScene?.invisiblePurchaseLabel.text = "I + 1000  -  \(invisiblePrice)"
                } else if product.productIdentifier == IAPProduct.deleteAds.rawValue {
                    removeAdsPrice = priceStringForProducts(item: product)!
                    //purchaseScene?.removeAdPurchaseLabel.text = "\(invisiblePrice)"
                    if preferredLanguage == .ru {
                        purchaseScene?.removeAdPurchaseLabel.text = "Убрать рекламу  -  \(removeAdsPrice)"
                        mainScene?.removeAdPurchaseLabel.text = "Убрать рекламу  -  \(removeAdsPrice)"
                    } else if preferredLanguage == .ch {
                        purchaseScene?.removeAdPurchaseLabel.text = "刪除廣告  -  \(removeAdsPrice)"
                        mainScene?.removeAdPurchaseLabel.text = "刪除廣告  -  \(removeAdsPrice)"
                    } else if preferredLanguage == .es {
                        purchaseScene?.removeAdPurchaseLabel.text = "Quitar anuncios  -  \(removeAdsPrice)"
                        mainScene?.removeAdPurchaseLabel.text = "Quitar anuncios  -  \(removeAdsPrice)"
                    } else if preferredLanguage == .jp {
                        purchaseScene?.removeAdPurchaseLabel.text = "広告を削除  -  \(removeAdsPrice)"
                        mainScene?.removeAdPurchaseLabel.text = "広告を削除  -  \(removeAdsPrice)"
                    } else if preferredLanguage == .fr {
                        purchaseScene?.removeAdPurchaseLabel.text = "Supprimez la pub  -  \(removeAdsPrice)"
                        mainScene?.removeAdPurchaseLabel.text = "Supprimez la pub  -  \(removeAdsPrice)"
                    } else if preferredLanguage == .gr {
                        purchaseScene?.removeAdPurchaseLabel.text = "Anzeigen entfernen  -  \(removeAdsPrice)"
                        mainScene?.removeAdPurchaseLabel.text = "Anzeigen entfernen  -  \(removeAdsPrice)"
                    } else {
                        purchaseScene?.removeAdPurchaseLabel.text = "Remove Ad  -  \(removeAdsPrice)"
                        mainScene?.removeAdPurchaseLabel.text = "Remove Ad  -  \(removeAdsPrice)"
                    }
                    //var test = ppriceStringForProducts(item: product)
                }
            }
        }
    }
 
}

func priceStringForProducts(item: SKProduct) -> String? {
    let numberFormatter = NumberFormatter()
    let price = item.price
    let locale = item.priceLocale
    numberFormatter.numberStyle = .currency
    numberFormatter.locale = locale
    return numberFormatter.string(from: price)
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //var alertTitle: String = ""
        //var alertMessage: String = ""
        let defaults = UserDefaults()
        
        for transaction in transactions {
            //print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing:
                mainScene?.stopNewAcitvityIndicator()
                purchaseScene?.stopNewAcitvityIndicator()
                //queue.finishTransaction(transaction)
                break
            case .failed:
                queue.finishTransaction(transaction)
                //mainScene?.stopAcitvityIndicator()
                mainScene?.stopNewAcitvityIndicator()
                //purchaseScene?.stopAcitvityIndicator()
                purchaseScene?.stopNewAcitvityIndicator()
            case .restored:
                //alertTitle = "Transaction failed"
                //alertMessage = "Try again later"
                if transaction.payment.productIdentifier == IAPProduct.deleteAds.rawValue {
                    programmIsPaid = true
                    defaults.set(programmIsPaid, forKey: "ProgrammIsPaid")
                }
                //print("purcahses restored")
                queue.finishTransaction(transaction)
                //mainScene?.stopAcitvityIndicator()
                mainScene?.stopNewAcitvityIndicator()
                //purchaseScene?.stopAcitvityIndicator()
                purchaseScene?.stopNewAcitvityIndicator()
            case .deferred:
                //print("purchase deferred")
                queue.finishTransaction(transaction)
                //mainScene?.stopAcitvityIndicator()
                mainScene?.stopNewAcitvityIndicator()
                //purchaseScene?.stopAcitvityIndicator()
                purchaseScene?.stopNewAcitvityIndicator()
            case .purchased:
                if transaction.payment.productIdentifier == IAPProduct.trioProduct.rawValue {
                    trioTimeActive += 1000
                    defaults.set(trioTimeActive, forKey: "TrioSeconds")
                    mainScene?.trioTimerLabel.text = "\(trioTimeActive.truncate(places: 1))"
                    //mainScene?.trioTimeActiveLoc = trioTimeActive
                } else if transaction.payment.productIdentifier == IAPProduct.rougeProduct.rawValue {
                    rougeOneTimeActive += 1000
                    defaults.set(rougeOneTimeActive, forKey: "RougeSeconds")
                    //mainScene?.rougeOneTimeActiveLoc = rougeOneTimeActive
                    mainScene?.rougeOneTimerLabel.text = "\(rougeOneTimeActive.truncate(places: 1))"
                } else if transaction.payment.productIdentifier == IAPProduct.invisibleProduct.rawValue {
                    InvisibleTimeActive += 1000
                    defaults.set(InvisibleTimeActive, forKey: "InvisibleSeconds")
                    //mainScene?.InvisibleTimeActiveLoc = InvisibleTimeActive
                    mainScene?.invisibleTimerLabel.text = "\(InvisibleTimeActive.truncate(places: 1))"
                } else if transaction.payment.productIdentifier == IAPProduct.deleteAds.rawValue {
                    programmIsPaid = true
                    defaults.set(programmIsPaid, forKey: "ProgrammIsPaid")
                    
                }
                queue.finishTransaction(transaction)
                //mainScene?.stopAcitvityIndicator()
                mainScene?.stopNewAcitvityIndicator()
                //purchaseScene?.stopAcitvityIndicator()
                purchaseScene?.stopNewAcitvityIndicator()
            }
        }
        
        /*
        trioTimerLabel.text = "\(trioTimeActive.truncate(places: 1))"
        rougeOneTimerLabel.text = "\(rougeOneTimeActive.truncate(places: 1))"
        invisibleTimerLabel.text = "\(InvisibleTimeActive.truncate(places: 1))"
        */
        /*  // Message for user about his transaction.
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok.", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
         */
    }

}
/*
 case trioProduct = "trioProduct"
 case rougeProduct = "rougeProduct"
 case invisibleProduct = "invisibleProduct"
 case deleteAds = "deleteAds"
*/
extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred:
            return "deferred"
        case .failed:
            return "failed"
        case .purchased:
            return "purchased"
        case .purchasing:
            return "purchasing"
        case .restored:
            return "restored"
        }
    }
}
