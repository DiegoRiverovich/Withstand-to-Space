//
//  GameScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 19.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import SpriteKit
import GameplayKit

//let constructionTimeIntervalArray: Array = [2,4,1,1,1,1,1,2,5,7,1,1,1,1,1]   // 15

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var levelNumber = 1
    //var livesNumber = 3
    
    var canMove: Bool = false
    
    var ship = PlayerShip()
    var tempShipRouge = PlayerShip()
    var rougeOneShipGlobal: PlayerShip?
    
    var partitions = [Partition]()
    //var partitionHigherThenTheShip = false
    
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
    var planetTimer: Timer?
    var spacestationTimer: Timer?
    var constructionTimer: Timer?
    
    var constructionTimeInterval = 0
    var constructionBarrierAnimationDuration: TimeInterval = 0
    
    let coinsLabel = SKLabelNode(fontNamed: SomeNames.fontName)     // Helvetica
    let lostCoinsLabel = SKLabelNode(fontNamed: SomeNames.fontName)
    
    // Swige gestures
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    // Tap gesture
    let tapGestureRec = UITapGestureRecognizer()
    
    let trioTimerLabel = SKLabelNode(fontNamed: "Helvetica")
    let invisibleTimerLabel = SKLabelNode(fontNamed: "Helvetica")
    let rougeOneTimerLabel = SKLabelNode(fontNamed: "Helvetica")
    
    var trioTimer = Timer()
    var invisibleTimer = Timer()
    var rougeOneTimer = Timer()
    
    
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
        buttonsSetup()
        planetsSetup()
        spacestationSetup()
        
        setupRecognizers()
        partitions.removeAll()
        
        //let constructionTimeIntervalArray: Array = [2,6,1,1,1,1,1,2,5,7,1,1,1,1,1]   // 15
        
        if canMove {
            //barrierTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameScene.barrierSetup), userInfo: nil, repeats: true)
            partitionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameScene.partitionSetup), userInfo: nil, repeats: true)
            planetTimer = Timer.scheduledTimer(timeInterval: TimeInterval(100), target: self, selector: #selector(GameScene.planetsSetup), userInfo: nil, repeats: true)
            spacestationTimer = Timer.scheduledTimer(timeInterval: TimeInterval(20), target: self, selector: #selector(GameScene.spacestationSetup), userInfo: nil, repeats: true)
            constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
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
        
        
        // Setup shipstatus time TRIO
        trioTimerLabel.text = "0"
        trioTimerLabel.position = CGPoint(x: self.size.width * 0.70, y: self.size.height * 0.64)
        trioTimerLabel.fontColor = UIColor.white
        trioTimerLabel.fontSize = 30
        self.addChild(trioTimerLabel)
        
        // Setup shipstatus time ROUGEONE
        rougeOneTimerLabel.text = "0"
        rougeOneTimerLabel.position = CGPoint(x: self.size.width * 0.70, y: self.size.height * 0.58)
        rougeOneTimerLabel.fontColor = UIColor.white
        rougeOneTimerLabel.fontSize = 30
        self.addChild(rougeOneTimerLabel)
        
        // Setup shipstatus time INVISIBLE
        invisibleTimerLabel.text = "0"
        invisibleTimerLabel.position = CGPoint(x: self.size.width * 0.70, y: self.size.height * 0.52)
        invisibleTimerLabel.fontColor = UIColor.white
        invisibleTimerLabel.fontSize = 30
        self.addChild(invisibleTimerLabel)
        
        // Notification center on blow the ship
        NotificationCenter.default.addObserver(forName: SomeNames.blowTheShip, object: nil, queue: nil) { (notification) in
            self.runGameOver()
        }
        
        // Construction setup
        //constructionSetup()
        addPhysicsBodyToConstruction()
        
        
    }
    
    // MARK: +++++++++++++++++++ Delay function !!!!!
    /*
    func someTime() {
        for (index, element) in constructionTimeIntervalArray.enumerated() {
            delay(Double(element)) {
                if index < 14 {
                    //self.constructionTimeInterval = TimeInterval(element)
                    //self.constructionTimer = Timer.scheduledTimer(timeInterval: self.constructionTimeInterval, target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: true)
                    self.constructionSetup()
                } else if index == 14 {
                    //_ = Timer.scheduledTimer(timeInterval: self.constructionTimeInterval + TimeInterval(2), target: self, selector: #selector(GameScene.runGameOver), userInfo: nil, repeats: false)
                    //self.runGameOver()
                }
            }
        }
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
  */
    
//    let normalStatusButton = SKSpriteNode(imageNamed: "statusNormalN140.png")
//    normalStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.70)
//    normalStatusButton.zPosition = 10
//    normalStatusButton.name = "statusNormalButton"
//    self.addChild(normalStatusButton)
//
//    let trioStatusButton = SKSpriteNode(imageNamed: "statusTrioN140.png")
//    trioStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.64)
//    trioStatusButton.zPosition = 10
//    trioStatusButton.name = "statusTrioButton"
//    self.addChild(trioStatusButton)
//
//    let rougeOneStatusButton = SKSpriteNode(imageNamed: "statusRougeOneN140.png")
//    rougeOneStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.58)
//    rougeOneStatusButton.zPosition = 10
//    rougeOneStatusButton.name = "statusRougeOneButton"
//    self.addChild(rougeOneStatusButton)
//
//    let invisibleStatusButton = SKSpriteNode(imageNamed: "statusInvisibleN140.png")
//    invisibleStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.52)
//    invisibleStatusButton.zPosition = 10
//    invisibleStatusButton.name = "statusInvisibleButton"
//    self.addChild(invisibleStatusButton)
    
    
    
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
            planetTimer = Timer.scheduledTimer(timeInterval: TimeInterval(100), target: self, selector: #selector(GameScene.planetsSetup), userInfo: nil, repeats: true)
            spacestationTimer = Timer.scheduledTimer(timeInterval: TimeInterval(20), target: self, selector: #selector(GameScene.spacestationSetup), userInfo: nil, repeats: true)
            constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: true)
        }
        
        
    }
    
    @objc func runGameOver() {
        self.removeAllActions()
        barrierTimer?.invalidate()
        partitionTimer?.invalidate()
        planetTimer?.invalidate()
        spacestationTimer?.invalidate()
        constructionTimer?.invalidate()
        barrierTimer = nil
        partitionTimer = nil
        planetTimer = nil
        spacestationTimer = nil
        constructionTimer = nil
        
        canMove = false
        
        // stop all barriers
        enumerateChildNodes(withName: "barrier") { (node, _) in
            if node.name == "barrier" {
                node.speed = 0.0
            }
        }
        // stop all partitions
        enumerateChildNodes(withName: "partition") { (node, _) in
            if node.name == "partition" {
                node.speed = 0.0
            }
        }
        // stop backgroupd
        enumerateChildNodes(withName: "BackgroudStars") { (node, _) in
            if node.name == "BackgroudStars" {
                node.speed = 0.0
            }
        }
        // stop coins
        enumerateChildNodes(withName: "coinDebris") { (node, _) in
            if node.name == "coinDebris" {
                node.speed = 0.0
            }
        }
        // stop galaxy
        enumerateChildNodes(withName: "galaxy") { (node, _) in
            if node.name == "galaxy" {
                node.speed = 0.0
            }
        }
        // stop station
        enumerateChildNodes(withName: "station") { (node, _) in
            if node.name == "station" {
                node.speed = 0.0
            }
        }
        // stop construction
        enumerateChildNodes(withName: "constructionDebris") { (node, _) in
            if node.name == "constructionDebris" {
                node.speed = 0.0
            }
        }
        
        //constructionDebris
        
        //coinDebris
        
//        for recognizer in (self.view?.gestureRecognizers)! {
//            
//        }
        
        self.view?.gestureRecognizers?.removeAll()
        //self.view?.gestureRecognizers = []
        
        currentGameStatus = .afterGame
        
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameScene.moveToGameOverScreen), userInfo: nil, repeats: false)
        
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
        
//        view?.ignoresSiblingOrder = true
//        
//        view?.showsFPS = true
//        view?.showsNodeCount = true
//        view?.showsPhysics = true
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var player:  PlayerShip?
        var barrier: Barrier?
        var partition: Partition?
        var contactBodycD: CollisionDetector?
        var debris: Debris?
        
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
            // MARK: Contact with debris
        } else if (contact.bodyA.categoryBitMask == BodyType.cD.rawValue && contact.bodyB.categoryBitMask == BodyType.debris.rawValue) {
            player = (contact.bodyA.node)?.parent as? PlayerShip
            debris = contact.bodyB.node as? Debris
            
            //print("touch dot")
            if debris != nil && player != nil && debris?.isActive == true {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
                
            }
            // MARK: Contact with debris2
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.debris.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            debris = contact.bodyA.node as? Debris
            //print("END touch barrier 5")
            if debris != nil && player != nil && debris?.isActive == true && player?.rougeIsActive == true {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
                //print("END touch barrier 2")
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
                //beginContactWithPartitionFunction(player: player!,partition: partition!)
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
                //beginContactWithPartitionFunction(player: player!, partition: partition!)
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
        var debris: Debris?
        
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
            if barrier != nil && player != nil && barrier?.isActive == true && player?.rougeIsActive == true {
                detectCollisionOnDifferentZPosition(player: player!, barrier: barrier!)
            }
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.barrier.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            barrier = contact.bodyA.node as? Barrier
            //print("END touch barrier 2")
            if barrier != nil && player != nil && barrier?.isActive == true && player?.rougeIsActive == true {
                detectCollisionOnDifferentZPosition(player: player!, barrier: barrier!)
            }
            // MARK: Contact with debris
        } else if (contact.bodyA.categoryBitMask == BodyType.cD.rawValue && contact.bodyB.categoryBitMask == BodyType.debris.rawValue) {
            player = (contact.bodyA.node)?.parent as? PlayerShip
            debris = contact.bodyB.node as? Debris
            
            //print("touch dot")
            if debris != nil && player != nil && debris?.isActive == true {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
            }
            // MARK: Contact with debris2
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.debris.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            debris = contact.bodyA.node as? Debris
            //print("END touch barrier 4")
            if debris != nil && player != nil && debris?.isActive == true && player?.rougeIsActive == true {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
                //print("END touch barrier 3")
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
            if partition != nil && player != nil && player?.rougeIsActive == true /*&& partition?.isActive == true*/ {
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
            if partition != nil && player != nil && player?.rougeIsActive == true /*&& barrier?.isActive == true*/ {
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
    
    func detectCollisionOnDifferentZPositionWithDebris (player: PlayerShip, debris: Debris) {
        if player.zPosition == debris.zPosition {
            zPositionMatchForDebris(player: player, debris: debris)
        } else if player.zPosition > debris.zPosition {
            //print("missed Player over barrier")
        } else if player.zPosition < debris.zPosition {
            //print("missed Player unde barrier")
        }
        else {
            //print("Missed bithc!!!")
        }
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
    
    func zPositionMatchForDebris(player: PlayerShip, debris: Debris) {
        print("Bam Debris bitch")
        debris.isActive = false
        //coins += 1
        debris.removeFromParent()
        
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
            /* tapGestureRec.addTarget(self, action: #selector(GameScene.tapDown))
            tapGestureRec.numberOfTapsRequired = 2
            self.view?.addGestureRecognizer(tapGestureRec) */
        }
        
    }
    
    // MARK: Swipes
    
    @objc func swipeRight() {
        if canMove {
            if ship.rougeIsActive {
                ship.moveRight()
            } else if tempShipRouge.rougeIsActive {
                tempShipRouge.moveRight()
            }
            //print("swipe right")
        }
    }
    
    @objc func swipeLeft() {
        if canMove {
            if ship.rougeIsActive {
                ship.moveLeft()
            } else if tempShipRouge.rougeIsActive {
                tempShipRouge.moveLeft()
            }
            
            //ship.moveLeft()
            //print("swipe left")
        }
    }
    
    @objc func swipeUp() {
        if canMove {
            if ship.rougeIsActive {
                ship.moveUp()
            } else if tempShipRouge.rougeIsActive {
                tempShipRouge.moveUp()
            }
            
            //ship.moveUp()
            partitionAlpha()
            //print("scale up")
        }
    }
    
    @objc func swipeDown() {
        if canMove {
            if ship.rougeIsActive {
                ship.moveDown()
            } else if tempShipRouge.rougeIsActive {
                tempShipRouge.moveDown()
            }
            
            //ship.moveDown()
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
    
    func changeShipStatus() {
        
        let allShips = self.children
        
        switch shipStatus {
        case .noraml:
            print("normal status")
        case .trio:
            
            for trioShip in allShips {
                if trioShip is PlayerShip && trioShip.name == "trioShip" {
                    trioShip.removeFromParent()
                }
            }
            self.ship.isHidden = false
            trioTimer.invalidate()
            shipStatus = .noraml
            
        case .rogueOne:
            
            var playerShip = PlayerShip()
            var rougeOneShip = PlayerShip()
            if let allNodes = scene?.children {
                for ship in allNodes {
                    if let _ship = ship as? PlayerShip {
                        if _ship.name == "playerShip" /*&& _ship.rougeIsActive == true*/  {
                            playerShip = _ship
                        }
                        if _ship.name == "rougeOneShip" /*&& _ship.rougeIsActive == true*/ {
                            rougeOneShip = _ship
                        }
                    }
                }
            }
            
            
            
            if playerShip.rougeIsActive == false {
                
                
                
                
                tempShipRouge = ship
                tempShipRouge.rougeIsActive = false
                ship = playerShip as PlayerShip
                ship.rougeIsActive = true
                tempShipRouge.removeFromParent()
                
                
                
                //ship.rougeIsActive = true
                //tempShipRouge.removeFromParent()
                
                //rougeOne.removeFromParent()
            } else if rougeOneShip.rougeIsActive == false {
                
                rougeOneShip.removeFromParent()
            } /*else if rougeOneShip.rougeIsActive == true {
                //ship = rougeOneT
                rougeOneShip.removeFromParent()
            } */
            
            
//            for rougeOne in allShips {
//                if let rougeOneT = rougeOne as? PlayerShip {
//                    if rougeOneT.name == "playerShip" && rougeOneT.rougeIsActive == false {
//                        ship = rougeOneT as PlayerShip
//                        //ship.rougeIsActive = true
//                        //tempShipRouge.removeFromParent()
//
//                        //rougeOne.removeFromParent()
//                    }
//                    if rougeOneT.name == "rougeOneShip" && rougeOneT.rougeIsActive == false {
//                        rougeOneT.removeFromParent()
//                    } else if rougeOneT.name == "rougeOneShip" && rougeOneT.rougeIsActive == true {
//                        //ship = rougeOneT
//                        rougeOneT.removeFromParent()
//                    }
//                }
//            }
            
            rougeOneTimer.invalidate()
            shipStatus = .noraml
            
        case .invisible:
            
            let allDetectors = ship.children
            for cD in allDetectors {
                if cD.name == "cD" {
                    cD.physicsBody?.categoryBitMask = BodyType.cD.rawValue
                    cD.physicsBody?.collisionBitMask = BodyType.other.rawValue
                    cD.physicsBody?.contactTestBitMask = BodyType.barrier.rawValue | BodyType.partition.rawValue
                    
                }
            }
            self.ship.alpha = 1
            invisibleTimer.invalidate()
            shipStatus = .noraml
            
        }
        
    }
    
    // MARK: Ship setup
    func playerSetup() {
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
        ship.zPosition = 3
        ship.name = "playerShip"
        self.addChild(ship)
        
//        let jetFire = SKEmitterNode(fileNamed: "jetFire.sks")
//        jetFire?.targetNode = ship
//        jetFire?.zPosition = -10
//        //jetFire?.emissionAngle = 180
//        //jetFire?.position = CGPoint(x: ship.position.x, y: (ship.position.y - (ship.size.height / 2)) - 20)
//        self.addChild(jetFire!)
    }
    
    //MARK: Partition setup
    @objc func partitionSetup() {
        let partition = Partition()
        partition.mainScene = self
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
        
        
        //let animationDuration: TimeInterval = 6
        var animationDuration: TimeInterval = 15
        if barrier.zPosition == 1 {
            animationDuration = 14
        } else if barrier.zPosition == 3 {
            animationDuration = 15
        } else if barrier.zPosition == 5 {
            animationDuration = 16.5
        }
        
        
        //var actionArray = [SKAction]()
        
        let moveAction = SKAction.moveTo(y: (barrier.size.height * 0) - barrier.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([moveAction, removeFromParent, lostCoinsAction])
        barrier.run(moveSequence, withKey: "setUpBarrier")
        
    }
    
    
    // MARK: Construction barrier setup
    func constructionBarrierSetup(zPosition: CGFloat, XPosition: CGFloat) {
        let debris = Debris(zPosition: zPosition, XPosition: XPosition)
        debris.mainScene = self
        debris.name = "constructionDebris"
        // Set random X position
        //let randomXPostion = Int(arc4random()%3)
        /*
        switch XPosition {
        case 1:
            if zPosition == 1 {
                debris.position = CGPoint(x: self.size.width * 0.70 - 170, y: self.size.height * 1.2)
                //barrier.xScale -= 0.5
                //barrier.yScale -= 0.5
                //barrier.setScale(0.5)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            } else if zPosition == 3 {
                debris.position = CGPoint(x: self.size.width * 0.70 - 60, y: self.size.height * 1.2)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            } else if zPosition == 5 {
                debris.position = CGPoint(x: self.size.width * 0.70 + 25, y: self.size.height * 1.2)
                //barrier.xScale += 0.5
                //barrier.yScale += 0.5
                //barrier.setScale(1.5)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            }
            //barrier.position = CGPoint(x: self.size.width * 0.30 + 45, y: self.size.height * 1.20)
            
        case 2:
            
            if zPosition == 1 {
                debris.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.2)
                //barrier.xScale -= 0.5
                //barrier.yScale -= 0.5
                //barrier.setScale(0.5)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            } else if zPosition == 3 {
                debris.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.2)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            } else if zPosition == 5 {
                debris.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.2)
                //barrier.xScale += 0.5
                //barrier.yScale += 0.5
                //barrier.setScale(1.5)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            }
            
            //barrier.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.20)
            
        case 3:
            if zPosition == 1 {
                debris.position = CGPoint(x: self.size.width * 0.30 + 170, y: self.size.height * 1.2)
                //barrier.xScale -= 0.5
                //barrier.yScale -= 0.5
                //barrier.setScale(0.5)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            } else if zPosition == 3 {
                debris.position = CGPoint(x: self.size.width * 0.30 + 60, y: self.size.height * 1.2)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            } else if zPosition == 5  {
                debris.position = CGPoint(x: self.size.width * 0.30 - 25, y: self.size.height * 1.2)
                //barrier.xScale += 0.5
                //barrier.yScale += 0.5
                //barrier.setScale(1.5)
                //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
            }
        //barrier.position = CGPoint(x: self.size.width * 0.70 - 45, y: self.size.height * 1.20)
         default:
         debris.position = CGPoint(x: self.size.width * 0.60, y: self.size.height * 1.20)
         print("default")
         }
         */
        //barrier.physicsBody = SKPhysicsBody(texture: barrier.texture!, size: barrier.size)
        var animationDuration: TimeInterval = 15
        self.addChild(debris)
        switch debrisSpeed {
        case .slow:
            if zPosition == 1 {
                animationDuration = 15
            } else if zPosition == 3 {
                animationDuration = 15
            } else if zPosition == 5 {
                animationDuration = 15
            }
        case .middle:
            if zPosition == 1 {
                animationDuration = 10
            } else if zPosition == 3 {
                animationDuration = 10
            } else if zPosition == 5 {
                animationDuration = 10
            }
        case .fast:
            if zPosition == 1 {
                animationDuration = 5
            } else if zPosition == 3 {
                animationDuration = 5
            } else if zPosition == 5 {
                animationDuration = 5
            }
        }
        
        /*
        var animationDuration: TimeInterval = 15
        self.addChild(debris)
        if zPosition == 1 {
            animationDuration = 15
        } else if zPosition == 3 {
            animationDuration = 15
        } else if zPosition == 5 {
            animationDuration = 15
        }
         */
        
        //let animationDuration: TimeInterval = 15
        
        constructionBarrierAnimationDuration = animationDuration
        
        let moveAction = SKAction.moveTo(y: (debris.size.height * 0) - debris.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([moveAction, removeFromParent/*, lostCoinsAction*/])
        debris.run(moveSequence, withKey: "setUpConstruction")
        
        
        
        
    }
    
    // MARK: Coin setup
    func coinSetup(zPosition: CGFloat, XPosition: CGFloat) {
        let barrier = Barrier(zPosition: zPosition, XPosition: XPosition)
        barrier.mainScene = self
        barrier.name = "coinDebris"
        
        var animationDuration: TimeInterval = 15
        self.addChild(barrier)
        
        switch debrisSpeed {
        case .slow:
            if zPosition == 1 {
                animationDuration = 15
            } else if zPosition == 3 {
                animationDuration = 15
            } else if zPosition == 5 {
                animationDuration = 15
            }
        case .middle:
            if zPosition == 1 {
                animationDuration = 10
            } else if zPosition == 3 {
                animationDuration = 10
            } else if zPosition == 5 {
                animationDuration = 10
            }
        case .fast:
            if zPosition == 1 {
                animationDuration = 5
            } else if zPosition == 3 {
                animationDuration = 5
            } else if zPosition == 5 {
                animationDuration = 5
            }
        }
        
        /*
        if zPosition == 1 {
            animationDuration = 15
        } else if zPosition == 3 {
            animationDuration = 15
        } else if zPosition == 5 {
            animationDuration = 15
        }
         */
        
        //let animationDuration: TimeInterval = 15
        
        let moveAction = SKAction.moveTo(y: (barrier.size.height * 0) - barrier.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([moveAction, removeFromParent/*, lostCoinsAction*/])
        barrier.run(moveSequence, withKey: "setUpCoin")
    }
    
    // MARK: Middle barrier setup
    func middleBarrierSetup(zPosition: CGFloat, XPosition: CGFloat) {
        let mBarrier = MiddleBarrier(zPosition: zPosition, XPosition: XPosition)
        mBarrier.mainScene = self
        mBarrier.name = "mBarrier"
        
        var animationDuration: TimeInterval = 15
        self.addChild(mBarrier)
        
        switch debrisSpeed {
        case .slow:
            if zPosition == 1 {
                animationDuration = 15
            } else if zPosition == 3 {
                animationDuration = 15
            } else if zPosition == 5 {
                animationDuration = 15
            }
        case .middle:
            if zPosition == 1 {
                animationDuration = 10
            } else if zPosition == 3 {
                animationDuration = 10
            } else if zPosition == 5 {
                animationDuration = 10
            }
        case .fast:
            if zPosition == 1 {
                animationDuration = 5
            } else if zPosition == 3 {
                animationDuration = 5
            } else if zPosition == 5 {
                animationDuration = 5
            }
        }
        
        /*
        if zPosition == 1 {
            animationDuration = 15
        } else if zPosition == 3 {
            animationDuration = 15
        } else if zPosition == 5 {
            animationDuration = 15
        }
         */
        
        //let animationDuration: TimeInterval = 15
        
        let moveAction = SKAction.moveTo(y: (mBarrier.size.height * 0) - mBarrier.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([moveAction, removeFromParent/*, lostCoinsAction*/])
        mBarrier.run(moveSequence, withKey: "setUpMiddleBarrier")
    }
    
    // ADD physical body to construction
    @objc func addPhysicsBodyToConstruction() {
        let allObjects = self.children
        for constructionDebris in allObjects {
            if constructionDebris.name == "constructionDebris" && constructionDebris.physicsBody == nil {
                let debris = constructionDebris as! Debris
                debris.physicsBody = SKPhysicsBody(texture: debris.texture!, size: debris.size)
                
                
                // Set PhysicsBody. First create PhysicsBody then set properties !!!!
                debris.physicsBody?.isDynamic = true
                debris.physicsBody?.affectedByGravity = false
                debris.physicsBody?.pinned = false
                debris.physicsBody?.allowsRotation = false
                
                // CategoryBitMask, collisionBitMask, contactTestBitMask
                debris.physicsBody?.categoryBitMask = BodyType.barrier.rawValue
                debris.physicsBody?.collisionBitMask = 0
                //        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue
                
                //barrier.name = "constructionBarrier"
            }
        }
        
    }
    
    // MARK: Background setup
    func backgroundSetup() {
        /*
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
     */
        
        for i in 0...1 {
            let backgroundStars = SKSpriteNode(imageNamed: "backgroundStars")
            backgroundStars.size = self.size
            backgroundStars.anchorPoint = CGPoint(x: 0.5, y: 0)
            backgroundStars.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
            backgroundStars.zPosition = -100
            backgroundStars.name = "BackgroudStars"
            self.addChild(backgroundStars)
        }
        
        for i in 0...1 {
            let backgroundPngStars = SKSpriteNode(imageNamed: "backgroundPngStars")
            backgroundPngStars.size = self.size
            backgroundPngStars.anchorPoint = CGPoint(x: 0.5, y: 0)
            backgroundPngStars.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
            backgroundPngStars.zPosition = -99
            backgroundPngStars.name = "BackgroundPngStars"
            self.addChild(backgroundPngStars)
        }
    }
    
    // MARK: Setup Buttons
    func buttonsSetup() {
        
        let normalStatusButton = SKSpriteNode(imageNamed: "statusNormalN140.png")
        normalStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.70)
        normalStatusButton.zPosition = 10
        normalStatusButton.name = "statusNormalButton"
        self.addChild(normalStatusButton)
        
        let trioStatusButton = SKSpriteNode(imageNamed: "statusTrioN140.png")
        trioStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.64)
        trioStatusButton.zPosition = 10
        trioStatusButton.name = "statusTrioButton"
        self.addChild(trioStatusButton)
        
        let rougeOneStatusButton = SKSpriteNode(imageNamed: "statusRougeOneN140.png")
        rougeOneStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.58)
        rougeOneStatusButton.zPosition = 10
        rougeOneStatusButton.name = "statusRougeOneButton"
        self.addChild(rougeOneStatusButton)
        
        let invisibleStatusButton = SKSpriteNode(imageNamed: "statusInvisibleN140.png")
        invisibleStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.52)
        invisibleStatusButton.zPosition = 10
        invisibleStatusButton.name = "statusInvisibleButton"
        self.addChild(invisibleStatusButton)
    }
    
    // MARK: Planetes setup
    @objc func planetsSetup() {
        //let planetObject = Planet(texture: SKTexture(imageNamed: "venus"))
        let planetObject = Planet()
        //planetObject.position = CGPoint(x: self.size.width * 0.20, y: self.size.height * 1.30)
        planetObject.position.y = self.size.height * 1.30
        planetObject.zPosition = -20
        planetObject.name = "galaxy"
        self.addChild(planetObject)
        
        
        let animationDuration: TimeInterval = 100
        let moveAction = SKAction.moveTo(y: (planetObject.size.height * 0) - planetObject.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([moveAction, removeFromParent/*, lostCoinsAction*/])
        planetObject.run(moveSequence, withKey: "setUpPlanet")
    }
    
    // MARK: StationSet up
    @objc func spacestationSetup() {
        //let planetObject = Planet(texture: SKTexture(imageNamed: "venus"))
        let spacestation = SpaceStation()
        //planetObject.position = CGPoint(x: self.size.width * 0.20, y: self.size.height * 1.30)
        //spacestation.position.y = self.size.height * 0.50
        spacestation.zPosition = -10
        spacestation.name = "station"
        self.addChild(spacestation)
        
        
        let animationDuration: TimeInterval = 10
        //let moveAction = SKAction.moveTo(y: 500, duration: animationDuration)
        let nmoveAction = SKAction.move(to: spacestation.rundomToPosition() /*CGPoint(x: 1500, y: 712)*/, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([nmoveAction, removeFromParent/*, lostCoinsAction*/])
        spacestation.run(moveSequence, withKey: "setUpStation")
    }
    
    // MAKR: Construction setup
    var nextRow = 0
    @objc func constructionSetup() {
        let construction = levels[level]
        //for row in construction {
        let row = construction[nextRow]
        for (index, element) in row.enumerated() {
            //print("\(index)  \(element)")
            switch index {
            case 0:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 1, XPosition: 3)
                } else if element == 2 {
                    coinSetup(zPosition: 1, XPosition: 3)
                } else if element == 4 {
                    //middleBarrierSetup(zPosition: <#T##CGFloat#>, XPosition: <#T##CGFloat#>)
                }
            case 1:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 1, XPosition: 2)
                } else if element == 2 {
                    coinSetup(zPosition: 1, XPosition: 2)
                } else if element == 4 {
                    middleBarrierSetup(zPosition: 1, XPosition: 1)
                }
            case 2:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 1, XPosition: 2)
                } else if element == 2 {
                    coinSetup(zPosition: 1, XPosition: 2)
                } else if element == 4 {
                    
                }
            case 3:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 3, XPosition: 3)
                } else if element == 2 {
                    coinSetup(zPosition: 3, XPosition: 3)
                } else if element == 4 {
                    middleBarrierSetup(zPosition: 1, XPosition: 2)
                }
            case 4:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 1, XPosition: 1)
                } else if element == 2 {
                    coinSetup(zPosition: 1, XPosition: 1)
                } else if element == 4 {
                    
                }
            case 5:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 3, XPosition: 3)
                } else if element == 2 {
                    coinSetup(zPosition: 3, XPosition: 3)
                } else if element == 4 {
                    
                }
            case 6:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 5, XPosition: 3)
                } else if element == 2 {
                    coinSetup(zPosition: 5, XPosition: 3)
                } else if element == 4 {
                    middleBarrierSetup(zPosition: 3, XPosition: 1)
                }
            case 7:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 3, XPosition: 2)
                } else if element == 2 {
                    coinSetup(zPosition: 3, XPosition: 2)
                } else if element == 4 {
                    
                }
            case 8:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 5, XPosition: 1)
                } else if element == 2 {
                    coinSetup(zPosition: 5, XPosition: 1)
                } else if element == 4 {
                    middleBarrierSetup(zPosition: 3, XPosition: 2)
                }
            case 9:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 3, XPosition: 1)
                } else if element == 2 {
                    coinSetup(zPosition: 3, XPosition: 1)
                } else if element == 4 {
                    
                }
                
            case 10:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 5, XPosition: 3)
                } else if element == 2 {
                    coinSetup(zPosition: 5, XPosition: 3)
                } else if element == 4 {
                    
                }
                
            case 11:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 5, XPosition: 1)
                } else if element == 2 {
                    coinSetup(zPosition: 5, XPosition: 1)
                } else if element == 4 {
                    middleBarrierSetup(zPosition: 5, XPosition: 1)
                }
                
            case 12:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 5, XPosition: 2)
                } else if element == 2 {
                    coinSetup(zPosition: 5, XPosition: 2)
                } else if element == 4 {
                    
                }
                
            case 13:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 5, XPosition: 1)
                } else if element == 2 {
                    coinSetup(zPosition: 5, XPosition: 1)
                } else if element == 4 {
                    middleBarrierSetup(zPosition: 5, XPosition: 2)
                    //constructionBarrierSetup(zPosition: 5, XPosition: 2)
                }
                
            case 14:
                if element == 0 {
                    
                } else if element == 1 {
                    constructionBarrierSetup(zPosition: 5, XPosition: 1)
                } else if element == 2 {
                    coinSetup(zPosition: 5, XPosition: 1)
                } else if element == 4 {
                    
                }
                
            default: break
            }
            
        }
        nextRow += 1
        constructionDelay()
        
    }
    
    // MARK: Construction delay
    func constructionDelay() {
        constructionTimer?.invalidate()
        constructionTimeInterval += 1
        if constructionTimeInterval < 14 {
            constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimeIntervalArray[level][constructionTimeInterval]), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
        } else if constructionTimeInterval == 14 {
            constructionTimer = Timer.scheduledTimer(timeInterval: constructionBarrierAnimationDuration /*TimeInterval(constructionTimeIntervalArray[constructionTimeInterval]*/, target: self, selector: #selector(GameScene.runGameOver), userInfo: nil, repeats: false)
            //runGameOver()
        }
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
        
        //switch shipStatus {
        //case:
        // disable trio status
        /*
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
                cD.physicsBody?.contactTestBitMask = BodyType.barrier.rawValue | BodyType.partition.rawValue
                
            }
        }
        
        self.ship.alpha = 1
        /////////// - disable invisible status
        
        self.ship.isHidden = false
         */
        
        shipStatus = .noraml
            
        //switch }
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
            } else if ship.zPosition == 5 {
                
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
        
        trioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.trioCounter), userInfo: nil, repeats: true)
        
        shipStatus = .trio
        
    }
    
    @objc func trioCounter() {
        ship.trioTimeActive -= 1
        trioTimerLabel.text = String(ship.trioTimeActive)
        if (ship.trioTimeActive == 0) {
            trioTimer.invalidate()
        }
    }
    
    func triggerRogueOneStatus() {
        /*
        let allShips = self.children
        for trioShip in allShips {
            if trioShip is PlayerShip && trioShip.name == "trioShip" {
                trioShip.removeFromParent()
            }
        }
        self.ship.isHidden = false
         */
        
        if ship.zPosition == 1 {
            rougeOneShipGlobal = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "heroRougeOne"))
            //rougeOneShip.name = "rougeOneShip"
            rougeOneShipGlobal?.zPosition = 3
            rougeOneShipGlobal?.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
            rougeOneShipGlobal?.rougeIsActive = false
            self.addChild(rougeOneShipGlobal!)
        } else if ship.zPosition == 3 {
            rougeOneShipGlobal = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "heroRougeOne"))
            //rougeOneShip.name = "rougeOneShip"
            rougeOneShipGlobal?.zPosition = 3
            rougeOneShipGlobal?.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
            rougeOneShipGlobal?.rougeIsActive = false
            self.addChild(rougeOneShipGlobal!)
        } else if ship.zPosition == 5 {
            rougeOneShipGlobal = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "heroRougeOne"))
            //rougeOneShip.name = "rougeOneShip"
            rougeOneShipGlobal?.zPosition = 3
            rougeOneShipGlobal?.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
            rougeOneShipGlobal?.rougeIsActive = false
            self.addChild(rougeOneShipGlobal!)
        } else {
            
        }
        rougeOneTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.rougeOneCounter), userInfo: nil, repeats: true)
        shipStatus = .rogueOne
    }

    @objc func rougeOneCounter() {
        ship.rougeOneTimeActive -= 1
        rougeOneTimerLabel.text = String(ship.rougeOneTimeActive)
        if (ship.rougeOneTimeActive == 0) {
            rougeOneTimer.invalidate()
        }
    }
    
    func triggerInvisibleStatus() {
        /*
        let allShips = self.children
        
        // disable rougeOne status
        for rougeOneShip in allShips {
            if rougeOneShip.name == "playerShip" {
                ship = rougeOneShip as! PlayerShip
                
            }
            if rougeOneShip.name == "rougeOneShip" {
                rougeOneShip.removeFromParent()
            }
        }
        */
        
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
        
        invisibleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.invisibleCounter), userInfo: nil, repeats: true)
        shipStatus = .invisible
    }
    
    @objc func invisibleCounter() {
        ship.InvisibleTimeActive -= 1
        invisibleTimerLabel.text = String(ship.InvisibleTimeActive)
        if (ship.InvisibleTimeActive == 0) {
            invisibleTimer.invalidate()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if let label = self.label {
        //label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        
        var playerShip = PlayerShip()
        var rougeOneShip = PlayerShip()
        
        if let allNodes = scene?.children {
            for ship in allNodes {
                if let _ship = ship as? PlayerShip {
                    if _ship.name == "playerShip" /*&& _ship.rougeIsActive == true*/  {
                        playerShip = _ship
                    }
                    if _ship.name == "rougeOneShip" /*&& _ship.rougeIsActive == true*/ {
                        rougeOneShip = _ship
                    }
                }
            }
        }
        
        
        for touch in touches {
            let pointTouch = touch.location(in: self)
            if shipStatus == .rogueOne {
                
                if rougeOneShip.contains(pointTouch) {
                    let rougeOneShipT = rougeOneShip as PlayerShip
                    
                    if rougeOneShipT.rougeIsActive == true {
                        
                    } else {
                        tempShipRouge = ship
                        //tempShipRouge.texture = SKTexture(imageNamed: "heroRougeOne")
                        ship = rougeOneShipT
                        rougeOneShipGlobal = tempShipRouge
                        //ship.texture = SKTexture(imageNamed: "ship10001")
                        //rougeOneShipT = tempShipRouge
                        tempShipRouge.rougeIsActive = false
                        ship.rougeIsActive = true
                    }
                    
                }
                if playerShip.contains(pointTouch) {
                    let playerShipT = playerShip as PlayerShip
                    
                    if playerShipT.rougeIsActive == true {
                        
                    } else {
                        tempShipRouge = ship
                        ship = playerShipT
                        rougeOneShipGlobal = tempShipRouge
                        //tempShipRouge = rougeOneShipT
                        
                        
                        //tempShipRouge = ship
                        //tempShipRouge.texture = SKTexture(imageNamed: "heroRougeOne")
                        //ship = rougeOneShipT
                        //ship.texture = SKTexture(imageNamed: "ship10001")
                        //rougeOneShipT = tempShipRouge
                        tempShipRouge.rougeIsActive = false
                        ship.rougeIsActive = true
                    }
                }
            }
            
            // MARK: Changing status by button USAGE
            let buttons = self.children
            
            for button in buttons {
                if button.name == SomeNames.invisibleStatusButton || button.name == SomeNames.normalStatusButton || button.name == SomeNames.trioStatusButton || button.name == SomeNames.rougeOneStatusButton {
                    touchButtonsChangeStatus(button: button, pointTouch: pointTouch)
                }
            }
            
            
        }
    
    }
        
        
//        for touch in touches {
//
//            let pointTouch = touch.location(in: self)
//            let allShips = self.children
//
//            for rougeOneShip in allShips {
//
//                if shipStatus == .rogueOne {
//
//                    if rougeOneShip is PlayerShip && rougeOneShip.name == "rougeOneShip" {
//
//                        if rougeOneShip.contains(pointTouch) {
//                            let rougeOneShipT = rougeOneShip as! PlayerShip
//
//                            if rougeOneShipT.rougeIsActive == true {
//
//                            } else {
//                                tempShipRouge = ship
//                                //tempShipRouge.texture = SKTexture(imageNamed: "heroRougeOne")
//                                ship = rougeOneShipT
//                                //ship.texture = SKTexture(imageNamed: "ship10001")
//                                //rougeOneShipT = tempShipRouge
//                                tempShipRouge.rougeIsActive = false
//                                ship.rougeIsActive = true
//                            }
//                        }
//                    } else if rougeOneShip is PlayerShip && rougeOneShip.name == "playerShip" {
//                        if rougeOneShip.contains(pointTouch) {
//                            let rougeOneShipT = rougeOneShip as! PlayerShip
//
//                            if rougeOneShipT.rougeIsActive == true {
//
//                            } else {
//                                tempShipRouge = ship
//                                ship = rougeOneShipT
//                                //tempShipRouge = rougeOneShipT
//
//
//                                   //tempShipRouge = ship
//                                //tempShipRouge.texture = SKTexture(imageNamed: "heroRougeOne")
//                                   //ship = rougeOneShipT
//                                //ship.texture = SKTexture(imageNamed: "ship10001")
//                                //rougeOneShipT = tempShipRouge
//                                tempShipRouge.rougeIsActive = false
//                                ship.rougeIsActive = true
//                            }
//                        }
//                    }
//                }
//
//                // MARK: Changing status by button USAGE
//                touchButtonsChangeStatus(button: rougeOneShip, pointTouch: pointTouch)
//
//            }
//
//
//        }
    //}
    
    // MARK: Changing status by button FUNCTION
    func touchButtonsChangeStatus(button: SKNode, pointTouch: CGPoint) {
        if button.name == "statusNormalButton" {
            if button.contains(pointTouch) {
                changeShipStatus()
                triggerNormalStatus()
                print("normal")
            }
        } else if button.name == "statusTrioButton" {
            if button.contains(pointTouch) {
                changeShipStatus()
                triggerTrioStatus()
                print("trio")
            }
        } else if button.name == "statusRougeOneButton" {
            if button.contains(pointTouch) {
                changeShipStatus()
                triggerRogueOneStatus()
                print("rouge")
            }
        } else if button.name == "statusInvisibleButton" {
            if button.contains(pointTouch) {
                changeShipStatus()
                triggerInvisibleStatus()
                print("invisible")
            }
        }
    }
    
    // MARK: moving backgroup variables
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 20.0
    var amountToMovePerSecondPNG: CGFloat = 40.0
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        // MARK: ++++++++++++++++++ moving backgroup
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
       
        
        self.enumerateChildNodes(withName: "BackgroudStars") { (background, stop) in
            
            if self.canMove {
                background.position.y -= amountToMoveBackground
                
                if background.position.y < -self.size.height {
                    background.position.y += self.size.height * 2
                }
            }
        }
        // ------------------------- moving backgroup
        
        // MARK: ++++++++++++++++++ moving backgroup PNG
        
        let amountToMoveBackgroundPNG = amountToMovePerSecondPNG * CGFloat(deltaFrameTime)
        
        
        self.enumerateChildNodes(withName: "BackgroundPngStars") { (background, stop) in
            
            if self.canMove {
                background.position.y -= amountToMoveBackgroundPNG
                
                if background.position.y < -self.size.height {
                    background.position.y += self.size.height * 2
                }
            }
        }
        // ------------------------- moving backgroup PNG
        
    }
    
    func explosion(pos: CGPoint) {
        if let explosion = SKEmitterNode(fileNamed: "explosion.sks") {
            explosion.particlePosition = pos
            scene?.addChild(explosion)
            scene?.run(SKAction.wait(forDuration: TimeInterval(2)), completion: { explosion.removeFromParent() } )
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
