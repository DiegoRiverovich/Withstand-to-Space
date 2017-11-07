//
//  MainMenuScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 24.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit
import Firebase

class MainMenuScene: SKScene {
    
    var ref: DatabaseReference?
    let highScore = SKSpriteNode(imageNamed: "alien3")
    
    var loadScoresTimer: Timer?
    
    override func didMove(to view: SKView) {
        loadMainScene()
    }
    
    func loadMainScene() {
        splashScreenSetup()
        
        determineLanguage()
        
        //addBackgroundMusic()
        
        ref = Database.database().reference().child("user")        
        auth()
        
        getNickname()
        
        backgroundSetup()
        startButtonSetup()
        highScoreButtonSetup()
        creditsButtonSetup()
        
        //highScoreMenu()
        
        loadScores()
        loadLevelIsActive()
        
        saveUserDefaults()
        
        loadScoresTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(MainMenuScene.loadScores), userInfo: nil, repeats: false)
    }
    
//    func addBackgroundMusic() {
//        
//        gameBackgroundMusic = SKAudioNode(fileNamed: SomeNames.soulStar)
//        self.addChild(gameBackgroundMusic)
//        
//    }
    
    // Determine Language
    func determineLanguage() {
        let preferredLanguageVar = NSLocale.preferredLanguages[0]
        print("\(preferredLanguageVar)")
        if preferredLanguageVar == "ru-RU" || preferredLanguageVar == "ru" {
            preferredLanguage = .ru
            print("ru")
        } else {
            preferredLanguage = .en
            print("en")
        }
    }
    
    // MARK: Get nickname
    
    func getNickname(){
        let defaults = UserDefaults()
        if isKeyPresentInUserDefaults(key: "nickname") {
            nickName = defaults.string(forKey: "nickname")!
        }
        if isKeyPresentInUserDefaults(key: "userId") {
            userId = defaults.string(forKey: "userId")!
        } else {
            //defaults.set(userId, forKey: "userId")
        }
    }
    
    // MARK: Background setup
    func backgroundSetup() {
        
        let background = SKSpriteNode(imageNamed: "menuBackground2")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    // MARK: splashScreenSetup
    func splashScreenSetup() {
        if startScreenCount == 1 {
        let splashScreen = SKSpriteNode(imageNamed: "loadingScreen")
        splashScreen.size = self.size
        splashScreen.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        splashScreen.zPosition = 100
        self.addChild(splashScreen)
        
        let fadeSSAction: SKAction = SKAction.fadeOut(withDuration: TimeInterval(0.5))
        let removeSplashAction: SKAction = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([fadeSSAction, removeSplashAction])
        splashScreen.run(actionSequence)
            startScreenCount -= 1
        }
    }
    
    // MARK: START BUTTON
    func startButtonSetup() {
        var startButton = SKSpriteNode()
        if preferredLanguage == .ru {
            startButton = SKSpriteNode(imageNamed: "playButtonRU1")
        } else {
            startButton = SKSpriteNode(imageNamed: "playButton1")
        }
        startButton.name = "Start"
        //startButton.size = self.size
        startButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        startButton.zPosition = -99
        self.addChild(startButton)
    }
    
    func highScoreMenu() {
        
        highScore.name = "highScoreNodeMenu"
        
        //startButton.size = self.size
        highScore.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.9)
        highScore.zPosition = -99
        highScore.alpha = 0.0
        self.addChild(highScore)
    }
    
    func highScoreButtonSetup() {
        var highScoreButton = SKSpriteNode()
        if preferredLanguage == .ru {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButtonRU1")
        } else {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButton1")
        }
        highScoreButton.name = "highScoreButton"
        //startButton.size = self.size
        highScoreButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        highScoreButton.zPosition = -99
        self.addChild(highScoreButton)
    }
    
    func creditsButtonSetup() {
        var creditsButton = SKSpriteNode()
        if preferredLanguage == .ru {
            creditsButton = SKSpriteNode(imageNamed: "creditsButtonRU1")
        } else {
            creditsButton = SKSpriteNode(imageNamed: "creditsButton1")
        }
        
        creditsButton.name = "Credits"
        //startButton.size = self.size
        creditsButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.4)
        creditsButton.zPosition = -99
        self.addChild(creditsButton)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Start" {
                let scene = LevelsScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let startGameTransition = SKTransition.doorsOpenHorizontal(withDuration: 0.5 ) //doorsCloseHorizontal(withDuration: 0.5)
                // Present the scene
                view?.presentScene(scene, transition: startGameTransition)
                if #available(iOS 10.0, *) {
                    view?.preferredFramesPerSecond = 60
                } else {
                    // Fallback on earlier versions
                }
                
//                view?.ignoresSiblingOrder = true
//                
//                view?.showsFPS = true
//                view?.showsNodeCount = true
//                view?.showsPhysics = true
            } else if atPoint(location).name == "highScoreButton" {
                self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
            } else if atPoint(location).name == "Credits" {
                let scene = CreditsScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                // Present the scene
                view?.presentScene(scene, transition: startGameTransition)
            }
        }
    }
    
    // Auth
    func auth() {
        Auth.auth().signIn(withEmail: "withstandtospace@test.com", password: "123ASDasd") { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let defaults = UserDefaults()
                let defaultsIsExist = self.isKeyPresentInUserDefaults(key: "userId")
                if !defaultsIsExist {
                    // Set user id
                    let childRef = self.ref?.childByAutoId()
                    
                    //highScoreNumber = 0
                    
                    // read user id
                    let userKey = childRef?.key
                    if userKey != nil {
                        userId = userKey!
                    }
                    
                    // set user id and high score to defautls
                    defaults.set(userId, forKey: "userId")
                    defaults.set(highScoreNumber, forKey: "highScoreSaved")
                    
                    // set user id and high score to FIREBASE
                    childRef?.child("highscore").setValue(highScoreNumber)
                    childRef?.child("nickname").setValue(nickName)
                    
                    for i in 1...lvlScore.count {
                        let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "A\(i)")
                        if !lvlKeyIsExist {
                            defaults.set(lvlScore[i-1], forKey: "A\(i)")
                            //print(lvlScore[i])
                            //print("sheet")
                        }
                    }
                    
                    for i in 1...lvl2Score.count {
                        let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "B\(i)")
                        if !lvlKeyIsExist {
                            defaults.set(lvl2Score[i-1], forKey: "B\(i)")
                            //print(lvlScore[i])
                            //print("sheet")
                        }
                    }
                    
                    for i in 1...activeLevel.count {
                        let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "level\(i)IsAcitve")
                        if !lvlKeyIsExist {
                            defaults.set(activeLevel[i-1], forKey: "level\(i)IsAcitve")
                            print(activeLevel[i-1])
                            //print("sheet")
                        }
                    }
                    
                    for i in 1...active2Level.count {
                        let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "2level\(i)IsAcitve")
                        if !lvlKeyIsExist {
                            defaults.set(active2Level[i-1], forKey: "2level\(i)IsAcitve")
                            print(active2Level[i-1])
                            //print("sheet")
                        }
                    }
                }
                
                userId = defaults.string(forKey: "userId")!
                self.highScore.alpha = 1.0
                
                //MACubuntu20
                //defaults.set(1, forKey: "highScoreSaved")
                /*
                for i in 0...lvlScore.count {
                    let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "A\(i+1)")
                    if !lvlKeyIsExist {
                        defaults.set(lvlScore[i], forKey: "A\(i+1)")
                        //print(lvlScore[i])
                        //print("sheet")
                    }
                }
                 */
                
                /*
                for i in 1...lvl2Score.count {
                    let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "B\(i)")
                    if !lvlKeyIsExist {
                        defaults.set(lvl2Score[i-1], forKey: "B\(i)")
                        //print(lvlScore[i])
                        //print("sheet")
                    }
                }
                */
                
                
                
            }
            
        }
    }
    
    @objc func loadScores() {
        let defaults = UserDefaults()
        for i in 1...lvlScore.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "A\(i)")
            if lvlKeyIsExist {
                lvlScore[i-1] = defaults.integer(forKey: "A\(i)")
                //print(lvlScore[i])
                print("A\(i) - \(lvlScore[i-1])")
            }
            
        }
        
        for i in 1...lvl2Score.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "B\(i)")
            if lvlKeyIsExist {
                lvl2Score[i-1] = defaults.integer(forKey: "B\(i)")
                //print(lvlScore[i])
                print("B\(i) - \(lvl2Score[i-1])")
            }
            
        }
        //defaults.set(10, forKey: "highScoreSaved")
        /*
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value)")
        }
         */
    }
    
    func loadLevelIsActive() {
        let defaults = UserDefaults()
        for i in 1...activeLevel.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "level\(i)IsAcitve")
            if lvlKeyIsExist {
                activeLevel[i-1] = defaults.integer(forKey: "level\(i)IsAcitve")
                //print(lvlScore[i])
                print("level\(i)IsAcitve - \(activeLevel[i-1])")
            }
            
        }
        
        for i in 1...active2Level.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "2level\(i)IsAcitve")
            if lvlKeyIsExist {
                active2Level[i-1] = defaults.integer(forKey: "2level\(i)IsAcitve")
                //print(lvlScore[i])
                print("2level\(i)IsAcitve - \(active2Level[i-1])")
            }
            
        }
    }
    
    func loadUpgrades() {
        let defaults = UserDefaults()
        
        let engineUpgradeIsExist = self.isKeyPresentInUserDefaults(key: "engineUpgrade")
        let flapsUpgradeIsExist = self.isKeyPresentInUserDefaults(key: "flapsUpgrade")
        let trioUpgradeIsExist = self.isKeyPresentInUserDefaults(key: "trioUpgrade")
        let doubleUpgradeIsExist = self.isKeyPresentInUserDefaults(key: "doubleUpgrade")
        let invisibleUpgradeIsExist = self.isKeyPresentInUserDefaults(key: "invisibleUpgrade")
        
        if engineUpgradeIsExist {
            engineUpgrade = defaults.bool(forKey: "engineUpgrade")
        } else {
            engineUpgrade = false
        }
        
        if flapsUpgradeIsExist {
            flapsUpgrade = defaults.bool(forKey: "flapsUpgrade")
        }  else {
            flapsUpgrade = false
        }
        
        if trioUpgradeIsExist {
            trioUpgrade = defaults.bool(forKey: "trioUpgrade")
        }  else {
            trioUpgrade = false
        }
        
        if doubleUpgradeIsExist {
            doubleUpgrade = defaults.bool(forKey: "doubleUpgrade")
        }  else {
            doubleUpgrade = false
        }
        
        if invisibleUpgradeIsExist {
            invisibleUpgrade = defaults.bool(forKey: "invisibleUpgrade")
        }  else {
            invisibleUpgrade = false
        }
        
        //defaults.set(10, forKey: "highScoreSaved")
        /*
         for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
         print("\(key) = \(value)")
         }
         */
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func saveUserDefaults() {
        let defaults = UserDefaults()
        highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        var temHighScore = 0
        for i in 1...lvlScore.count {
            temHighScore += lvlScore[i-1]
        }
        
        if temHighScore > highScoreNumber {
            highScoreNumber = temHighScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        /*
        if score > highScoreNumber {
            highScoreNumber = score
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            
            
        }
         */
        
        
    }
    
    deinit {
        print("mainmenue deinit")
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}   // class
