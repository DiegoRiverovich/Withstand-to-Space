//
//  GameScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 19.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BodyType: UInt32 {
    case player = 1
    case barrier = 2
    case cD = 4
    case other = 8
    case partition = 16
}

enum gameState {
    case beforeGame
    case inGame
    case afterGame
}

var score = 0

var currentGameStatus = gameState.inGame


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var levelNumber = 1
    //var livesNumber = 3
    
    var canMove: Bool = false
    
    var ship = PlayerShip()
    var tempShipRouge = PlayerShip()
    
    var partitions = [Partition]()
    
    var coins: Int = 0 {
        didSet {
            coinsLabel.text = String("Coins: \(coins)")
            score = coins
        }
    }
    
    var lostCoins: Int = 3 {
        didSet {
            lostCoinsLabel.text = String("Lives: \(lostCoins)")
        }
    }
    
    var barrierTimer: Timer?
    var partitionTimer: Timer?
    
    let coinsLabel = SKLabelNode(fontNamed: "Helvetica")
    let lostCoinsLabel = SKLabelNode(fontNamed: "Helvetica")
    
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    
    let tapGestureRec = UITapGestureRecognizer()
    
    
    override func didMove(to view: SKView) {

        loadMainScene()
    }

    override func willMove(from view: SKView) {
        removeSwipeGestures()
    }
    
    func loadMainScene() {
        
        self.physicsWorld.contactDelegate = self
        
        canMove = true
        
        ship.mainScene = self
        
        backgroundSetup()
        playerSetup()
        
        setupRecognizers()
        partitions.removeAll()
        
        if canMove {
            //barrierTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameScene.barrierSetup), userInfo: nil, repeats: true)
            partitionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameScene.partitionSetup), userInfo: nil, repeats: true)
        }
        
        // Setup score label
        coinsLabel.text = "Coins: 0"
        coinsLabel.position = CGPoint(x: self.size.width * 0.30, y: self.size.height * 0.95)
        coinsLabel.fontColor = UIColor.white
        coinsLabel.fontSize = 100
        self.addChild(coinsLabel)
        
        // Setup lose label
        lostCoinsLabel.text = "Lives: 3"
        lostCoinsLabel.position = CGPoint(x: self.size.width * 0.70, y: self.size.height * 0.95)
        lostCoinsLabel.fontColor = UIColor.white
        lostCoinsLabel.fontSize = 100
        self.addChild(lostCoinsLabel)
        
        // Set score to zero. New game
        score = 0
        
        
    }
    
    func startNewLevel() {
        
        levelNumber += 1
        
//        if self.action(forKey: "setUpBarrier") != nil {
//            self.removeAction(forKey: "setUpBarrier")
//        }
        
        if barrierTimer != nil {
            barrierTimer?.invalidate()
            barrierTimer = nil
        }
        
        var barrierDuration = TimeInterval()
        var partitionDuration = TimeInterval()
        partitionDuration = 4
        
        switch levelNumber {
        case 1:
            barrierDuration = 2
        case 2:
            barrierDuration = 1.8
        case 3:
            barrierDuration = 1.5
        case 4:
            barrierDuration = 1.3
        case 5:
            barrierDuration = 1
        default:
            barrierDuration = 1.3
            print("cant find level")
        }
        
        if canMove {
            barrierTimer = Timer.scheduledTimer(timeInterval: TimeInterval(barrierDuration), target: self, selector: #selector(GameScene.barrierSetup), userInfo: nil, repeats: true)
            partitionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(partitionDuration), target: self, selector: #selector(GameScene.partitionSetup), userInfo: nil, repeats: true)
        }
        
        
    }
    
    func runGameOver() {
        self.removeAllActions()
        barrierTimer?.invalidate()
        barrierTimer = nil
        
        enumerateChildNodes(withName: "barrier") { (node, _) in
            if node.name == "barrier" {
                node.speed = 0.0
            }
        }
        
//        for recognizer in (self.view?.gestureRecognizers)! {
//            
//        }
        
        self.view?.gestureRecognizers?.removeAll()
        //self.view?.gestureRecognizers = []
        
        currentGameStatus = .afterGame
        
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.moveToGameOverScreen), userInfo: nil, repeats: false)
        
        partitions.removeAll()
    }
    
    @objc func moveToGameOverScreen() {
        
        let scene = GameOverScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        let gameOverTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        view?.presentScene(scene, transition: gameOverTransition)
        
        // Present the scene
        //view?.presentScene(scene)
        if #available(iOS 10.0, *) {
            view?.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
        }
        
        view?.ignoresSiblingOrder = true
        
        view?.showsFPS = true
        view?.showsNodeCount = true
        view?.showsPhysics = true
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var player:  PlayerShip?
        var barrier: Barrier?
        var partition: Partition?
        var contactBodycD: CollisionDetector?
        
        
        // ********** work when player had physics body. Now it has not.
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.barrier.rawValue) {
            player = contact.bodyA.node as? PlayerShip
            barrier = contact.bodyB.node as? Barrier
            //print("touch barrier \(barrier)")
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.barrier.rawValue) {
            player = contact.bodyB.node as? PlayerShip
            barrier = contact.bodyA.node as? Barrier
            //print("touch barrier 2")
        // ********** work when player had physics body. Now it has not.
            
            
        // MARK: Main didbegin contact condition   Player and barrier contact
        } else if (contact.bodyA.categoryBitMask == BodyType.cD.rawValue && contact.bodyB.categoryBitMask == BodyType.barrier.rawValue) {
            player = (contact.bodyA.node)?.parent as? PlayerShip
            barrier = contact.bodyB.node as? Barrier
            //print("touch dot")
            if barrier != nil && player != nil && barrier?.isActive == true {
                detectCollisionOnDifferentZPosition(player: player!, barrier: barrier!)
                
            }
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.barrier.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            barrier = contact.bodyA.node as? Barrier
            //print("touch dot 2")
            if barrier != nil && player != nil && barrier?.isActive == true {
                detectCollisionOnDifferentZPosition(player: player!, barrier: barrier!)
                
            }
        } else {
            //print("bodyB \(contact.bodyB.categoryBitMask), bodyA \(contact.bodyA.categoryBitMask)")
            
        }
        
        // MARK: Player and Partition contact
        if (contact.bodyA.categoryBitMask == BodyType.cD.rawValue && contact.bodyB.categoryBitMask == BodyType.partition.rawValue) {
            player = (contact.bodyA.node)?.parent as? PlayerShip
            partition = contact.bodyB.node as? Partition
            contactBodycD = contact.bodyA.node as? CollisionDetector
            //print("touch dot")
            if partition != nil && player != nil /*&& partition?.isActive == true*/ {
                //detectCollisionOnDifferentZPositionWithPartition(player: player!, partition: partition!)
                beginContactWithPartitionFunction(player: player!,partition: partition!)
                //endContactWithPartitionFunction(partition: partition!)
                //print("didbeg1")
                
                partition?.contactWithShip = true
                contactBodycD?.isInContactWithSomething = true
            }
            //print("didbeg1")
            //beginContactWithPartitionFunction(partition: partition!)
            //endContactWithPartitionFunction(partition: partition!)
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.partition.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            partition = contact.bodyA.node as? Partition
            contactBodycD = contact.bodyB.node as? CollisionDetector
            //print("touch dot 2")
            if partition != nil && player != nil /*&& barrier?.isActive == true*/ {
                //detectCollisionOnDifferentZPositionWithPartition(player: player!, partition: partition!)
                beginContactWithPartitionFunction(player: player!, partition: partition!)
                //endContactWithPartitionFunction(partition: partition!)
                //print("didbeg2")
                partition?.contactWithShip = true
                contactBodycD?.isInContactWithSomething = true
                
            }
            //print("didgeg1")
        } else {
            //print("bodyB \(contact.bodyB.categoryBitMask), bodyA \(contact.bodyA.categoryBitMask)")
            
        }
        
        //print("main begcontact")
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var player:  PlayerShip?
        var barrier: Barrier?
        var partition: Partition?
        var contactBodycD: CollisionDetector?
        
        
        // ********** work when player had physics body. Now it has not.
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.barrier.rawValue) {
            player = contact.bodyA.node as? PlayerShip
            barrier = contact.bodyB.node as? Barrier
            //print("END touch barrier")
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.barrier.rawValue) {
            player = contact.bodyB.node as? PlayerShip
            barrier = contact.bodyA.node as? Barrier
            //print("END touch barrier 2")
        // ********** work when player had physics body. Now it has not.
            
            
        // MARK: Main didbegin contact condition   Player and barrier contact
        } else if (contact.bodyA.categoryBitMask == BodyType.cD.rawValue && contact.bodyB.categoryBitMask == BodyType.barrier.rawValue) {
            player = (contact.bodyA.node)?.parent as? PlayerShip
            barrier = contact.bodyB.node as? Barrier
            //print("END touch barrier")
            if barrier != nil && player != nil && barrier?.isActive == true {
                detectCollisionOnDifferentZPosition(player: player!, barrier: barrier!)
            }
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.barrier.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            barrier = contact.bodyA.node as? Barrier
            //print("END touch barrier 2")
            if barrier != nil && player != nil && barrier?.isActive == true {
                detectCollisionOnDifferentZPosition(player: player!, barrier: barrier!)
            }
        } else {
            //print("bodyB \(contact.bodyB.categoryBitMask), bodyA \(contact.bodyA.categoryBitMask)")
            
        }
        
        
        // MARK: Player and Partition contact
        if (contact.bodyA.categoryBitMask == BodyType.cD.rawValue && contact.bodyB.categoryBitMask == BodyType.partition.rawValue) {
            player = (contact.bodyA.node)?.parent as? PlayerShip
            partition = contact.bodyB.node as? Partition
            contactBodycD = contact.bodyA.node as? CollisionDetector
            //print("touch dot")
            if partition != nil && player != nil /*&& partition?.isActive == true*/ {
                //beginContactWithPartitionFunction(player: player!,partition: partition!)
                //print("didend1")
                
                contactBodycD?.isInContactWithSomething = false
                contactEndedOrNot(player: player!, partition: partition!)
            }
            //print("didend1")
            //beginContactWithPartitionFunction(partition: partition!)
            //endContactWithPartitionFunction(partition: partition!)
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.partition.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            contactBodycD = contact.bodyB.node as? CollisionDetector
            partition = contact.bodyA.node as? Partition
            //print("touch dot 2")
            if partition != nil && player != nil /*&& barrier?.isActive == true*/ {
                //beginContactWithPartitionFunction(player: player!,partition: partition!)
                //print("didend2")
                
                contactBodycD?.isInContactWithSomething = false
                contactEndedOrNot(player: player!, partition: partition!)
            }
            //print("didend1")

        } else {
            //print("bodyB \(contact.bodyB.categoryBitMask), bodyA \(contact.bodyA.categoryBitMask)")
            
        }
        //print("main endcontact")
    }
 
    // MARK: Contact ended or not function
    func contactEndedOrNot(player: PlayerShip, partition: Partition) {
        let allChildren = player.children
        var inContact = false
        for child in allChildren {
            if let cD = child as? CollisionDetector {
                
                if cD.isInContactWithSomething {
                    inContact = true
                } else {
                    if inContact {
                        
                    } else {
                        inContact = false
                        //contactBodycD?.isInContactWithSomething = false
                        
                    }
                }
            }
        }
        
        if inContact {
            
        } else {
            partition.contactWithShip = false
            //contactBodycD?.isInContactWithSomething = false
        }
    }
    
    //   ++++++++++++++++++++++Detecting change zPosition while contacting player detectors and partition
    var beginContactIndex = 0
    var graiter = false
    
    func beginContactWithPartitionFunction(player: PlayerShip, partition: Partition) {
        //print(beginContactIndex)
//        if beginContactIndex == 0 {
//            if player.zPosition > partition.zPosition {
//                graiter = true
//            } else if player.zPosition < partition.zPosition {
//                graiter = false
//            }
//            beginContactIndex += 1
//        } else if beginContactIndex < 8 /*&& beginContactIndex > 0*/ {
//            //var playerNewZposition = player.zPosition
//            if player.zPosition > partition.zPosition {
//                let grtr = true
//                if grtr != graiter {
//                    print("bam mtfkr")
//                    zPositionMatchWithPartition(partition: partition)
//                }
//            } else if player.zPosition < partition.zPosition {
//                let grtr = false
//                if grtr != graiter {
//                    print("bam mtfkr")
//                    zPositionMatchWithPartition(partition: partition)
//                }
//            } else {
//                // do nothigy
//            }
//
//            if beginContactIndex == 3 {
//                beginContactIndex = 0
//            } else {
//                beginContactIndex += 1
//            }
//        } else {
//            // do nothing
//        }

//        if player.zPosition > partition.zPosition && partition.higherThenShip {
//            print("bam1")
//        } else if player.zPosition < partition.zPosition && !partition.higherThenShip {
//            print("bam2")
//        } else {
//
//        }
        
        
//        if partition.contactWithShip == true {
//            var whereShip = ship.zPosition > partition.zPosition
//            if whereShip == partition.higherThenShip {
//                
//            }
//        }
//
//
    }

//    var endContactIndex = 0
//    func endContactWithPartitionFunction(partition: Partition) {
//        if endContactIndex == 0 {
//            if ship.zPosition > partition.zPosition {
//                graiter = true
//            } else if ship.zPosition < partition.zPosition {
//                graiter = false
//            }
//            endContactIndex += 1
//        } else if endContactIndex < 4 && endContactIndex > 0 {
//            if ship.zPosition > partition.zPosition {
//                let grtr = true
//                if grtr != graiter {
//                    print("bam mtfkr")
//                    zPositionMatchWithPartition(partition: partition)
//                }
//            } else if ship.zPosition < partition.zPosition {
//                let grtr = false
//                if grtr != graiter {
//                    print("bam mtfkr")
//                    zPositionMatchWithPartition(partition: partition)
//                }
//            }
//
//            if endContactIndex == 3 {
//                endContactIndex = 0
//            } else {
//                endContactIndex += 1
//            }
//        } else {
//            // do nothing
//        }
//    }
    
    //   ------------------------Detecting change zPosition while contacting player detectors and partition
    
    func detectCollisionOnDifferentZPosition(player: PlayerShip, barrier: Barrier) {
        
        if player.zPosition == barrier.zPosition {
            zPositionMatch(player: player, barrier: barrier)
        } else if player.zPosition > barrier.zPosition {
            //print("missed Player over barrier")
        } else if player.zPosition < barrier.zPosition {
            //print("missed Player unde barrier")
        }
        else {
            //print("Missed bithc!!!")
        }
        
    }
    
    func detectCollisionOnDifferentZPositionWithPartition(player: PlayerShip, partition: Partition) {
        
        if player.zPosition == partition.zPosition {
            //zPositionMatchWithPartition(player: player, partition: partition)
        } else if player.zPosition > partition.zPosition {
            //print("missed Player over barrier")
        } else if player.zPosition < partition.zPosition {
            //print("missed Player unde barrier")
        }
        else {
            //print("Missed bithc!!!")
        }
        
        //zPositionMatchWithPartition(player: player, partition: partition)
        
    }
    
    func zPositionMatchWithPartition(partition: Partition) {
        //print("Bam bitch partition")
        //partition.isActive = false
        //coins += 1
        partition.removeFromParent()
        
        //checkGameScoreForLevels(coins: coins)
    }
    
    func zPositionMatch(player: PlayerShip, barrier: Barrier) {
        print("Bam bitch")
        barrier.isActive = false
        coins += 1
        barrier.removeFromParent()
        
        checkGameScoreForLevels(coins: coins)
    }
    
    func checkGameScoreForLevels(coins: Int) {
        if coins == 10 || coins == 25 || coins == 50 || coins == 75 {
            startNewLevel()
            print("newLevel")
        }
    }
    
    func setupRecognizers() {
        
        if canMove {
            //RIGHT
            swipeRightRec.addTarget(self, action: #selector(GameScene.swipeRight))
            swipeRightRec.direction = .right
            self.view?.addGestureRecognizer(swipeRightRec)
            //LEFT
            swipeLeftRec.addTarget(self, action: #selector(GameScene.swipeLeft))
            swipeLeftRec.direction = .left
            self.view?.addGestureRecognizer(swipeLeftRec)
            //UP
            swipeUpRec.addTarget(self, action: #selector(GameScene.swipeUp))
            swipeUpRec.direction = .up
            self.view?.addGestureRecognizer(swipeUpRec)
            //DOWN
            swipeDownRec.addTarget(self, action: #selector(GameScene.swipeDown))
            swipeDownRec.direction = .down
            self.view?.addGestureRecognizer(swipeDownRec)
            
            //TAP
            tapGestureRec.addTarget(self, action: #selector(GameScene.tapDown))
            tapGestureRec.numberOfTapsRequired = 2
            self.view?.addGestureRecognizer(tapGestureRec)
        }
        
    }
    
    // MARK: Swipes
    
    @objc func swipeRight() {
        if canMove {
            ship.moveRight()
            //print("swipe right")
        }
    }
    
    @objc func swipeLeft() {
        if canMove {
            ship.moveLeft()
            //print("swipe left")
        }
    }
    
    @objc func swipeUp() {
        if canMove {
            
            ship.moveUp()
            partitionAlpha()
            //print("scale up")
        }
    }
    
    @objc func swipeDown() {
        if canMove {
            
            ship.moveDown()
            partitionAlpha()
            //print("scale down")
        }
    }
    
    // MARK: Tap Gesture
    @objc func tapDown() {
        if shipStatus == .noraml {
            shipStatus = .trio
            triggerTrioStatus()
        } else if shipStatus == .trio {
            shipStatus = .rogueOne
            triggerRogueOneStatus()
        } else if shipStatus == .rogueOne {
            shipStatus = .invisible
            triggerInvisibleStatus()
        } else if shipStatus == .invisible {
            shipStatus = .noraml
            triggerNormalStatus()
        }
    }
    
    // MARK: Ship setup
    func playerSetup() {
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
        ship.zPosition = 3
        ship.name = "playerShip"
        self.addChild(ship)
    }
    
    //MARK: Partition setup
    @objc func partitionSetup() {
        let partition = Partition()
        partition.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.20)
        
        self.addChild(partition)
        self.partitions.append(partition)
        
        //partitionAlpha()
        
        let animationDuration: TimeInterval = 6
        
        //var actionArray = [SKAction]()
        let setAlphaToPartition = SKAction.run {
            self.partitionAlpha()
        }
        let moveAction = SKAction.moveTo(y: (partition.size.height * 0) - partition.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        let removeFromPartitionsArray = SKAction.run {
            self.partitions.removeFirst()
        }
        //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([setAlphaToPartition, moveAction, removeFromParent, removeFromPartitionsArray/*, lostCoinsAction*/])
        partition.run(moveSequence, withKey: "setUpPartition")
        
    }
    
    // MARK: alpha partitions
    func partitionAlpha() {
        for partition in partitions {
            if partition.zPosition > ship.zPosition {
                partition.alpha = 0.5
                partition.higherThenShip = true
            } else if partition.zPosition < ship.zPosition {
                partition.alpha = 1.0
                partition.higherThenShip = false
            } else {
                // do nothing
            }
        }
        //playerZposition = ship.zPosition
    }
    
    // MARK: Barrier setup
    @objc func barrierSetup() {
        let barrier = Barrier()
        
        // Set random X position
        let randomXPostion = Int(arc4random()%3)
        switch randomXPostion {
        case 0:
            if barrier.zPosition == 1 {
                barrier.position = CGPoint(x: self.size.width * 0.70 - 170, y: self.size.height * 1.1)
            } else if barrier.zPosition == 3 {
                barrier.position = CGPoint(x: self.size.width * 0.70 - 60, y: self.size.height * 1.1)
            } else if barrier.zPosition == 5 {
                barrier.position = CGPoint(x: self.size.width * 0.70 + 25, y: self.size.height * 1.1)
            }
            //barrier.position = CGPoint(x: self.size.width * 0.30 + 45, y: self.size.height * 1.20)
            
        case 1:
            barrier.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.20)
            
        case 2:
            if barrier.zPosition == 1 {
                barrier.position = CGPoint(x: self.size.width * 0.30 + 170, y: self.size.height * 1.1)
            } else if barrier.zPosition == 3 {
                barrier.position = CGPoint(x: self.size.width * 0.30 + 60, y: self.size.height * 1.1)
            } else if barrier.zPosition == 5  {
                barrier.position = CGPoint(x: self.size.width * 0.30 - 25, y: self.size.height * 1.1)
            }
            //barrier.position = CGPoint(x: self.size.width * 0.70 - 45, y: self.size.height * 1.20)
        default:
            barrier.position = CGPoint(x: self.size.width * 0.60, y: self.size.height * 1.20)
            print("default")
        }
        
        self.addChild(barrier)
        
        
        let animationDuration: TimeInterval = 6
        
        //var actionArray = [SKAction]()
        
        let moveAction = SKAction.moveTo(y: (barrier.size.height * 0) - barrier.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([moveAction, removeFromParent, lostCoinsAction])
        barrier.run(moveSequence, withKey: "setUpBarrier")
        
//        actionArray.append(SKAction.moveTo(y: (barrier.size.height * 0) - barrier.size.height, duration: animationDuration))
//        actionArray.append(SKAction.removeFromParent())
//        barrier.run(SKAction.sequence(actionArray))
    }
    
    // MARK: Background setup
    func backgroundSetup() {

        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    
    // MARK: Remove swipe gestures
    func removeSwipeGestures() {
        for gesture in (self.view?.gestureRecognizers)! {
            if gesture is UISwipeGestureRecognizer {
                self.view?.removeGestureRecognizer(gesture)
            }
        }
    }
    
    // MARK: Lose coins or anemy
    
    func loseCoinsOrAnemy() {
        lostCoins -= 1
        //lostCoins += 1
        
        if lostCoins == 0 {
            runGameOver()
        }
    }
    
    func triggerNormalStatus() {
        
        // disable trio status
        let allShips = self.children
        for trioShip in allShips {
            if trioShip is PlayerShip && trioShip.name == "trioShip" {
                trioShip.removeFromParent()
            }
        }
        
        // disable rougeOne status
        for rougeOne in allShips {
            if rougeOne.name == "playerShip" {
                ship = rougeOne as! PlayerShip
            }
            if rougeOne.name == "rougeOneShip" {
                rougeOne.removeFromParent()
            }
        }
        
        /////////// disable invisible status
        let allDetectors = ship.children
        for cD in allDetectors {
            if cD.name == "cD" {
                cD.physicsBody?.categoryBitMask = BodyType.cD.rawValue
                cD.physicsBody?.collisionBitMask = BodyType.other.rawValue
                cD.physicsBody?.contactTestBitMask = BodyType.barrier.rawValue
                
            }
        }
        
        self.ship.alpha = 1
        /////////// - disable invisible status
        
        self.ship.isHidden = false
    }
    
//    struct PlayerPosition {
//        static let lowLeft620 = CGPoint(x: 620, y: 512)
//        static let lowCenter768 = CGPoint(x: 768, y: 512)
//        static let lowRight925 = CGPoint(x: 925, y: 512)
//        
//        static let middleLeft535 = CGPoint(x: 535, y: 512)
//        static let middleCenter768 = CGPoint(x: 768, y: 512)
//        static let middleRight1010 = CGPoint(x: 1010, y: 512)
//        
//        static let highLeft450 = CGPoint(x: 450, y: 512)
//        static let highCenter768 = CGPoint(x: 768, y: 512)
//        static let highRight1095 = CGPoint(x: 1095, y: 512)
//    }
    
    func triggerTrioStatus() {
        
        for position in 1...3 {
            let trioShip = PlayerShip()
            trioShip.name = "trioShip"
            if ship.zPosition == 1 {
                
                if position == 1 {
                    trioShip.position = PlayerPosition.lowLeft620
                    trioShip.zPosition = 1
                    trioShip.xScale = 0.5
                    trioShip.yScale = 0.5
                    trioShip.centerLeftOrRightPosition = 2
                    self.addChild(trioShip)
                } else if position == 2 {
                    trioShip.position = PlayerPosition.lowCenter768
                    trioShip.zPosition = 1
                    trioShip.xScale = 0.5
                    trioShip.yScale = 0.5
                    trioShip.centerLeftOrRightPosition = 3
                    self.addChild(trioShip)
                } else if position == 3 {
                    trioShip.position = PlayerPosition.lowRight925
                    trioShip.zPosition = 1
                    trioShip.xScale = 0.5
                    trioShip.yScale = 0.5
                    trioShip.centerLeftOrRightPosition = 4
                    self.addChild(trioShip)
                }
                //print("z 2")
                
//                if position == 1 {
//                    trioShip.position = CGPoint(x: self.size.width * 0.30 + 160, y: self.size.height * 0.25)
//                    trioShip.zPosition = 1
//                    trioShip.xScale = 0.5
//                    trioShip.yScale = 0.5
//                    trioShip.centerLeftOrRightPosition = 2
//                    self.addChild(trioShip)
//                } else if position == 2 {
//                    trioShip.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
//                    trioShip.zPosition = 1
//                    trioShip.xScale = 0.5
//                    trioShip.yScale = 0.5
//                    trioShip.centerLeftOrRightPosition = 3
//                    self.addChild(trioShip)
//                } else if position == 3 {
//                    trioShip.position = CGPoint(x: self.size.width * 0.70 - 160, y: self.size.height * 0.25)
//                    trioShip.zPosition = 1
//                    trioShip.xScale = 0.5
//                    trioShip.yScale = 0.5
//                    trioShip.centerLeftOrRightPosition = 4
//                    self.addChild(trioShip)
//                }
//                print("z 2")
            } else if ship.zPosition == 3 {
                
                if position == 1 {
                    trioShip.position = PlayerPosition.middleLeft535
                    trioShip.zPosition = 3
                    trioShip.centerLeftOrRightPosition = 2
                    self.addChild(trioShip)
                    //print("z 3 1")
                } else if position == 2 {
                    trioShip.position = PlayerPosition.middleCenter768
                    trioShip.zPosition = 3
                    trioShip.centerLeftOrRightPosition = 3
                    self.addChild(trioShip)
                    //print("z 3 2")
                } else if position == 3 {
                    trioShip.position = PlayerPosition.middleRight1010
                    trioShip.zPosition = 3
                    trioShip.centerLeftOrRightPosition = 4
                    self.addChild(trioShip)
                    //print("z 3 3")
                }
                //print("z 3")
                
//                if position == 1 {
//                    trioShip.position = CGPoint(x: self.size.width * 0.30 + 65, y: self.size.height * 0.25)
//                    trioShip.zPosition = 3
//                    trioShip.centerLeftOrRightPosition = 2
//                    self.addChild(trioShip)
//                    print("z 3 1")
//                } else if position == 2 {
//                    trioShip.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
//                    trioShip.zPosition = 3
//                    trioShip.centerLeftOrRightPosition = 3
//                    self.addChild(trioShip)
//                    print("z 3 2")
//                } else if position == 3 {
//                    trioShip.position = CGPoint(x: self.size.width * 0.70 - 65, y: self.size.height * 0.25)
//                    trioShip.zPosition = 3
//                    trioShip.centerLeftOrRightPosition = 4
//                    self.addChild(trioShip)
//                    print("z 3 3")
//                }
//                print("z 3")
            } else if ship.zPosition == 4 {
                
                if position == 1 {
                    trioShip.position = PlayerPosition.highLeft450
                    trioShip.zPosition = 5
                    trioShip.xScale = 1.5
                    trioShip.yScale = 1.5
                    trioShip.centerLeftOrRightPosition = 2
                    self.addChild(trioShip)
                } else if position == 2 {
                    trioShip.position = PlayerPosition.highCenter768
                    trioShip.zPosition = 5
                    trioShip.xScale = 1.5
                    trioShip.yScale = 1.5
                    trioShip.centerLeftOrRightPosition = 3
                    self.addChild(trioShip)
                } else if position == 3 {
                    trioShip.position = PlayerPosition.highRight1095
                    trioShip.zPosition = 5
                    trioShip.xScale = 1.5
                    trioShip.yScale = 1.5
                    trioShip.centerLeftOrRightPosition = 4
                    self.addChild(trioShip)
                }
                //print("z 4")
                
//                if position == 1 {
//                    trioShip.position = CGPoint(x: self.size.width * 0.30 - 20, y: self.size.height * 0.25)
//                    trioShip.zPosition = 5
//                    trioShip.xScale = 1.5
//                    trioShip.yScale = 1.5
//                    trioShip.centerLeftOrRightPosition = 2
//                    self.addChild(trioShip)
//                } else if position == 2 {
//                    trioShip.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
//                    trioShip.zPosition = 5
//                    trioShip.xScale = 1.5
//                    trioShip.yScale = 1.5
//                    trioShip.centerLeftOrRightPosition = 3
//                    self.addChild(trioShip)
//                } else if position == 3 {
//                    trioShip.position = CGPoint(x: self.size.width * 0.70 + 20, y: self.size.height * 0.25)
//                    trioShip.zPosition = 5
//                    trioShip.xScale = 1.5
//                    trioShip.yScale = 1.5
//                    trioShip.centerLeftOrRightPosition = 4
//                    self.addChild(trioShip)
//                }
//                //print("z 4")
            } else {
                //print("else")
            }
        }
        //print("end")
        self.ship.isHidden = true
        
    }
    
    func triggerRogueOneStatus() {
        
        let allShips = self.children
        for trioShip in allShips {
            if trioShip is PlayerShip && trioShip.name == "trioShip" {
                trioShip.removeFromParent()
            }
        }
        self.ship.isHidden = false
        
        if ship.zPosition == 1 {
            let rougeOneShip = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "heroRougeOne"))
            //rougeOneShip.name = "rougeOneShip"
            rougeOneShip.zPosition = 3
            rougeOneShip.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
            rougeOneShip.rougeIsActive = false
            self.addChild(rougeOneShip)
        } else if ship.zPosition == 3 {
            let rougeOneShip = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "heroRougeOne"))
            //rougeOneShip.name = "rougeOneShip"
            rougeOneShip.zPosition = 3
            rougeOneShip.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
            rougeOneShip.rougeIsActive = false
            self.addChild(rougeOneShip)
        } else if ship.zPosition == 5 {
            let rougeOneShip = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "heroRougeOne"))
            //rougeOneShip.name = "rougeOneShip"
            rougeOneShip.zPosition = 3
            rougeOneShip.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
            rougeOneShip.rougeIsActive = false
            self.addChild(rougeOneShip)
        } else {
            
        }
        
    }

    
    func triggerInvisibleStatus() {
        
        let allShips = self.children
        
        // disable rougeOne status
        for rougeOne in allShips {
            if rougeOne.name == "playerShip" {
                ship = rougeOne as! PlayerShip
                
            }
            if rougeOne.name == "rougeOneShip" {
                rougeOne.removeFromParent()
            }
        }
        
        // disable physics body from collision detectors
        let allDetectors = ship.children
        for cD in allDetectors {
            if cD.name == "cD" /* || cD.name == "cD2" || cD.name == "cD3" || cD.name == "cD4"*/ {   /*cD is SKSpriteNode &&*/
                cD.physicsBody?.collisionBitMask = 0
                cD.physicsBody?.categoryBitMask = 0
                cD.physicsBody?.contactTestBitMask = 0
                //print("yo")
            }
        }
        
        self.ship.alpha = 0.5
        
        self.ship.isHidden = false
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if let label = self.label {
        //label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        
        
        if shipStatus == .rogueOne {
            
            for touch in touches {
                let pointTouch = touch.location(in: self)
                let allShips = self.children
                for rougeOneShip in allShips {
                    
                    if rougeOneShip is PlayerShip && rougeOneShip.name == "rougeOneShip" {
                        
                        if rougeOneShip.contains(pointTouch) {
                            var rougeOneShipT = rougeOneShip as! PlayerShip
                            
                            if rougeOneShipT.rougeIsActive == true {
                                
                            } else {
                                tempShipRouge = ship
                                tempShipRouge.texture = SKTexture(imageNamed: "heroRougeOne")
                                ship = rougeOneShipT
                                ship.texture = SKTexture(imageNamed: "playerShip")
                                rougeOneShipT = tempShipRouge
                                tempShipRouge.rougeIsActive = false
                                ship.rougeIsActive = true
                            }
                        }
                    } else if rougeOneShip is PlayerShip && rougeOneShip.name == "playerShip" {
                        if rougeOneShip.contains(pointTouch) {
                            var rougeOneShipT = rougeOneShip as! PlayerShip
                            
                            if rougeOneShipT.rougeIsActive == true {
                                
                            } else {
                                tempShipRouge = ship
                                tempShipRouge.texture = SKTexture(imageNamed: "heroRougeOne")
                                ship = rougeOneShipT
                                ship.texture = SKTexture(imageNamed: "playerShip")
                                rougeOneShipT = tempShipRouge
                                tempShipRouge.rougeIsActive = false
                                ship.rougeIsActive = true
                            }
                        }
                    }
                    
                }
                
            
                
            }
            
        }
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
//    
//    override func didMove(to view: SKView) {
//        
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
//    
//    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}
