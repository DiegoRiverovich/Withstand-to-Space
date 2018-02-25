//
//  LevelsScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 15.10.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit
import NVActivityIndicatorView

class LevelsScene: SKScene {
    
    private var newActivityIndicator: NVActivityIndicatorView?
    
    private let levelsLabelNode = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    //var levelTenButtonPosition: CGPoint?
    @objc private  var distortTimer: Timer?
    private var levelTenDistortButton: SKSpriteNode?
    
    // Swige gestures
    private let swipeRightRecLvl = UISwipeGestureRecognizer()
    private let swipeLeftRecLvl = UISwipeGestureRecognizer()
    
    private var stars1LvlArray = [SKSpriteNode]()
    private var stars2LvlArray = [SKSpriteNode]()
    private var stars3LvlArray = [SKSpriteNode]()
    
    private var buttons1LvlArray = [SKSpriteNode]()
    private var buttons2LvlArray = [SKSpriteNode]()
    private var buttons3LvlArray = [SKSpriteNode]()
    
    private let arrowLeft = SKSpriteNode(imageNamed: "lvlsArrowLeft")
    private let arrowRight = SKSpriteNode(imageNamed: "lvlsArrowRight")
    
    private let dotLeft = SKSpriteNode(imageNamed: "lvlMenuDot")
    private let dotLeft1 = SKSpriteNode(imageNamed: "lvlMenuDot")
    private let dotCenter = SKSpriteNode(imageNamed: "lvlMenuDot")
    private let dotRight1 = SKSpriteNode(imageNamed: "lvlMenuDot")
    private let dotRight = SKSpriteNode(imageNamed: "lvlMenuDot")
    
    private let backgroundPlanet = SKSpriteNode(imageNamed: "planet01_400")
    private let backgroundPlanet2 = SKSpriteNode(imageNamed: "venus_500")
    private let backgroundPlanet3 = SKSpriteNode(imageNamed: "planet_31")
    private let backgroundPlanet4 = SKSpriteNode(imageNamed: "planet_411")
    private let backgroundAsteroid5 = SKSpriteNode(imageNamed: "Asteroids")
    
    private var comingSoonNode = SKSpriteNode(imageNamed: "comingSoonLogo")
    private var infinityNode = SKSpriteNode(imageNamed: "Infinity")
    
    private let movingBackground = SKSpriteNode(imageNamed: "backgroundPngStars2")
    
    override func didMove(to view: SKView) {
        loadMainScene()
    }
    
    //var scrollViewVar: UIScrollView?
    
    private func loadMainScene() {
        changePlanetOnFourAndFive()
        
        backgroundSetup()
        levelButtonsSetup()
        level2ButtonsSetup()
        level3ButtonsSetup()
        //levelsLabel()
        levelsLabelSetup()
        scoreLableSetup()
        
        backToMenuButtonsSetup()
        setupRecognizers()
        
        lvlsPage = 1
        
        
        //print(lvlsPage)
        
        addArrosAndDots()
        
        backgroundPlanetSetup()
        movingBackgroundSetup()
        
        comingSoonFunc()
        infinityFunc()
        
        pageSetup()
        
        
        distortTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(LevelsScene.levelButtonDistortNew), userInfo: nil, repeats: false)
    }
    
    private func startNewAcitivityIndicator() {
        if let viewLoc = view {
            newActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: (viewLoc.center.x - 50), y: (viewLoc.center.y - 50), width: 100, height: 100),
                                                           type: .ballTrianglePath,
                                                           color: UIColor.white,
                                                           padding: nil)
        } else {
            newActivityIndicator?.center = CGPoint(x: 700, y: 900)
        }
        //newActivityIndicator.
        //myActivityIndicator.hidesWhenStopped = true
        newActivityIndicator?.startAnimating()
        //scene!.view?.addSubview(newActivityIndicator!)
        
        DispatchQueue.main.async { [weak self] in
            self?.scene!.view?.addSubview(self!.newActivityIndicator!)

        }
    }
    
    private func stopNewAcitvityIndicator() {
        newActivityIndicator?.stopAnimating()
        newActivityIndicator?.removeFromSuperview()
    }
    
    //MARK: func button distort
    @objc private func levelButtonDistortNew() {
        let animationAction = SKAction.animate(with: [SKTexture(imageNamed: "lvl10beige1Dist1"), SKTexture(imageNamed: "lvl10beige1")], timePerFrame: 0.3)
        let waitAction = SKAction.wait(forDuration: TimeInterval(2))
        let sequence = SKAction.sequence([animationAction, waitAction])
        levelTenDistortButton?.run(SKAction.repeatForever(sequence))
    }
    
    // MARK: Levels planets page setup
    private func pageSetup() {
        if planet == 1 {
            
        } else if planet == 2 {
            for i in 1...buttons2LvlArray.count {
                let button = buttons2LvlArray[i-1]
                button.position.x = button.position.x - 100
                if active2Level[i-1] == 1 {
                    button.alpha = 1.0
                } else {
                    button.alpha = 0.5
                }
                //button.alpha = 1.0
            }
            for i in 1...buttons1LvlArray.count {
                let button = buttons1LvlArray[i-1]
                button.position.x = button.position.x - 100
                button.alpha = 0.0
            }
            
            lvlsPage = 2
            
            if !stars1LvlArray.isEmpty {
                for i in 1...stars1LvlArray.count {
                    let stars = stars1LvlArray[i-1]
                    stars.alpha = 0.0
                }
            }
            if !stars2LvlArray.isEmpty {
                for i in 1...stars2LvlArray.count {
                    let stars = stars2LvlArray[i-1]
                    stars.alpha = 1.0
                }
            }
            
            enumerateChildNodes(withName: "score1LvlLabel") { (node, _) in
                node.alpha = 0.0
                
            }
            
            enumerateChildNodes(withName: "score2LvlLabel") { (node, _) in
                node.alpha = 1.0
                
            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 1.0
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 1.0
            dotCenter.alpha = 0.5
            dotRight.alpha = 0.5
            dotRight1.alpha = 0.5
            
            backgroundPlanet.position = CGPoint(x: self.size.width * (-3), y: self.size.height * 1)
            backgroundPlanet2.position = CGPoint(x: self.size.width/2, y: self.size.height * (-0.1))
            backgroundPlanet2.alpha = 1.0
            
            movingBackground.position.x = movingBackground.position.x - 100
            
        } else if planet == 3 {
            
            for i in 1...buttons3LvlArray.count {
                let button = buttons3LvlArray[i-1]
                button.position.x = button.position.x - 100
                if active3Level[i-1] == 1 {
                    button.alpha = 1.0
                } else {
                    button.alpha = 0.5
                }
                //button.alpha = 1.0
            }
            
            for i in 1...buttons2LvlArray.count {
                let button = buttons2LvlArray[i-1]
                button.position.x = button.position.x - 200
                button.alpha = 0.0
            }
            for i in 1...buttons1LvlArray.count {
                let button = buttons1LvlArray[i-1]
                button.position.x = button.position.x - 100
                button.alpha = 0.0
            }
            
            lvlsPage = 3
            
            if !stars1LvlArray.isEmpty {
                for i in 1...stars1LvlArray.count {
                    let stars = stars1LvlArray[i-1]
                    stars.alpha = 0.0
                }
            }
            if !stars2LvlArray.isEmpty {
                for i in 1...stars2LvlArray.count {
                    let stars = stars2LvlArray[i-1]
                    stars.alpha = 0.0
                }
            }
            if !stars3LvlArray.isEmpty {
                for i in 1...stars3LvlArray.count {
                    let stars = stars3LvlArray[i-1]
                    stars.alpha = 1.0
                }
            }
            
            enumerateChildNodes(withName: "score1LvlLabel") { (node, _) in
                node.alpha = 0.0
                
            }
            
            enumerateChildNodes(withName: "score2LvlLabel") { (node, _) in
                node.alpha = 0.0
                
            }
            
            enumerateChildNodes(withName: "score3LvlLabel") { (node, _) in
                node.alpha = 1.0
                
            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 1.0
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 0.5
            dotCenter.alpha = 1.0
            dotRight.alpha = 0.5
            dotRight1.alpha = 0.5
            
            backgroundPlanet.position = CGPoint(x: self.size.width * (-3), y: self.size.height * 1)
            backgroundPlanet2.position = CGPoint(x: self.size.width * (-3), y: self.size.height * (-0.1))
            backgroundPlanet2.alpha = 1.0
            
            backgroundPlanet3.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * (0.8))
            backgroundPlanet3.alpha = 1.0
            
            movingBackground.position.x = movingBackground.position.x - 200
            
        } else if planet == 4 {
            
        } else if planet == 5 {
            
        } else {
            // do nothingy
        }
        
    }
    
    // MARK: Coming soon setup
    private func comingSoonFunc() {
        if preferredLanguage == .ru {
            comingSoonNode = SKSpriteNode(imageNamed: "comingSoonLogoRU")
        } else if preferredLanguage == .ch {
            comingSoonNode = SKSpriteNode(imageNamed: "comingSoonLogoCH")
        } else if preferredLanguage == .es {
            comingSoonNode = SKSpriteNode(imageNamed: "comingSoonLogoSP")
        } else {
            comingSoonNode = SKSpriteNode(imageNamed: "comingSoonLogo")
        }
        
        comingSoonNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        comingSoonNode.zRotation = CGFloat(Double.pi / 9)
        comingSoonNode.zPosition = 100
        comingSoonNode.xScale = 1.5
        comingSoonNode.yScale = 1.5
        comingSoonNode.alpha = 0.0
        self.addChild(comingSoonNode)
    }
    
    // MARK: Infinity label
    private func infinityFunc() {
        if preferredLanguage == .ru {
            infinityNode = SKSpriteNode(imageNamed: "InfinityRU")
        } else if preferredLanguage == .ch {
            infinityNode = SKSpriteNode(imageNamed: "InfinityCH")
        } else if preferredLanguage == .es {
            infinityNode = SKSpriteNode(imageNamed: "InfinitySP")
        } else {
            infinityNode = SKSpriteNode(imageNamed: "Infinity")
        }
        
        infinityNode.position = CGPoint(x: self.size.width * 2, y: self.size.height / 2)
        //infinityNode.zRotation = CGFloat(Double.pi / 9)
        infinityNode.zPosition = 100
        infinityNode.name = "suvivalMode"
        //infinityNode.zRotation = CGFloat(Double.pi / 6)
        //infinityNode.xScale = 1.5
        //infinityNode.yScale = 1.5
        infinityNode.alpha = 0.0
        self.addChild(infinityNode)
    }
    
    // MARK: Moving background
    private func movingBackgroundSetup() {
        //let backgroundPlanet = SKSpriteNode(imageNamed: "planet01_900")
        //backgroundPlanet.size = self.size
        movingBackground.position = CGPoint(x: self.size.width / 5, y: self.size.height / 2)
        movingBackground.zRotation = CGFloat(Double.pi / 2)
        movingBackground.zPosition = -101
        movingBackground.xScale = 1.4
        movingBackground.yScale = 1.4
        self.addChild(movingBackground)
        
    }
    
    // MARK: Planet on backbround
    private func backgroundPlanetSetup() {
        //let backgroundPlanet = SKSpriteNode(imageNamed: "planet01_900")
        //backgroundPlanet.size = self.size
        backgroundPlanet.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
        backgroundPlanet.zPosition = -100
        backgroundPlanet.xScale = 2.0
        backgroundPlanet.yScale = 2.0
        self.addChild(backgroundPlanet)
        
        //let backgroundPlanet2 = SKSpriteNode(imageNamed: "venus")
        //backgroundPlanet.size = self.size
        backgroundPlanet2.position = CGPoint(x: self.size.width * 3, y: self.size.height * (-0.3))
        backgroundPlanet2.zPosition = -100
        backgroundPlanet2.alpha = 0.0
        backgroundPlanet2.xScale = 3.0
        backgroundPlanet2.yScale = 3.0
        self.addChild(backgroundPlanet2)
        
        backgroundPlanet3.position = CGPoint(x: self.size.width * 2, y: self.size.height * 0.9)
        backgroundPlanet3.zPosition = -100
        backgroundPlanet3.alpha = 0.0
        backgroundPlanet3.xScale = 1.5
        backgroundPlanet3.yScale = 1.5
        self.addChild(backgroundPlanet3)
        
        backgroundPlanet4.position = CGPoint(x: self.size.width * 2, y: self.size.height * 0.5)
        backgroundPlanet4.zPosition = -100
        backgroundPlanet4.alpha = 0.0
        backgroundPlanet4.xScale = 2.5
        backgroundPlanet4.yScale = 2.5
        self.addChild(backgroundPlanet4)
        
        backgroundAsteroid5.position = CGPoint(x: self.size.width * 2, y: self.size.height * 0.5)
        backgroundAsteroid5.zPosition = -100
        backgroundAsteroid5.alpha = 0.0
        backgroundAsteroid5.zRotation = CGFloat(Double.pi / 6)
        backgroundAsteroid5.xScale = 2.5
        backgroundAsteroid5.yScale = 2.5
        self.addChild(backgroundAsteroid5)
    }
    
    // MARK: Arrows and dots
    
    private func addArrosAndDots() {
        
        arrowLeft.position = CGPoint(x: ((self.size.width/2) - 330), y: self.size.height * 0.08)
        arrowLeft.zPosition = -99
        arrowLeft.xScale = 0.7
        arrowLeft.yScale = 0.7
        arrowLeft.alpha = 0.5
        self.addChild(arrowLeft)
        
        arrowRight.position = CGPoint(x: ((self.size.width/2) + 330), y: self.size.height * 0.08)
        arrowRight.zPosition = -99
        arrowRight.xScale = 0.7
        arrowRight.yScale = 0.7
        self.addChild(arrowRight)
        
       
        dotLeft.position = CGPoint(x: ((self.size.width/2) - 120), y: self.size.height * 0.08)
        dotLeft.zPosition = -99
        self.addChild(dotLeft)
        
        dotLeft1.position = CGPoint(x: ((self.size.width/2) - 60), y: self.size.height * 0.08)
        dotLeft1.zPosition = -99
        dotLeft1.alpha = 0.5
        self.addChild(dotLeft1)
        
        dotCenter.position = CGPoint(x: ((self.size.width/2) - 0), y: self.size.height * 0.08)
        dotCenter.zPosition = -99
        dotCenter.alpha = 0.5
        self.addChild(dotCenter)
        
        dotRight1.position = CGPoint(x: ((self.size.width/2) + 60), y: self.size.height * 0.08)
        dotRight1.zPosition = -99
        dotRight1.alpha = 0.5
        self.addChild(dotRight1)
        
        dotRight.position = CGPoint(x: ((self.size.width/2) + 120), y: self.size.height * 0.08)
        dotRight.zPosition = -99
        dotRight.alpha = 0.5
        self.addChild(dotRight)
        
    }
    
    // MARK: adding scroll view
    private func setupRecognizers() {
        
        //RIGHT
        swipeRightRecLvl.addTarget(self, action: #selector(LevelsScene.swipeRight))
        swipeRightRecLvl.direction = .right
        self.view?.addGestureRecognizer(swipeRightRecLvl)
        //LEFT
        swipeLeftRecLvl.addTarget(self, action: #selector(LevelsScene.swipeLeft))
        swipeLeftRecLvl.direction = .left
        self.view?.addGestureRecognizer(swipeLeftRecLvl)

    }
    /*
    override func willMove(from view: SKView) {
        if view.gestureRecognizers != nil {
            for gesture in view.gestureRecognizers! {
                if let recoginzer = gesture as? UISwipeGestureRecognizer {
                    view.removeGestureRecognizer(recoginzer)
                }
            }
        }
    }
    */
    private func removeGestureRocognizers() {
        if view?.gestureRecognizers != nil {
            for gesture in view!.gestureRecognizers! {
                if let recoginzer = gesture as? UISwipeGestureRecognizer {
                    view!.removeGestureRecognizer(recoginzer)
                }
            }
        }
    }
    
    @objc private func swipeRight() {
        if lvlsPage == 2 {
            
            if !buttons2LvlArray.isEmpty {
                for i in 1...buttons2LvlArray.count {
                    let button = buttons2LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x + 100 , y: button.position.y) , duration:0.2)
//                    if active2Level[i-1] == 1 {
                        fadeNodeAction = SKAction.fadeOut(withDuration: 0.1)
//                    } else {
//                        fadeNodeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
//                    }
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            if !buttons1LvlArray.isEmpty {
                for i in 1...buttons1LvlArray.count {
                    let button = buttons1LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x + 100 , y: button.position.y) , duration:0.2)
                    if activeLevel[i-1] == 1 {
                        fadeNodeAction = SKAction.fadeIn(withDuration: 0.1)
                    } else {
                        fadeNodeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
                    }
                    
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            
            lvlsPage = 1
            planet = 1
            if preferredLanguage == .ru {
                levelsLabelNode.text = "Планета \(planet)"
            } else if preferredLanguage == .ch {
                levelsLabelNode.text = "行星 \(planet)"
            } else if preferredLanguage == .es {
                levelsLabelNode.text = "Planeta \(planet)"
            } else if preferredLanguage == .jp {
                levelsLabelNode.text = "惑星 \(planet)"
            } else if preferredLanguage == .fr {
                levelsLabelNode.text = "Planète \(planet)"
            } else if preferredLanguage == .gr {
                levelsLabelNode.text = "Planet \(planet)"
            } else {
                levelsLabelNode.text = "Planet \(planet)"
            }
            
            let fadeStarsAnimOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeStarsAnimIn = SKAction.fadeIn(withDuration: 0.5)
            if !stars2LvlArray.isEmpty {
                for i in 1...stars2LvlArray.count {
                    let stars = stars2LvlArray[i-1]
                    stars.run(fadeStarsAnimOut)
                }
            }
            
            if !stars1LvlArray.isEmpty {
                for i in 1...stars1LvlArray.count {
                    let stars = stars1LvlArray[i-1]
                    stars.run(fadeStarsAnimIn)
                }
            }
            
            let fadeLabelAnimOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeLabelAnimIn = SKAction.fadeIn(withDuration: 0.5)
            
            enumerateChildNodes(withName: "score2LvlLabel") { (node, _) in
                node.run(fadeLabelAnimOut)
                
            }
            
            enumerateChildNodes(withName: "score1LvlLabel") { (node, _) in
                node.run(fadeLabelAnimIn)
                
            }
            
            
            arrowLeft.alpha = 0.5
            arrowRight.alpha = 1.0
            dotLeft.alpha = 1.0
            dotLeft1.alpha = 0.5
            dotCenter.alpha = 0.5
            dotRight.alpha = 0.5
            dotRight1.alpha = 0.5
            
            
            //backgroundPlanet.alpha = 1.0
            //backgroundPlanet2.alpha = 0.0
            
            //P1 CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
            //P2 CGPoint(x: self.size.width/2, y: self.size.height * (-0.2))
            
            let movePlane1Action = SKAction.move(to: CGPoint(x: self.size.width * 0.7, y: self.size.height * 1) , duration: 0.5)
            let fadePlanet1Action = SKAction.fadeIn(withDuration: 0.5)
            let planet1GroupAction = SKAction.group([movePlane1Action, fadePlanet1Action])
            
            let movePlanet2Action = SKAction.move(to: CGPoint(x: self.size.width * 4, y: self.size.height * (-0.3)) , duration: 0.5)
            let fadePlanet2Action = SKAction.fadeOut(withDuration: 0.5)
            let planet2GroupAction = SKAction.group([movePlanet2Action, fadePlanet2Action])
            
            backgroundPlanet.run(planet1GroupAction)
            backgroundPlanet2.run(planet2GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x - 100, duration: 0.5)
            movingBackground.run(moveBackground)
            
            
            
            
        } else if lvlsPage == 3 {
            
            if !buttons3LvlArray.isEmpty {
                for i in 1...buttons3LvlArray.count {
                    let button = buttons3LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x + 100 , y: button.position.y) , duration:0.2)
                    //                    if active2Level[i-1] == 1 {
                    fadeNodeAction = SKAction.fadeOut(withDuration: 0.1)
                    //                    } else {
                    //                        fadeNodeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
                    //                    }
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            if !buttons2LvlArray.isEmpty {
                for i in 1...buttons2LvlArray.count {
                    let button = buttons2LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x + 100 , y: button.position.y) , duration:0.2)
                    if active2Level[i-1] == 1 {
                        fadeNodeAction = SKAction.fadeIn(withDuration: 0.1)
                    } else {
                        fadeNodeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
                    }
                    
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            
            lvlsPage = 2
            planet = 2
            if preferredLanguage == .ru {
                levelsLabelNode.text = "Планета \(planet)"
            } else if preferredLanguage == .ch {
                levelsLabelNode.text = "行星 \(planet)"
            } else if preferredLanguage == .es {
                levelsLabelNode.text = "Planeta \(planet)"
            } else if preferredLanguage == .jp {
                levelsLabelNode.text = "惑星 \(planet)"
            } else if preferredLanguage == .fr {
                levelsLabelNode.text = "Planète \(planet)"
            } else if preferredLanguage == .gr {
                levelsLabelNode.text = "Planet \(planet)"
            } else {
                levelsLabelNode.text = "Planet \(planet)"
            }
            
            let fadeStarsAnimOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeStarsAnimIn = SKAction.fadeIn(withDuration: 0.5)
            if !stars3LvlArray.isEmpty {
                for i in 1...stars3LvlArray.count {
                    let stars = stars3LvlArray[i-1]
                    stars.run(fadeStarsAnimOut)
                }
            }
            
            if !stars2LvlArray.isEmpty {
                for i in 1...stars2LvlArray.count {
                    let stars = stars2LvlArray[i-1]
                    stars.run(fadeStarsAnimIn)
                }
            }
            
            let fadeLabelAnimOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeLabelAnimIn = SKAction.fadeIn(withDuration: 0.5)
            
            enumerateChildNodes(withName: "score3LvlLabel") { (node, _) in
                node.run(fadeLabelAnimOut)
                
            }
            
            enumerateChildNodes(withName: "score2LvlLabel") { (node, _) in
                node.run(fadeLabelAnimIn)
                
            }
            
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 1.0
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 1.0
            dotCenter.alpha = 0.5
            dotRight1.alpha = 0.5
            dotRight.alpha = 0.5
            
            
            //backgroundPlanet.alpha = 1.0
            //backgroundPlanet2.alpha = 0.0
            
            //P1 CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
            //P2 CGPoint(x: self.size.width/2, y: self.size.height * (-0.2))
            
            let movePlanet2Action = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height * (-0.1)) , duration: 0.5)
            let fadePlanet2Action = SKAction.fadeIn(withDuration: 0.5)
            let planet2GroupAction = SKAction.group([movePlanet2Action, fadePlanet2Action])
            
            let movePlanet3Action = SKAction.move(to: CGPoint(x: self.size.width * 2, y: self.size.height * 0.9) , duration: 0.5)
            let fadePlanet3Action = SKAction.fadeOut(withDuration: 0.5)
            let planet3GroupAction = SKAction.group([movePlanet3Action, fadePlanet3Action])
            
            backgroundPlanet2.run(planet2GroupAction)
            backgroundPlanet3.run(planet3GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x - 100, duration: 0.5)
            movingBackground.run(moveBackground)
            
        }  else if lvlsPage == 4 {
            
            if !buttons3LvlArray.isEmpty {
                for i in 1...buttons3LvlArray.count {
                    let button = buttons3LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x + 100 , y: button.position.y) , duration:0.2)
                    if active3Level[i-1] == 1 {
                        fadeNodeAction = SKAction.fadeIn(withDuration: 0.1)
                    } else {
                        fadeNodeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
                    }
                    
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            
            let fadeStarsAnimIn = SKAction.fadeIn(withDuration: 0.5)
            if !stars3LvlArray.isEmpty {
                for i in 1...stars3LvlArray.count {
                    let stars = stars3LvlArray[i-1]
                    stars.run(fadeStarsAnimIn)
                }
            }
            
            let fadeLabelAnimIn = SKAction.fadeIn(withDuration: 0.5)
            enumerateChildNodes(withName: "score3LvlLabel") { (node, _) in
                node.run(fadeLabelAnimIn)
                
            }
            
            lvlsPage = 3
            planet = 3
            if preferredLanguage == .ru {
                levelsLabelNode.text = "Планета \(planet)"
            } else if preferredLanguage == .ch {
                levelsLabelNode.text = "行星 \(planet)"
            } else if preferredLanguage == .es {
                levelsLabelNode.text = "Planeta \(planet)"
            } else if preferredLanguage == .jp {
                levelsLabelNode.text = "惑星 \(planet)"
            } else if preferredLanguage == .fr {
                levelsLabelNode.text = "Planète \(planet)"
            } else if preferredLanguage == .gr {
                levelsLabelNode.text = "Planet \(planet)"
            } else {
                levelsLabelNode.text = "Planet \(planet)"
            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 1.0
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 0.5
            dotCenter.alpha = 1.0
            dotRight1.alpha = 0.5
            dotRight.alpha = 0.5
            
            
            //backgroundPlanet.alpha = 1.0
            //backgroundPlanet2.alpha = 0.0
            
            //P1 CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
            //P2 CGPoint(x: self.size.width/2, y: self.size.height * (-0.2))
            
            let movePlanet3Action = SKAction.move(to: CGPoint(x: self.size.width * 0.2, y: self.size.height * (0.8)), duration: 0.5)
            let fadePlanet3Action = SKAction.fadeIn(withDuration: 0.5)
            let planet3GroupAction = SKAction.group([movePlanet3Action, fadePlanet3Action])
            
            let movePlanet4Action = SKAction.move(to: CGPoint(x: self.size.width * 2, y: self.size.height * 0.5), duration: 0.5)
            let fadePlanet4Action = SKAction.fadeOut(withDuration: 0.5)
            let planet4GroupAction = SKAction.group([movePlanet4Action, fadePlanet4Action])
            
            comingSoonNode.run(fadePlanet4Action)
            
            backgroundPlanet3.run(planet3GroupAction)
            backgroundPlanet4.run(planet4GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x - 100, duration: 0.5)
            movingBackground.run(moveBackground)
        }  else if lvlsPage == 5 {
            
            let moveInfinityAction = SKAction.move(to: CGPoint(x: self.size.width * 2, y: self.size.height / 2) , duration: 0.5)
            let fadeInfintyAction = SKAction.fadeOut(withDuration: 0.5)
            let infinityGroupAction = SKAction.group([moveInfinityAction, fadeInfintyAction])
            
            lvlsPage = 4
            planet = 4
            levelsLabelNode.alpha = 1.0
            if preferredLanguage == .ru {
                levelsLabelNode.text = "Планета \(planet)"
            } else if preferredLanguage == .ch {
                levelsLabelNode.text = "行星 \(planet)"
            } else if preferredLanguage == .es {
                levelsLabelNode.text = "Planeta \(planet)"
            } else if preferredLanguage == .jp {
                levelsLabelNode.text = "惑星 \(planet)"
            } else if preferredLanguage == .fr {
                levelsLabelNode.text = "Planète \(planet)"
            } else if preferredLanguage == .gr {
                levelsLabelNode.text = "Planet \(planet)"
            } else {
                levelsLabelNode.text = "Planet \(planet)"
            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 1.0
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 0.5
            dotCenter.alpha = 0.5
            dotRight1.alpha = 1.0
            dotRight.alpha = 0.5
            
            
            let movePlanet4Action = SKAction.move(to: CGPoint(x: self.size.width * 0.4, y: self.size.height * (0.9)), duration: 0.5)
            let fadePlanet4Action = SKAction.fadeIn(withDuration: 0.5)
            let planet4GroupAction = SKAction.group([movePlanet4Action, fadePlanet4Action])
            
            let moveAsteroid5Action = SKAction.move(to: CGPoint(x: self.size.width * 2, y: self.size.height * 0.5), duration: 0.5)
            let fadeOutAsteroid5Action = SKAction.fadeOut(withDuration: 0.5)
            let asteroid5GroupAction = SKAction.group([moveAsteroid5Action, fadeOutAsteroid5Action])
            
            infinityNode.run(infinityGroupAction)
            comingSoonNode.run(SKAction.fadeIn(withDuration: 0.5))
            
            backgroundPlanet4.run(planet4GroupAction)
            backgroundAsteroid5.run(asteroid5GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x - 100, duration: 0.5)
            movingBackground.run(moveBackground)
        }
        //print("swipe right")
    }
    
    @objc private func swipeLeft() {
        
        if lvlsPage == 1 {
            
            if !buttons1LvlArray.isEmpty {
                for i in 1...buttons1LvlArray.count {
                    let button = buttons1LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x - 100 , y: button.position.y) , duration:0.1)
                    
                    fadeNodeAction = SKAction.fadeOut(withDuration: 0.1)

                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            if !buttons2LvlArray.isEmpty {
                for i in 1...buttons2LvlArray.count {
                    let button = buttons2LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x - 100 , y: button.position.y) , duration:0.1)
                    if active2Level[i-1] == 1 {
                        fadeNodeAction = SKAction.fadeIn(withDuration: 0.1)
                    } else {
                        fadeNodeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
                    }
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            
            lvlsPage = 2
            planet = 2
            if preferredLanguage == .ru {
                levelsLabelNode.text = "Планета \(planet)"
            } else if preferredLanguage == .ch {
                levelsLabelNode.text = "行星 \(planet)"
            } else if preferredLanguage == .es {
                levelsLabelNode.text = "Planeta \(planet)"
            } else if preferredLanguage == .jp {
                levelsLabelNode.text = "惑星 \(planet)"
            } else if preferredLanguage == .fr {
                levelsLabelNode.text = "Planète \(planet)"
            } else if preferredLanguage == .gr {
                levelsLabelNode.text = "Planet \(planet)"
            } else {
                levelsLabelNode.text = "Planet \(planet)"
            }
            
            let fadeStarsAnimOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeStarsAnimIn = SKAction.fadeIn(withDuration: 0.5)
            
            if !stars1LvlArray.isEmpty {
                for i in 1...stars1LvlArray.count {
                    let stars = stars1LvlArray[i-1]
                    stars.run(fadeStarsAnimOut)
                }
            }
            if !stars2LvlArray.isEmpty {
                for i in 1...stars2LvlArray.count {
                    let stars = stars2LvlArray[i-1]
                    stars.run(fadeStarsAnimIn)
                }
            }
            
            
            let fadeLabelAnimOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeLabelAnimIn = SKAction.fadeIn(withDuration: 0.5)
            
            enumerateChildNodes(withName: "score1LvlLabel") { (node, _) in
                node.run(fadeLabelAnimOut)

            }

            enumerateChildNodes(withName: "score2LvlLabel") { (node, _) in
                node.run(fadeLabelAnimIn)

            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 1.0
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 1.0
            dotCenter.alpha = 0.5
            dotRight1.alpha = 0.5
            dotRight.alpha = 0.5
            
            //backgroundPlanet.alpha = 0.0
            //backgroundPlanet2.alpha = 1.0
            
            
            //P1 CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
            //P2 CGPoint(x: self.size.width/2, y: self.size.height * (-0.2))
            
            let movePlane1Action = SKAction.move(to: CGPoint(x: self.size.width * (-3), y: self.size.height * 1) , duration: 0.5)
            let fadePlanet1Action = SKAction.fadeOut(withDuration: 0.5)
            let planet1GroupAction = SKAction.group([movePlane1Action, fadePlanet1Action])
            
            let movePlanet2Action = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height * (-0.1)) , duration: 0.5)
            let fadePlanet2Action = SKAction.fadeIn(withDuration: 0.5)
            let planet2GroupAction = SKAction.group([movePlanet2Action, fadePlanet2Action])
            
            backgroundPlanet.run(planet1GroupAction)
            backgroundPlanet2.run(planet2GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x + 100, duration: 0.5)
            movingBackground.run(moveBackground)
            
        } else if lvlsPage == 2 {
            
            if !buttons2LvlArray.isEmpty {
                for i in 1...buttons2LvlArray.count {
                    let button = buttons2LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x - 100 , y: button.position.y) , duration:0.1)
                    
                    fadeNodeAction = SKAction.fadeOut(withDuration: 0.1)
                    
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            if !buttons3LvlArray.isEmpty {
                //print("button3LvlArtay not empty")
                for i in 1...buttons3LvlArray.count {
                    let button = buttons3LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x - 100 , y: button.position.y) , duration:0.1)
                    if active3Level[i-1] == 1 {
                        fadeNodeAction = SKAction.fadeIn(withDuration: 0.1)
                    } else {
                        fadeNodeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
                    }
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            
            lvlsPage = 3
            planet = 3
            if preferredLanguage == .ru {
                levelsLabelNode.text = "Планета \(planet)"
            } else if preferredLanguage == .ch {
                levelsLabelNode.text = "行星 \(planet)"
            } else if preferredLanguage == .es {
                levelsLabelNode.text = "Planeta \(planet)"
            } else if preferredLanguage == .jp {
                levelsLabelNode.text = "惑星 \(planet)"
            } else if preferredLanguage == .fr {
                levelsLabelNode.text = "Planète \(planet)"
            } else if preferredLanguage == .gr {
                levelsLabelNode.text = "Planet \(planet)"
            } else {
                levelsLabelNode.text = "Planet \(planet)"
            }
            
            let fadeStarsAnimOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeStarsAnimIn = SKAction.fadeIn(withDuration: 0.5)
            
            if !stars2LvlArray.isEmpty {
                for i in 1...stars2LvlArray.count {
                    let stars = stars2LvlArray[i-1]
                    stars.run(fadeStarsAnimOut)
                }
            }
            if !stars3LvlArray.isEmpty {
                for i in 1...stars3LvlArray.count {
                    let stars = stars3LvlArray[i-1]
                    stars.run(fadeStarsAnimIn)
                }
            }
            
            
            let fadeLabelAnimOut = SKAction.fadeOut(withDuration: 0.5)
            let fadeLabelAnimIn = SKAction.fadeIn(withDuration: 0.5)
            
            enumerateChildNodes(withName: "score2LvlLabel") { (node, _) in
                node.run(fadeLabelAnimOut)
                
            }
            
            enumerateChildNodes(withName: "score3LvlLabel") { (node, _) in
                node.run(fadeLabelAnimIn)
                
            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 1.0
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 0.5
            dotCenter.alpha = 1.0
            dotRight1.alpha = 0.5
            dotRight.alpha = 0.5
            
            //backgroundPlanet.alpha = 0.0
            //backgroundPlanet2.alpha = 1.0
            
            
            //P1 CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
            //P2 CGPoint(x: self.size.width/2, y: self.size.height * (-0.2))
            
            let movePlane2Action = SKAction.move(to: CGPoint(x: self.size.width * (-3), y: self.size.height * 0.1) , duration: 0.5)
            let fadePlanet2Action = SKAction.fadeOut(withDuration: 0.5)
            let planet2GroupAction = SKAction.group([movePlane2Action, fadePlanet2Action])
            
            let movePlanet3Action = SKAction.move(to: CGPoint(x: self.size.width * 0.2, y: self.size.height * (0.8)) , duration: 0.5)
            let fadePlanet3Action = SKAction.fadeIn(withDuration: 0.5)
            let planet3GroupAction = SKAction.group([movePlanet3Action, fadePlanet3Action])
            
            backgroundPlanet2.run(planet2GroupAction)
            backgroundPlanet3.run(planet3GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x + 100, duration: 0.5)
            movingBackground.run(moveBackground)
            
        }  else if lvlsPage == 3 {
            
            if !buttons3LvlArray.isEmpty {
                for i in 1...buttons3LvlArray.count {
                    let button = buttons3LvlArray[i-1]
                    
                    let fadeNodeAction: SKAction
                    let moveNodeAction = SKAction.move(to: CGPoint(x: button.position.x - 100 , y: button.position.y) , duration:0.1)
                    
                    fadeNodeAction = SKAction.fadeOut(withDuration: 0.1)
                    
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            
            let fadeStarsAnimOut = SKAction.fadeOut(withDuration: 0.5)
            if !stars3LvlArray.isEmpty {
                for i in 1...stars3LvlArray.count {
                    let stars = stars3LvlArray[i-1]
                    stars.run(fadeStarsAnimOut)
                }
            }
            
            let fadeLabelAnimOut = SKAction.fadeOut(withDuration: 0.5)
            enumerateChildNodes(withName: "score3LvlLabel") { (node, _) in
                node.run(fadeLabelAnimOut)
                
            }
            
            lvlsPage = 4
            planet = 4
            if preferredLanguage == .ru {
                levelsLabelNode.text = "Планета \(planet)"
            } else if preferredLanguage == .ch {
                levelsLabelNode.text = "行星 \(planet)"
            } else if preferredLanguage == .es {
                levelsLabelNode.text = "Planeta \(planet)"
            } else if preferredLanguage == .jp {
                levelsLabelNode.text = "惑星 \(planet)"
            } else if preferredLanguage == .fr {
                levelsLabelNode.text = "Planète \(planet)"
            } else if preferredLanguage == .gr {
                levelsLabelNode.text = "Planet \(planet)"
            } else {
                levelsLabelNode.text = "Planet \(planet)"
            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 1.0
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 0.5
            dotCenter.alpha = 0.5
            dotRight1.alpha = 1.0
            dotRight.alpha = 0.5
            
            //backgroundPlanet.alpha = 0.0
            //backgroundPlanet2.alpha = 1.0
            
            
            //P1 CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
            //P2 CGPoint(x: self.size.width/2, y: self.size.height * (-0.2))
            
            let movePlane3Action = SKAction.move(to: CGPoint(x: self.size.width * (-3), y: self.size.height * 0.8) , duration: 0.5)
            let fadePlanet3Action = SKAction.fadeOut(withDuration: 0.5)
            let planet3GroupAction = SKAction.group([movePlane3Action, fadePlanet3Action])
            
            let movePlanet4Action = SKAction.move(to: CGPoint(x: self.size.width * 0.5, y: self.size.height * (0.5)) , duration: 0.5)
            let fadePlanet4Action = SKAction.fadeIn(withDuration: 0.5)
            let planet4GroupAction = SKAction.group([movePlanet4Action, fadePlanet4Action])
            
            comingSoonNode.run(fadePlanet4Action)
            
            backgroundPlanet3.run(planet3GroupAction)
            backgroundPlanet4.run(planet4GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x + 100, duration: 0.5)
            movingBackground.run(moveBackground)
            
        }   else if lvlsPage == 4 {
            
            let moveInfinityAction = SKAction.move(to: CGPoint(x: self.size.width / 2, y: self.size.height / 2) , duration: 0.5)
            let fadeInfintyAction = SKAction.fadeIn(withDuration: 0.5)
            let infinityGroupAction = SKAction.group([moveInfinityAction, fadeInfintyAction])
            
            
            lvlsPage = 5
            planet = 5
            levelsLabelNode.alpha = 0.0
//            if preferredLanguage == .ru {
//                levelsLabelNode.text = "Планета \(planet)"
//            } else if preferredLanguage == .ch {
//                levelsLabelNode.text = "行星 \(planet)"
//            } else if preferredLanguage == .es {
//                levelsLabelNode.text = "Planeta \(planet)"
//            } else {
//                levelsLabelNode.text = "Planet \(planet)"
//            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 0.5
            dotLeft.alpha = 0.5
            dotLeft1.alpha = 0.5
            dotCenter.alpha = 0.5
            dotRight1.alpha = 0.5
            dotRight.alpha = 1.0
            
            
            let movePlane4Action = SKAction.move(to: CGPoint(x: self.size.width * (-3), y: self.size.height * 0.8) , duration: 0.5)
            let fadePlanet4Action = SKAction.fadeOut(withDuration: 0.5)
            let planet4GroupAction = SKAction.group([movePlane4Action, fadePlanet4Action])
            
            let moveAsteroid5Action = SKAction.move(to: CGPoint(x: self.size.width * 0.6, y: self.size.height * (0.2)) , duration: 0.5)
            let fadeAsteroid5Action = SKAction.fadeIn(withDuration: 0.5)
            let asteroid5GroupAction = SKAction.group([moveAsteroid5Action, fadeAsteroid5Action])
            
            comingSoonNode.run(SKAction.fadeOut(withDuration: 0.5))
            infinityNode.run(infinityGroupAction)
            
            backgroundPlanet4.run(planet4GroupAction)
            backgroundAsteroid5.run(asteroid5GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x + 100, duration: 0.5)
            movingBackground.run(moveBackground)
        }
        //print("swipe left")
    }
    
    // MARK: Background setup
    private func backgroundSetup() {
         let background = SKSpriteNode(imageNamed: "backgroundStars")
         background.size = self.size
         background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
         background.zPosition = -102
         self.addChild(background)
    }
    
    private func levelsLabel() {
        var levelsLabel = SKSpriteNode()
        if preferredLanguage == .ru {
            levelsLabel = SKSpriteNode(imageNamed: "levelsLableRU1")
        } else if preferredLanguage == .ch {
            levelsLabel = SKSpriteNode(imageNamed: "levelsLableCH1")
        } else if preferredLanguage == .es {
            levelsLabel = SKSpriteNode(imageNamed: "levelsLableSP1")
        } else {
            levelsLabel = SKSpriteNode(imageNamed: "levelsLable1")
        }
        //levelsLabel.size = self.size
        levelsLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.90)
        levelsLabel.zPosition = -99
        self.addChild(levelsLabel)
    }
    
    private func levelsLabelSetup() {
        if preferredLanguage == .ru {
            levelsLabelNode.text = "Планета \(planet)"
        } else if preferredLanguage == .ch {
            levelsLabelNode.text = "行星 \(planet)"
        } else if preferredLanguage == .es {
            levelsLabelNode.text = "Planeta \(planet)"
        } else if preferredLanguage == .jp {
            levelsLabelNode.text = "惑星 \(planet)"
        } else if preferredLanguage == .fr {
            levelsLabelNode.text = "Planète \(planet)"
        } else if preferredLanguage == .gr {
            levelsLabelNode.text = "Planet \(planet)"
        } else {
            levelsLabelNode.text = "Planet \(planet)"
        }
        //levelsLabel.size = self.size
        levelsLabelNode.fontSize = 70
        levelsLabelNode.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white //UIColor.white
        levelsLabelNode.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.88)
        levelsLabelNode.zPosition = -99
        self.addChild(levelsLabelNode)
    }
    
    private func levelButtonsSetup() {
        var x = 1
        var y = 1
        var z = 1
        for i in 1...lvlScore.count {
            let lvlButton = SKSpriteNode(imageNamed: "lvl\(i)beige1")
            lvlButton.name = "lvl\(i)ButtonONE"
            
            //lvlButton.size = self.size
            if i <= 3 {
                if activeLevel[i-1] == 1 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * i), y: self.size.height * 0.80)
                } else {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * i), y: self.size.height * 0.80)
                    lvlButton.alpha = 0.5
                }
            } else if i <= 6 {
                if activeLevel[i-1] == 1 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                } else {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    lvlButton.alpha = 0.5
                }
                x += 1
            } else if i <= 9 {
                if activeLevel[i-1] == 1 && paidLevel[i-1] == 1 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                } else if activeLevel[i-1] == 1 && paidLevel[i-1] == 0 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvlButton.size.width - (lvlButton.size.width), y: lvlButton.size.height - (lvlButton.size.height))
                    levelLock.position = CGPoint(x: lvlButton.size.width - (lvlButton.size.width / 2) - 30, y: lvlButton.size.height - (lvlButton.size.height + (lvlButton.size.height / 2)) + 30)
                    lvlButton.addChild(levelLock)
                } else  if activeLevel[i-1] == 0 && paidLevel[i-1] == 0 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    lvlButton.alpha = 0.5
                    
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvlButton.size.width - (lvlButton.size.width), y: lvlButton.size.height - (lvlButton.size.height))
                    levelLock.position = CGPoint(x: lvlButton.size.width - (lvlButton.size.width / 2) - 30, y: lvlButton.size.height - (lvlButton.size.height + (lvlButton.size.height / 2)) + 30)
                    lvlButton.addChild(levelLock)
                } else  if activeLevel[i-1] == 0 && paidLevel[i-1] == 1 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    lvlButton.alpha = 0.5
                }
                y += 1
            } else if i <= 12 {
                if activeLevel[i-1] == 1 && paidLevel[i-1] == 1  {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                } else if activeLevel[i-1] == 1 && paidLevel[i-1] == 0 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    levelLock.position = CGPoint(x: lvlButton.size.width - (lvlButton.size.width / 2) - 30, y: lvlButton.size.height - (lvlButton.size.height + (lvlButton.size.height / 2)) + 30)
                    lvlButton.addChild(levelLock)
                } else if activeLevel[i-1] == 0 && paidLevel[i-1] == 0 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    lvlButton.alpha = 0.5
                    
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    levelLock.position = CGPoint(x: lvlButton.size.width - (lvlButton.size.width / 2) - 30, y: lvlButton.size.height - (lvlButton.size.height + (lvlButton.size.height / 2)) + 30)
                    lvlButton.addChild(levelLock)
                } else if activeLevel[i-1] == 0 && paidLevel[i-1] == 1 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    lvlButton.alpha = 0.5
                }
                if i == 10 {
                    //levelTenButtonPosition = lvlButton.position
                    levelTenDistortButton = lvlButton
                }
                z += 1
            }
            
            buttons1LvlArray.append(lvlButton)
            
            lvlButton.zPosition = -99
            lvlButton.xScale += 0.4
            lvlButton.yScale += 0.4
            self.addChild(lvlButton)
            
            var stars = levelStars[i-1]
            for j in 1...stars.count {
                if j == 1 {
                    scoreOneStar = stars[j-1]
                } else if j == 2 {
                    scoreTwoStar = stars[j-1]
                } else if j == 3 {
                    scoreThreeStars = stars[j-1]
                }
            }
            
            scoreStars(index: i, button: lvlButton)
            //scrollViewVar?.addSubview(lvlButton)
        }
    }
    
    private func level2ButtonsSetup() {
        var x = 1
        var y = 1
        var z = 1
        for i in 1...lvl2Score.count {
            let lvl2Button = SKSpriteNode(imageNamed: "lvl2\(i)beige1")
            lvl2Button.name = "lvl\(i)ButtonTWO"
            
            //lvlButton.size = self.size
            if i <= 3 {
                if active2Level[i-1] == 1 && paid2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                } else if active2Level[i-1] == 1 && paid2Level[i-1] == 0 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width / 2) - 30, y: lvl2Button.size.height - (lvl2Button.size.height + (lvl2Button.size.height / 2)) + 30)
                    lvl2Button.addChild(levelLock)
                } else  if active2Level[i-1] == 0 && paid2Level[i-1] == 0 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    lvl2Button.alpha = 0.5
                    
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width / 2) - 30, y: lvl2Button.size.height - (lvl2Button.size.height + (lvl2Button.size.height / 2)) + 30)
                    lvl2Button.addChild(levelLock)
                } else  if active2Level[i-1] == 0 && paid2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    lvl2Button.alpha = 0.5
                }
            } else if i <= 6 {
                if active2Level[i-1] == 1 && paid2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                } else if active2Level[i-1] == 1 && paid2Level[i-1] == 0 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width / 2) - 30, y: lvl2Button.size.height - (lvl2Button.size.height + (lvl2Button.size.height / 2)) + 30)
                    lvl2Button.addChild(levelLock)
                } else if active2Level[i-1] == 0 && paid2Level[i-1] == 0 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    lvl2Button.alpha = 0.5
                    
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width / 2) - 30, y: lvl2Button.size.height - (lvl2Button.size.height + (lvl2Button.size.height / 2)) + 30)
                    lvl2Button.addChild(levelLock)
                } else if active2Level[i-1] == 0 && paid2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    lvl2Button.alpha = 0.5
                }
                x += 1
            } else if i <= 9 {
                if active2Level[i-1] == 1 && paid2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                } else if active2Level[i-1] == 1 && paid2Level[i-1] == 0 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width / 2) - 30, y: lvl2Button.size.height - (lvl2Button.size.height + (lvl2Button.size.height / 2)) + 30)
                    lvl2Button.addChild(levelLock)
                } else if active2Level[i-1] == 0 && paid2Level[i-1] == 0 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    lvl2Button.alpha = 0.5
                    
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width / 2) - 30, y: lvl2Button.size.height - (lvl2Button.size.height + (lvl2Button.size.height / 2)) + 30)
                    lvl2Button.addChild(levelLock)
                } else if active2Level[i-1] == 0 && paid2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    lvl2Button.alpha = 0.5
                }
                y += 1
            } else if i <= 12 {
                if active2Level[i-1] == 1 && paid2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                } else if active2Level[i-1] == 1 && paid2Level[i-1] == 0 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width / 2) - 30, y: lvl2Button.size.height - (lvl2Button.size.height + (lvl2Button.size.height / 2)) + 30)
                    lvl2Button.addChild(levelLock)
                } else if active2Level[i-1] == 0 && paid2Level[i-1] == 0 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    lvl2Button.alpha = 0.5
                    
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width / 2) - 30, y: lvl2Button.size.height - (lvl2Button.size.height + (lvl2Button.size.height / 2)) + 30)
                    lvl2Button.addChild(levelLock)
                } else if active2Level[i-1] == 0 && paid2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    lvl2Button.alpha = 0.5
                }
                z += 1
            }
            
            buttons2LvlArray.append(lvl2Button)
            
            lvl2Button.zPosition = -99
            lvl2Button.xScale += 0.4
            lvl2Button.yScale += 0.4
            lvl2Button.alpha = 0.0
            self.addChild(lvl2Button)
            
            
            var stars = level2Stars[i-1]
            for j in 1...stars.count {
                if j == 1 {
                    scoreOneStar = stars[j-1]
                } else if j == 2 {
                    scoreTwoStar = stars[j-1]
                } else if j == 3 {
                    scoreThreeStars = stars[j-1]
                }
            }
            
            scoreStars(index: i, button: lvl2Button)
            //scrollViewVar?.addSubview(lvlButton)
         
        }
    }
    
    private func level3ButtonsSetup() {
        var x = 1
        var y = 1
        var z = 1
        for i in 1...lvl3Score.count {
            let lvl3Button = SKSpriteNode(imageNamed: "lvl3\(i)beige1")
            lvl3Button.name = "lvl\(i)ButtonTREE"
            
            //lvlButton.size = self.size
            if i <= 3 {
                if active3Level[i-1] == 1 && paid3Level[i-1] == 1 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                } else if active3Level[i-1] == 1 && paid3Level[i-1] == 0 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    levelLock.position = CGPoint(x: lvl3Button.size.width - (lvl3Button.size.width / 2) - 30, y: lvl3Button.size.height - (lvl3Button.size.height + (lvl3Button.size.height / 2)) + 30)
                    lvl3Button.addChild(levelLock)
                } else  if active3Level[i-1] == 0 && paid3Level[i-1] == 0 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    lvl3Button.alpha = 0.5
                    
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    levelLock.position = CGPoint(x: lvl3Button.size.width - (lvl3Button.size.width / 2) - 30, y: lvl3Button.size.height - (lvl3Button.size.height + (lvl3Button.size.height / 2)) + 30)
                    lvl3Button.addChild(levelLock)
                } else  if active3Level[i-1] == 0 && paid3Level[i-1] == 1 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    lvl3Button.alpha = 0.5
                }
            } else if i <= 6 {
                if active3Level[i-1] == 1 && paid3Level[i-1] == 1 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                } else if active3Level[i-1] == 1 && paid3Level[i-1] == 0 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl3Button.size.width - (lvl3Button.size.width / 2) - 30, y: lvl3Button.size.height - (lvl3Button.size.height + (lvl3Button.size.height / 2)) + 30)
                    lvl3Button.addChild(levelLock)
                } else if active3Level[i-1] == 0 && paid3Level[i-1] == 0 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    lvl3Button.alpha = 0.5
                    
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl3Button.size.width - (lvl3Button.size.width / 2) - 30, y: lvl3Button.size.height - (lvl3Button.size.height + (lvl3Button.size.height / 2)) + 30)
                    lvl3Button.addChild(levelLock)
                } else if active3Level[i-1] == 0 && paid3Level[i-1] == 1 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    lvl3Button.alpha = 0.5
                }
                x += 1
            } else if i <= 9 {
                if active3Level[i-1] == 1 && paid3Level[i-1] == 1 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                } else if active3Level[i-1] == 1 && paid3Level[i-1] == 0 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl3Button.size.width - (lvl3Button.size.width / 2) - 30, y: lvl3Button.size.height - (lvl3Button.size.height + (lvl3Button.size.height / 2)) + 30)
                    lvl3Button.addChild(levelLock)
                } else if active3Level[i-1] == 0 && paid3Level[i-1] == 0 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    lvl3Button.alpha = 0.5
                    
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl3Button.size.width - (lvl3Button.size.width / 2) - 30, y: lvl3Button.size.height - (lvl3Button.size.height + (lvl3Button.size.height / 2)) + 30)
                    lvl3Button.addChild(levelLock)
                } else if active3Level[i-1] == 0 && paid3Level[i-1] == 1 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    lvl3Button.alpha = 0.5
                }
                y += 1
            } else if i <= 12 {
                if active3Level[i-1] == 1 && paid3Level[i-1] == 1 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                } else if active3Level[i-1] == 1 && paid3Level[i-1] == 0 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl3Button.size.width - (lvl3Button.size.width / 2) - 30, y: lvl3Button.size.height - (lvl3Button.size.height + (lvl3Button.size.height / 2)) + 30)
                    lvl3Button.addChild(levelLock)
                } else if active3Level[i-1] == 0 && paid3Level[i-1] == 0 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    lvl3Button.alpha = 0.5
                    
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    let levelLock = SKSpriteNode(imageNamed: "levelLock111")
                    levelLock.yScale = 0.7
                    levelLock.xScale = 0.7
                    //levelLock.position = CGPoint(x: lvl2Button.size.width - (lvl2Button.size.width), y: lvl2Button.size.height - (lvl2Button.size.height))
                    levelLock.position = CGPoint(x: lvl3Button.size.width - (lvl3Button.size.width / 2) - 30, y: lvl3Button.size.height - (lvl3Button.size.height + (lvl3Button.size.height / 2)) + 30)
                    lvl3Button.addChild(levelLock)
                } else if active3Level[i-1] == 0 && paid3Level[i-1] == 1 {
                    lvl3Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                    lvl3Button.alpha = 0.5
                }
                z += 1
            }
            
            buttons3LvlArray.append(lvl3Button)
            
            lvl3Button.zPosition = -99
            lvl3Button.xScale += 0.4
            lvl3Button.yScale += 0.4
            lvl3Button.alpha = 0.0
            self.addChild(lvl3Button)
            
            
            var stars = level3Stars[i-1]
            for j in 1...stars.count {
                if j == 1 {
                    scoreOneStar = stars[j-1]
                } else if j == 2 {
                    scoreTwoStar = stars[j-1]
                } else if j == 3 {
                    scoreThreeStars = stars[j-1]
                }
            }
            
            scoreStars(index: i, button: lvl3Button)
            //scrollViewVar?.addSubview(lvlButton)
            
        }
    }
    
    
    private func scoreStars(index: Int, button: SKSpriteNode) {
        var score: Int = 0
        if button.name!.contains("ONE") /*== "lvlButton"*/ {
            score = lvlScore[index-1]
        } else if button.name!.contains("TWO") /*== "lvl2Button"*/ {
            score = lvl2Score[index-1]
        } else if button.name!.contains("TREE") /*== "lvl2Button"*/ {
            score = lvl3Score[index-1]
        } else {
            // nothingy
        }
        
        
        if score < scoreOneStar {
            //print("zore")
        } else if score >= scoreOneStar && score < scoreTwoStar {
            let scoreStar = SKSpriteNode(imageNamed: "scoreOneStar200")
            if button.name!.contains("ONE") /*== "lvlButton"*/ {
                scoreStar.name = "scoreOneStar"
                scoreStar.position.x = button.position.x
                stars1LvlArray.append(scoreStar)
            } else if button.name!.contains("TWO") /*== "lvl2Button"*/ {
                scoreStar.name = "scoreOneStar2"
                scoreStar.position.x = button.position.x - 100
                scoreStar.alpha = 0.0
                stars2LvlArray.append(scoreStar)
            } else if button.name!.contains("TREE") /*== "lvl2Button"*/ {
                scoreStar.name = "scoreOneStar3"
                scoreStar.position.x = button.position.x - 100
                scoreStar.alpha = 0.0
                stars3LvlArray.append(scoreStar)
            }
            //scoreStar.position.x = button.position.x
            scoreStar.position.y = button.position.y - 130
            scoreStar.zPosition = -98
            //button.addChild(scoreStar)
            self.addChild(scoreStar)
            //print("one")
        } else if score >= scoreTwoStar && score < scoreThreeStars {
            let scoreStar = SKSpriteNode(imageNamed: "scoreTwoStar200")
            if button.name!.contains("ONE") /*== "lvlButton"*/ {
                scoreStar.name = "scoreTwoStar"
                scoreStar.position.x = button.position.x
                stars1LvlArray.append(scoreStar)
            } else if button.name!.contains("TWO") /*== "lvlButton"*/ {
                scoreStar.name = "scoreTwoStar2"
                scoreStar.alpha = 0.0
                scoreStar.position.x = button.position.x - 100
                stars2LvlArray.append(scoreStar)
            } else if button.name!.contains("TREE") /*== "lvlButton"*/ {
                scoreStar.name = "scoreTwoStar3"
                scoreStar.alpha = 0.0
                scoreStar.position.x = button.position.x - 100
                stars3LvlArray.append(scoreStar)
            }
            //scoreStar.position.x = button.position.x
            scoreStar.position.y = button.position.y - 130
            scoreStar.zPosition = -98
            //button.addChild(scoreStar)
            self.addChild(scoreStar)
            //print("two")
        } else if score >= scoreThreeStars {
            let scoreStar = SKSpriteNode(imageNamed: "scoreThreeStar200")
            if button.name!.contains("ONE") /*== "lvlButton"*/ {
                scoreStar.name = "scoreThreeStar"
                scoreStar.position.x = button.position.x
                stars1LvlArray.append(scoreStar)
            } else if button.name!.contains("TWO") /*== "lvlButton"*/ {
                scoreStar.name = "scoreThreeStar2"
                scoreStar.alpha = 0.0
                scoreStar.position.x = button.position.x - 100
                stars2LvlArray.append(scoreStar)
            } else if button.name!.contains("TREE") /*== "lvlButton"*/ {
                scoreStar.name = "scoreThreeStar3"
                scoreStar.alpha = 0.0
                scoreStar.position.x = button.position.x - 100
                stars3LvlArray.append(scoreStar)
            }
            //scoreStar.position.x = button.position.x
            scoreStar.position.y = button.position.y - 130
            scoreStar.zPosition = -98
            //button.addChild(scoreStar)
            self.addChild(scoreStar)
            //print("three")
        }
    }
    
    private func scoreLableSetup() {
        
        var x = 1
        var y = 1
        var z = 1
        
        for i in 1...lvlScore.count {
            let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
            scoreLabel.name = "score1LvlLabel"
            //scoreLabel.text = "\(23)"
            
            //lvlButton.size = self.size
            if i <= 3 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * i), y: self.size.height * 0.80 - CGFloat(180) - CGFloat(30))
            } else if i <= 6 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(350) - CGFloat(240))
                x += 1
            } else if i <= 9 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(700) - CGFloat(260))
                y += 1
            } else if i <= 12 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1050) - CGFloat(290))
                z += 1
            }
            
            scoreLabel.fontSize = 40
            scoreLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
            scoreLabel.zPosition = -99
            self.addChild(scoreLabel)
            
            scoreLabel.text = /*String(lvlScore[i-1])*/ "\(lvlScore[i-1]) / \(levelStars[i-1][2])"
            //print(lvlScore[i-1])
        }
        
        
        x = 1
        y = 1
        z = 1
        
        for i in 1...lvl2Score.count {
            let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
            scoreLabel.name = "score2LvlLabel"
            ///scoreLabel.text = "\(23)"
            
            //lvlButton.size = self.size
            if i <= 3 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * i), y: self.size.height * 0.80 - CGFloat(180) - CGFloat(30))
            } else if i <= 6 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(350) - CGFloat(240))
                x += 1
            } else if i <= 9 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(700) - CGFloat(260))
                y += 1
            } else if i <= 12 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1050) - CGFloat(290))
                z += 1
            }
            
            scoreLabel.fontSize = 40
            scoreLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
            //scoreLabel.fontSize = 80
            //scoreLabel.fontColor = UIColor.white
            scoreLabel.zPosition = -99
            scoreLabel.alpha = 0.0
            self.addChild(scoreLabel)
            
            scoreLabel.text = /*String(lvl2Score[i-1])*/ "\(lvl2Score[i-1]) / \(level2Stars[i-1][2]) "
            //scoreLabel.text = "\(23)"
            //print(lvlScore[i-1])
        }
        
        
        x = 1
        y = 1
        z = 1
        
        for i in 1...lvl3Score.count {
            let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
            scoreLabel.name = "score3LvlLabel"
            ///scoreLabel.text = "\(23)"
            
            //lvlButton.size = self.size
            if i <= 3 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * i), y: self.size.height * 0.80 - CGFloat(180) - CGFloat(30))
            } else if i <= 6 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(350) - CGFloat(240))
                x += 1
            } else if i <= 9 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(700) - CGFloat(260))
                y += 1
            } else if i <= 12 {
                scoreLabel.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1050) - CGFloat(290))
                z += 1
            }
            
            scoreLabel.fontSize = 40
            scoreLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
            //scoreLabel.fontSize = 80
            //scoreLabel.fontColor = UIColor.white
            scoreLabel.zPosition = -99
            scoreLabel.alpha = 0.0
            self.addChild(scoreLabel)
            
            scoreLabel.text = /*String(lvl2Score[i-1])*/ "\(lvl3Score[i-1]) / \(level3Stars[i-1][2]) "
            //scoreLabel.text = "\(23)"
            //print(lvlScore[i-1])
        }
        
    }
    
    private func backToMenuButtonsSetup() {
        
        let backToMenuButton = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        backToMenuButton.name = "Back to menu"
        backToMenuButton.fontColor = UIColor.white//UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
        if preferredLanguage == .ch || preferredLanguage == .jp {
            backToMenuButton.fontSize = 85
        } else {
            backToMenuButton.fontSize = 70
        }
        if preferredLanguage == .ru {
            backToMenuButton.text = "НА3АД"
        } else if preferredLanguage == .ch {
            backToMenuButton.text = "后退"
        } else if preferredLanguage == .es {
            backToMenuButton.text = "Atrás"
        } else if preferredLanguage == .jp {
            backToMenuButton.text = "戻る"
        } else if preferredLanguage == .fr {
            backToMenuButton.text = "Retour"
        } else if preferredLanguage == .gr {
            backToMenuButton.text = "Zurück"
        } else {
            backToMenuButton.text = "BACK"
        }
        
        backToMenuButton.position = CGPoint(x: self.size.width * 0.26, y: self.size.height * 0.94)
        backToMenuButton.zPosition = 1
        
        let backgroundForLabel = SKSpriteNode(imageNamed: "backBackground5")
        backgroundForLabel.name = "backBackground"
        backgroundForLabel.position = backToMenuButton.position
        backgroundForLabel.zPosition = backToMenuButton.zPosition - 1
        
        
//        backToMenuButton.xScale += 0.4
//        backToMenuButton.yScale += 0.4
        self.addChild(backToMenuButton)
        self.addChild(backgroundForLabel)
    }
    
    private func scaleButton(button: SKSpriteNode) {
        button.xScale -= 0.4
        button.yScale -= 0.4
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !levelButtonTouched {
            for touch in touches {
                let location = touch.location(in: self)
                if lvlsPage == 1 {
                    gameMode = GameMode.normal
                    if atPoint(location).name == "lvl1ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[0] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            //atPoint(location).colori
                            startNewAcitivityIndicator()
                            level = 0  // 1
                            planet = 1
                            timerFunc()
                            //nextLevelFunc()
                            //presentScene(sceneName: "Game scene")
                        }
                        
                    } else if atPoint(location).name == "lvl2ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[1] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            planet = 1
                            level = 1 // 2
                            
                            
                            timerFunc()
                            //print("level2")
                        }
                    } else if atPoint(location).name == "lvl3ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[2] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            planet = 1
                            level = 2 //3
                            
                            
                            timerFunc()
                            //print("level3")
                        }
                    } else if atPoint(location).name == "lvl4ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[3] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 3 //4
                            planet = 1
                            
                            
                            timerFunc()
                            //print("level4")
                        }
                    } else if atPoint(location).name == "lvl5ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[4] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 4 //5
                            planet = 1
                            
                            
                            timerFunc()
                            //print("level5")
                        }
                    } else if atPoint(location).name == "lvl6ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[5] == 1 && paidLevel[5] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 5 //6
                            planet = 1
                            
                            
                            timerFunc()
                            //print("level6")
                        }
                    } else if atPoint(location).name == "lvl7ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[6] == 1 && paidLevel[6] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 6 //7
                            planet = 1
                            
                            
                            timerFunc()
                            //print("level7")
                        }
                    } else if atPoint(location).name == "lvl8ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[7] == 1 && paidLevel[7] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 7 //8
                            planet = 1
                            
                            
                            timerFunc()
                            //print("level8")
                        }
                    } else if atPoint(location).name == "lvl9ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[8] == 1 && paidLevel[8] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 8 //9
                            planet = 1
                            
                            
                            timerFunc()
                            //print("level9")
                        }
                    } else if atPoint(location).name == "lvl10ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[9] == 1 && paidLevel[9] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 9 //10
                            planet = 1
                            
                            
                            timerFunc()
                            //print("level10")
                        }
                    } else if atPoint(location).name == "lvl11ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[10] == 1 && paidLevel[10] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 10 //11
                            planet = 1
                            
                            
                            timerFunc()
                            //print("level11")
                        }
                    } else if atPoint(location).name == "lvl12ButtonONE" && atPoint(location) == firstTouchButton {
                        if activeLevel[11] == 1 && paidLevel[11] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 11 //12
                            planet = 1
                            
                            
                            timerFunc()
                            //     print("level12")
                        }
                        // lvl\(i)ButtonTWO
                    } /*else if atPoint(location).name == "Back to menu" && atPoint(location) == firstTouchBackButton || atPoint(location).name == "backBackground" && atPoint(location) == firstTouchBackButton {
                        //level = 11 //12
                        presentScene(sceneName: "Menu scene")
                        //print("level12")  backBackground
                    }*/
                } else if lvlsPage == 2 {                                                              // SECOND PLANET ---------------------------
                    gameMode = GameMode.normal
                    /*if atPoint(location).name == "Back to menu" && atPoint(location) == firstTouchBackButton || atPoint(location).name == "backBackground" && atPoint(location) == firstTouchBackButton {
                        //level = 11 //12
                        presentScene(sceneName: "Menu scene")
                        //print("level12")
                    } else*/ if atPoint(location).name == "lvl1ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[0] == 1 && paid2Level[0] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 0 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    } else if atPoint(location).name == "lvl2ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[1] == 1 && paid2Level[1] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 1 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl3ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[2] == 1 && paid2Level[2] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 2 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl4ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[3] == 1 && paid2Level[3] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 3 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl5ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[4] == 1 && paid2Level[4] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 4 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl6ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[5] == 1 && paid2Level[5] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 5 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl7ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[6] == 1 && paid2Level[6] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 6 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl8ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[7] == 1 && paid2Level[7] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 7 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl9ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[8] == 1 && paid2Level[8] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 8 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl10ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[9] == 1 && paid2Level[9] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 9 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }   else if atPoint(location).name == "lvl11ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[10] == 1 && paid2Level[10] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 10 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }   else if atPoint(location).name == "lvl12ButtonTWO" && atPoint(location) == firstTouchButton {
                        if active2Level[11] == 1 && paid2Level[11] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 11 //1
                            planet = 2
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }
                } else if lvlsPage == 3 {                                                              //  THIRD PLANET ---------------------------
                    gameMode = GameMode.normal
                    /* if atPoint(location).name == "Back to menu" && atPoint(location) == firstTouchBackButton || atPoint(location).name == "backBackground" && atPoint(location) == firstTouchBackButton {
                        //level = 11 //12
                        presentScene(sceneName: "Menu scene")
                        //print("level12")
                    } else */ if atPoint(location).name == "lvl1ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[0] == 1 && paid3Level[0] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 0 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    } else if atPoint(location).name == "lvl2ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[1] == 1 && paid3Level[1] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 1 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl3ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[2] == 1 && paid3Level[2] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 2 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl4ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[3] == 1 && paid3Level[3] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 3 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl5ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[4] == 1 && paid3Level[4] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 4 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl6ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[5] == 1 && paid3Level[5] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 5 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl7ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[6] == 1 && paid3Level[6] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 6 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl8ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[7] == 1 && paid3Level[7] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 7 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl9ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[8] == 1 && paid3Level[8] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 8 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }  else if atPoint(location).name == "lvl10ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[9] == 1 && paid3Level[9] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 9 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }   else if atPoint(location).name == "lvl11ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[10] == 1 && paid3Level[10] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 10 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }   else if atPoint(location).name == "lvl12ButtonTREE" && atPoint(location) == firstTouchButton {
                        if active3Level[11] == 1 && paid3Level[11] == 1 {
                            scaleButton(button: atPoint(location) as! SKSpriteNode)
                            startNewAcitivityIndicator()
                            level = 11 //1
                            planet = 3
                            
                            timerFunc()
                            //print("level1 Planet 2")
                        }
                        // lvl\(i)ButtonTWO
                    }
                } else if lvlsPage == 4 {                                                              //  THIRD PLANET ---------------------------
                    /*if atPoint(location).name == "Back to menu" && atPoint(location) == firstTouchBackButton || atPoint(location).name == "backBackground" && atPoint(location) == firstTouchBackButton {
                        //changePlanetOnFourAndFive()
                        //level = 11 //12
                        presentScene(sceneName: "Menu scene")
                        //print("level12")
                    }*/
                }  else if lvlsPage == 5 {
                    gameMode = GameMode.survival
                    /*if atPoint(location).name == "Back to menu" && atPoint(location) == firstTouchBackButton || atPoint(location).name == "backBackground" && atPoint(location) == firstTouchBackButton {
                        //changePlanetOnFourAndFive()
                        //level = 11 //12
                        presentScene(sceneName: "Menu scene")
                        //print("level12")
                    } else */ if atPoint(location).name == "suvivalMode" && atPoint(location) == firstTouchButton {
                        scaleButton(button: atPoint(location) as! SKSpriteNode)
                        startNewAcitivityIndicator()
                        level = 51
                        planet = 5
                        timerFunc()
                        
                    }
                }
                
                
                
            }
        }
    }
    
    var firstTouchButton: SKSpriteNode?
    var firstTouchBackButton: SKLabelNode?
    var levelButtonTouched: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if lvlsPage == 1 {
                gameMode = GameMode.normal
                if atPoint(location).name == "lvl1ButtonONE" {
                    if activeLevel[0] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl2ButtonONE" {
                    if activeLevel[1] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl3ButtonONE" {
                    if activeLevel[2] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl4ButtonONE" {
                    if activeLevel[3] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl5ButtonONE" {
                    if activeLevel[4] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl6ButtonONE" {
                    if activeLevel[5] == 1 && paidLevel[5] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl7ButtonONE" {
                    if activeLevel[6] == 1 && paidLevel[6] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl8ButtonONE" {
                    if activeLevel[7] == 1 && paidLevel[7] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl9ButtonONE" {
                    if activeLevel[8] == 1 && paidLevel[8] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl10ButtonONE" {
                    if activeLevel[9] == 1 && paidLevel[9] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl11ButtonONE" {
                    if activeLevel[10] == 1 && paidLevel[10] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                } else if atPoint(location).name == "lvl12ButtonONE" {
                    if activeLevel[11] == 1 && paidLevel[11] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                } else if atPoint(location).name == "Back to menu" || atPoint(location).name == "backBackground" {
                    //firstTouchBackButton = atPoint(location) as? SKLabelNode
                    presentScene(sceneName: "Menu scene")
                }
            } else if lvlsPage == 2 {                                                              // SECOND PLANET --------------------------- backBackground
                gameMode = GameMode.normal
                if atPoint(location).name == "Back to menu" || atPoint(location).name == "backBackground" {
                    //firstTouchBackButton = atPoint(location) as? SKLabelNode
                    presentScene(sceneName: "Menu scene")
                } else if atPoint(location).name == "lvl1ButtonTWO" {
                    if active2Level[0] == 1 && paid2Level[0] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                } else if atPoint(location).name == "lvl2ButtonTWO" {
                    if active2Level[1] == 1 && paid2Level[1] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl3ButtonTWO" {
                    if active2Level[2] == 1 && paid2Level[2] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl4ButtonTWO" {
                    if active2Level[3] == 1 && paid2Level[3] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl5ButtonTWO" {
                    if active2Level[4] == 1 && paid2Level[4] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl6ButtonTWO" {
                    if active2Level[5] == 1 && paid2Level[5] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl7ButtonTWO" {
                    if active2Level[6] == 1 && paid2Level[6] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl8ButtonTWO" {
                    if active2Level[7] == 1 && paid2Level[7] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl9ButtonTWO" {
                    if active2Level[8] == 1 && paid2Level[8] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl10ButtonTWO" {
                    if active2Level[9] == 1 && paid2Level[9] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }   else if atPoint(location).name == "lvl11ButtonTWO" {
                    if active2Level[10] == 1 && paid2Level[10] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }   else if atPoint(location).name == "lvl12ButtonTWO" {
                    if active2Level[11] == 1 && paid2Level[11] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }
            } else if lvlsPage == 3 {                                                              //  THIRD PLANET ---------------------------
                gameMode = GameMode.normal
                if atPoint(location).name == "Back to menu" || atPoint(location).name == "backBackground" {
                    //firstTouchBackButton = atPoint(location) as? SKLabelNode
                    presentScene(sceneName: "Menu scene")
                } else if atPoint(location).name == "lvl1ButtonTREE" {
                    if active3Level[0] == 1 && paid3Level[0] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                } else if atPoint(location).name == "lvl2ButtonTREE" {
                    if active3Level[1] == 1 && paid3Level[1] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl3ButtonTREE" {
                    if active3Level[2] == 1 && paid3Level[2] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl4ButtonTREE" {
                    if active3Level[3] == 1 && paid3Level[3] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl5ButtonTREE" {
                    if active3Level[4] == 1 && paid3Level[4] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl6ButtonTREE" {
                    if active3Level[5] == 1 && paid3Level[5] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl7ButtonTREE" {
                    if active3Level[6] == 1 && paid3Level[6] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl8ButtonTREE" {
                    if active3Level[7] == 1 && paid3Level[7] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl9ButtonTREE" {
                    if active3Level[8] == 1 && paid3Level[8] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl10ButtonTREE" {
                    if active3Level[9] == 1 && paid3Level[9] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }   else if atPoint(location).name == "lvl11ButtonTREE" {
                    if active3Level[10] == 1 && paid3Level[10] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }   else if atPoint(location).name == "lvl12ButtonTREE" {
                    if active3Level[11] == 1 && paid3Level[11] == 1 {
                        firstTouchButton = atPoint(location) as? SKSpriteNode
                    }
                    // lvl\(i)ButtonTWO
                }
            } else if lvlsPage == 4 {                                                              //  THIRD PLANET ---------------------------
                if atPoint(location).name == "Back to menu" || atPoint(location).name == "backBackground" {
                    //firstTouchBackButton = atPoint(location) as? SKLabelNode
                    presentScene(sceneName: "Menu scene")
                }
            }  else if lvlsPage == 5 {
                gameMode = GameMode.survival
                if atPoint(location).name == "Back to menu" || atPoint(location).name == "backBackground" {
                    //firstTouchBackButton = atPoint(location) as? SKLabelNode
                    presentScene(sceneName: "Menu scene")
                } else if atPoint(location).name == "suvivalMode" {
                    firstTouchButton = atPoint(location) as? SKSpriteNode
                    
                }
            }
            
            
            
        }
        
    }

    private func timerFunc() {
        levelButtonTouched = true
        removeGestureRocognizers()
        _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.0), target: self, selector: #selector(LevelsScene.nextLevelTimerFunc), userInfo: nil, repeats: false)
    }
    
    @objc private func nextLevelTimerFunc() {
        nextLevelFunc()
        presentScene(sceneName: "Game scene")
    }
    
    private func changePlanetOnFourAndFive() {
        
        if planet == 4 || planet == 5 {
            planet = 3
        }
        
    }
    
    private func clean() {
        self.removeAllActions()
    }
    
    private func presentScene(sceneName: String) {
        clean()
        //changePlanetOnFourAndFive()
         
        var scene: SKScene = SKScene()
        if sceneName == "Game scene" {
            scene = GameScene(size: CGSize(width: 1536, height: 2048))
        } else if sceneName == "Menu scene" {
            scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        } else {
            // do nothingy
        }
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        if sceneName == "Game scene" {
            _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(LevelsScene.nextLevelPresentSceneFunc), userInfo: ["newScene" : scene], repeats: false)
        } else {
            
            
            let newGameTransition = SKTransition.reveal(with: SKTransitionDirection.up, duration: 0.7)//moveIn(with: SKTransitionDirection.left, duration: 2) //doorsCloseHorizontal(withDuration: 0.5)
            
            
            // Present the scene
            view?.presentScene(scene, transition: newGameTransition)
            
            
            
            if #available(iOS 10.0, *) {
                view?.preferredFramesPerSecond = 60
            } else {
                // Fallback on earlier versions
            }
        }
 
    }
    
    @objc private func nextLevelPresentSceneFunc(timer: Timer) {
        let userInfo = timer.userInfo as! Dictionary<String, Any>
        let scene: GameScene = (userInfo["newScene"] as! GameScene)
        
        
        //let newGameTransition = SKTransition.reveal(with: SKTransitionDirection.up, duration: 1.7)
        //let newGameTransition = SKTransition.fade(withDuration: 1.7)
        let newGameTransition = SKTransition.crossFade(withDuration: 1.4)
        
        view?.presentScene(scene, transition: newGameTransition)
        
        if #available(iOS 10.0, *) {
            view?.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    deinit {
        //print("level deinit")
        self.view?.gestureRecognizers?.removeAll()
        stopNewAcitvityIndicator()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}   //class
