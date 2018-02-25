//
//  PurchaseScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 14.12.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import Foundation
import SpriteKit
import NVActivityIndicatorView

class PurchaseScene: SKScene {
    
    private var newActivityIndicator: NVActivityIndicatorView?
    
    var canBuy: Bool = false
    
    //let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    private let trioStatusButton = SKSpriteNode(imageNamed: "statusTrio1" /*"statusTrioN140.png"*/)
    private let rougeOneStatusButton = SKSpriteNode(imageNamed: "statusRougeOne1" /*"statusRougeOneN140.png"*/)
    private let invisibleStatusButton = SKSpriteNode(imageNamed: "statusInvisible1" /*"statusInvisibleN140.png"*/)
    private let removeAdButton = SKSpriteNode(imageNamed: "statusInvisible1" /*"statusInvisibleN140.png"*/)
    
    let trioPurchaseLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    let rougePurchaseLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    let invisiblePurchaseLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    let removeAdPurchaseLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    let purchaseLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    let restorePurchasesLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    
    private let buyTrioStatusButton = SKSpriteNode(imageNamed: "buyButtonUNIVERSAL02" /*"statusInvisibleN140.png"*/)
    private let buyRougeOneStatusButton = SKSpriteNode(imageNamed: "buyButtonUNIVERSAL02" /*"statusInvisibleN140.png"*/)
    private let buyInvisibleStatusButton = SKSpriteNode(imageNamed: "buyButtonUNIVERSAL02" /*"statusInvisibleN140.png"*/)
    private let buyRemoveAdButton = SKSpriteNode(imageNamed: "buyButtonUNIVERSAL02" /*"statusInvisibleN140.png"*/)
    private let restorePurchasesButton = SKSpriteNode(imageNamed: "restorePurchasesButton1" /*"statusInvisibleN140.png"*/)
    
    override func didMove(to view: SKView) {
        IAPService.shared.getProducts()
        IAPService.shared.purchaseScene = self
        //IAPService.sharedInstance.getProducts()
        //IAPService.sharedInstance.purchaseScene = self
        
        backgroundSetup()
        buttonsSetup()
        buyButtonsSetup()
        backToMenuButtonsSetup()
        labelsSetup()
        
        //startAcitivityIndicator()
        startNewAcitivityIndicator()
        
    }
    
    private func startNewAcitivityIndicator() {
        if let viewLoc = view {
            newActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: (viewLoc.center.x - 50), y: (viewLoc.center.y - 50), width: 100, height: 100),
                                                           type: .ballTrianglePath,
                                                           color: UIColor.white,
                                                           padding: nil)
        } else {
            newActivityIndicator?.center = CGPoint(x: 700, y: 900)
        }
        //myActivityIndicator.hidesWhenStopped = true
        scene!.view?.addSubview(newActivityIndicator!)
        newActivityIndicator?.startAnimating()
    }
    
    func stopNewAcitvityIndicator() {
        newActivityIndicator?.stopAnimating()
        newActivityIndicator?.removeFromSuperview()
    }
    
    /*
    func startAcitivityIndicator() {
        if let viewLoc = view {
            myActivityIndicator.center = CGPoint(x: viewLoc.bounds.midX, y: viewLoc.bounds.midY)
        } else {
            myActivityIndicator.center = CGPoint(x: 700, y: 900)
        }
        myActivityIndicator.hidesWhenStopped = true
        scene!.view?.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
    }
    func stopAcitvityIndicator() {
        myActivityIndicator.stopAnimating()
    }
     */
    
    private func backToMenuButtonsSetup() {
        
        let backToMenuButton = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        backToMenuButton.name = "Back to menu"
        if preferredLanguage == .ch || preferredLanguage == .jp {
            backToMenuButton.fontSize = 85
        } else {
            backToMenuButton.fontSize = 70
        }
        if preferredLanguage == .ru {
            backToMenuButton.text = "НА3АД"
        } else if preferredLanguage == .ch {
            backToMenuButton.text = "后退"
        } else if preferredLanguage == .es {
            backToMenuButton.text = "Atrás"
        } else if preferredLanguage == .jp {
            backToMenuButton.text = "戻る"
        } else if preferredLanguage == .fr {
            backToMenuButton.text = "Retour"
        } else if preferredLanguage == .gr {
            backToMenuButton.text = "Zurück"
        } else {
            backToMenuButton.text = "BACK"
        }
        
        
        backToMenuButton.position = CGPoint(x: self.size.width * 0.26, y: self.size.height * 0.94)
        backToMenuButton.zPosition = -99
        
        //        backToMenuButton.xScale += 0.4
        //        backToMenuButton.yScale += 0.4
        
        let backgroundForLabel = SKSpriteNode(imageNamed: "backBackground5")
        backgroundForLabel.name = "backBackground"
        backgroundForLabel.position = backToMenuButton.position
        backgroundForLabel.zPosition = backToMenuButton.zPosition - 1
        
        self.addChild(backToMenuButton)
        self.addChild(backgroundForLabel)
    }
    
    private func buyButtonsSetup() {
        buyTrioStatusButton.position = CGPoint(x: self.size.width * 0.78, y: self.size.height * 0.70)
        buyTrioStatusButton.zPosition = 10
        buyTrioStatusButton.name = "buyStatusTrioButton"
        self.addChild(buyTrioStatusButton)
        
        buyRougeOneStatusButton.position = CGPoint(x: self.size.width * 0.78, y: self.size.height * 0.56)
        buyRougeOneStatusButton.zPosition = 10
        buyRougeOneStatusButton.name = "buyStatusRougeOneButton"
        self.addChild(buyRougeOneStatusButton)
        
        buyInvisibleStatusButton.position = CGPoint(x: self.size.width * 0.78, y: self.size.height * 0.42)
        buyInvisibleStatusButton.zPosition = 10
        buyInvisibleStatusButton.name = "buyStatusInvisibleButton"
        self.addChild(buyInvisibleStatusButton)
        
        buyRemoveAdButton.position = CGPoint(x: self.size.width * 0.78, y: self.size.height * 0.28)
        buyRemoveAdButton.zPosition = 10
        buyRemoveAdButton.name = "buyRemoveAd"
        self.addChild(buyRemoveAdButton)
        
        restorePurchasesButton.position = CGPoint(x: self.size.width * 0.78, y: self.size.height * 0.14)
        restorePurchasesButton.zPosition = 10
        restorePurchasesButton.name = "restorePurchases"
        self.addChild(restorePurchasesButton)
       
        
    }
    
    private func buttonsSetup() {
        trioStatusButton.position = CGPoint(x: self.size.width * 0.22, y: self.size.height * 0.70)
        trioStatusButton.zPosition = 10
        trioStatusButton.name = "statusTrioButton"
        self.addChild(trioStatusButton)
        
        rougeOneStatusButton.position = CGPoint(x: self.size.width * 0.22, y: self.size.height * 0.56)
        rougeOneStatusButton.zPosition = 10
        rougeOneStatusButton.name = "statusRougeOneButton"
        self.addChild(rougeOneStatusButton)
        
        invisibleStatusButton.position = CGPoint(x: self.size.width * 0.22, y: self.size.height * 0.42)
        invisibleStatusButton.zPosition = 10
        invisibleStatusButton.name = "statusInvisibleButton"
        self.addChild(invisibleStatusButton)
        
        removeAdButton.position = CGPoint(x: self.size.width * 0.22, y: self.size.height * 0.28)
        removeAdButton.zPosition = 10
        removeAdButton.name = "removeAd"
        //self.addChild(removeAdButton)
        
    }
    
    private func labelsSetup() {
        trioPurchaseLabel.position = CGPoint(x: self.size.width * 0.3, y: (self.size.height * 0.70) - 20)
        trioPurchaseLabel.horizontalAlignmentMode = .left
        trioPurchaseLabel.zPosition = 10
        trioPurchaseLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        if preferredLanguage == .ch || preferredLanguage == .jp {
            trioPurchaseLabel.fontSize = 35
        } else {
            trioPurchaseLabel.fontSize = 35
        }
        trioPurchaseLabel.text = "T + 1000  -  \(trioPrice)"
        trioPurchaseLabel.name = "statusTrioButtonLabel"
        self.addChild(trioPurchaseLabel)
        
        rougePurchaseLabel.position = CGPoint(x: self.size.width * 0.3, y: (self.size.height * 0.56) - 20)
        rougePurchaseLabel.horizontalAlignmentMode = .left
        rougePurchaseLabel.zPosition = 10
        rougePurchaseLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        rougePurchaseLabel.fontSize = 35
        rougePurchaseLabel.text = "D + 1000  -  \(doublePrice)"
        rougePurchaseLabel.name = "statusRougeOneButtonLabel"
        self.addChild(rougePurchaseLabel)
        
        invisiblePurchaseLabel.position = CGPoint(x: self.size.width * 0.3, y: (self.size.height * 0.42) - 20)
        invisiblePurchaseLabel.horizontalAlignmentMode = .left
        invisiblePurchaseLabel.zPosition = 10
        invisiblePurchaseLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        invisiblePurchaseLabel.fontSize = 35
        invisiblePurchaseLabel.text = "I + 1000  -  \(invisiblePrice)"
        invisiblePurchaseLabel.name = "statusInvisibleButtonLabel"
        self.addChild(invisiblePurchaseLabel)
        
        removeAdPurchaseLabel.position = CGPoint(x: self.size.width * 0.15, y: (self.size.height * 0.28) - 20)
        removeAdPurchaseLabel.horizontalAlignmentMode = .left
        removeAdPurchaseLabel.zPosition = 10
        removeAdPurchaseLabel.fontSize = 40
        removeAdPurchaseLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        //removeAdPurchaseLabel.text = "Remove Ad.  -  1.49"
        if preferredLanguage == .ru {
            removeAdPurchaseLabel.text = "Убрать рекламу  -  \(removeAdsPrice)"
            removeAdPurchaseLabel.fontSize = 35
        } else if preferredLanguage == .ch {
            removeAdPurchaseLabel.text = "移除广告  -  \(removeAdsPrice)"
            removeAdPurchaseLabel.fontSize = 55
        } else if preferredLanguage == .es {
            removeAdPurchaseLabel.text = "Sin publicidad  -  \(removeAdsPrice)"
            removeAdPurchaseLabel.fontSize = 35
        } else if preferredLanguage == .jp {
            removeAdPurchaseLabel.text = "広告削除  -  \(removeAdsPrice)"
            removeAdPurchaseLabel.fontSize = 55
        } else if preferredLanguage == .fr {
            removeAdPurchaseLabel.text = "Enlever les publicités  -  \(removeAdsPrice)"
            removeAdPurchaseLabel.fontSize = 35
        } else if preferredLanguage == .gr {
            removeAdPurchaseLabel.text = "Werbungen entfernen  -  \(removeAdsPrice)"
            removeAdPurchaseLabel.fontSize = 35
        } else {
            removeAdPurchaseLabel.text = "Remove ads  -  \(removeAdsPrice)"
            removeAdPurchaseLabel.fontSize = 35
        }
        removeAdPurchaseLabel.name = "removeAd"
        self.addChild(removeAdPurchaseLabel)
        
        
        
        purchaseLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.8)
        purchaseLabel.horizontalAlignmentMode = .center
        purchaseLabel.zPosition = 10
        purchaseLabel.fontSize = 60
        purchaseLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        if preferredLanguage == .ru {
            purchaseLabel.text = "Лист покупок"
        } else if preferredLanguage == .ch {
            purchaseLabel.text = "購買清單"
        } else if preferredLanguage == .es {
            purchaseLabel.text = "Lista de compras"
        } else if preferredLanguage == .jp {
            purchaseLabel.text = "購入リスト"
        } else if preferredLanguage == .fr {
            purchaseLabel.text = "Liste d'achat"
        } else if preferredLanguage == .gr {
            purchaseLabel.text = "Leinkaufsliste"
        } else {
            purchaseLabel.text = "Purchase list"
        }
        
        purchaseLabel.name = "purchaseLabel"
        self.addChild(purchaseLabel)
        
        
        restorePurchasesLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.14)
        restorePurchasesLabel.horizontalAlignmentMode = .left
        restorePurchasesLabel.zPosition = 10
        restorePurchasesLabel.fontSize = 45
        restorePurchasesLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        if preferredLanguage == .ru {
            restorePurchasesLabel.text = "Восстановить покупки"
            restorePurchasesLabel.fontSize = 35
        } else if preferredLanguage == .ch {
            restorePurchasesLabel.text = "恢復購買"
            restorePurchasesLabel.fontSize = 55
        } else if preferredLanguage == .es {
            restorePurchasesLabel.text = "Restaurar las compras"
            restorePurchasesLabel.fontSize = 35
        } else if preferredLanguage == .jp {
            restorePurchasesLabel.text = "購入を復元"
            restorePurchasesLabel.fontSize = 55
        } else if preferredLanguage == .fr {
            restorePurchasesLabel.text = "Restaurer les achats"
            restorePurchasesLabel.fontSize = 35
        } else if preferredLanguage == .gr {
            restorePurchasesLabel.text = "Käufe wiederherstellen"
            restorePurchasesLabel.fontSize = 35
        } else {
            restorePurchasesLabel.text = "Restore purchases"
            restorePurchasesLabel.fontSize = 35
        }
        
        restorePurchasesLabel.name = "purchaseLabel"
        self.addChild(restorePurchasesLabel)
        
    }
    
    // MARK: Background setup
    private func backgroundSetup() {
        
        let background = SKSpriteNode(imageNamed: "backgroundStars02" /*"menuBackground2"*/)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    // MARK: Touches begin
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Back to menu" || atPoint(location).name == "backBackground"{
                //IAPService.sharedInstance.dispose()
                stopNewAcitvityIndicator()
                let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                scene.scaleMode = .aspectFill
                let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                // Present the scene
                view?.presentScene(scene, transition: startGameTransition)
                if #available(iOS 10.0, *) {
                    view?.preferredFramesPerSecond = 60
                } else {
                    // Fallback on earlier versions
                }
            } else if atPoint(location).name == "buyStatusTrioButton" {
                if canBuy {
                    IAPService.shared.purchase(product: .trioProduct)
                    //IAPService.sharedInstance.purchase(product: .trioProduct)
                    startNewAcitivityIndicator()
                    //print("dsf")
                }
                
            } else if atPoint(location).name == "buyStatusRougeOneButton" {
                if canBuy {
                    IAPService.shared.purchase(product: .rougeProduct)
                    //IAPService.sharedInstance.purchase(product: .rougeProduct)
                    startNewAcitivityIndicator()
                    //startAcitivityIndicator()
                }
                
            } else if atPoint(location).name == "buyStatusInvisibleButton" {
                if canBuy {
                    IAPService.shared.purchase(product: .invisibleProduct)
                    //IAPService.sharedInstance.purchase(product: .invisibleProduct)
                    startNewAcitivityIndicator()
                    //startAcitivityIndicator()
                }
                //print("dsf")
            } else if atPoint(location).name == "buyRemoveAd" {
                if canBuy {
                    IAPService.shared.purchase(product: .deleteAds)
                    //IAPService.sharedInstance.purchase(product: .deleteAds)
                    startNewAcitivityIndicator()
                    //startAcitivityIndicator()
                }
                //print("dsf")
            } else if atPoint(location).name == "restorePurchases" {
                if canBuy {
                    IAPService.shared.restorePurchases()
                    //IAPService.sharedInstance.restorePurchases()
                    startNewAcitivityIndicator()
                    //startAcitivityIndicator()
                }
                //print("dsf")
            }
        }
    }
    deinit {
        //print("puchase deinit")
        //IAPService.sharedInstance.dispose()
    }
}    // class
