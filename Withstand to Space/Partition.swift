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
    weak var playerShipNotDeinit: PlayerShip?
    
    //var isActive: Bool = true
    
    var isSlowing: Bool = false
    
    //var _higherThenShip: Bool
    
    var higherThenShip: Bool {
        didSet {
            if self.contactWithShip && oldValue != higherThenShip /*&& shipStatus != .invisible*/ {
                //print("hello contact")
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
                        explosion(pos: rougeOneShip.position)
                        explosion(pos: playerShip.position)
                        playerShip.removeFromParent()
                        rougeOneShip.removeFromParent()
                        mainScene?.rougeOneShipGlobal?.name = "playerShip"
                        
                        mainScene?.ship = mainScene!.rougeOneShipGlobal!
                        mainScene?.ship.rougeIsActive = true
                        mainScene?.changeShipStatus()
                        //print("yo1")
                        
                    } else if shipStatus == .noraml /*|| shipStatus == .trio*/ {
                        //explosion(pos: playerShip.position)
                        mainScene?.explosion(pos: playerShipNotDeinit!.position, zPos: playerShipNotDeinit!.zPosition)
                        playerShipNotDeinit!.removeFromParent()
                        NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
                        //print("yo222")
                        //print(self.contactWithShip)
                    } else if shipStatus == .trio {
                        for trioShip in trioShips {
                            explosion(pos: trioShip.position)
                            trioShip.removeFromParent()
                            
                            explosion(pos: playerShip.position)
                            playerShip.removeFromParent()
                            
                            NotificationCenter.default.post(name: SomeNames.blowTheShip, object: nil)
                            mainScene?.changeShipStatus()
                            //print("yo3")
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
    
    private let partitions = ["testTxtr2.png"]
    
    init() {
        /*
        // Initialize whith RANDOM pic from array barriers.
        let texture = SKTexture(imageNamed: partitions[Int(arc4random()%1)])
        higherThenShip = false
        */
        higherThenShip = false
        let texture = SKTexture(imageNamed: partitions[Int(arc4random()%1)])
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        /*
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
     */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //print("partition removed")
    }
    
    convenience init(/*texture: SKTexture?, color: UIColor, size: CGSize,*/ zPosition: CGFloat, random: Bool, angle: CGFloat?, newTexture: SKTexture?) {
        self.init()
        self.physicsBody = nil
        //let texture: SKTexture
        
        if random {
            
            let texture = SKTexture(imageNamed: partitions[Int(arc4random()%1)])
            higherThenShip = false
            //super.init(texture: texture, color: UIColor.clear, size: texture.size())
            
            
            // Set random Z Position
            let randomNumber24 = CGFloat(arc4random_uniform(2) + 2)
            if randomNumber24 == 2 {
                self.zPosition = 2
                self.xScale = 0.9
                self.yScale = 0.9
            } else if randomNumber24 == 3 {
                self.zPosition = 4
                self.xScale = 1.2
                self.yScale = 1.2
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
                self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
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
            
        } else {
            
            
            
            //texture = SKTexture(imageNamed: partitions[Int(arc4random()%2)])
            higherThenShip = false
            
            
            
            switch level {
            case 0:
                texture = SKTexture(imageNamed: "testTxtr2")
                
            case 1:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 2:
                //texture = SKTexture(imageNamed: partitions[Int(arc4random()%2)])
                texture = SKTexture(imageNamed: "testTxtr2")
            case 3:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 4:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 5:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 6:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 7:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 8:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 9:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 10:
                texture = SKTexture(imageNamed: "testTxtr2")
            case 11:
                texture = SKTexture(imageNamed: "testTxtr2")
            default:
                texture = SKTexture(imageNamed: "testTxtr2")
            }
 
            
            if zPosition == 2 {
                self.zPosition = 2
                self.xScale = 2.9
                self.yScale = 2.9
            } else if zPosition == 4 {
                self.zPosition = 4
                self.xScale = 3.7
                self.yScale = 3.7
            } else {
                // do nothing
            }
            
            
        }
        if angle != nil {
            self.zRotation = CGFloat(angle!).degreesToRadians()
        } else {
            self.zRotation = CGFloat(0).degreesToRadians()
        }
        
        
        self.physicsBody = SKPhysicsBody(texture: texture!, size: self.size)
        
        
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
        
    }
    
    private func explosion(pos: CGPoint) {
        if let explosion = SKEmitterNode(fileNamed: "explosion.sks") {
            explosion.particlePosition = pos
            scene?.addChild(explosion)
            scene?.run(SKAction.wait(forDuration: TimeInterval(2)), completion: { explosion.removeFromParent() } )
        }
        if soundsIsOn {
            run(SKAction.playSoundFileNamed("boom1.m4a", waitForCompletion: false))
            removeAction(forKey: "shipEngineSound")
        }
        shipExplode = true
        
    }
    /*
    func explosionFromGameScene(pos: CGPoint, zPos: CGFloat) {
        if let explosion = SKEmitterNode(fileNamed: "explosion.sks") {
            if soundsIsOn {
                run(SKAction.playSoundFileNamed("boom1.m4a", waitForCompletion: false))
                //engineSoundsAction.speed = 0.0
                removeAction(forKey: "shipEngineSound")
            }
            explosion.particlePosition = pos
            explosion.zPosition = zPos
            //scene?.addChild(explosion)
            self.gameLayer.addChild(explosion)
            scene?.run(SKAction.wait(forDuration: TimeInterval(2)), completion: { explosion.removeFromParent() } )
            shipExplode = true
            puzzleCurrentGameStatus = false
            
            changeShipStatus()
            triggerNormalStatus()
            
        }
        
    }
    */
    
}     // class

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * CGFloat.pi / 180
    }
}
