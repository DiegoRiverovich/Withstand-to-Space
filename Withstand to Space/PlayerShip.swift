//
//  PlayerShip.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 19.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import Foundation
import SpriteKit

enum ShipStatus {
    case noraml
    case trio
    case rogueOne
    case invisible
}

struct PlayerPosition {
    static let lowLeft620 = CGPoint(x: 620, y: 512)
    static let lowCenter768 = CGPoint(x: 768, y: 512)
    static let lowRight925 = CGPoint(x: 925, y: 512)
    
    static let middleLeft535 = CGPoint(x: 535, y: 512)
    static let middleCenter768 = CGPoint(x: 768, y: 512)
    static let middleRight1010 = CGPoint(x: 1010, y: 512)
    
    static let highLeft450 = CGPoint(x: 450, y: 512)
    static let highCenter768 = CGPoint(x: 768, y: 512)
    static let highRight1095 = CGPoint(x: 1095, y: 512)
}

var shipStatus = ShipStatus.noraml

class PlayerShip: SKSpriteNode {
    
    weak var mainScene: SKScene?
    
    var shipSize: CGSize?
    
    var centerLeftOrRightPosition: Int = 3
    var playerName = "player"
    
    var rougeIsActive = true
    
    let cD1 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
    let cD2 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
    let cD3 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
    let cD4 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
    
    init() {
        // Initialize whith pic.
        let texture = SKTexture(imageNamed: "playerShip")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        /*
        // Set PhysicsBody. First create PhysicsBody then set properties !!!!
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = false
        self.physicsBody?.allowsRotation = false
        
        // CategoryBitMask, collisionBitMask, contactTestBitMask
        self.physicsBody?.categoryBitMask = BodyType.player.rawValue
        self.physicsBody?.collisionBitMask = /* BodyType.barrier.rawValue //| */ BodyType.other.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.barrier.rawValue //| BodyType.other.rawValue
        */
        // Add collision detectors
        addCollisionDetectors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String, texture: SKTexture) {
        self.init()
        
        self.name = name
        self.texture = texture
    }
    
    //MARK: Scale up and move up by z position
    func moveUp() {
        
        switch shipStatus {
        case .noraml, .invisible:
            let moveUp = true
            var actionArray: [SKAction] = []
            if self.xScale >= 1.5 && self.zPosition == 5 {
                self.setScale(1.5)
                self.zPosition = 5
            } else if self.xScale == 0.5 && self.zPosition == 1 {
                let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                
                actionArray.append(anchorPointAction)
                let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                actionArray.append(group)
                let actionSequence = SKAction.sequence(actionArray)
                self.run(actionSequence)
                self.zPosition += 2
            }else {
                let scaleDown = SKAction.scale(to: 1.5, duration: 0.2)
                let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                
                actionArray.append(ancorPointAction)
                let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                actionArray.append(group)
                let actionSequence = SKAction.sequence(actionArray)
                self.run(actionSequence)
                //            self.xScale += 0.5
                //            self.yScale += 0.5
                self.zPosition += 2
            }
            //print(self.position)
        case .trio:
            
            let allShips = mainScene?.children
            for trioShip in allShips! {
                if trioShip is PlayerShip /*&& trioShip.name == "trioShip"*/ {
                    
                    let moveUp = true
                    var actionArray: [SKAction] = []
                    if trioShip.xScale >= 1.5 && trioShip.zPosition == 5 {
                        trioShip.setScale(1.5)
                        trioShip.zPosition = 5
                    } else if trioShip.xScale == 0.5 && trioShip.zPosition == 1 {
                        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                        //let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                        let anchorPointAction: SKAction = SKAction.run {
                            self.calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip)
                        }
                        
                        actionArray.append(anchorPointAction)
                        let group = moveActionGroupSetTrioShip(trioShip: trioShip as! PlayerShip, scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                        actionArray.append(group)
                        let actionSequence = SKAction.sequence(actionArray)
                        trioShip.run(actionSequence)
                        trioShip.zPosition += 2
                    }else {
                        let scaleDown = SKAction.scale(to: 1.5, duration: 0.2)
                        //let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                        let anchorPointAction: SKAction = SKAction.run {
                            self.calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip)
                        }
                        
                        actionArray.append(anchorPointAction)
                        let group = moveActionGroupSetTrioShip(trioShip: trioShip as! PlayerShip, scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                        actionArray.append(group)
                        let actionSequence = SKAction.sequence(actionArray)
                        trioShip.run(actionSequence)
                        //            self.xScale += 0.5
                        //            self.yScale += 0.5
                        trioShip.zPosition += 2
                    }
                    
                }
                
            }
        case .rogueOne:
            
            let moveUp = true
            var actionArray: [SKAction] = []
            if self.xScale >= 1.5 && self.zPosition == 5 {
                self.setScale(1.5)
                self.zPosition = 5
            } else if self.xScale == 0.5 && self.zPosition == 1 {
                let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                
                actionArray.append(anchorPointAction)
                let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                actionArray.append(group)
                let actionSequence = SKAction.sequence(actionArray)
                self.run(actionSequence)
                self.zPosition += 2
            }else {
                let scaleDown = SKAction.scale(to: 1.5, duration: 0.2)
                let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                
                actionArray.append(ancorPointAction)
                let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                actionArray.append(group)
                let actionSequence = SKAction.sequence(actionArray)
                self.run(actionSequence)
                //            self.xScale += 0.5
                //            self.yScale += 0.5
                self.zPosition += 2
            }
            //print(self.position)
            
        //case .invisible: break
        }
        
        //print("Player zPosition \(zPosition)")
        
        //mainScene.partitionAlpha()
    }
    
    
    //MARK: Scale down and move down by z position
    func moveDown() {
        switch shipStatus {
        case .noraml, .invisible:
            let moveUp = false
            var actionArray: [SKAction] = []
            if self.xScale <= 0.5 && self.zPosition == 1 {
                self.setScale(0.5)
                self.zPosition = 1
            } else if self.xScale == 1.5 && self.zPosition == 5 {
                let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                
                actionArray.append(anchorPointAction)
                let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                actionArray.append(group)
                let actionSequence = SKAction.sequence(actionArray)
                self.run(actionSequence)
                self.zPosition -= 2
            } else {
                let scaleDown = SKAction.scale(to: 0.5, duration: 0.2)
                let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                
                actionArray.append(anchorPointAction)
                let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                actionArray.append(group)
                let actionSequence = SKAction.sequence(actionArray)
                self.run(actionSequence)
                //            self.xScale -= 0.5
                //            self.yScale -= 0.5
                self.zPosition -= 2
            }
            //print(self.position)
        case .trio:
            
            let allShips = mainScene?.children
            for trioShip in allShips! {
                if trioShip is PlayerShip /*&& trioShip.name == "trioShip"*/ {
                    
                    let moveUp = false
                    var actionArray: [SKAction] = []
                    if trioShip.xScale <= 0.5 && trioShip.zPosition == 1 {
                        self.setScale(0.5)
                        self.zPosition = 1
                    } else if trioShip.xScale == 1.5 && trioShip.zPosition == 5 {
                        //let anchorPointAction: SKAction = SKAction.run(calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip))
                        let anchorPointAction: SKAction = SKAction.run {
                            self.calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip)
                        }
                        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                        
                        actionArray.append(anchorPointAction)
                        let group = moveActionGroupSetTrioShip(trioShip: trioShip as! PlayerShip, scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                        actionArray.append(group)
                        let actionSequence = SKAction.sequence(actionArray)
                        trioShip.run(actionSequence)
                        trioShip.zPosition -= 2
                    } else {
                        let scaleDown = SKAction.scale(to: 0.5, duration: 0.2)
                        //let anchorPointAction: SKAction = SKAction.run(calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip))
                        let anchorPointAction: SKAction = SKAction.run {
                            self.calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip)
                        }
                        
                        actionArray.append(anchorPointAction)
                        let group = moveActionGroupSetTrioShip(trioShip: trioShip as! PlayerShip, scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                        actionArray.append(group)
                        let actionSequence = SKAction.sequence(actionArray)
                        trioShip.run(actionSequence)
                        //            self.xScale -= 0.5
                        //            self.yScale -= 0.5
                        trioShip.zPosition -= 2
                    }
                }
                
            }
        case .rogueOne:
            
        let moveUp = false
        var actionArray: [SKAction] = []
        if self.xScale <= 0.5 && self.zPosition == 1 {
            self.setScale(0.5)
            self.zPosition = 1
        } else if self.xScale == 1.5 && self.zPosition == 5 {
            let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            
            actionArray.append(anchorPointAction)
            let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
            actionArray.append(group)
            let actionSequence = SKAction.sequence(actionArray)
            self.run(actionSequence)
            self.zPosition -= 2
        } else {
            let scaleDown = SKAction.scale(to: 0.5, duration: 0.2)
            let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
            
            actionArray.append(anchorPointAction)
            let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
            actionArray.append(group)
            let actionSequence = SKAction.sequence(actionArray)
            self.run(actionSequence)
            //            self.xScale -= 0.5
            //            self.yScale -= 0.5
            self.zPosition -= 2
        }
        //print(self.position)
        //case .invisible: break
        }
    }
    


    
    // Determine which side to move whene scaling player UP and DOWN and group in Action it.
    func moveActionGroupSet(scaleDown: SKAction, moveUp: Bool) -> SKAction {
        
        let moveToAction2: SKAction
        let moveToAction3: SKAction
        let moveToAction4: SKAction
        
        if moveUp {
            
            if self.zPosition == 1 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.middleLeft535.x, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.middleRight1010.x /*scene!.size.width * 0.30 - 20*/, duration: 0.2) //
            } else if self.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.highLeft450.x, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.highRight1095.x /*scene!.size.width * 0.30 - 20*/, duration: 0.2)
            } else {  // zPosition = 5
                moveToAction2 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 160*/, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.highRight1095.x, duration: 0.2)
            }
            
            
            /* Old calculated points from scene
            if self.zPosition == 2 {
                moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 + 65, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 - 65 /*scene!.size.width * 0.30 - 20*/, duration: 0.2) //
            } else if self.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 - 20, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 + 20 /*scene!.size.width * 0.30 - 20*/, duration: 0.2)
            } else {
                moveToAction2 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 160*/, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 + 20, duration: 0.2)
            }
            */
            
            /*  Old calculated points related to ship NOT to scene like now
            moveToAction2 = SKAction.moveTo(x: self.position.x + 90, duration: 0.2)
            moveToAction3 = SKAction.moveTo(x: self.position.x, duration: 0.2)
            moveToAction4 = SKAction.moveTo(x: self.position.x - 90, duration: 0.2)
             */

        } else {
            
            if self.zPosition == 1 {
                moveToAction2 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 160*/, duration: 0.2)  //
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.lowLeft620.x, duration: 0.2)
            } else if self.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.lowLeft620.x, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.lowRight925.x /*self.position.x*/, duration: 0.2)
            } else {  // zPosition = 5
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.middleLeft535.x /*scene!.size.width * 0.70 - 160*/, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.middleRight1010.x /*scene!.size.width * 0.70 + 20*/, duration: 0.2)
            }
            
            /* Old calculated points from scene
            if self.zPosition == 2 {
                moveToAction2 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 160*/, duration: 0.2)  //
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.30 - 20, duration: 0.2)
            } else if self.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 + 160, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 - 160 /*self.position.x*/, duration: 0.2)
            } else {
                moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 + 65 /*scene!.size.width * 0.70 - 160*/, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 - 65 /*scene!.size.width * 0.70 + 20*/, duration: 0.2)
            }
            */
            
            /*  Old calculated points related to ship NOT to scene like now
            moveToAction2 = SKAction.moveTo(x: self.position.x - 90, duration: 0.2)
            moveToAction3 = SKAction.moveTo(x: self.position.x, duration: 0.2)
            moveToAction4 = SKAction.moveTo(x: self.position.x + 90, duration: 0.2)
            */
            
        }
        
        var group: SKAction
        if centerLeftOrRightPosition == 2 {
            group = SKAction.group([scaleDown, moveToAction2])
        } else if centerLeftOrRightPosition == 3 {
            group = SKAction.group([scaleDown, moveToAction3])
        } else /* if centerLeftOrRightPosition == 4 */ {
            group = SKAction.group([scaleDown, moveToAction4])
        }
        
        return group
    }
    
    func moveActionGroupSetTrioShip(trioShip: PlayerShip, scaleDown: SKAction, moveUp: Bool) -> SKAction {
        
        let moveToAction2: SKAction
        let moveToAction3: SKAction
        let moveToAction4: SKAction
        
        if moveUp {
            
            if trioShip.zPosition == 1 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.middleLeft535.x, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.middleRight1010.x /*scene!.size.width * 0.30 - 20*/, duration: 0.2) //
            } else if trioShip.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.highLeft450.x, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.highRight1095.x /*scene!.size.width * 0.30 - 20*/, duration: 0.2)
            } else {  //  zPosition = 5
                moveToAction2 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 160*/, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.highRight1095.x, duration: 0.2)
            }
            
            /* Old calculated points from scene
            if trioShip.zPosition == 2 {
                moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 + 65, duration: 0.2)  // Left side
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 65*/, duration: 0.2)    // Center
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 - 65 /*scene!.size.width * 0.30 - 20*/, duration: 0.2) // Right side
            } else if trioShip.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 - 20, duration: 0.2)   // Left side
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x, duration: 0.2)       // Center
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 + 20 /*scene!.size.width * 0.30 - 20*/, duration: 0.2)    // Right side
            } else {
                moveToAction2 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 160*/, duration: 0.2)    // Left side
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)     // Center
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 + 20, duration: 0.2)      // Right side
            }
            */
            
            /* Old calculated points related to ship NOT to scene like now
            moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 + 160 /*trioShip.position.x - 90*/, duration: 0.2)
            moveToAction3 = SKAction.moveTo(x: trioShip.position.x, duration: 0.2)
            moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.30 - 20 /*trioShip.position.x + 90*/, duration: 0.2)
            */
            
        } else {
            
            if trioShip.zPosition == 1 {
                moveToAction2 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 160*/, duration: 0.2)  //
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.lowLeft620.x, duration: 0.2)
            } else if trioShip.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.lowLeft620.x, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.lowRight925.x /*self.position.x*/, duration: 0.2)
            } else {   // zPosition = 5
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.middleLeft535.x /*scene!.size.width * 0.70 - 160*/, duration: 0.2)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.middleRight1010.x /*scene!.size.width * 0.70 + 20*/, duration: 0.2)
            }
            
            /* Old calculated points from scene
            if trioShip.zPosition == 2 {
                moveToAction2 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 160*/, duration: 0.2)   // Left side
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 65*/, duration: 0.2)     // Center
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.30 - 20, duration: 0.2)     // Right side
            } else if trioShip.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 + 160, duration: 0.2)      // Left side
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x, duration: 0.2)       // Center
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 - 160 /*self.position.x*/, duration: 0.2)        // Right side
            } else {
                moveToAction2 = SKAction.moveTo(x: scene!.size.width * 0.30 + 65 /*scene!.size.width * 0.70 - 160*/, duration: 0.2)     // Left side
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)    // Center
                moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 - 65 /*scene!.size.width * 0.70 + 20*/, duration: 0.2)    // Right side
            }
            */
            
            /* Old calculated points related to ship NOT to scene like now
            moveToAction2 = SKAction.moveTo(x:  scene!.size.width * 0.70 + 20 /*trioShip.position.x + 90*/, duration: 0.2)
            moveToAction3 = SKAction.moveTo(x: trioShip.position.x, duration: 0.2)
            moveToAction4 = SKAction.moveTo(x: scene!.size.width * 0.70 - 160 /*trioShip.position.x - 90*/, duration: 0.2)
            */
 
        }
        
        var group: SKAction
        if trioShip.centerLeftOrRightPosition == 2 {
            group = SKAction.group([scaleDown, moveToAction2])
        } else if trioShip.centerLeftOrRightPosition == 3 {
            group = SKAction.group([scaleDown, moveToAction3])
        } else /* if centerLeftOrRightPosition == 4 */ {
            group = SKAction.group([scaleDown, moveToAction4])
        }
        
        return group
    }
    
    func moveLeft() {
        
        switch shipStatus {
        case .noraml, .rogueOne, .invisible:
            
            let currentPosition = self.position
            if ceil(currentPosition.x) == scene!.size.width / 2 {
                //self.position = CGPoint(x: scene!.size.width * 0.30, y: scene!.size.height * 0.25)
                
                
                var moveAction: SKAction
                if self.zPosition == 1 {
                    moveAction = SKAction.move(to: PlayerPosition.lowLeft620, duration: 0.2)
                } else if self.zPosition == 3 {
                    moveAction = SKAction.move(to: PlayerPosition.middleLeft535, duration: 0.2)
                } else {   //zPosition = 5
                    moveAction = SKAction.move(to: PlayerPosition.highLeft450, duration: 0.2)
                }
                
                /*
                var moveAction: SKAction
                if self.zPosition == 2 {
                    moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.30 + 160, y: scene!.size.height * 0.25), duration: 0.2)
                } else if self.zPosition == 3 {
                    moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.30 + 65, y: scene!.size.height * 0.25), duration: 0.2)
                } else {
                    moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.30 - 20, y: scene!.size.height * 0.25), duration: 0.2)
                }
                */
                
                //let moveAction: SKAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.30, y: scene!.size.height * 0.25), duration: 0.2)
                let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                let actionSequence = SKAction.sequence([moveAction, ancorPointAction])
                self.run(actionSequence)
            } else if ceil(currentPosition.x) > scene!.size.width * 0.5 {
                //self.position = CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25)
                
                var moveAction: SKAction
                /* moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25), duration: 0.2) */
                moveAction = SKAction.move(to: PlayerPosition.middleCenter768, duration: 0.2)

                let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                let actionSequence = SKAction.sequence([moveAction, ancorPointAction])
                self.run(actionSequence)
            }
            //print(self.position)
        case .trio: break
            
        //case .rogueOne: break
        //case .invisible: break
        }
        //calculateAnchorPoint()
    }
    
    
    
    func moveRight() {
        
        switch shipStatus {
        case .noraml, .rogueOne, .invisible:
            
            //calculateAnchorPoint()
            
            let currentPosition = self.position
            if ceil(currentPosition.x) == ceil(scene!.size.width / 2) {
                //self.position = CGPoint(x: scene!.size.width * 0.70, y: scene!.size.height * 0.25)
                
                var moveAction: SKAction
                
                if self.zPosition == 1 {
                    moveAction = SKAction.move(to: PlayerPosition.lowRight925, duration: 0.2)
                } else if self.zPosition == 3 {
                    moveAction = SKAction.move(to: PlayerPosition.middleRight1010, duration: 0.2)
                } else {   //zPosition = 5
                    moveAction = SKAction.move(to: PlayerPosition.highRight1095, duration: 0.2)
                }
                
                /*
                if self.zPosition == 1 {
                    moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.70 - 160, y: scene!.size.height * 0.25), duration: 0.2)
                } else if self.zPosition == 3 {
                    moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.70 - 65, y: scene!.size.height * 0.25), duration: 0.2)
                } else {
                    moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.70 + 20, y: scene!.size.height * 0.25), duration: 0.2)
                }
                */
                
                //let moveAction: SKAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.70, y: scene!.size.height * 0.25), duration: 0.2)
                let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                let actionSequence = SKAction.sequence([moveAction, ancorPointAction])
                self.run(actionSequence)
            } else if ceil(currentPosition.x) < scene!.size.width * 0.5  {
                //self.position = CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25)
                //let moveAction: SKAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25), duration: 0.2)
                
                var moveAction: SKAction
                
                /* moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25), duration: 0.2) */
                moveAction = SKAction.move(to: PlayerPosition.middleCenter768, duration: 0.2)
                
                let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                let actionSequence = SKAction.sequence([moveAction, ancorPointAction])
                self.run(actionSequence)
            }
            //print(self.position)
        case .trio: break
        //case .rogueOne: break
        //case .invisible: break
        }
        //calculateAnchorPoint()
    }
    
    func calculateAnchorPoint() {
        let currentPosition = self.position
        if ceil(currentPosition.x) == scene!.size.width / 2 {
            //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.centerLeftOrRightPosition = 3
        } else if ceil(currentPosition.x) < scene!.size.width / 2 {
            //self.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            self.centerLeftOrRightPosition = 2
        } else if ceil(currentPosition.x) > scene!.size.width / 2 {
            //self.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            self.centerLeftOrRightPosition = 4
        }
    }
    
    func calculateAnchorPointForTrio(trioShip: PlayerShip) {
        let currentPosition = trioShip.position
        if ceil(currentPosition.x) == scene!.size.width / 2 {
            //self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            trioShip.centerLeftOrRightPosition = 3
        } else if ceil(currentPosition.x) < scene!.size.width / 2 {
            //self.anchorPoint = CGPoint(x: 1.0, y: 0.5)
            trioShip.centerLeftOrRightPosition = 2
        } else if ceil(currentPosition.x) > scene!.size.width / 2 {
            //self.anchorPoint = CGPoint(x: 0.0, y: 0.5)
            trioShip.centerLeftOrRightPosition = 4
        }
    }
    
    func calculateHorizontalPosition() {
        
    }
    
    func addCollisionDetectors() {
        //let cD1 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
        cD1.position = CGPoint(x: 0 /*(self.size.width / 2)*/, y: (self.size.height / 2) - 2)
        //cD1.anchorPoint = CGPoint(x: 0, y: 0)
        cD1.name = "cD"
        
        
        //let cD2 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
        cD2.position = CGPoint(x: 0 /*(self.size.width / 2)*/ , y: (self.size.height / 2) / 2)
        //cD1.anchorPoint = CGPoint(x: 0, y: 0)
        cD2.name = "cD"
        
        
        //let cD3 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
        cD3.position = CGPoint(x: 0 /*(self.size.width / 2)*/ , y: ((self.size.height - self.size.height) + 2))
        //cD1.anchorPoint = CGPoint(x: 0, y: 0)
        cD3.name = "cD"
        
        //let cD4 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
        cD4.position = CGPoint(x: 0 /*(self.size.width / 2)*/ , y: ((self.size.height - (self.size.height * 1.5)) + 2))
        //cD1.anchorPoint = CGPoint(x: 0, y: 0)
        cD4.name = "cD"
        
        
        
        self.addChild(cD1)
        self.addChild(cD2)
        self.addChild(cD3)
        self.addChild(cD4)
        
        addPhysicsBodyToDetectors(node: cD1)
        addPhysicsBodyToDetectors(node: cD2)
        addPhysicsBodyToDetectors(node: cD3)
        addPhysicsBodyToDetectors(node: cD4)
    }
    
    
    func addPhysicsBodyToDetectors(node: SKSpriteNode) {
        
        // Set PhysicsBody. First create PhysicsBody then set properties !!!!
        node.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.pinned = false
        node.physicsBody?.allowsRotation = false
        
        // CategoryBitMask, collisionBitMask, contactTestBitMask
        node.physicsBody?.categoryBitMask = BodyType.cD.rawValue
        node.physicsBody?.collisionBitMask = /* BodyType.barrier.rawValue //| */ BodyType.other.rawValue
        node.physicsBody?.contactTestBitMask = BodyType.barrier.rawValue | BodyType.partition.rawValue
        
    }
    

    
}  // class


class CollisionDetector: SKSpriteNode {
    var isInContactWithSomething = false
}






















