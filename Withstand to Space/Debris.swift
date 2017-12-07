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
    
    var debrisEffectArray: [SKTexture] = [SKTexture(imageNamed: "b1r"),SKTexture(imageNamed: "b2r"),SKTexture(imageNamed: "b3r"),SKTexture(imageNamed: "b4r"),SKTexture(imageNamed: "b5r"),SKTexture(imageNamed: "b6r") ,SKTexture(imageNamed: "b7r")]
    
    var greenMineEffectArray: [SKTexture] = [SKTexture(imageNamed: "mine03_1"),SKTexture(imageNamed: "mine03_2"),SKTexture(imageNamed: "mine03_3"),SKTexture(imageNamed: "mine03_4"),SKTexture(imageNamed: "mine03_5"),SKTexture(imageNamed: "mine03_6") ,SKTexture(imageNamed: "mine03_7")]
    
    var greenMineChargedEffectArray: [SKTexture] = [SKTexture(imageNamed: "mine03Charged_1"),SKTexture(imageNamed: "mine03Charged_2"),SKTexture(imageNamed: "mine03Charged_3"),SKTexture(imageNamed: "mine03Charged_4"),SKTexture(imageNamed: "mine03Charged_5"),SKTexture(imageNamed: "mine03Charged_6") ,SKTexture(imageNamed: "mine03Charged_7")]
    
    var yellowMineEffectArray: [SKTexture] = [SKTexture(imageNamed: "mine08_1s"),SKTexture(imageNamed: "mine08_2s"),SKTexture(imageNamed: "mine08_3s"),SKTexture(imageNamed: "mine08_4s"),SKTexture(imageNamed: "mine08_5s"),SKTexture(imageNamed: "mine08_6s") ,SKTexture(imageNamed: "mine08_7s")]
    
    let barriers = ["alien1_85"]
    
    var isActive: Bool = true
    var isSlowing: Bool = false
    
    var greenMineCharged: Bool = false
    
    var hiddenCoin: Barrier?
    var hiddenMine: Debris?
    
    let barrierDot = SKSpriteNode(color: UIColor.red, size: CGSize(width: 100, height: 100))
    
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
        //let mine = Int(arc4random()%2)
        let zRotationArray: [CGFloat] = [CGFloat(Double.pi / 9), CGFloat(Double.pi / 3), CGFloat(Double.pi / 6), CGFloat(Double.pi)]
        let zRotation = zRotationArray[Int(arc4random()%4)]
        if planet == 1 {
            self.texture = SKTexture(imageNamed: "mine01")
            self.zRotation = zRotation
        } else if planet == 2 {
            self.texture = SKTexture(imageNamed: "mine07")
            self.xScale += 0.1
            self.yScale += 0.1
            self.zRotation = zRotation //CGFloat(Double.pi / 9)
        } else if planet == 3 {
            self.texture = SKTexture(imageNamed: "mine08_4s")
            self.xScale += 0.5
            self.yScale += 0.5
            self.zRotation = zRotation //CGFloat(Double.pi / 9)
        } else if planet == 6 {
            self.texture = SKTexture(imageNamed: "mine06b1")
            self.xScale += 0.5
            self.yScale += 0.5
        }
        self.zPosition = zPosition
        //self.position.x = XPosition
        
        
        
        
//        switch XPosition {
//        case 1:
        if XPosition == 1 {
            if zPosition == 1 {
                self.position = DebrisPosition.lowRight925 //CGPoint(x: mainScene!.size.width * 0.70 - 170, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.2 //0.4
                self.yScale -= 0.2
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleRight1010//CGPoint(x: mainScene!.size.width * 0.70 - 60, y: mainScene!.size.height * 1.2)
                self.xScale += 0.3 //0.4
                self.yScale += 0.3
            } else if zPosition == 5 {
                self.position = DebrisPosition.highRight1095 //CGPoint(x: mainScene!.size.width * 0.70 + 25, y: mainScene!.size.height * 1.2)
                self.xScale += 0.8 //0.4
                self.yScale += 0.8
            }
        } else if XPosition == 2 {
            
            //case 2:
            
            if zPosition == 1 {
                self.position = DebrisPosition.lowCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.2 //0.4
                self.yScale -= 0.2
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale += 0.3 //0.4
                self.yScale += 0.3
            } else if zPosition == 5 {
                self.position = DebrisPosition.highCenter768 //CGPoint(x: mainScene!.size.width * 0.5, y: mainScene!.size.height * 1.2)
                self.xScale += 0.8 //0.4
                self.yScale += 0.8
            }
        } else if XPosition == 3 {
            
            //case 3:
            if zPosition == 1 {
                self.position = DebrisPosition.lowLeft620 //CGPoint(x: mainScene!.size.width * 0.30 + 170, y: mainScene!.size.height * 1.2)
                self.xScale -= 0.2 //0.4
                self.yScale -= 0.2
            } else if zPosition == 3 {
                self.position = DebrisPosition.middleLeft535 //CGPoint(x: mainScene!.size.width * 0.30 + 60, y: mainScene!.size.height * 1.2)
                self.xScale += 0.3 //0.4
                self.yScale += 0.3
            } else if zPosition == 5  {
                self.position = DebrisPosition.highLeft450 //CGPoint(x: mainScene!.size.width * 0.30 - 25, y: mainScene!.size.height * 1.2)
                self.xScale += 0.8 //0.4
                self.yScale += 0.8
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
    
    func debrisEffectPositionDot() {
        barrierDot.zPosition = 100
        barrierDot.position = CGPoint(x: (self.size.width - self.size.width) , y: (self.size.height - self.size.height))
        //rougeOnedot.position = CGPoint(x: 200, y: 200)
        barrierDot.size = CGSize(width: self.size.width + 100, height: self.size.height + 100)
        self.addChild(barrierDot)
        //print("adsfhaskdjflsadfhjashdfjakdhfkshadlfjksdf")
    }
    
    //MARK: RougeOne Effect
    func debrisEffect() {
        let effect = SKAction.animate(with: debrisEffectArray, timePerFrame: 0.06)
        barrierDot.run(SKAction.repeatForever(effect), withKey: "rougeOneEffectAction")
        barrierDot.isHidden = false
    }
    
    func stopdebrisEffect() {
        barrierDot.removeAction(forKey: "rougeOneEffectAction")
        barrierDot.isHidden = true
    }
    
    // MARK: Green glowing mine effect
    func greenGlowingMineEffect() {
        let effect = SKAction.animate(with: greenMineEffectArray, timePerFrame: 0.06)
        //let scale = SKAction.scale(to: CGFloat(1.5), duration: 0.06)
        //self.run(scale)
        self.run(SKAction.repeatForever(effect), withKey: "greenGlowingMineEffectAction")
    }
    
    func stopGreenGlowingMineEffect() {
        self.removeAction(forKey: "greenGlowingMineEffectAction")
    }
    
    // MARK: Green Chareged glowing mine effect
    func greenCharegedGlowingMineEffect() {
        let effect = SKAction.animate(with: greenMineChargedEffectArray, timePerFrame: 0.06)
        //let scale = SKAction.scale(to: CGFloat(1.5), duration: 0.06)
        //self.run(scale)
        self.run(SKAction.repeatForever(effect), withKey: "greenCharegedGlowingMineEffectAction")
    }
    
    func stopGreenCharegedGlowingMineEffect() {
        self.removeAction(forKey: "greenCharegedGlowingMineEffectAction")
    }
    
    
    // MARK: yellow glowing mine effect
    func yellowGlowingMineEffect() {
        let effect = SKAction.animate(with: yellowMineEffectArray, timePerFrame: 0.06)
        
        //let zRotationArray: [CGFloat] = [CGFloat(Double.pi / 9), CGFloat(Double.pi / 3), CGFloat(Double.pi / 6), CGFloat(Double.pi)]
        //let zRotation = zRotationArray[Int(arc4random()%4)]
        let rotationEffect = SKAction.rotate(byAngle: CGFloat(10 * Double.pi), duration: 15)
        let rotationGroup = SKAction.group([effect, rotationEffect])
        //let scale = SKAction.scale(to: CGFloat(1.5), duration: 0.06)
        //self.run(scale)
        self.run(SKAction.repeatForever(rotationGroup), withKey: "yellowGlowingMineEffectAction")
    }
    
    func stopYellowGlowingMineEffect() {
        self.removeAction(forKey: "yellowGlowingMineEffectAction")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}    // calss
