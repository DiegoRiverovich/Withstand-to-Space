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
    
    var buttons1LvlArray = [SKSpriteNode]()
    var buttons2LvlArray = [SKSpriteNode]()
    
    let arrowLeft = SKSpriteNode(imageNamed: "lvlsArrowLeft")
    let arrowRight = SKSpriteNode(imageNamed: "lvlsArrowRight")
    
    let dotLeft = SKSpriteNode(imageNamed: "lvlMenuDot")
    let dotRight = SKSpriteNode(imageNamed: "lvlMenuDot")
    
    let backgroundPlanet = SKSpriteNode(imageNamed: "planet01_900")
    let backgroundPlanet2 = SKSpriteNode(imageNamed: "venus")
    
    let movingBackground = SKSpriteNode(imageNamed: "backgroundPngStars2")
    
    override func didMove(to view: SKView) {
        loadMainScene()
    }
    
    //var scrollViewVar: UIScrollView?
    
    func loadMainScene() {
        
        backgroundSetup()
        levelButtonsSetup()
        level2ButtonsSetup()
        levelsLabel()
        scoreLableSetup()
        
        backToMenuButtonsSetup()
        setupRecognizers()
        
        lvlsPage = 1
        
        print(lvlsPage)
        
        addArrosAndDots()
        
        backgroundPlanetSetup()
        movingBackgroundSetup()
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
        self.addChild(backgroundPlanet)
        
        //let backgroundPlanet2 = SKSpriteNode(imageNamed: "venus")
        //backgroundPlanet.size = self.size
        backgroundPlanet2.position = CGPoint(x: self.size.width * 3, y: self.size.height * (-0.2))
        backgroundPlanet2.zPosition = -100
        backgroundPlanet2.alpha = 0.0
        self.addChild(backgroundPlanet2)
    }
    
    // MARK: Arrows and dots
    
    func addArrosAndDots() {
        
        arrowLeft.position = CGPoint(x: ((self.size.width/2) - 230), y: self.size.height * 0.08)
        arrowLeft.zPosition = -99
        arrowLeft.xScale = 0.7
        arrowLeft.yScale = 0.7
        arrowLeft.alpha = 0.5
        self.addChild(arrowLeft)
        
        arrowRight.position = CGPoint(x: ((self.size.width/2) + 230), y: self.size.height * 0.08)
        arrowRight.zPosition = -99
        arrowRight.xScale = 0.7
        arrowRight.yScale = 0.7
        self.addChild(arrowRight)
        
       
        dotLeft.position = CGPoint(x: ((self.size.width/2) - 30), y: self.size.height * 0.08)
        dotLeft.zPosition = -99
        self.addChild(dotLeft)
        
        dotRight.position = CGPoint(x: ((self.size.width/2) + 30), y: self.size.height * 0.08)
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
            
            
            
//            enumerateChildNodes(withName: "lvlButton") { (node, _) in
//                if node.name == "lvlButton" {
//                    let moveNodeAction = SKAction.move(to: CGPoint(x: node.position.x + 100 , y: node.position.y) , duration:0.1)
//                    let fadeNodeAction = SKAction.fadeIn(withDuration: 0.1)
//                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
//                    node.run(groupAction)
//                    //node.isHidden = false
//                    //node.zPosition += 1
//                    //node.speed = 0.0
//                    //print("lvl1Action")
//                }
//            }
//
//            enumerateChildNodes(withName: "lvl2Button") { (node, _) in
//                if node.name == "lvl2Button" {
//                    let moveNodeAction = SKAction.move(to: CGPoint(x: node.position.x + 100 , y: node.position.y) , duration:0.1)
//                    let fadeNodeAction = SKAction.fadeOut(withDuration: 0.1)
//                    let groupAction = SKAction.group([moveNodeAction, fadeNodeAction])
//                    node.run(groupAction)
//                    //node.isHidden = true
//                    //node.zPosition -= 1
//                    //node.speed = 0.0
//                    //print("lvl2Action")
//                }
//            }
            lvlsPage = 1
            
            let fadeStarsAnimOut = SKAction.fadeOut(withDuration: 0.1)
            let fadeStarsAnimIn = SKAction.fadeIn(withDuration: 0.1)
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
            
            let fadeLabelAnimOut = SKAction.fadeOut(withDuration: 0.1)
            let fadeLabelAnimIn = SKAction.fadeIn(withDuration: 0.1)
            
            enumerateChildNodes(withName: "score2LvlLabel") { (node, _) in
                node.run(fadeLabelAnimOut)
                
            }
            
            enumerateChildNodes(withName: "score1LvlLabel") { (node, _) in
                node.run(fadeLabelAnimIn)
                
            }
            
            
            arrowLeft.alpha = 0.5
            arrowRight.alpha = 1.0
            dotRight.alpha = 0.5
            dotLeft.alpha = 1.0
            
            //backgroundPlanet.alpha = 1.0
            //backgroundPlanet2.alpha = 0.0
            
            //P1 CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
            //P2 CGPoint(x: self.size.width/2, y: self.size.height * (-0.2))
            
            let movePlane1Action = SKAction.move(to: CGPoint(x: self.size.width * 0.7, y: self.size.height * 1) , duration: 0.5)
            let fadePlanet1Action = SKAction.fadeIn(withDuration: 0.1)
            let planet1GroupAction = SKAction.group([movePlane1Action, fadePlanet1Action])
            
            let movePlanet2Action = SKAction.move(to: CGPoint(x: self.size.width * 4, y: self.size.height * (-0.2)) , duration: 0.5)
            let fadePlanet2Action = SKAction.fadeOut(withDuration: 0.1)
            let planet2GroupAction = SKAction.group([movePlanet2Action, fadePlanet2Action])
            
            backgroundPlanet.run(planet1GroupAction)
            backgroundPlanet2.run(planet2GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x - 100, duration: 0.5)
            movingBackground.run(moveBackground)
            
            
            
            
        } else {
            // do nothing
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
            
            let fadeStarsAnimOut = SKAction.fadeOut(withDuration: 0.1)
            let fadeStarsAnimIn = SKAction.fadeIn(withDuration: 0.1)
            
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
            
            
            let fadeLabelAnimOut = SKAction.fadeOut(withDuration: 0.1)
            let fadeLabelAnimIn = SKAction.fadeIn(withDuration: 0.1)
            
            enumerateChildNodes(withName: "score1LvlLabel") { (node, _) in
                node.run(fadeLabelAnimOut)

            }

            enumerateChildNodes(withName: "score2LvlLabel") { (node, _) in
                node.run(fadeLabelAnimIn)

            }
            
            arrowLeft.alpha = 1.0
            arrowRight.alpha = 0.5
            dotRight.alpha = 1.0
            dotLeft.alpha = 0.5
            
            //backgroundPlanet.alpha = 0.0
            //backgroundPlanet2.alpha = 1.0
            
            
            //P1 CGPoint(x: self.size.width * 0.7, y: self.size.height * 1)
            //P2 CGPoint(x: self.size.width/2, y: self.size.height * (-0.2))
            
            let movePlane1Action = SKAction.move(to: CGPoint(x: self.size.width * (-3), y: self.size.height * 1) , duration: 0.5)
            let fadePlanet1Action = SKAction.fadeOut(withDuration: 0.1)
            let planet1GroupAction = SKAction.group([movePlane1Action, fadePlanet1Action])
            
            let movePlanet2Action = SKAction.move(to: CGPoint(x: self.size.width/2, y: self.size.height * (-0.2)) , duration: 0.5)
            let fadePlanet2Action = SKAction.fadeIn(withDuration: 0.1)
            let planet2GroupAction = SKAction.group([movePlanet2Action, fadePlanet2Action])
            
            backgroundPlanet.run(planet1GroupAction)
            backgroundPlanet2.run(planet2GroupAction)
            
            let moveBackground = SKAction.moveTo(x: movingBackground.position.x + 100, duration: 0.5)
            movingBackground.run(moveBackground)
            
        } else {
            // do nothing
        }
        print("swipe left")
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
                if activeLevel[i-1] == 1 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                } else {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    lvlButton.alpha = 0.5
                }
                y += 1
            } else if i <= 12 {
                if activeLevel[i-1] == 1 {
                    lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                } else {
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
                if active2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                } else {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * i), y: self.size.height * 0.80)
                    lvl2Button.alpha = 0.5
                }
            } else if i <= 6 {
                if active2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                } else {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * x), y: self.size.height * 0.80 - CGFloat(380))
                    lvl2Button.alpha = 0.5
                }
                x += 1
            } else if i <= 9 {
                if active2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                } else {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1 ) + 100) + CGFloat(300 * y), y: self.size.height * 0.80 - CGFloat(750))
                    lvl2Button.alpha = 0.5
                }
                y += 1
            } else if i <= 12 {
                if active2Level[i-1] == 1 {
                    lvl2Button.position = CGPoint(x: ((self.size.width * 0.1) + 100) + CGFloat(300 * z), y: self.size.height * 0.80 - CGFloat(1120))
                } else {
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
    
    func scoreStars(index: Int, button: SKSpriteNode) {
        var score: Int = 0
        if button.name!.contains("ONE") /*== "lvlButton"*/ {
            score = lvlScore[index-1]
        } else if button.name!.contains("TWO") /*== "lvl2Button"*/ {
            score = lvl2Score[index-1]
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
            scoreLabel.text = "\(23)"
            
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
            
            scoreLabel.text = String(lvlScore[i-1])
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
            
            scoreLabel.text = String(lvlScore[i-1])
            scoreLabel.text = "\(23)"
            //print(lvlScore[i-1])
        }
        
    }
    
    func backToMenuButtonsSetup() {
        
        let backToMenuButton = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        backToMenuButton.name = "Back to menu"
        backToMenuButton.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white //UIColor.white
        if preferredLanguage == .ru {
            backToMenuButton.text = "НАЗАД"
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
                if atPoint(location).name == "lvl1ButtonONE" {
                    if activeLevel[0] == 1 {
                        level = 0  // 1
                        planet = 1
                        //                    canMoveUpAndDown = false
                        //                    hintLevel = true
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 59
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .middleHigh
                        //                    partitionSpeedLow = .middleLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 15
                        //                    scoreThreeStars = 22
                        //
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                    }
                    
                } else if atPoint(location).name == "lvl2ButtonONE" {
                    if activeLevel[1] == 1 {
                        planet = 1
                        level = 1 // 2
                        //                    canMoveUpAndDown = false
                        //                    hintLevel = false
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 59
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .middleHigh
                        //                    partitionSpeedLow = .middleLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 20
                        //                    scoreThreeStars = 23
                        
                        
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level2")
                    }
                } else if atPoint(location).name == "lvl3ButtonONE" {
                    if activeLevel[2] == 1 {
                        planet = 1
                        level = 2 //3
                        
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = true
                        //                    onlyTopLevel = true
                        //                    constructionLevelDurationTimerInterval = 59
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .middleHigh
                        //                    partitionSpeedLow = .middleLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 26
                        //                    scoreThreeStars = 28
                        //
                        //
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level3")
                    }
                } else if atPoint(location).name == "lvl4ButtonONE" {
                    if activeLevel[3] == 1 {
                        level = 3 //4
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = false
                        //                    onlyTopLevel = true
                        //                    constructionLevelDurationTimerInterval = 59
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .middleHigh
                        //                    partitionSpeedLow = .middleLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 29
                        //                    scoreThreeStars = 34
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level4")
                    }
                } else if atPoint(location).name == "lvl5ButtonONE" {
                    if activeLevel[4] == 1 {
                        level = 4 //5
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = true
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 59
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .middleHigh
                        //                    partitionSpeedLow = .middleLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 29
                        //                    scoreThreeStars = 34
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level5")
                    }
                } else if atPoint(location).name == "lvl6ButtonONE" {
                    if activeLevel[5] == 1 {
                        level = 5 //6
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = false
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 59
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .middleHigh
                        //                    partitionSpeedLow = .middleLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 30
                        //                    scoreThreeStars = 35
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level6")
                    }
                } else if atPoint(location).name == "lvl7ButtonONE" {
                    if activeLevel[6] == 1 {
                        level = 6 //7
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = false
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 59
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .middleHigh
                        //                    partitionSpeedLow = .middleLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    scoreOneStar = 4
                        //                    scoreTwoStar = 10
                        //                    scoreThreeStars = 12
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level7")
                    }
                } else if atPoint(location).name == "lvl8ButtonONE" {
                    if activeLevel[7] == 1 {
                        level = 7 //8
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = true
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 34
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .slowHigh
                        //                    partitionSpeedLow = .slowLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    scoreOneStar = 9
                        //                    scoreTwoStar = 11
                        //                    scoreThreeStars = 13
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level8")
                    }
                } else if atPoint(location).name == "lvl9ButtonONE" {
                    if activeLevel[8] == 1 {
                        level = 8 //9
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = true
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 34
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .slowHigh
                        //                    partitionSpeedLow = .slowLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    showTrioSP = true
                        //                    showRougeSP = false
                        //                    showInvisibleSP = false
                        //
                        //                    scoreOneStar = 9
                        //                    scoreTwoStar = 11
                        //                    scoreThreeStars = 13
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level9")
                    }
                } else if atPoint(location).name == "lvl10ButtonONE" {
                    if activeLevel[9] == 1 {
                        level = 9 //10
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = true
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 34
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .slowHigh
                        //                    partitionSpeedLow = .slowLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    showTrioSP = false
                        //                    showRougeSP = true
                        //                    showInvisibleSP = false
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 12
                        //                    scoreThreeStars = 14
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level10")
                    }
                } else if atPoint(location).name == "lvl11ButtonONE" {
                    if activeLevel[10] == 1 {
                        level = 10 //11
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = true
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 34
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .slowHigh
                        //                    partitionSpeedLow = .slowLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    showTrioSP = false
                        //                    showRougeSP = false
                        //                    showInvisibleSP = true
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 12
                        //                    scoreThreeStars = 14
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level11")
                    }
                } else if atPoint(location).name == "lvl12ButtonONE" {
                    if activeLevel[11] == 1 {
                        level = 11 //12
                        planet = 1
                        
                        //                    canMoveUpAndDown = true
                        //                    hintLevel = false
                        //                    onlyTopLevel = false
                        //                    constructionLevelDurationTimerInterval = 34
                        //                    debrisSpeed = .slow
                        //                    partitionSpeedHigh = .slowHigh
                        //                    partitionSpeedLow = .slowLow
                        //                    shipSpeedMovement = .slow
                        //
                        //                    showTrioSP = true
                        //                    showRougeSP = true
                        //                    showInvisibleSP = true
                        //
                        //                    scoreOneStar = 10
                        //                    scoreTwoStar = 14
                        //                    scoreThreeStars = 16
                        //
                        //                    presentScene(sceneName: "Game scene")
                        nextLevelFunc()
                        presentScene(sceneName: "Game scene")
                        print("level12")
                    }
                } else if atPoint(location).name == "Back to menu" {
                    //level = 11 //12
                    presentScene(sceneName: "Menu scene")
                    //print("level12")
                }
            } else if lvlsPage == 2 {
                if atPoint(location).name == "Back to menu" {
                    //level = 11 //12
                    presentScene(sceneName: "Menu scene")
                    //print("level12")
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
