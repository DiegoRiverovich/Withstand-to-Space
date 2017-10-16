//
//  Partition.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 05.10.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit

class Partition: SKSpriteNode {
    
    weak var mainScene: GameScene?
    
    //var _higherThenShip: Bool
    
    var higherThenShip: Bool {
        didSet {
            if self.contactWithShip && oldValue != higherThenShip {
                print("hello contact")
                var playerShip = PlayerShip()
                var rougeOneShip = PlayerShip()
                var trioShips = [PlayerShip]()
                if let allNodes = scene?.children {
                    for ship in allNodes {
                        if let _ship = ship as? PlayerShip {
                            if _ship.name == "playerShip" /*&& _ship.rougeIsActive == true*/  {
                                playerShip = _ship
                            }
                            if _ship.name == "rougeOneShip" /*&& _ship.rougeIsActive == true*/ {
                                rougeOneShip = _ship
                            }
                            if _ship.name == "trioShip" {
                                trioShips.append(_ship)
                            }
                        }
                    }
                }
                
                if playerShip.rougeIsActive == true  {
                    if shipStatus == .rogueOne {
                        explosion(pos: playerShip.position)
                        playerShip.removeFromParent()
                        mainScene?.rougeOneShipGlobal?.name = "playerShip"
                        
                        mainScene?.ship = mainScene!.rougeOneShipGlobal!
                        mainScene?.ship.rougeIsActive = true
                        mainScene?.changeShipStatus()
                        
                    } else if shipStatus == .noraml /*|| shipStatus == .trio*/ {
                        explosion(pos: playerShip.position)
                        playerShip.removeFromParent()
                        NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
                    } else if shipStatus == .trio {
                        for trioShip in trioShips {
                            explosion(pos: trioShip.position)
                            trioShip.removeFromParent()
                            
                            explosion(pos: playerShip.position)
                            playerShip.removeFromParent()
                            
                            NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
                            mainScene?.changeShipStatus()
                        }
                    }
                 
                    //mainScene.runGameOver()
                } else if rougeOneShip.rougeIsActive == true {
                    if shipStatus == .rogueOne {
                        explosion(pos: rougeOneShip.position)
                        rougeOneShip.removeFromParent()
                        
                        mainScene?.ship = mainScene!.rougeOneShipGlobal!
                        mainScene?.ship.name = "playerShip"
                        mainScene?.ship.rougeIsActive = true
                        
                        mainScene?.changeShipStatus()
                        
                    } else if shipStatus == .noraml /*|| shipStatus == .trio*/ {
                        explosion(pos: rougeOneShip.position)
                        rougeOneShip.removeFromParent()
                        NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
                    } else if shipStatus == .trio {
                        for trioShip in trioShips {
                            explosion(pos: trioShip.position)
                            trioShip.removeFromParent()
                            
                            explosion(pos: playerShip.position)
                            playerShip.removeFromParent()
                            
                            NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
                            mainScene?.changeShipStatus()
                        }
                    }
                    
                }
            }
        }
    }
    
    var contactWithShip: Bool = false
    
    let partitions = ["testTxtr.jpg"]
    
    init() {
        // Initialize whith RANDOM pic from array barriers.
        let texture = SKTexture(imageNamed: partitions[Int(arc4random()%1)])
        higherThenShip = false
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        // Set random Z Position
        let randomNumber24 = CGFloat(arc4random_uniform(2) + 2)
        if randomNumber24 == 2 {
            self.zPosition = 2
            self.xScale = 0.7
            self.yScale = 0.7
        } else if randomNumber24 == 3 {
            self.zPosition = 4
            self.xScale = 1.0
            self.yScale = 1.0
//        } else if randomNumber24 == 4 {
//            self.zPosition = 5
//            self.xScale = 1.0
//            self.yScale = 1.0
        } else {
            // do nothing
        }
        
        
        
        
        //self.zPosition = CGFloat(arc4random_uniform(3) + 2)
        
        
        //print("Barrier zPosition \(zPosition)")
        
        if self.zPosition < 3.0 {
//            self.xScale -= 0.5
//            self.yScale -= 0.5
            self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        } else if self.zPosition > 3.0 {
//            self.xScale += 0.5
//            self.yScale += 0.5
            self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        } else {
            self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        }
        
        //self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.isDynamic = true
        
        
        // Set PhysicsBody. First create PhysicsBody then set properties !!!!
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = false
        self.physicsBody?.allowsRotation = false
        
        // CategoryBitMask, collisionBitMask, contactTestBitMask
        self.physicsBody?.categoryBitMask = BodyType.partition.rawValue
        self.physicsBody?.collisionBitMask = 0
        //        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        self.name = "partition"
        //print("Partition zPosition \(zPosition)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //print("partition removed")
    }
    
    func explosion(pos: CGPoint) {
        if let explosion = SKEmitterNode(fileNamed: "explosion.sks") {
            explosion.particlePosition = pos
            scene?.addChild(explosion)
            scene?.run(SKAction.wait(forDuration: TimeInterval(2)), completion: { explosion.removeFromParent() } )
        }
        
    }
    
    
    
//    var higherThenShip: Bool {
//        didSet {
//            if self.contactWithShip && oldValue != higherThenShip {
//                print("hello contact")
//                var ship1 = PlayerShip()
//                var ship2 = PlayerShip()
//                if let allNodes = scene?.children {
//                    for ship in allNodes {
//                        if let _ship = ship as? PlayerShip {
//                            //                            if _ship.name == "playerShip" && _ship.rougeIsActive == true  {
//                            //                                ship1 = _ship
//                            //                            }
//                            //                            if _ship.name == "rougeOneShip" && _ship.rougeIsActive == true {
//                            //                                ship2 = _ship
//                            //                            }
//
//                            if _ship.name == "playerShip" && _ship.rougeIsActive == true  {
//                                mainScene?.tempShipRouge = _ship
//
//                                explosion(pos: ship.position)
//                                _ship.removeFromParent()
//                                NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
//                                if shipStatus == .rogueOne {
//                                    mainScene?.ship = mainScene!.tempShipRouge
//                                    mainScene?.ship.rougeIsActive = true
//                                    _ship.rougeIsActive = false
//                                    shipStatus = .noraml
//                                    //_ship = nil
//                                }
//                                //mainScene.runGameOver()
//                            } else if _ship.name == "rougeOneShip" && _ship.rougeIsActive == true {
//                                explosion(pos: ship.position)
//                                _ship.removeFromParent()
//                                NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
//                                if shipStatus == .rogueOne {
//                                    //mainScene?.ship = mainScene!.tempShipRouge
//                                    shipStatus = .noraml
//                                }
//
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
    
//
//    var higherThenShip: Bool {
//        didSet {
//            if self.contactWithShip && oldValue != higherThenShip {
//                print("hello contact")
//                var playerShip = PlayerShip()
//                var rougeOneShip = PlayerShip()
//                if let allNodes = scene?.children {
//                    for ship in allNodes {
//                        if let _ship = ship as? PlayerShip {
//                            if _ship.name == "playerShip" && _ship.rougeIsActive == true  {
//                                playerShip = _ship
//                            }
//                            if _ship.name == "rougeOneShip" && _ship.rougeIsActive == true {
//                                rougeOneShip = _ship
//                            }
//                        }
//
//                        if playerShip.rougeIsActive == true  {
//                            mainScene?.tempShipRouge = playerShip
//                            playerShip = rougeOneShip
//                            explosion(pos: ship.position)
//                            playerShip.removeFromParent()
//                            NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
//                            if shipStatus == .rogueOne {
//                                mainScene?.ship = mainScene!.tempShipRouge
//                                mainScene?.ship.rougeIsActive = true
//                                playerShip.rougeIsActive = false
//                                shipStatus = .noraml
//                                //playerShip = mainScene!.tempShipRouge
//                                //_ship = nil
//                            }
//                            //mainScene.runGameOver()
//                        } else if rougeOneShip.rougeIsActive == true {
//                            explosion(pos: ship.position)
//                            rougeOneShip.removeFromParent()
//                            NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
//                            if shipStatus == .rogueOne {
//                                //mainScene?.ship = mainScene!.tempShipRouge
//                                shipStatus = .noraml
//                            }
//
//                        }
//                    }
//                }
//            }
//        }
//    }
    
}     // class
