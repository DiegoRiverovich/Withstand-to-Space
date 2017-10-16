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
    
    let barriers = ["alien1", "alien2", "alien3", "coin1"]
    
    var isActive: Bool = true
    
    weak var mainScene: SKScene?
    
    init() {
        // Initialize whith RANDOM pic from array barriers.
        let texture = SKTexture(imageNamed: barriers[Int(arc4random()%4)])
        
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
        self.texture = SKTexture(imageNamed: "boxTrio")
        self.zPosition = zPosition
        //self.position.x = XPosition
        
        if XPosition == 1 {
            if zPosition == 1 {
                self.position = DebrisPosition.lowRight925 //CGPoint(x: mainScene!.size.width * 0.70 - 170, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.5
                self.yScale -= 0.5
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleRight1010//CGPoint(x: mainScene!.size.width * 0.70 - 60, y: mainScene!.size.height * 1.2)
            } else if zPosition == 5 {
                self.position = DebrisPosition.highRight1095 //CGPoint(x: mainScene!.size.width * 0.70 + 25, y: mainScene!.size.height * 1.2)
                self.xScale += 0.5
                self.yScale += 0.5
            }
        } else if XPosition == 2 {
            
            //case 2:
            
            if zPosition == 1 {
                self.position = DebrisPosition.lowCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.5
                self.yScale -= 0.5
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
            } else if zPosition == 5 {
                self.position = DebrisPosition.highCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale += 0.5
                self.yScale += 0.5
            }
        } else if XPosition == 3 {
            
            //case 3:
            if zPosition == 1 {
                self.position = DebrisPosition.lowLeft620 //CGPoint(x: mainScene!.size.width * 0.30 + 170, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.5
                self.yScale -= 0.5
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleLeft535 //CGPoint(x: mainScene!.size.width * 0.30 + 60, y: mainScene!.size.height * 1.2)
            } else if zPosition == 5  {
                self.position = DebrisPosition.highLeft450 //CGPoint(x: mainScene!.size.width * 0.30 - 25, y: mainScene!.size.height * 1.2)
                self.xScale += 0.5
                self.yScale += 0.5
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
