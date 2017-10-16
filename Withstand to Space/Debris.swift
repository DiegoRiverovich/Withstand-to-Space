//
//  Debris.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 13.10.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit

class Debris: SKSpriteNode {
    
    let barriers = ["alien1_85"]
    
    var isActive: Bool = true
    
    weak var mainScene: SKScene?
    
    init() {
        // Initialize whith RANDOM pic from array barriers.
        let texture = SKTexture(imageNamed: barriers[Int(arc4random()%1)])
        super.init(texture: texture, color: UIColor.clear, size: texture.size())

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(/*texture: SKTexture?,*/ zPosition: CGFloat, XPosition: CGFloat) {
        self.init()
        self.physicsBody = nil
        //let texture = SKTexture(imageNamed: barriers[Int(arc4random()%4)])
        self.texture = SKTexture(imageNamed: "mine01")
        self.zPosition = zPosition
        //self.position.x = XPosition
        
        
        
        
//        switch XPosition {
//        case 1:
        if XPosition == 1 {
            if zPosition == 1 {
                self.position = DebrisPosition.lowRight925 //CGPoint(x: mainScene!.size.width * 0.70 - 170, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.4
                self.yScale -= 0.4
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleRight1010//CGPoint(x: mainScene!.size.width * 0.70 - 60, y: mainScene!.size.height * 1.2)
            } else if zPosition == 5 {
                self.position = DebrisPosition.highRight1095 //CGPoint(x: mainScene!.size.width * 0.70 + 25, y: mainScene!.size.height * 1.2)
                self.xScale += 0.4
                self.yScale += 0.4
            }
        } else if XPosition == 2 {
            
            //case 2:
            
            if zPosition == 1 {
                self.position = DebrisPosition.lowCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.4
                self.yScale -= 0.4
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
            } else if zPosition == 5 {
                self.position = DebrisPosition.highCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale += 0.4
                self.yScale += 0.4
            }
        } else if XPosition == 3 {
            
            //case 3:
            if zPosition == 1 {
                self.position = DebrisPosition.lowLeft620 //CGPoint(x: mainScene!.size.width * 0.30 + 170, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.4
                self.yScale -= 0.4
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleLeft535 //CGPoint(x: mainScene!.size.width * 0.30 + 60, y: mainScene!.size.height * 1.2)
            } else if zPosition == 5  {
                self.position = DebrisPosition.highLeft450 //CGPoint(x: mainScene!.size.width * 0.30 - 25, y: mainScene!.size.height * 1.2)
                self.xScale += 0.4
                self.yScale += 0.4
            }
        }
        /*default:
            //self.position = CGPoint(x: mainScene!.size.width * 0.60, y: mainScene!.size.height * 1.20)
            print("default")
        }*/

        self.physicsBody = SKPhysicsBody(texture: texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        
        
        // Set PhysicsBody. First create PhysicsBody then set properties !!!!
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = false
        self.physicsBody?.allowsRotation = false
        
        // CategoryBitMask, collisionBitMask, contactTestBitMask
        self.physicsBody?.categoryBitMask = BodyType.debris.rawValue
        self.physicsBody?.collisionBitMask = 0
        //        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}    // calss
