//
//  GameOverScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 25.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit
import Firebase

class GameOverScene: SKScene {
    
    var ref: DatabaseReference?
    
    let highScore = SKSpriteNode(imageNamed: "alien3")
    
    let overallHighScoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    let lvlHighScoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    
    var starsTimer: Timer?
    
    let levelScene = LevelsScene()
    
    //var userName = "SuperUser"
    
    //var highscoreTableView = HighscoreTableView(coder: NSCoder)
    
    //weak var mainScene: SKScene?
    
    
    
    override func didMove(to view: SKView) {
        loadMainScene()
        
    }
    
    override func willMove(from view: SKView) {
        //  highscoreTableView.removeFromSuperview()
    }
    
    func loadMainScene() {
        
        ref = Database.database().reference()
        
        auth()
        
        
        backgroundSetup()
        
        scoreButtonSetup()
        goToMenuButtonSetup()
        shareButtonSetup()
        
        if shipExplode {
            youLoseSetup()
            setHithScoreLabel()
            setOverallHithScoreLabel()
            
            if soundsIsOn {
                run(SKAction.playSoundFileNamed("youLoseSound.m4a", waitForCompletion: false))
            }
            
        } else {
            
            setScoreLabel()
            setHithScoreLabel()
            setOverallHithScoreLabel()
            //sethighScoreMenu()
            
            highScore.alpha = 0.0
            
            saveUserDefaults()
            
            starsTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameOverScene.addStar), userInfo: nil, repeats: false)
            auth()
            
            if soundsIsOn {
                run(SKAction.playSoundFileNamed("vicrotySound.m4a", waitForCompletion: false))
            }
            
        }
        unlockNextLevel()
        startButtonSetup()
        nextLevelButtonSetup()
        
    }
    
    // Auth
    func auth() {
        Auth.auth().signIn(withEmail: "withstandtospace@test.com", password: "123ASDasd") { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                //let defaults = UserDefaults()
                if self.isKeyPresentInUserDefaults(key: "userId") {
                    //let userId = defaults.string(forKey: "userId")
                    print(userId)
                    print(highScoreNumber)
                    print(nickName)
                    self.ref?.child("user").child(userId).child("highscore"/*self.userName*/).setValue(highScoreNumber)
                    self.ref?.child("user").child(userId).child("nickname"/*self.userName*/).setValue(nickName)
                    //self.ref?.child("user").child(userId).child("A\(level+1)"/*self.userName*/).setValue(currentLevelHighScore)
                    
                    //self.saveUserDefaults()
                    self.highScore.alpha = 1.0
                }
                
                if shipExplode {
                    
                } else {
                    self.ref?.child("user").child(userId).child("highscore"/*self.userName*/).setValue(highScoreNumber)
                    self.saveUserDefaults()
                }
            }
            
        }
    }

    /*
    //MARK: Highscore tableview setup
    func highscoreTableViewSetup() {
        
        highscoreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        highscoreTableView.alpha = 0
        highscoreTableView.frame = CGRect(x: 20, y: (scene?.size.height)! * 0.1, width: 280,height: 200)
        highscoreTableView.backgroundColor = UIColor.blue
        self.scene?.view?.addSubview(highscoreTableView)
        //self.addChild(highscoreTableView)
        highscoreTableView.reloadData()
        UIView.animate(withDuration: TimeInterval(0.3)) { 
            self.highscoreTableView.alpha = 1
        }
    }
 */
    
    // MARK: Background setup
    func backgroundSetup() {
        
        let background = SKSpriteNode(imageNamed: "menuBackground2" /*"menuBackground"*/)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    // MARK: START BUTTON
    func startButtonSetup() {
        
        let defaults = UserDefaults()
        currentLevelHighScore = defaults.integer(forKey: "A\(level+1)")
        if currentLevelHighScore > scoreOneStar {
            
            var startButton = SKSpriteNode()
            if preferredLanguage == .ru {
                startButton = SKSpriteNode(imageNamed: "replayGameOverButtonRU1" /*"gameOverButton"*/)
            } else {
                startButton = SKSpriteNode(imageNamed: "replayGameOverButton1" /*"gameOverButton"*/)
            }
            //let startButton = SKSpriteNode(imageNamed: "playAgainButton" /*"gameOverButton"*/)
            startButton.name = "Play Again"
            //startButton.size = self.size
            startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.65)
            startButton.zPosition = -99
            self.addChild(startButton)
        } else {
            var startButton = SKSpriteNode()
            if preferredLanguage == .ru {
                startButton = SKSpriteNode(imageNamed: "restartButtonRU1" /*"gameOverButton"*/)
            } else {
                startButton = SKSpriteNode(imageNamed: "restartButton1" /*"gameOverButton"*/)
            }
            //let startButton = SKSpriteNode(imageNamed: "playAgainButton" /*"gameOverButton"*/)
            startButton.name = "Play Again"
            //startButton.size = self.size
            startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.65)
            startButton.zPosition = -99
            self.addChild(startButton)
        }
    }
    
    // MARK: NEXT LEVEL BUTTON
    func nextLevelButtonSetup() {
        
        let defaults = UserDefaults()
        currentLevelHighScore = defaults.integer(forKey: "A\(level+1)")
        if currentLevelHighScore > scoreOneStar {
            
            var nextLevelButton = SKSpriteNode()
            if preferredLanguage == .ru {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButtonRU1" /*"gameOverButton"*/)
            } else {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButton1" /*"gameOverButton"*/)
            }
            //let startButton = SKSpriteNode(imageNamed: "playAgainButton" /*"gameOverButton"*/)
            nextLevelButton.name = "Next level"
            //startButton.size = self.size
            nextLevelButton.position = CGPoint(x: self.size.width * 0.65, y: self.size.height * 0.65)
            nextLevelButton.zPosition = -99
            self.addChild(nextLevelButton)
        }
    }
    
    // MARK: SCORE BUTTON
    func scoreButtonSetup() {
        var startButton = SKSpriteNode()
        if preferredLanguage == .ru {
            startButton = SKSpriteNode(imageNamed: "highScoreButtonRU1" /*"gameOverButton"*/)
        } else {
            startButton = SKSpriteNode(imageNamed: "highScoreButton1" /*"gameOverButton"*/)
        }
        //let startButton = SKSpriteNode(imageNamed: "highScore" /*"gameOverButton"*/)
        startButton.name = "High Score"
        //startButton.size = self.size
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.50)
        startButton.zPosition = -99
        self.addChild(startButton)
    }
    
    // MARK: GO To menu Button
    func goToMenuButtonSetup() {
        var startButton = SKSpriteNode()
        if preferredLanguage == .ru {
            startButton = SKSpriteNode(imageNamed: "goToMenuButtonRU1" /*"gameOverButton"*/)
        } else {
            startButton = SKSpriteNode(imageNamed: "goToMenuButton1" /*"gameOverButton"*/)
        }
        //let startButton = SKSpriteNode(imageNamed: "goToMenuButton" /*"gameOverButton"*/)
        startButton.name = "Go To Menu"
        //startButton.size = self.size
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.35)
        startButton.zPosition = -99
        self.addChild(startButton)
    }
    
    // MARK: Share Button
    func shareButtonSetup() {
        var shareButton = SKSpriteNode()
        if preferredLanguage == .ru {
            shareButton = SKSpriteNode(imageNamed: "shareButtonRU1" /*"gameOverButton"*/)
        } else {
            shareButton = SKSpriteNode(imageNamed: "shareButton1" /*"gameOverButton"*/)
        }
        shareButton.name = "Share Button"
        //startButton.size = self.size
        shareButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.20)
        shareButton.zPosition = -99
        self.addChild(shareButton)
    }
    
    // MARK: You lose sign setup
    func youLoseSetup() {
        var youLose = SKSpriteNode()
        if preferredLanguage == .ru {
            youLose = SKSpriteNode(imageNamed: "youLoseRU1" /*"gameOverButton"*/)
        } else {
            youLose = SKSpriteNode(imageNamed: "youLose1" /*"gameOverButton"*/)
        }
        //let youLose = SKSpriteNode(imageNamed: "youLose" /*"gameOverButton"*/)
        youLose.name = "You lose"
        //startButton.size = self.size
        youLose.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.91)
        youLose.zPosition = -99
        //youLose.xScale += 0.4
        //youLose.yScale += 0.4
        self.addChild(youLose)
    }
    
    // MARK: Score label
    func setScoreLabel() {
        let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 140
        scoreLabel.fontColor = UIColor.red
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.91)
        scoreLabel.zPosition = -99
        self.addChild(scoreLabel)
    }
    
    // MARK: Level Highscore label
    func setHithScoreLabel() {
        
        let defaults = UserDefaults()
        currentLevelHighScore = defaults.integer(forKey: "A\(level+1)")
        
        if preferredLanguage == .ru {
            lvlHighScoreLabel.text = "Лучший счет уровня: \(currentLevelHighScore)"
        } else {
            lvlHighScoreLabel.text = "Level high score: \(currentLevelHighScore)"
        }
        
        lvlHighScoreLabel.fontSize = 40 //120
        lvlHighScoreLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white //UIColor.white
        lvlHighScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.78)
        lvlHighScoreLabel.zPosition = -99
        self.addChild(lvlHighScoreLabel)
    }
    
    // MARK: Overall Highscore label
    func setOverallHithScoreLabel() {
        if shipExplode {
            if preferredLanguage == .ru {
                overallHighScoreLabel.text = "Суммарный счет уровней: \(highScoreNumber)"
            } else {
                overallHighScoreLabel.text = "All levels high score: \(highScoreNumber)"
            }
            
        }
        overallHighScoreLabel.fontSize = 40 //120
        overallHighScoreLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
        overallHighScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.74)
        overallHighScoreLabel.zPosition = -99
        self.addChild(overallHighScoreLabel)
    }
    
    // MARK: HighScore menu button
    func sethighScoreMenu() {
        
        
        highScore.name = "highScoreNodeMenu"
        //startButton.size = self.size
        highScore.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.85)
        highScore.zPosition = -99
        highScore.alpha = 0.0
        self.addChild(highScore)
    }
    
    func unlockNextLevel() {
        if planet == 1 {
            if score >= scoreOneStar {
                let defaults = UserDefaults()
                defaults.set(1, forKey: "level\(level+2)IsAcitve")
                if level <= 10 {
                    activeLevel[level+1] = 1
                }
            }
        }
        if planet == 2 {
            if score >= scoreOneStar {
                let defaults = UserDefaults()
                defaults.set(1, forKey: "2level\(level+2)IsAcitve")
                if level <= 10 {
                    active2Level[level+1] = 1
                }
            }
        }
    }
    
    @objc func addStar() {
        
        var stars = SKSpriteNode()
        if score < scoreOneStar {
            print("zore")
        } else if score >= scoreOneStar && score < scoreTwoStar {
           stars = SKSpriteNode(imageNamed: "gameOverOneStar"/*"gameOverButton"*/)
            print("one")
        } else if score >= scoreTwoStar && score < scoreThreeStars {
            stars = SKSpriteNode(imageNamed: "gameOverTwoStars" /*"gameOverButton"*/)
            print("two")
        } else if score >= scoreThreeStars {
            stars = SKSpriteNode(imageNamed: "gameOverThreeStars" /*"gameOverButton"*/)
            print("three")
        } else {
            // do nothing
        }
        
        
        //let oneStar = SKSpriteNode(imageNamed: "gameOverOneStar" /*"gameOverButton"*/)
        stars.name = "Game Over One Star"
        //startButton.size = self.size
        stars.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.86)
        stars.zPosition = -99
        stars.scale(to: CGSize.zero)
        stars.alpha = 0
        self.addChild(stars)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.2)
        let scaleUpAction = SKAction.scale(to: 1.3, duration: 0.4)
        let scaleToNormal = SKAction.scale(to: 1, duration: 0.1)
        let fadeInAndScaleUp: SKAction = SKAction.group([fadeInAction, scaleUpAction])
        fadeInAndScaleUp.timingMode = SKActionTimingMode.easeOut
        let actionSequence = SKAction.sequence([/*moveAction*/ fadeInAndScaleUp, scaleToNormal])
        actionSequence.timingMode = SKActionTimingMode.easeOut
        
        stars.run(actionSequence)
        
        if soundsIsOn {
            run(SKAction.playSoundFileNamed("getStarsScore.m4a", waitForCompletion: false))
        }
        
        /*
        moveAction = SKAction.move(to: PlayerPosition.middleCenter768, duration: shipSpeedMovement.rawValue)
        let moveAndTurnGroup: SKAction = SKAction.group([moveAction, turnLeftAction])
        moveAndTurnGroup.timingMode = SKActionTimingMode.easeInEaseOut
        
        let ancorPointAction: SKAction = SKAction.run(calculateAnchorPoint)
        let actionSequence = SKAction.sequence([/*moveAction*/ moveAndTurnGroup, ancorPointAction])
        self.run(actionSequence, completion: {
            self.actionIsActive = false
        })
         */
        
    }
    
    func saveUserDefaults() {
        let defaults = UserDefaults()
        highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        
        if score > lvlScore[level] {
            lvlScore[level] = score
            defaults.set(score, forKey: "A\(level+1)")
        }
 
        
        currentLevelHighScore = defaults.integer(forKey: "A\(level+1)")
        if score > currentLevelHighScore {
            lvlScore[level] = score
            defaults.set(score, forKey: "A\(level+1)")
            currentLevelHighScore = score
        }
        print("\(defaults.integer(forKey: "A\(level+1)")) + yyyy")
        print("A\(level+1)")
        
        var tempHighScore = 0
        for i in 1...lvlScore.count {
            tempHighScore += lvlScore[i-1]
        }
        
        if tempHighScore > highScoreNumber {
            defaults.set(tempHighScore, forKey: "highScoreSaved")
            
            //ref?.child("user").child(userId).child("highscore"/*self.userName*/).setValue(highScoreNumber)
            //ref?.child("user").child(userId).child("nickname"/*self.userName*/).setValue(nickName)
            print("saved highsocre")
        }
        if preferredLanguage == .ru {
            overallHighScoreLabel.text = "Суммарный счет уровней: \(tempHighScore)"
            lvlHighScoreLabel.text = "Лучший счет уровня: \(currentLevelHighScore)"
            
        } else {
            overallHighScoreLabel.text = "All levels high score: \(tempHighScore)"
            lvlHighScoreLabel.text = "Level high score: \(currentLevelHighScore)"
        }
        
        //print(highScoreNumber)
        
        /*
        if score > highScoreNumber {
            highScoreNumber = score
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        */
        
        //var tempLvlScore = lvlScore[level]
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Play Again" {
                let scene = GameScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let newGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                // Present the scene
                view?.presentScene(scene, transition: newGameTransition)
                if #available(iOS 10.0, *) {
                    view?.preferredFramesPerSecond = 60
                } else {
                    // Fallback on earlier versions
                }
                currentGameStatus = .inGame
            } else if atPoint(location).name == "High Score" {
                self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
            } else if atPoint(location).name == "Go To Menu" {
                let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                scene.scaleMode = .aspectFill
                let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                // Present the scene
                view?.presentScene(scene, transition: startGameTransition)
                if #available(iOS 10.0, *) {
                    view?.preferredFramesPerSecond = 60
                } else {
                    // Fallback on earlier versions
                }
                
            } else if atPoint(location).name == "Next level" {
                level += 1
                nextLevelFunc()
                currentGameStatus = .inGame
                
                let scene = GameScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let newGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                // Present the scene
                view?.presentScene(scene, transition: newGameTransition)
                if #available(iOS 10.0, *) {
                    view?.preferredFramesPerSecond = 60
                } else {
                    // Fallback on earlier versions
                }
                
            } else if atPoint(location).name == "Share Button" {
                //self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
                shareImageButton()
            } else {
                
            }
        }
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func shareImageButton() {
        let image = takeScreenShot(scene: scene!)
        let text = "Try this game!"
        
        //let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.openInIBooks, UIActivityType.print]
        self.view?.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func takeScreenShot(scene: SKScene) -> UIImage {
        let bounds = self.scene!.view?.bounds
        UIGraphicsBeginImageContextWithOptions(bounds!.size, true, UIScreen.main.scale)
        self.scene?.view?.drawHierarchy(in: bounds!, afterScreenUpdates: true)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenShot!
    }
    
    
    
    
    
    
    
    deinit {
        print("gameover deinit")
    }
    
    
}   // class

extension UIApplication {
    var screenShot: UIImage? {
        if let rootViewController = keyWindow?.rootViewController {
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
            if let _ = UIGraphicsGetImageFromCurrentImageContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
}








