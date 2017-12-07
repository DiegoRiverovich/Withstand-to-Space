//
//  LevelsScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 15.10.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit

class LevelsScene: SKScene {
    
    // Swige gestures
    let swipeRightRecLvl = UISwipeGestureRecognizer()
    let swipeLeftRecLvl = UISwipeGestureRecognizer()
    
    var stars1LvlArray = [SKSpriteNode]()
    var stars2LvlArray = [SKSpriteNode]()
    var stars3LvlArray = [SKSpriteNode]()
    
    var buttons1LvlArray = [SKSpriteNode]()
    var buttons2LvlArray = [SKSpriteNode]()
    var buttons3LvlArray = [SKSpriteNode]()
    
    let arrowLeft = SKSpriteNode(imageNamed: "lvlsArrowLeft")
    let arrowRight = SKSpriteNode(imageNamed: "lvlsArrowRight")
    
    let dotLeft = SKSpriteNode(imageNamed: "lvlMenuDot")
    let dotLeft1 = SKSpriteNode(imageNamed: "lvlMenuDot")
    let dotCenter = SKSpriteNode(imageNamed: "lvlMenuDot")
    let dotRight1 = SKSpriteNode(imageNamed: "lvlMenuDot")
    let dotRight = SKSpriteNode(imageNamed: "lvlMenuDot")
    
    let backgroundPlanet = SKSpriteNode(imageNamed: "planet01_400")
    let backgroundPlanet2 = SKSpriteNode(imageNamed: "venus_500")
    let backgroundPlanet3 = SKSpriteNode(imageNamed: "planet_31")
    let backgroundPlanet4 = SKSpriteNode(imageNamed: "planet_411")
    let backgroundAsteroid5 = SKSpriteNode(imageNamed: "Asteroids")
    
    var comingSoonNode = SKSpriteNode(imageNamed: "comingSoonLogo")
    var infinityNode = SKSpriteNode(imageNamed: "Infinity")
    
    let movingBackground = SKSpriteNode(imageNamed: "backgroundPngStars2")
    
    override func didMove(to view: SKView) {
        loadMainScene()
    }
    
    //var scrollViewVar: UIScrollView?
    
    func loadMainScene() {
        
        backgroundSetup()
        levelButtonsSetup()
        level2ButtonsSetup()
        level3ButtonsSetup()
        levelsLabel()
        scoreLableSetup()
        
        backToMenuButtonsSetup()
        setupRecognizers()
        
        lvlsPage = 1
        
        print(lvlsPage)
        
        addArrosAndDots()
        
        backgroundPlanetSetup()
        movingBackgroundSetup()
        
        comingSoonFunc()
        infinityFunc()
    }
    
    // MARK: Coming soon setup
    func comingSoonFunc() {
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
    func infinityFunc() {
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
    func movingBackgroundSetup() {
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
    func backgroundPlanetSetup() {
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
    
    func addArrosAndDots() {
        
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
    func setupRecognizers() {
        
        //RIGHT
        swipeRightRecLvl.addTarget(self, action: #selector(LevelsScene.swipeRight))
        swipeRightRecLvl.direction = .right
        self.view?.addGestureRecognizer(swipeRightRecLvl)
        //LEFT
        swipeLeftRecLvl.addTarget(self, action: #selector(LevelsScene.swipeLeft))
        swipeLeftRecLvl.direction = .left
        self.view?.addGestureRecognizer(swipeLeftRecLvl)

    }
    
    @objc func swipeRight() {
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
                    if activeLevel[i-1] == 1 {
                        fadeNodeAction = SKAction.fadeIn(withDuration: 0.1)
                    } else {
                        fadeNodeAction = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
                    }
                    
                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
                    
                    button.run(groupAction)
                }
            }
            
            lvlsPage = 2
            
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
        print("swipe right")
    }
    
    @objc func swipeLeft() {
        
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
                print("button3LvlArtay not empty")
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
    func backgroundSetup() {
         let background = SKSpriteNode(imageNamed: "backgroundStars")
         background.size = self.size
         background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
         background.zPosition = -102
         self.addChild(background)
    }
    
    func levelsLabel() {
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
    
    func levelButtonsSetup() {
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
    
    func level2ButtonsSetup() {
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
    
    func level3ButtonsSetup() {
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
    
    
    func scoreStars(index: Int, button: SKSpriteNode) {
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
            print("zore")
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
            print("one")
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
            print("two")
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
            print("three")
        }
    }
    
    func scoreLableSetup() {
        
        var x = 1
        var y = 1
        var z = 1
        
        for i in 1...lvlScore.count {
            let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontName)
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
            
            scoreLabel.fontSize = 80
            scoreLabel.fontColor = UIColor.white
            scoreLabel.zPosition = -99
            self.addChild(scoreLabel)
            
            scoreLabel.text = /*String(lvlScore[i-1])*/ "\(lvlScore[i-1]) / \(levelStars[i-1][2])"
            //print(lvlScore[i-1])
        }
        
        
        x = 1
        y = 1
        z = 1
        
        for i in 1...lvl2Score.count {
            let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontName)
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
            
            scoreLabel.fontSize = 80
            scoreLabel.fontColor = UIColor.white
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
            let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontName)
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
            
            scoreLabel.fontSize = 80
            scoreLabel.fontColor = UIColor.white
            scoreLabel.zPosition = -99
            scoreLabel.alpha = 0.0
            self.addChild(scoreLabel)
            
            scoreLabel.text = /*String(lvl2Score[i-1])*/ "\(lvl3Score[i-1]) / \(level3Stars[i-1][2]) "
            //scoreLabel.text = "\(23)"
            //print(lvlScore[i-1])
        }
        
    }
    
    func backToMenuButtonsSetup() {
        
        let backToMenuButton = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        backToMenuButton.name = "Back to menu"
        backToMenuButton.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white //UIColor.white
        if preferredLanguage == .ru {
            backToMenuButton.text = "НА3АД"
        } else if preferredLanguage == .ch {
            backToMenuButton.text = "后退"
        } else if preferredLanguage == .es {
            backToMenuButton.text = "Atrás"
        } else {
            backToMenuButton.text = "BACK"
        }
        
        backToMenuButton.position = CGPoint(x: self.size.width * 0.26, y: self.size.height * 0.94)
        backToMenuButton.zPosition = 1
        backToMenuButton.fontSize = 60
//        backToMenuButton.xScale += 0.4
//        backToMenuButton.yScale += 0.4
        self.addChild(backToMenuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if lvlsPage == 1 {
                gameMode = GameMode.normal
                if atPoint(location).name == "lvl1ButtonONE" {
                    if activeLevel[0] == 1 {
                        level = 0  // 1
                        planet = 1
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                    }
                    
                } else if atPoint(location).name == "lvl2ButtonONE" {
                    if activeLevel[1] == 1 {
                        planet = 1
                        level = 1 // 2
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level2")
                    }
                } else if atPoint(location).name == "lvl3ButtonONE" {
                    if activeLevel[2] == 1 {
                        planet = 1
                        level = 2 //3
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level3")
                    }
                } else if atPoint(location).name == "lvl4ButtonONE" {
                    if activeLevel[3] == 1 {
                        level = 3 //4
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level4")
                    }
                } else if atPoint(location).name == "lvl5ButtonONE" {
                    if activeLevel[4] == 1 {
                        level = 4 //5
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level5")
                    }
                } else if atPoint(location).name == "lvl6ButtonONE" {
                    if activeLevel[5] == 1 && paidLevel[5] == 1 {
                        level = 5 //6
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level6")
                    }
                } else if atPoint(location).name == "lvl7ButtonONE" {
                    if activeLevel[6] == 1 && paidLevel[6] == 1 {
                        level = 6 //7
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level7")
                    }
                } else if atPoint(location).name == "lvl8ButtonONE" {
                    if activeLevel[7] == 1 && paidLevel[7] == 1 {
                        level = 7 //8
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level8")
                    }
                } else if atPoint(location).name == "lvl9ButtonONE" {
                    if activeLevel[8] == 1 && paidLevel[8] == 1 {
                        level = 8 //9
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level9")
                    }
                } else if atPoint(location).name == "lvl10ButtonONE" {
                    if activeLevel[9] == 1 && paidLevel[9] == 1 {
                        level = 9 //10
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level10")
                    }
                } else if atPoint(location).name == "lvl11ButtonONE" {
                    if activeLevel[10] == 1 && paidLevel[10] == 1 {
                        level = 10 //11
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level11")
                    }
                } else if atPoint(location).name == "lvl12ButtonONE" {
                    if activeLevel[11] == 1 && paidLevel[11] == 1 {
                        level = 11 //12
                        planet = 1
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level12")
                    }
                    // lvl\(i)ButtonTWO
                } else if atPoint(location).name == "Back to menu" {
                    //level = 11 //12
                    presentScene(sceneName: "Menu scene")
                    //print("level12")
                }
            } else if lvlsPage == 2 {                                                              // SECOND PLANET ---------------------------
                gameMode = GameMode.normal
                if atPoint(location).name == "Back to menu" {
                    //level = 11 //12
                    presentScene(sceneName: "Menu scene")
                    //print("level12")
                } else if atPoint(location).name == "lvl1ButtonTWO" {
                    if active2Level[0] == 1 && paid2Level[0] == 1 {
                        level = 0 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                } else if atPoint(location).name == "lvl2ButtonTWO" {
                    if active2Level[1] == 1 && paid2Level[1] == 1 {
                        level = 1 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl3ButtonTWO" {
                    if active2Level[2] == 1 && paid2Level[2] == 1 {
                        level = 2 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl4ButtonTWO" {
                    if active2Level[3] == 1 && paid2Level[3] == 1 {
                        level = 3 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl5ButtonTWO" {
                    if active2Level[4] == 1 && paid2Level[4] == 1 {
                        level = 4 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl6ButtonTWO" {
                    if active2Level[5] == 1 && paid2Level[5] == 1 {
                        level = 5 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl7ButtonTWO" {
                    if active2Level[6] == 1 && paid2Level[6] == 1 {
                        level = 6 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl8ButtonTWO" {
                    if active2Level[7] == 1 && paid2Level[7] == 1 {
                        level = 7 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl9ButtonTWO" {
                    if active2Level[8] == 1 && paid2Level[8] == 1 {
                        level = 8 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl10ButtonTWO" {
                    if active2Level[9] == 1 && paid2Level[9] == 1 {
                        level = 9 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }   else if atPoint(location).name == "lvl11ButtonTWO" {
                    if active2Level[10] == 1 && paid2Level[10] == 1 {
                        level = 10 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }   else if atPoint(location).name == "lvl12ButtonTWO" {
                    if active2Level[11] == 1 && paid2Level[11] == 1 {
                        level = 11 //1
                        planet = 2
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }
            } else if lvlsPage == 3 {                                                              //  THIRD PLANET ---------------------------
                gameMode = GameMode.normal
                if atPoint(location).name == "Back to menu" {
                    //level = 11 //12
                    presentScene(sceneName: "Menu scene")
                    //print("level12")
                } else if atPoint(location).name == "lvl1ButtonTREE" {
                    if active3Level[0] == 1 && paid3Level[0] == 1 {
                        level = 0 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                } else if atPoint(location).name == "lvl2ButtonTREE" {
                    if active3Level[1] == 1 && paid3Level[1] == 1 {
                        level = 1 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl3ButtonTREE" {
                    if active3Level[2] == 1 && paid3Level[2] == 1 {
                        level = 2 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl4ButtonTREE" {
                    if active3Level[3] == 1 && paid3Level[3] == 1 {
                        level = 3 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl5ButtonTREE" {
                    if active3Level[4] == 1 && paid3Level[4] == 1 {
                        level = 4 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl6ButtonTREE" {
                    if active3Level[5] == 1 && paid3Level[5] == 1 {
                        level = 5 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl7ButtonTREE" {
                    if active3Level[6] == 1 && paid3Level[6] == 1 {
                        level = 6 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl8ButtonTREE" {
                    if active3Level[7] == 1 && paid3Level[7] == 1 {
                        level = 7 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl9ButtonTREE" {
                    if active3Level[8] == 1 && paid3Level[8] == 1 {
                        level = 8 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }  else if atPoint(location).name == "lvl10ButtonTREE" {
                    if active3Level[9] == 1 && paid3Level[9] == 1 {
                        level = 9 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }   else if atPoint(location).name == "lvl11ButtonTREE" {
                    if active3Level[10] == 1 && paid3Level[10] == 1 {
                        level = 10 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }   else if atPoint(location).name == "lvl12ButtonTREE" {
                    if active3Level[11] == 1 && paid3Level[11] == 1 {
                        level = 11 //1
                        planet = 3
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level1 Planet 2")
                    }
                    // lvl\(i)ButtonTWO
                }
            } else if lvlsPage == 4 {                                                              //  THIRD PLANET ---------------------------
                if atPoint(location).name == "Back to menu" {
                    //level = 11 //12
                    presentScene(sceneName: "Menu scene")
                    //print("level12")
                }
            }  else if lvlsPage == 5 {
                gameMode = GameMode.survival
                if atPoint(location).name == "Back to menu" {
                    //level = 11 //12
                    presentScene(sceneName: "Menu scene")
                    //print("level12")
                } else if atPoint(location).name == "suvivalMode" {
                    level = 51
                    planet = 5
                    nextLevelFunc()
                    presentScene(sceneName: "Game scene")
                    
                }
            }
            
            
            
        }
        
    }
    
    func presentScene(sceneName: String) {
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
        
        let newGameTransition = SKTransition.reveal(with: SKTransitionDirection.up, duration: 0.7)//moveIn(with: SKTransitionDirection.left, duration: 2) //doorsCloseHorizontal(withDuration: 0.5)
        // Present the scene
        view?.presentScene(scene, transition: newGameTransition)
        if #available(iOS 10.0, *) {
            view?.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    deinit {
        print("level deinit")
        self.view?.gestureRecognizers?.removeAll()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}   //class
