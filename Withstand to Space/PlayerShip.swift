//
//  PlayerShip.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 19.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import Foundation
import SpriteKit
import simd

class PlayerShip: SKSpriteNode {
    
    weak var mainScene: SKScene?
    
    var shipSize: CGSize?
    
    var centerLeftOrRightPosition: Int = 3
    var playerName = "player"
    
    var particleToNormalTimer: Timer?
    
    var shipTurningLeftArray: [SKTexture] = [SKTexture(imageNamed: "ship10"),SKTexture(imageNamed: "ship11"),SKTexture(imageNamed: "ship12"),SKTexture(imageNamed: "ship13"),SKTexture(imageNamed: "ship14"),SKTexture(imageNamed: "ship15"),SKTexture(imageNamed: "ship16"),SKTexture(imageNamed: "ship17"),SKTexture(imageNamed: "ship18"),SKTexture(imageNamed: "ship19")]
    var shipTurningRightArray: [SKTexture] = [SKTexture(imageNamed: "ship0"),SKTexture(imageNamed: "ship1"),SKTexture(imageNamed: "ship2"),SKTexture(imageNamed: "ship3"),SKTexture(imageNamed: "ship4"),SKTexture(imageNamed: "ship5"),SKTexture(imageNamed: "ship6"),SKTexture(imageNamed: "ship7"),SKTexture(imageNamed: "ship8"),SKTexture(imageNamed: "ship9")]
 
    var shipTurningDownArray: [SKTexture] = [SKTexture(imageNamed: "ship20"),SKTexture(imageNamed: "ship21"),SKTexture(imageNamed: "ship22"),SKTexture(imageNamed: "ship23"),SKTexture(imageNamed: "ship24"),SKTexture(imageNamed: "ship25"),SKTexture(imageNamed: "ship26")]
    var shipTurningUpArray: [SKTexture] = [SKTexture(imageNamed: "ship30"),SKTexture(imageNamed: "ship31"),SKTexture(imageNamed: "ship32"),SKTexture(imageNamed: "ship33"),SKTexture(imageNamed: "ship34"),SKTexture(imageNamed: "ship35"),SKTexture(imageNamed: "ship36")]
    
    let jetFire = SKEmitterNode(fileNamed: "jetFire.sks")
    
    var rougeIsActive = true
    
    var actionIsActive: Bool
    
    // Second status active
    var trioTimeActive = 100 {
        didSet {
            
        }
    }
    var rougeOneTimeActive = 100
    {
        didSet {
            
        }
    }
    var InvisibleTimeActive = 100
    {
        didSet {
            
        }
    }
    
    // Global collision detectors
    let cD1 = CollisionDetector(color: UIColor.clear, size: CGSize(width: 10, height: 10))
    let cD2 = CollisionDetector(color: UIColor.clear, size: CGSize(width: 10, height: 10))
    let cD3 = CollisionDetector(color: UIColor.clear, size: CGSize(width: 10, height: 10))
    let cD4 = CollisionDetector(color: UIColor.clear, size: CGSize(width: 10, height: 10))
    let cD5 = CollisionDetector(color: UIColor.clear, size: CGSize(width: 10, height: 10))
    let cD6 = CollisionDetector(color: UIColor.clear, size: CGSize(width: 10, height: 10))
    let cD7 = CollisionDetector(color: UIColor.clear, size: CGSize(width: 10, height: 10))
    let cD8 = CollisionDetector(color: UIColor.clear, size: CGSize(width: 10, height: 10))
    
    init() {
        // Initialize whith pic.
        actionIsActive = false
        let texture = SKTexture(imageNamed: "ship10001")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        addCollisionDetectors()
        
        if soundsIsOn {
            //let waitActionBeforeStartEngine = SKAction.wait(forDuration: TimeInterval(0))
            let playSoundStartEngine = SKAction.playSoundFileNamed("engineStart1.m4a", waitForCompletion: false)
            let startEngineSequence = SKAction.sequence([/*waitActionBeforeStartEngine,*/ playSoundStartEngine])
            run(startEngineSequence)
        }
        
        jetFire?.targetNode = self
        jetFire?.zPosition = -10
        //jetFire?.emissionAngle = 180
        jetFire?.position = CGPoint(x: self.position.x, y: (self.position.y - (self.size.height / 2)) - 20)
        self.addChild(jetFire!)
        //jetFire?.numParticlesToEmit = 900
        //jetFire?.speed = 1000
        jetFire?.particleSpeed = 400
        jetFire?.particleLifetime = 0.7
        
        particleToNormalTimer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(PlayerShip.particleToNormal), userInfo: nil, repeats: false)
        
        //jetFire?.particleScale = 1.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String?, texture: SKTexture?) {
        self.init()
        
        if name != nil {
            self.name = name
        }
        if texture != nil {
            self.texture = texture
        }
        
        jetFire?.particleSpeed = 200
        jetFire?.particleLifetime = 0.2
    }
    
    //MARK: ParticleEmitter to normal after start
    @objc func particleToNormal() {
        jetFire?.particleSpeed = 200
        jetFire?.particleLifetime = 0.2
    }
    
    //MARK: Scale up and move up by z position
    func moveUp() {
        if (!actionIsActive) {
            actionIsActive = true
            switch shipStatus {
            case .noraml, .invisible:
                let moveUp = true
                var actionArray: [SKAction] = []
                //let xScale = CGFloat(round(10 * self.xScale) / 10)
                if self.xScale.roundTo1Decimal() >= ShipScale.big /*1.5*/ && self.zPosition == 5 {
                    self.setScale(ShipScale.big/*1.5*/)
                    self.zPosition = 5
                    actionIsActive = false
                } else if self.xScale.roundTo1Decimal() == ShipScale.small /*0.5*/ && self.zPosition == 1 {
                    let scaleDown = SKAction.scale(to: ShipScale.middle /*1*/, duration: shipSpeedMovement.rawValue /*0.2*/)
                    let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    
                    actionArray.append(anchorPointAction)
                    let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                    group.timingMode = SKActionTimingMode.easeInEaseOut
                    actionArray.append(group)
                    let actionSequence = SKAction.sequence(actionArray)
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    self.zPosition += 2
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                } else {
                    let scaleDown = SKAction.scale(to: ShipScale.big /*1.5*/, duration: shipSpeedMovement.rawValue)
                    let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    
                    actionArray.append(ancorPointAction)
                    let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                    group.timingMode = SKActionTimingMode.easeInEaseOut
                    actionArray.append(group)
                    let actionSequence = SKAction.sequence(actionArray)
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    //            self.xScale += 0.5
                    //            self.yScale += 0.5
                    self.zPosition += 2
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                }
            //print(self.position)
            case .trio:
                
                let allShips = mainScene?.children
                for trioShip in allShips! {
                    if trioShip is PlayerShip /*&& trioShip.name == "trioShip"*/ {
                        let moveUp = true
                        var actionArray: [SKAction] = []
                        if trioShip.xScale.roundTo1Decimal() >= ShipScale.big /*1.5*/ && trioShip.zPosition == 5 {
                            trioShip.setScale(ShipScale.big /*1.5*/)
                            trioShip.zPosition = 5
                            actionIsActive = false
                        } else if trioShip.xScale.roundTo1Decimal() == ShipScale.small /*0.5*/ && trioShip.zPosition == 1 {
                            let scaleDown = SKAction.scale(to: ShipScale.middle /*1*/, duration: shipSpeedMovement.rawValue)
                            //let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                            if self.rougeIsActive == true {
                                let anchorPointAction: SKAction = SKAction.run {
                                    self.calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip)
                                }
                                
                                actionArray.append(anchorPointAction)
                            }
                            let group = moveActionGroupSetTrioShip(trioShip: trioShip as! PlayerShip, scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                            group.timingMode = SKActionTimingMode.easeInEaseOut
                            actionArray.append(group)
                            let actionSequence = SKAction.sequence(actionArray)
                            trioShip.run(actionSequence, completion: {
                                self.actionIsActive = false
                            })
                            trioShip.zPosition += 2
                            if soundsIsOn {
                                run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                            }
                        }else {
                            let scaleDown = SKAction.scale(to: ShipScale.big /*1.5*/, duration: shipSpeedMovement.rawValue)
                            //let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                            if self.rougeIsActive == true {
                                let anchorPointAction: SKAction = SKAction.run {
                                    self.calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip)
                                }
                                
                                actionArray.append(anchorPointAction)
                            }
                            let group = moveActionGroupSetTrioShip(trioShip: trioShip as! PlayerShip, scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                            group.timingMode = SKActionTimingMode.easeInEaseOut
                            actionArray.append(group)
                            let actionSequence = SKAction.sequence(actionArray)
                            trioShip.run(actionSequence, completion: {
                                self.actionIsActive = false
                            })
                            //            self.xScale += 0.5
                            //            self.yScale += 0.5
                            trioShip.zPosition += 2
                            if soundsIsOn {
                                run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                            }
                        }
                        
                    }
                    
                }
            case .rogueOne:
                
                let moveUp = true
                var actionArray: [SKAction] = []
                if self.xScale.roundTo1Decimal() >= ShipScale.big /*1.5*/ && self.zPosition == 5 {
                    self.setScale(ShipScale.big /*1.5*/)
                    self.zPosition = 5
                    actionIsActive = false
                } else if self.xScale.roundTo1Decimal() == ShipScale.small /*0.5*/ && self.zPosition == 1 {
                    let scaleDown = SKAction.scale(to: ShipScale.middle /*1*/, duration: shipSpeedMovement.rawValue)
                    let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    
                    actionArray.append(anchorPointAction)
                    let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                    group.timingMode = SKActionTimingMode.easeInEaseOut
                    actionArray.append(group)
                    let actionSequence = SKAction.sequence(actionArray)
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    self.zPosition += 2
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                }else {
                    let scaleDown = SKAction.scale(to: ShipScale.big /*1.5*/, duration: shipSpeedMovement.rawValue)
                    let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    
                    actionArray.append(ancorPointAction)
                    let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //UpMoveActionGroupSet(scaleDown: scaleDown)
                    group.timingMode = SKActionTimingMode.easeInEaseOut
                    actionArray.append(group)
                    let actionSequence = SKAction.sequence(actionArray)
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    //            self.xScale += 0.5
                    //            self.yScale += 0.5
                    self.zPosition += 2
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                }
                //print(self.position)
                
                //case .invisible: break
            }
        } else {
            
        }
    }
    
    
    //MARK: Scale down and move down by z position
    func moveDown() {
        
        if (!actionIsActive) {
            actionIsActive = true
            switch shipStatus {
            case .noraml, .invisible:
                let moveUp = false
                var actionArray: [SKAction] = []
                //let xScale = CGFloat(round(10 * self.xScale) / 10)
                if self.xScale.roundTo1Decimal() <= ShipScale.small /*0.5*/ && self.zPosition == 1 {
                    self.setScale(ShipScale.small /*0.5*/)
                    self.zPosition = 1
                    actionIsActive = false
                } else if self.xScale.roundTo1Decimal() == ShipScale.big /*1.5*/ && self.zPosition == 5 {
                    //if onlyTopLevel {  // MARK: to move only to top level and back no medium level
                    let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    let scaleDown = SKAction.scale(to: ShipScale.middle /*1*/, duration: shipSpeedMovement.rawValue)
                    
                    actionArray.append(anchorPointAction)
                    let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                    group.timingMode = SKActionTimingMode.easeInEaseOut
                    actionArray.append(group)
                    let actionSequence = SKAction.sequence(actionArray)
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    self.zPosition -= 2
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                    // } else {   // MARK: to move only to top level and back no medium level
                    //self.actionIsActive = false
                    // }
                } else {
                    if onlyTopLevel {
                        self.actionIsActive = false
                    } else {
                        let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                        let scaleDown = SKAction.scale(to: ShipScale.small /*0.5*/, duration: shipSpeedMovement.rawValue)
                        
                        
                        actionArray.append(anchorPointAction)
                        let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                        group.timingMode = SKActionTimingMode.easeInEaseOut
                        actionArray.append(group)
                        let actionSequence = SKAction.sequence(actionArray)
                        self.run(actionSequence, completion: {
                            self.actionIsActive = false
                        })
                        self.zPosition -= 2
                        if soundsIsOn {
                            run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                        }
                    }
                }
            //print(self.position)
            case .trio:
                
                let allShips = mainScene?.children
                for trioShip in allShips! {
                    if trioShip is PlayerShip /*&& trioShip.name == "trioShip"*/ {
                        
                        let moveUp = false
                        var actionArray: [SKAction] = []
                        //let trioShipxScale = CGFloat(round(10 * trioShip.xScale) / 10)
                        if trioShip.xScale.roundTo1Decimal() <= ShipScale.small /*0.5*/ && trioShip.zPosition == 1 {
                            self.setScale(ShipScale.small /*0.5*/)
                            self.zPosition = 1
                            actionIsActive = false
                        } else if trioShip.xScale.roundTo1Decimal() == ShipScale.big /*1.5*/ && trioShip.zPosition == 5 {
                            //let anchorPointAction: SKAction = SKAction.run(calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip))
                            if self.rougeIsActive == true {
                                let anchorPointAction: SKAction = SKAction.run {
                                    self.calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip)
                                }
                                actionArray.append(anchorPointAction)
                            }
                            let scaleDown = SKAction.scale(to: ShipScale.middle /*1*/, duration: shipSpeedMovement.rawValue)
                            let group = moveActionGroupSetTrioShip(trioShip: trioShip as! PlayerShip, scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                            group.timingMode = SKActionTimingMode.easeInEaseOut
                            actionArray.append(group)
                            let actionSequence = SKAction.sequence(actionArray)
                            trioShip.run(actionSequence, completion: {
                                self.actionIsActive = false
                            })
                            trioShip.zPosition -= 2
                            if soundsIsOn {
                                run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                            }
                        } else {
                            let scaleDown = SKAction.scale(to: ShipScale.small /*0.5*/, duration: shipSpeedMovement.rawValue)
                            //let anchorPointAction: SKAction = SKAction.run(calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip))
                            if self .rougeIsActive == true {
                                let anchorPointAction: SKAction = SKAction.run {
                                    self.calculateAnchorPointForTrio(trioShip: trioShip as! PlayerShip)
                                }
                                
                                actionArray.append(anchorPointAction)
                            }
                            
                            let group = moveActionGroupSetTrioShip(trioShip: trioShip as! PlayerShip, scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                            group.timingMode = SKActionTimingMode.easeInEaseOut
                            actionArray.append(group)
                            let actionSequence = SKAction.sequence(actionArray)
                            trioShip.run(actionSequence, completion: {
                                self.actionIsActive = false
                            })
                            //            self.xScale -= 0.5
                            //            self.yScale -= 0.5
                            trioShip.zPosition -= 2
                            if soundsIsOn {
                                run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                            }
                        }
                    }
                    
                }
            case .rogueOne:
                
                let moveUp = false
                var actionArray: [SKAction] = []
                if self.xScale.roundTo1Decimal() <= ShipScale.small /*0.5*/ && self.zPosition == 1 {
                    self.setScale(ShipScale.small /*0.5*/)
                    self.zPosition = 1
                    actionIsActive = false
                } else if self.xScale.roundTo1Decimal() == ShipScale.big /*1.5*/ && self.zPosition == 5 {
                    let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    let scaleDown = SKAction.scale(to: ShipScale.middle /*1*/, duration: shipSpeedMovement.rawValue)
                    
                    actionArray.append(anchorPointAction)
                    let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                    group.timingMode = SKActionTimingMode.easeInEaseOut
                    actionArray.append(group)
                    let actionSequence = SKAction.sequence(actionArray)
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    self.zPosition -= 2
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                } else {
                    let scaleDown = SKAction.scale(to: ShipScale.small /*0.5*/, duration: shipSpeedMovement.rawValue)
                    let anchorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    
                    actionArray.append(anchorPointAction)
                    let group = moveActionGroupSet(scaleDown: scaleDown, moveUp: moveUp) //DownMoveActionGroupSet(scaleDown: scaleDown)
                    group.timingMode = SKActionTimingMode.easeInEaseOut
                    actionArray.append(group)
                    let actionSequence = SKAction.sequence(actionArray)
                    //self.run(actionSequence)
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    //            self.xScale -= 0.5
                    //            self.yScale -= 0.5
                    self.zPosition -= 2
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                }
                //print(self.position)
                //case .invisible: break
            }
        } else {
            
        }
    }
    


    
    // Determine which side to move whene scaling player UP and DOWN and group in Action it.
    func moveActionGroupSet(scaleDown: SKAction, moveUp: Bool) -> SKAction {
        
        let moveToAction2: SKAction
        let moveToAction3: SKAction
        let moveToAction4: SKAction
        let moveUpOrDown: SKAction
        //let moveDownAction: SKAction
        
        if moveUp {
            
            if self.zPosition == 1 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.middleLeft535.x, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 65*/, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.middleRight1010.x /*scene!.size.width * 0.30 - 20*/, duration: shipSpeedMovement.rawValue) //
            } else if self.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.highLeft450.x, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: self.position.x, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.highRight1095.x /*scene!.size.width * 0.30 - 20*/, duration: shipSpeedMovement.rawValue)
            } else {  // zPosition = 5
                moveToAction2 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 160*/, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 65*/, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.highRight1095.x, duration: shipSpeedMovement.rawValue)
            }
            moveUpOrDown = SKAction.animate(with: shipTurningUpArray, timePerFrame: 0.1)
            
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
                moveToAction2 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 160*/, duration: shipSpeedMovement.rawValue)  //
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.30 + 65*/, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.lowLeft620.x, duration: shipSpeedMovement.rawValue)
            } else if self.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.lowLeft620.x, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: self.position.x, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.lowRight925.x /*self.position.x*/, duration: shipSpeedMovement.rawValue)
            } else {  // zPosition = 5
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.middleLeft535.x /*scene!.size.width * 0.70 - 160*/, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: self.position.x /*scene!.size.width * 0.70 - 65*/, duration: 0.2)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.middleRight1010.x /*scene!.size.width * 0.70 + 20*/, duration: shipSpeedMovement.rawValue)
            }
            moveUpOrDown = SKAction.animate(with: shipTurningDownArray, timePerFrame: 0.1)
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
            
            //moveToAction4.timingMode = SKActionTimingMode.easeInEaseOut
        }
        
        var group: SKAction
        if centerLeftOrRightPosition == 2 {
            group = SKAction.group([scaleDown, moveToAction2, moveUpOrDown])
        } else if centerLeftOrRightPosition == 3 {
            group = SKAction.group([scaleDown, moveToAction3, moveUpOrDown])
        } else /* if centerLeftOrRightPosition == 4 */ {
            group = SKAction.group([scaleDown, moveToAction4, moveUpOrDown])
        }
        group.timingMode = SKActionTimingMode.easeInEaseOut
        
        return group
    }
    
    func moveActionGroupSetTrioShip(trioShip: PlayerShip, scaleDown: SKAction, moveUp: Bool) -> SKAction {
        
        let moveToAction2: SKAction
        let moveToAction3: SKAction
        let moveToAction4: SKAction
        
        if moveUp {
            
            if trioShip.zPosition == 1 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.middleLeft535.x, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 65*/, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.middleRight1010.x /*scene!.size.width * 0.30 - 20*/, duration: shipSpeedMovement.rawValue) //
            } else if trioShip.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.highLeft450.x, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.highRight1095.x /*scene!.size.width * 0.30 - 20*/, duration: shipSpeedMovement.rawValue)
            } else {  //  zPosition = 5
                moveToAction2 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 160*/, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 65*/, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.highRight1095.x, duration: shipSpeedMovement.rawValue)
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
                moveToAction2 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 160*/, duration: shipSpeedMovement.rawValue)  //
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.30 + 65*/, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.lowLeft620.x, duration: shipSpeedMovement.rawValue)
            } else if trioShip.zPosition == 3 {
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.lowLeft620.x, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.lowRight925.x /*self.position.x*/, duration: shipSpeedMovement.rawValue)
            } else {   // zPosition = 5
                moveToAction2 = SKAction.moveTo(x: PlayerPosition.middleLeft535.x /*scene!.size.width * 0.70 - 160*/, duration: shipSpeedMovement.rawValue)
                moveToAction3 = SKAction.moveTo(x: trioShip.position.x /*scene!.size.width * 0.70 - 65*/, duration: shipSpeedMovement.rawValue)
                moveToAction4 = SKAction.moveTo(x: PlayerPosition.middleRight1010.x /*scene!.size.width * 0.70 + 20*/, duration: shipSpeedMovement.rawValue)
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
        group.timingMode = SKActionTimingMode.easeInEaseOut
        return group
    }
    
    func moveLeft() {
        if (!actionIsActive) {
            actionIsActive = true
            switch shipStatus {
            case .noraml, .rogueOne, .invisible:
                
                
                //let turnLeftAction = SKAction.animate
                let currentPosition = self.position
                if ceil(currentPosition.x) == scene!.size.width / 2 {
                    //self.position = CGPoint(x: scene!.size.width * 0.30, y: scene!.size.height * 0.25)
                    let turnLeftAction = SKAction.animate(with: shipTurningLeftArray, timePerFrame: 0.06)
                    
                    var moveAction: SKAction
                    if self.zPosition == 1 {
                        moveAction = SKAction.move(to: PlayerPosition.lowLeft620, duration: shipSpeedMovement.rawValue)
                    } else if self.zPosition == 3 {
                        moveAction = SKAction.move(to: PlayerPosition.middleLeft535, duration: shipSpeedMovement.rawValue)
                    } else {   //zPosition = 5
                        moveAction = SKAction.move(to: PlayerPosition.highLeft450, duration: shipSpeedMovement.rawValue)
                    }
                    let moveAndTurnGroup: SKAction = SKAction.group([moveAction, turnLeftAction])
                    moveAndTurnGroup.timingMode = SKActionTimingMode.easeInEaseOut
                    
                    let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    let actionSequence = SKAction.sequence([/*moveAction*/ moveAndTurnGroup, ancorPointAction])
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                } else if ceil(currentPosition.x) > scene!.size.width * 0.5 {
                    //self.position = CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25)
                    let turnLeftAction = SKAction.animate(with: shipTurningLeftArray, timePerFrame: 0.06)
                    
                    var moveAction: SKAction
                    /* moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25), duration: 0.2) */
                    moveAction = SKAction.move(to: PlayerPosition.middleCenter768, duration: shipSpeedMovement.rawValue)
                    let moveAndTurnGroup: SKAction = SKAction.group([moveAction, turnLeftAction])
                    moveAndTurnGroup.timingMode = SKActionTimingMode.easeInEaseOut
                    
                    let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    let actionSequence = SKAction.sequence([/*moveAction*/ moveAndTurnGroup, ancorPointAction])
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                } else {
                    actionIsActive = false
                }
            //print(self.position)
            case .trio: break
                
                //case .rogueOne: break
                //case .invisible: break
            }
        } else {
            
        }
        
        //calculateAnchorPoint()
    }
    
    
    
    func moveRight() {
        if (!actionIsActive) {
            actionIsActive = true
            switch shipStatus {
            case .noraml, .rogueOne, .invisible:
                
                //calculateAnchorPoint()
                
                let currentPosition = self.position
                if ceil(currentPosition.x) == ceil(scene!.size.width / 2) {
                    //self.position = CGPoint(x: scene!.size.width * 0.70, y: scene!.size.height * 0.25)
                    
                    let turnRightAction = SKAction.animate(with: shipTurningRightArray, timePerFrame: 0.06)
                    
                    var moveAction: SKAction
                    
                    if self.zPosition == 1 {
                        moveAction = SKAction.move(to: PlayerPosition.lowRight925, duration: shipSpeedMovement.rawValue)
                    } else if self.zPosition == 3 {
                        moveAction = SKAction.move(to: PlayerPosition.middleRight1010, duration: shipSpeedMovement.rawValue)
                    } else {   //zPosition = 5
                        moveAction = SKAction.move(to: PlayerPosition.highRight1095, duration: shipSpeedMovement.rawValue)
                    }
                    let moveAndTurnGroup: SKAction = SKAction.group([moveAction, turnRightAction])
                    moveAndTurnGroup.timingMode = SKActionTimingMode.easeInEaseOut
                    //let moveAction: SKAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.70, y: scene!.size.height * 0.25), duration: 0.2)
                    let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    let actionSequence = SKAction.sequence([/*moveAction*/ moveAndTurnGroup, ancorPointAction])
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                } else if ceil(currentPosition.x) < scene!.size.width * 0.5  {
                    //self.position = CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25)
                    //let moveAction: SKAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25), duration: 0.2)
                    
                    let turnRightAction = SKAction.animate(with: shipTurningRightArray, timePerFrame: 0.06)
                    
                    var moveAction: SKAction
                    
                    /* moveAction = SKAction.move(to: CGPoint(x: scene!.size.width * 0.5, y: scene!.size.height * 0.25), duration: 0.2) */
                    moveAction = SKAction.move(to: PlayerPosition.middleCenter768, duration: shipSpeedMovement.rawValue)
                    let moveAndTurnGroup: SKAction = SKAction.group([moveAction, turnRightAction])
                    moveAndTurnGroup.timingMode = SKActionTimingMode.easeInEaseOut
                    //moveAndTurnGroup.timingFunction = getTimingFunction(curve: <#T##timingFunction#>)
                    
                    let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
                    let actionSequence = SKAction.sequence([/*moveAction*/ moveAndTurnGroup, ancorPointAction])
                    self.run(actionSequence, completion: {
                        self.actionIsActive = false
                    })
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("turnDone4.m4a", waitForCompletion: false))
                    }
                } else {
                    actionIsActive = false
                }
            //print(self.position)
            case .trio: break
                //case .rogueOne: break
                //case .invisible: break
            }
        } else {
            
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
        
        //let cD4 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
        cD5.position = CGPoint(x: -90 /*(self.size.width / 2)*/ , y: ((self.size.height - self.size.height) + 2))
        //cD1.anchorPoint = CGPoint(x: 0, y: 0)
        cD5.name = "cD"
        
        //let cD4 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
        cD6.position = CGPoint(x: 90 /*(self.size.width / 2)*/ , y: ((self.size.height - self.size.height) + 2))
        //cD1.anchorPoint = CGPoint(x: 0, y: 0)
        cD6.name = "cD"
        
        
        
        
        //let cD4 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
        cD7.position = CGPoint(x: -70 /*(self.size.width / 2)*/ , y: ((self.size.height - self.size.height) - 70))
        //cD1.anchorPoint = CGPoint(x: 0, y: 0)
        cD7.name = "cD"
        
        //let cD4 = CollisionDetector(color: UIColor.black, size: CGSize(width: 10, height: 10))
        cD8.position = CGPoint(x: 70 /*(self.size.width / 2)*/ , y: ((self.size.height - self.size.height) - 70))
        //cD1.anchorPoint = CGPoint(x: 0, y: 0)
        cD8.name = "cD"
        
        
        
        
        self.addChild(cD1)
        self.addChild(cD2)
        self.addChild(cD3)
        self.addChild(cD4)
        self.addChild(cD5)
        self.addChild(cD6)
        self.addChild(cD7)
        self.addChild(cD8)
        
        addPhysicsBodyToDetectors(node: cD1)
        addPhysicsBodyToDetectors(node: cD2)
        addPhysicsBodyToDetectors(node: cD3)
        addPhysicsBodyToDetectors(node: cD4)
        addPhysicsBodyToDetectors(node: cD5)
        addPhysicsBodyToDetectors(node: cD6)
        addPhysicsBodyToDetectors(node: cD7)
        addPhysicsBodyToDetectors(node: cD8)
        
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
        node.physicsBody?.contactTestBitMask = BodyType.barrier.rawValue | BodyType.partition.rawValue | BodyType.debris.rawValue
        
    }
    
    deinit {
        print("player deinit")
    }
    
    
}  // class


class CollisionDetector: SKSpriteNode {
    var isInContactWithSomething = false
}

public extension CGFloat {
    mutating func roundTo1Decimal() -> CGFloat {
        return CGFloat(Darwin.round(10 * self) / 10)
    }
}




















