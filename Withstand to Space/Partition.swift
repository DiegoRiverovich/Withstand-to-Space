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
    
    weak var mainScene: SKScene?
    
    var higherThenShip: Bool {
        didSet {
            if self.contactWithShip && oldValue != higherThenShip {
                print("hello contact")
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
    
    
    
    
    
    
    
    
    
}     // class
