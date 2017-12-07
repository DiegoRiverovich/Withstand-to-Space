//
//  Barrier.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 22.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import Foundation
import SpriteKit

class Barrier: SKSpriteNode {
    
    let barriers = ["alien1_85"/*"alien1", "alien2", "alien3", "coin1"*/]
    var coinMovingArray: [SKTexture] = [SKTexture(imageNamed: "newCoin1"),SKTexture(imageNamed: "newCoin2"),SKTexture(imageNamed: "newCoin3"),SKTexture(imageNamed: "newCoin4"),SKTexture(imageNamed: "newCoin5"),SKTexture(imageNamed: "newCoin6"),SKTexture(imageNamed: "newCoin7"),SKTexture(imageNamed: "newCoin8"), SKTexture(imageNamed: "newCoin9"),SKTexture(imageNamed: "newCoin10"),SKTexture(imageNamed: "newCoin11"),SKTexture(imageNamed: "newCoin12"),SKTexture(imageNamed: "newCoin13"),SKTexture(imageNamed: "newCoin14"),SKTexture(imageNamed: "newCoin15"),SKTexture(imageNamed: "newCoin16")]
    
    var coinMovingArray1: [SKTexture] = [SKTexture(imageNamed: "newCoin21"),SKTexture(imageNamed: "newCoin22"),SKTexture(imageNamed: "newCoin23"),SKTexture(imageNamed: "newCoin24"),SKTexture(imageNamed: "newCoin25"),SKTexture(imageNamed: "newCoin26"),SKTexture(imageNamed: "newCoin27"),SKTexture(imageNamed: "newCoin28")]
    
    var coinMovingArray2: [SKTexture] = [SKTexture(imageNamed: "newCoin3_1"),SKTexture(imageNamed: "newCoin3_2"),SKTexture(imageNamed: "newCoin3_3"),SKTexture(imageNamed: "newCoin3_4"),SKTexture(imageNamed: "newCoin3_5"),SKTexture(imageNamed: "newCoin3_6"),SKTexture(imageNamed: "newCoin3_7")]
    
    
    var isActive: Bool = true
    var isSlowing: Bool = false
    
    weak var mainScene: SKScene?
    
    init() {
        // Initialize whith RANDOM pic from array barriers.
        let texture = SKTexture(imageNamed: barriers[Int(arc4random()%1)])
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        /*
        // Set random Z Position
        let randomNumber24 = CGFloat(arc4random_uniform(3) + 2)
        if randomNumber24 == 2 {
            self.zPosition = 1
        } else if randomNumber24 == 3 {
            self.zPosition = 3
        } else if randomNumber24 == 4 {
            self.zPosition = 5
        } else {
            // do nothing
        }
        //self.zPosition = CGFloat(arc4random_uniform(3) + 2)
        
        
        //print("Barrier zPosition \(zPosition)")
        
        if self.zPosition < 3.0 {
            self.xScale -= 0.5
            self.yScale -= 0.5
            self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        } else if self.zPosition > 3.0 {
            self.xScale += 0.5
            self.yScale += 0.5
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
        self.physicsBody?.categoryBitMask = BodyType.barrier.rawValue
        self.physicsBody?.collisionBitMask = 0
        //        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        self.name = "barrier"
        //print("Barrier zPosition \(zPosition)")
         */
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(/*texture: SKTexture?,*/ zPosition: CGFloat, XPosition: CGFloat) {
        self.init()
        self.physicsBody = nil
        //let texture = SKTexture(imageNamed: barriers[Int(arc4random()%4)])
        //self.texture = SKTexture(imageNamed: "boxTrio")
        self.zPosition = zPosition
        //self.position.x = XPosition
        
//        var coin = Int(arc4random()%2)
//        coin = 2
        if planet == 3 {
            let coinMovingAction = SKAction.animate(with: coinMovingArray, timePerFrame: 0.06)
            let forever = SKAction.repeatForever(coinMovingAction)
            self.run(forever)
        } else if planet == 2 {
            let coinMovingAction = SKAction.animate(with: coinMovingArray1, timePerFrame: 0.06)
            let forever = SKAction.repeatForever(coinMovingAction)
            self.run(forever)
        } else if planet == 1 {
            let coinMovingAction = SKAction.animate(with: coinMovingArray2, timePerFrame: 0.06)
            let forever = SKAction.repeatForever(coinMovingAction)
            self.run(forever)
        } else if planet == 5 {  // Random Texture
            let textureNumber = Int(arc4random()%2)
            if textureNumber == 0 {
                let coinMovingAction = SKAction.animate(with: coinMovingArray, timePerFrame: 0.06)
                let forever = SKAction.repeatForever(coinMovingAction)
                self.run(forever)
            } else if textureNumber == 1 {
                let coinMovingAction = SKAction.animate(with: coinMovingArray2, timePerFrame: 0.06)
                let forever = SKAction.repeatForever(coinMovingAction)
                self.run(forever)
            } else if textureNumber == 2 {
                let coinMovingAction = SKAction.animate(with: coinMovingArray1, timePerFrame: 0.06)
                let forever = SKAction.repeatForever(coinMovingAction)
                self.run(forever)
            }
        }
        
        if XPosition == 1 {
            if zPosition == 1 {
                self.position = DebrisPosition.lowRight925 //CGPoint(x: mainScene!.size.width * 0.70 - 170, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.0
                self.yScale -= 0.0
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleRight1010//CGPoint(x: mainScene!.size.width * 0.70 - 60, y: mainScene!.size.height * 1.2)
                self.xScale += 0.5
                self.yScale += 0.5
            } else if zPosition == 5 {
                self.position = DebrisPosition.highRight1095 //CGPoint(x: mainScene!.size.width * 0.70 + 25, y: mainScene!.size.height * 1.2)
                self.xScale += 1.0
                self.yScale += 1.0
            }
        } else if XPosition == 2 {
            
            //case 2:
            
            if zPosition == 1 {
                self.position = DebrisPosition.lowCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.0
                self.yScale -= 0.0
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale += 0.5
                self.yScale += 0.5
            } else if zPosition == 5 {
                self.position = DebrisPosition.highCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale += 1.0
                self.yScale += 1.0
            }
        } else if XPosition == 3 {
            
            //case 3:
            if zPosition == 1 {
                self.position = DebrisPosition.lowLeft620 //CGPoint(x: mainScene!.size.width * 0.30 + 170, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.0
                self.yScale -= 0.0
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleLeft535 //CGPoint(x: mainScene!.size.width * 0.30 + 60, y: mainScene!.size.height * 1.2)
                self.xScale += 0.5
                self.yScale += 0.5
            } else if zPosition == 5  {
                self.position = DebrisPosition.highLeft450 //CGPoint(x: mainScene!.size.width * 0.30 - 25, y: mainScene!.size.height * 1.2)
                self.xScale += 1.0
                self.yScale += 1.0
            }
        }
        
        /*
        if self.zPosition < 3.0 {
            self.xScale -= 0.5
            self.yScale -= 0.5
            //self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        } else if self.zPosition > 3.0 {
            self.xScale += 0.5
            self.yScale += 0.5
            //self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        } else {
            //self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        }
         */
        self.physicsBody = SKPhysicsBody(texture: texture!, size: self.size)
        self.name = "barrier"
        //self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.isDynamic = true
        
        
        // Set PhysicsBody. First create PhysicsBody then set properties !!!!
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = false
        self.physicsBody?.allowsRotation = false
        
        // CategoryBitMask, collisionBitMask, contactTestBitMask
        self.physicsBody?.categoryBitMask = BodyType.barrier.rawValue
        self.physicsBody?.collisionBitMask = 0
        //        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        
        
    }
    
    
    

    
    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}  // class
