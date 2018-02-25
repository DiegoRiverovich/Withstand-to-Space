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
import CoreMotion
import NVActivityIndicatorView

class MainMenuScene: SKScene {
    
    private var newActivityIndicator: NVActivityIndicatorView?
    
    private var motionManeger = CMMotionManager()
    
    private let background = SKSpriteNode(imageNamed: "backgroundStars02" /*"menuBackground2"*/)
    private let planetForGyro = SKSpriteNode(imageNamed: "planet01_400")
    private let gameNameUnderScoreNode = SKSpriteNode(imageNamed: "GameName1_")
    private let mainPlanetForGyro = SKSpriteNode(imageNamed: "venus_500")
    private let buyIcon = SKSpriteNode(imageNamed: "purchase01")
    
    
    private var ref: DatabaseReference?
    private let highScore = SKSpriteNode(imageNamed: "alien3")
    //var setLang = false
    
    private let enLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let ruLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let chLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let esLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let jpLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let frLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let deLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    
    private var startButton = SKSpriteNode()
    private var highScoreButton = SKSpriteNode()
    private var creditsButton = SKSpriteNode()
    private var gameNameLogo = SKSpriteNode()
    
    private var loadScoresTimer: Timer?
    private var distortButtonTimer: Timer?
    private var underScoreTimer: Timer?
    
    private var gameNameLogoPositionForGyro: CGPoint?
    
    override func didMove(to view: SKView) {
        
        loadMainScene()
    }
    
    private func loadMainScene() {
        //zeroingHighScoreSurvival()
        
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
        gameNameSetup()
        
        //highScoreMenu()
        
        loadScores()
        loadLevelIsActive()
        
        saveUserDefaults()
        
        loadScoresTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(MainMenuScene.loadScores), userInfo: nil, repeats: false)
        loadSeconds()
        
        addLanguageLabels()
        programmPaidOrNot()
        
        //allLevelsActive()
        //moreSP()
        distortButtonTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(MainMenuScene.buttonDistort), userInfo: nil, repeats: true)
        underScoreTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1.2), target: self, selector: #selector(MainMenuScene.underscoreFlick), userInfo: nil, repeats: true)
        
        planetForGyroFunc()
        moveBackgroupByGyro()
        
        gameNameUnderScoreFunc()
        buyIconSetup()
        //replenishRouge()
        determineRuningDevice()
        loadAdsAttemtps()
        
        loadDisabilities()
        
        loadReviewInvintationCount()
    }
    
    private func startNewAcitivityIndicator() {
        if let viewLoc = view {
            /*
            newActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: (viewLoc.center.x - 50), y: (viewLoc.center.y - 50), width: 100, height: 100),
                                                           type: .ballTrianglePath,
                                                           color: UIColor.lightGray,
                                                           padding: nil)
             */
            
            newActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: (viewLoc.center.x - 168), y: (viewLoc.center.y - 51), width: 30, height: 30),
                                                           type: .ballTrianglePath,
                                                           color: UIColor.white,
                                                           padding: nil)
            
        } else {
            newActivityIndicator?.center = CGPoint(x: 700, y: 900)
        }
        //myActivityIndicator.hidesWhenStopped = true
        scene!.view?.addSubview(newActivityIndicator!)
        newActivityIndicator?.startAnimating()
    }
    
    private func stopNewAcitvityIndicator() {
        newActivityIndicator?.stopAnimating()
        newActivityIndicator?.removeFromSuperview()
    }
    
    private func determineRuningDevice() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            runingDevice = RuningDeviceEnum.phone
        case .pad:
            runingDevice = RuningDeviceEnum.pad
        default:
            runingDevice = RuningDeviceEnum.other
        }
    }
    
    private func buyIconSetup() {
        buyIcon.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.95)
        
        buyIcon.name = "buyIcon"
        buyIcon.xScale = 1.0
        buyIcon.yScale = 1.0
        buyIcon.zPosition = 99
        
        self.addChild(buyIcon)
    }
    
    private func zeroingHighScoreSurvival() {
        let defaults = UserDefaults()
        defaults.set(0, forKey: "highScoreSavedSurvival")
    }
    
    private func replenishRouge() {
        let defaults = UserDefaults()
        
        //rougeOneTimeActive = 650
        //defaults.set(rougeOneTimeActive, forKey: "RougeSeconds")
        
        trioTimeActive = 200
        defaults.set(trioTimeActive, forKey: "TrioSeconds")
        
        //InvisibleTimeActive = 400
        //defaults.set(InvisibleTimeActive, forKey: "InvisibleSeconds")
        
    }
    
    private func gameNameUnderScoreFunc() {
        //let gameNameUnderScoreNode = SKSpriteNode(imageNamed: "GameName1_")
        gameNameUnderScoreNode.name = "Game Name Underscore"
        //gameNameUnderScore.xScale = 0.6
        //gameNameUnderScore.yScale = 0.6
        //startButton.size = self.size
        if preferredLanguage == .ru {
            gameNameUnderScoreNode.position = CGPoint(x: self.size.width * 0.81, y: self.size.height * 0.66)
        } else if preferredLanguage == .ch {
            gameNameUnderScoreNode.position = CGPoint(x: self.size.width * 0.81, y: self.size.height * 0.645)
        } else if preferredLanguage == .es {
            gameNameUnderScoreNode.position = CGPoint(x: self.size.width * 0.81, y: self.size.height * 0.625)
        } else if preferredLanguage == .jp {
            gameNameUnderScoreNode.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.65)
        } else if preferredLanguage == .fr {
            gameNameUnderScoreNode.position = CGPoint(x: self.size.width * 0.81, y: self.size.height * 0.665)
        } else if preferredLanguage == .gr {
            gameNameUnderScoreNode.position = CGPoint(x: self.size.width * 0.81, y: self.size.height * 0.67)
        } else {
           gameNameUnderScoreNode.position = CGPoint(x: self.size.width * 0.64, y: self.size.height * 0.68)
        }
        
        gameNameUnderScoreNode.zPosition = -98
        self.addChild(gameNameUnderScoreNode)
    }
    
    @objc private func underscoreFlick() {
        var animationAction = SKAction()
        animationAction = SKAction.animate(with: [SKTexture(imageNamed: "GameName1_empty"), SKTexture(imageNamed: "GameName1_")], timePerFrame: 0.5)
        gameNameUnderScoreNode.run(animationAction)
    }
    
    private func moveBackgroupByGyro() {
        motionManeger.gyroUpdateInterval = 0.03
        
        motionManeger.startGyroUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
            if let myData = data {
                if let selfLoc = self {
                    if myData.rotationRate.x > 1 {
                        if /*self!.gameNameLogo.position.y > (self!.gameNameLogoPositionForGyro!.y - 50) &&*/ selfLoc.gameNameLogo.position.y < (selfLoc.gameNameLogoPositionForGyro!.y + 50) {
                            self?.gameNameLogo.position.y += 3
                            self?.startButton.position.y += 3
                            self?.highScoreButton.position.y += 3
                            self?.creditsButton.position.y += 3
                            self?.gameNameUnderScoreNode.position.y += 3
                            self?.planetForGyro.position.y -= 1
                            self?.mainPlanetForGyro.position.y -= 7
                            //print("1")
                        }
                        
                    }
                    if myData.rotationRate.x < -1  && !(myData.rotationRate.x > -1) {
                        if selfLoc.gameNameLogo.position.y > (selfLoc.gameNameLogoPositionForGyro!.y - 50) /*&& self!.gameNameLogo.position.y < (self!.gameNameLogoPositionForGyro!.y + 50)*/ {
                            self?.gameNameLogo.position.y -= 3
                            self?.startButton.position.y -= 3
                            self?.highScoreButton.position.y -= 3
                            self?.creditsButton.position.y -= 3
                            self?.gameNameUnderScoreNode.position.y -= 3
                            self?.planetForGyro.position.y += 1
                            self?.mainPlanetForGyro.position.y += 7
                            //print("2")
                        }
                    }
                    if myData.rotationRate.y > 1 {
                        if selfLoc.gameNameLogo.position.x > (selfLoc.gameNameLogoPositionForGyro!.x - 50) /*&& self!.gameNameLogo.position.x < (self!.gameNameLogoPositionForGyro!.x + 50)*/ {
                            self?.gameNameLogo.position.x -= 3
                            self?.startButton.position.x -= 3
                            self?.highScoreButton.position.x -= 3
                            self?.creditsButton.position.x -= 3
                            self?.gameNameUnderScoreNode.position.x -= 3
                            self?.planetForGyro.position.x += 1
                            self?.mainPlanetForGyro.position.x += 7
                            //print("3")
                        }
                    }
                    if myData.rotationRate.y < -1 && !(myData.rotationRate.y > -1) {
                        if /*self!.gameNameLogo.position.x > (self!.gameNameLogoPositionForGyro!.x - 50) &&*/ selfLoc.gameNameLogo.position.x < (selfLoc.gameNameLogoPositionForGyro!.x + 50) {
                            self?.gameNameLogo.position.x += 3
                            self?.startButton.position.x += 3
                            self?.highScoreButton.position.x += 3
                            self?.creditsButton.position.x += 3
                            self?.gameNameUnderScoreNode.position.x += 3
                            self?.planetForGyro.position.x -= 1
                            self?.mainPlanetForGyro.position.x -= 7
                            //print("4")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: START BUTTON
    private func planetForGyroFunc() {
        
        planetForGyro.name = "Gyro Planet"
        planetForGyro.xScale = 0.6
        planetForGyro.yScale = 0.6
        //startButton.size = self.size
        planetForGyro.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.55)
        planetForGyro.zPosition = -100
        self.addChild(planetForGyro)
        
        mainPlanetForGyro.name = "Gyro Main Planet"
        mainPlanetForGyro.xScale = 2.6
        mainPlanetForGyro.yScale = 2.6
        //startButton.size = self.size
        mainPlanetForGyro.position = CGPoint(x: self.size.width * (0.22), y: self.size.height * (0.17))
        mainPlanetForGyro.zPosition = -100
        self.addChild(mainPlanetForGyro)
    }
    
    //MARK: func button distort
    @objc private func buttonDistort() {
        var animationAction = SKAction()
        if preferredLanguage == .ru {
            animationAction = SKAction.animate(with: [SKTexture(imageNamed: "playButtonRU1D2"), SKTexture(imageNamed: "playButtonRU1D2_1"), SKTexture(imageNamed: "playButtonRU1")], timePerFrame: 0.07)
        } else if preferredLanguage == .ch {
            animationAction = SKAction.animate(with: [SKTexture(imageNamed: "playButtonCH1D2_1"), SKTexture(imageNamed: "playButtonCH1D2_2"), SKTexture(imageNamed: "playButtonCH1")], timePerFrame: 0.07)
        } else if preferredLanguage == .es {
            animationAction = SKAction.animate(with: [SKTexture(imageNamed: "playButtonSP1D2_1"), SKTexture(imageNamed: "playButtonSP1D2_2"), SKTexture(imageNamed: "playButtonSP1")], timePerFrame: 0.07)
        } else if preferredLanguage == .jp {
            animationAction = SKAction.animate(with: [SKTexture(imageNamed: "playButtonJP1D2_1"), SKTexture(imageNamed: "playButtonJP1D2_2"), SKTexture(imageNamed: "playButtonJP1")], timePerFrame: 0.07)
        } else if preferredLanguage == .fr {
            animationAction = SKAction.animate(with: [SKTexture(imageNamed: "playButtonFR1D2_1"), SKTexture(imageNamed: "playButtonFR1D2_2"), SKTexture(imageNamed: "playButtonFR1")], timePerFrame: 0.07)
        } else if preferredLanguage == .gr {
            animationAction = SKAction.animate(with: [SKTexture(imageNamed: "playButtonDE1D2_1"), SKTexture(imageNamed: "playButtonDE1D2_2"), SKTexture(imageNamed: "playButtonDE1")], timePerFrame: 0.07)
        } else if preferredLanguage == .en {
            animationAction = SKAction.animate(with: [SKTexture(imageNamed: "playButton1D2_1"), SKTexture(imageNamed: "playButton1D2_2"), SKTexture(imageNamed: "playButton1")], timePerFrame: 0.07)
        }
            startButton.run(animationAction)
    }
    
    // test func
    private func deleteAllScores() {
        let defaults = UserDefaults()
        
        for i in 0...lvlScore.count {
            defaults.set(0, forKey: "A\(i+1)")
        }
        
        for i in 1...lvl2Score.count {
            defaults.set(0, forKey: "B\(i)")
        }
        
        for i in 1...activeLevel.count {
            if i == 1 {
                defaults.set(1, forKey: "level\(i)IsAcitve")
            } else {
                defaults.set(0, forKey: "level\(i)IsAcitve")
            }
        }
        
        for i in 1...active2Level.count {
            if i == 1 {
                defaults.set(1, forKey: "2level\(i)IsAcitve")
            } else {
                defaults.set(active2Level[i-1], forKey: "2level\(i)IsAcitve")
            }
        }
    }
    

    // test func
    private func allLevelsActive() {
        for i in 1...activeLevel.count {
            activeLevel[i-1] = 1
        }
        for i in 1...active2Level.count {
            active2Level[i-1] = 1
        }
        for i in 1...active3Level.count {
            active3Level[i-1] = 1
        }
    }
    // test func
    private func moreSP() {
        let defaults = UserDefaults()
        defaults.set(100, forKey: "TrioSeconds")
        
        defaults.set(100, forKey: "RougeSeconds")
        
        defaults.set(100, forKey: "InvisibleSeconds")
    }
    
//    func addBackgroundMusic() {
//        
//        gameBackgroundMusic = SKAudioNode(fileNamed: SomeNames.soulStar)
//        self.addChild(gameBackgroundMusic)
//        
//    }
    
    // MARK: Language labels
    private func addLanguageLabels() {
        //let enLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        enLabel.position = CGPoint(x: self.size.width * 0.45 - 400, y: self.size.height * 0.05)
        enLabel.text = "en"
        enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        enLabel.fontSize = 70
        enLabel.zPosition = 99
        enLabel.name = "EnLabel"
        
        //let ruLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        ruLabel.position = CGPoint(x: self.size.width * 0.45  - 240, y: self.size.height * 0.05)
        ruLabel.text = "ru"
        ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        ruLabel.fontSize = 70
        ruLabel.zPosition = 99
        ruLabel.name = "RuLabel"
        
        //let chLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        chLabel.position = CGPoint(x: self.size.width * 0.45 - 80, y: self.size.height * 0.05)
        chLabel.text = "ch"
        chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        chLabel.fontSize = 70
        chLabel.zPosition = 99
        chLabel.name = "ChLabel"
        
        esLabel.position = CGPoint(x: self.size.width * 0.45 + 80, y: self.size.height * 0.05)
        esLabel.text = "es"
        esLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        esLabel.fontSize = 70
        esLabel.zPosition = 99
        esLabel.name = "EsLabel"
        
        jpLabel.position = CGPoint(x: self.size.width * 0.45 + 240, y: self.size.height * 0.05)
        jpLabel.text = "jp"
        jpLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        jpLabel.fontSize = 70
        jpLabel.zPosition = 99
        jpLabel.name = "JpLabel"
        
        frLabel.position = CGPoint(x: self.size.width * 0.45 + 400, y: self.size.height * 0.05)
        frLabel.text = "fr"
        frLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        frLabel.fontSize = 70
        frLabel.zPosition = 99
        frLabel.name = "FrLabel"
        
        deLabel.position = CGPoint(x: self.size.width * 0.45 + 560, y: self.size.height * 0.05)
        deLabel.text = "de"
        deLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        deLabel.fontSize = 70
        deLabel.zPosition = 99
        deLabel.name = "DeLabel"
        
        if preferredLanguage == .ru {
            ruLabel.fontColor = UIColor.red
        } else if preferredLanguage == .ch {
            chLabel.fontColor = UIColor.red
        } else if preferredLanguage == .es {
            esLabel.fontColor = UIColor.red
        } else if preferredLanguage == .jp {
            jpLabel.fontColor = UIColor.red
        }  else if preferredLanguage == .fr {
            frLabel.fontColor = UIColor.red
        } else if preferredLanguage == .gr {
            deLabel.fontColor = UIColor.red
        } else {
            enLabel.fontColor = UIColor.red
        }
        
        
        self.addChild(enLabel)
        self.addChild(ruLabel)
        self.addChild(chLabel)
        self.addChild(esLabel)
        self.addChild(jpLabel)
        self.addChild(frLabel)
        self.addChild(deLabel)
    }
    
    // Determine Language
    private func determineLanguage() {
        if !setLang {
            let defaults = UserDefaults()
            let choosenLanguageExist = self.isKeyPresentInUserDefaults(key: "Choosen Language")
            if !choosenLanguageExist {
                
                let preferredLanguageVar = NSLocale.preferredLanguages[0]
               // print("\(preferredLanguageVar)")
                if preferredLanguageVar.contains("ru") || preferredLanguageVar.contains("RU") || preferredLanguageVar.contains("rus") /*== "ru-RU" || preferredLanguageVar == "ru"*/ {
                    preferredLanguage = .ru
                    //print("ru")
                    
                    enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    ruLabel.fontColor = UIColor.red
                    chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    esLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                    jpLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    frLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    deLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                } else if preferredLanguageVar.contains("ch") || preferredLanguageVar.contains("chi") || preferredLanguageVar.contains("zho") || preferredLanguageVar.contains("zh") {
                    preferredLanguage = .ch
                    //print("ch")
                    
                    enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    esLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    chLabel.fontColor = UIColor.red
                    
                    jpLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    frLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    deLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                } else if preferredLanguageVar.contains("es") || preferredLanguageVar.contains("spa") {
                    preferredLanguage = .es
                    //print("es")
                    
                    enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    esLabel.fontColor = UIColor.red
                    chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                    jpLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    frLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    deLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                } else if preferredLanguageVar.contains("ja") || preferredLanguageVar.contains("jpn") {
                    preferredLanguage = .jp
                    //print("es")
                    
                    enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    esLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                    jpLabel.fontColor = UIColor.red
                    frLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    deLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                } else if preferredLanguageVar.contains("fr") || preferredLanguageVar.contains("fre") {
                    preferredLanguage = .fr
                    //print("es")
                    
                    enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    esLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                    jpLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    frLabel.fontColor = UIColor.red
                    deLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                } else if preferredLanguageVar.contains("de") || preferredLanguageVar.contains("ger") {
                    preferredLanguage = .gr
                    //print("es")
                    
                    enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    esLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                    jpLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    frLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    deLabel.fontColor = UIColor.red
                    
                } else {
                    preferredLanguage = .en
                    //print("en")
                    
                    enLabel.fontColor = UIColor.red
                    ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    esLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                    jpLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    frLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    deLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    
                }
                
            } else {
                let choosenLang = defaults.string(forKey: "Choosen Language")
                if choosenLang == "ru" {
                    preferredLanguage = .ru
                } else if choosenLang == "ch" {
                    preferredLanguage = .ch
                } else if choosenLang == "es" {
                    preferredLanguage = .es
                } else if choosenLang == "jp" {
                    preferredLanguage = .jp
                } else if choosenLang == "fr" {
                    preferredLanguage = .fr
                } else if choosenLang == "de" {
                    preferredLanguage = .gr
                } else {
                    preferredLanguage = .en
                }
            }
        }
    }
    
    // MARK: Get nickname
    
    private func getNickname(){
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
    private func backgroundSetup() {
        
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    // MARK: splashScreenSetup
    private func splashScreenSetup() {
        if startScreenCount == 1 {
        let splashScreen = SKSpriteNode(imageNamed: "loadingScreen")
        splashScreen.size = self.size
        splashScreen.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        splashScreen.zPosition = 100
        self.addChild(splashScreen)
        
        let fadeSSAction: SKAction = SKAction.fadeOut(withDuration: TimeInterval(1.0))
        let removeSplashAction: SKAction = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([fadeSSAction, removeSplashAction])
        splashScreen.run(actionSequence)
            startScreenCount -= 1
        }
    }
    
    // MARK: Game name
    private func gameNameSetup() {
        
        if preferredLanguage == .ru {
            gameNameLogo = SKSpriteNode(imageNamed: "GameName1RU")
        } else if preferredLanguage == .ch {
            gameNameLogo = SKSpriteNode(imageNamed: "GameName1CH")
        } else if preferredLanguage == .es {
            gameNameLogo = SKSpriteNode(imageNamed: "GameName1SP")
        } else if preferredLanguage == .jp {
            gameNameLogo = SKSpriteNode(imageNamed: "GameName1JP")
        } else if preferredLanguage == .fr {
            gameNameLogo = SKSpriteNode(imageNamed: "GameName1FR")
        } else if preferredLanguage == .gr {
            gameNameLogo = SKSpriteNode(imageNamed: "GameName1DE")
        } else {
            gameNameLogo = SKSpriteNode(imageNamed: "GameName11")
        }
        gameNameLogo.name = "Game Name"
        gameNameLogo.xScale = 1.3
        gameNameLogo.yScale = 1.3
        //startButton.size = self.size
        gameNameLogo.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.75)
        gameNameLogo.zPosition = -99
        gameNameLogoPositionForGyro = gameNameLogo.position
        self.addChild(gameNameLogo)
    }
    
    // MARK: START BUTTON
    private func startButtonSetup() {
        
        if preferredLanguage == .ru {
            startButton = SKSpriteNode(imageNamed: "playButtonRU1")
        } else if preferredLanguage == .ch {
            startButton = SKSpriteNode(imageNamed: "playButtonCH1")
        } else if preferredLanguage == .es {
            startButton = SKSpriteNode(imageNamed: "playButtonSP1")
        } else if preferredLanguage == .jp {
            startButton = SKSpriteNode(imageNamed: "playButtonJP1")
        } else if preferredLanguage == .fr {
            startButton = SKSpriteNode(imageNamed: "playButtonFR1")
        } else if preferredLanguage == .gr {
            startButton = SKSpriteNode(imageNamed: "playButtonDE1")
        } else {
            startButton = SKSpriteNode(imageNamed: "playButton1")
        }
        startButton.name = "Start"
        //startButton.size = self.size
        startButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        startButton.zPosition = -99
        self.addChild(startButton)
    }
    
    private func highScoreMenu() {
        
        highScore.name = "highScoreNodeMenu"
        
        //startButton.size = self.size
        highScore.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.9)
        highScore.zPosition = -99
        highScore.alpha = 0.0
        self.addChild(highScore)
    }
    
    private func highScoreButtonSetup() {
        
        if preferredLanguage == .ru {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButtonRU1")
        } else if preferredLanguage == .ch {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButtonCH1")
        } else if preferredLanguage == .es {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButtonSP1")
        } else if preferredLanguage == .jp {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButtonJP1")
        } else if preferredLanguage == .fr {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButtonFR1")
        } else if preferredLanguage == .gr {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButtonDE1")
        } else {
            highScoreButton = SKSpriteNode(imageNamed: "highScoreButton1")
        }
        highScoreButton.name = "highScoreButton"
        //startButton.size = self.size
        highScoreButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.40)
        highScoreButton.zPosition = -99
        self.addChild(highScoreButton)
    }
    
    private func creditsButtonSetup() {
        
        if preferredLanguage == .ru {
            creditsButton = SKSpriteNode(imageNamed: "creditsButtonRU1")
        } else if preferredLanguage == .ch {
            creditsButton = SKSpriteNode(imageNamed: "creditsButtonCH1")
        } else if preferredLanguage == .es {
            creditsButton = SKSpriteNode(imageNamed: "creditsButtonSP1")
        } else if preferredLanguage == .jp {
            creditsButton = SKSpriteNode(imageNamed: "creditsButtonJP1")
        } else if preferredLanguage == .fr {
            creditsButton = SKSpriteNode(imageNamed: "creditsButtonFR1")
        } else if preferredLanguage == .gr {
            creditsButton = SKSpriteNode(imageNamed: "creditsButtonDE1")
        } else {
            creditsButton = SKSpriteNode(imageNamed: "creditsButton1")
        }
        
        creditsButton.name = "Credits"
        //startButton.size = self.size
        creditsButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.25)
        creditsButton.zPosition = -99
        self.addChild(creditsButton)
    }
    
    private func scaleButton(button: SKSpriteNode) {
        button.xScale -= 0.2
        button.yScale -= 0.2
    }
    
    @objc private func loadLevelsFunc(timer: Timer) {
        
        let userInfo = timer.userInfo as! Dictionary<String, Any>
        let scene: LevelsScene = (userInfo["scene"] as! LevelsScene)
        let transition: SKTransition = (userInfo["transition"] as! SKTransition)
        
        view?.presentScene(scene, transition: transition)
        if #available(iOS 10.0, *) {
            view?.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
        }
        stopNewAcitvityIndicator()
    }
    
    private var doneTouch = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !doneTouch {
                let location = touch.location(in: self)
                if atPoint(location).name == "Start" {
                    startNewAcitivityIndicator()
                    doneTouch = true
                    deinitMemoryJunk()
                    let scene = LevelsScene(size: CGSize(width: 1536, height: 2048))
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    //let transitionColor = UIColor(red: 23.0/255, green: 1.0/255, blue: 47.0/255, alpha: 1.0)
                    //let startGameTransition = SKTransition.doorsOpenHorizontal(withDuration: 0.5 ) //doorsCloseHorizontal(withDuration: 0.5)
                    //let startGameTransition = SKTransition.fade(with: transitionColor, duration: 1.0) //doorsCloseHorizontal(withDuration: 0.5)
                    let startGameTransition = SKTransition.crossFade(withDuration: 1.0)
                    
                    _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.7), target: self, selector: #selector(MainMenuScene.loadLevelsFunc), userInfo: ["scene" : scene, "transition" : startGameTransition], repeats: false)
                    // Present the scene
                    /*
                     view?.presentScene(scene, transition: startGameTransition)
                     if #available(iOS 10.0, *) {
                     view?.preferredFramesPerSecond = 60
                     } else {
                     // Fallback on earlier versions
                     }
                     */
                    
                    //                view?.ignoresSiblingOrder = true
                    //                
                    //                view?.showsFPS = true
                    //                view?.showsNodeCount = true
                    //                view?.showsPhysics = true
                } else if atPoint(location).name == "highScoreButton" {
                    //doneTouch = true
                    deinitMemoryJunk()
                    self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
                } else if atPoint(location).name == "Credits" {
                    doneTouch = true
                    deinitMemoryJunk()
                    let scene = CreditsScene(size: CGSize(width: 1536, height: 2048))
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    // Present the scene
                    view?.presentScene(scene, transition: startGameTransition)
                } else if atPoint(location).name == "RuLabel" {
                    doneTouch = true
                    deinitMemoryJunk()
                    preferredLanguage = .ru
                    setLang = true
                    
                    let defaults = UserDefaults()
                    defaults.set("ru", forKey: "Choosen Language")
                    
                    let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                    scene.scaleMode = .aspectFill
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: startGameTransition)
                    
                    //                enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    //                ruLabel.fontColor = UIColor.red
                    //                chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                } else if atPoint(location).name == "ChLabel" {
                    doneTouch = true
                    deinitMemoryJunk()
                    preferredLanguage = .ch
                    setLang = true
                    
                    let defaults = UserDefaults()
                    defaults.set("ch", forKey: "Choosen Language")
                    
                    let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                    scene.scaleMode = .aspectFill
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: startGameTransition)
                    
                    //                enLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    //                ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    //                chLabel.fontColor = UIColor.red
                } else if atPoint(location).name == "EsLabel" {
                    doneTouch = true
                    deinitMemoryJunk()
                    preferredLanguage = .es
                    setLang = true
                    
                    let defaults = UserDefaults()
                    defaults.set("es", forKey: "Choosen Language")
                    
                    let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                    scene.scaleMode = .aspectFill
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: startGameTransition)
                    
                    //                enLabel.fontColor = UIColor.red
                    //                ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    //                chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                } else if atPoint(location).name == "JpLabel" {
                    doneTouch = true
                    deinitMemoryJunk()
                    preferredLanguage = .jp
                    setLang = true
                    
                    let defaults = UserDefaults()
                    defaults.set("jp", forKey: "Choosen Language")
                    
                    let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                    scene.scaleMode = .aspectFill
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: startGameTransition)
                    
                    //                enLabel.fontColor = UIColor.red
                    //                ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    //                chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                } else if atPoint(location).name == "FrLabel" {
                    doneTouch = true
                    deinitMemoryJunk()
                    preferredLanguage = .fr
                    setLang = true
                    
                    let defaults = UserDefaults()
                    defaults.set("fr", forKey: "Choosen Language")
                    
                    let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                    scene.scaleMode = .aspectFill
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: startGameTransition)
                    
                    //                enLabel.fontColor = UIColor.red
                    //                ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    //                chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                } else if atPoint(location).name == "DeLabel" {
                    doneTouch = true
                    deinitMemoryJunk()
                    preferredLanguage = .gr
                    setLang = true
                    
                    let defaults = UserDefaults()
                    defaults.set("de", forKey: "Choosen Language")
                    
                    let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                    scene.scaleMode = .aspectFill
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: startGameTransition)
                    
                    //                enLabel.fontColor = UIColor.red
                    //                ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    //                chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                } else if atPoint(location).name == "EnLabel" {
                    doneTouch = true
                    deinitMemoryJunk()
                    preferredLanguage = .en
                    setLang = true
                    
                    let defaults = UserDefaults()
                    defaults.set("en", forKey: "Choosen Language")
                    
                    let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
                    scene.scaleMode = .aspectFill
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    view?.presentScene(scene, transition: startGameTransition)
                    
                    //                enLabel.fontColor = UIColor.red
                    //                ruLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                    //                chLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                } else if atPoint(location).name == "buyIcon" {
                    doneTouch = true
                    deinitMemoryJunk()
                    let scene = PurchaseScene(size: CGSize(width: 1536, height: 2048))
                    
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    // Present the scene
                    view?.presentScene(scene, transition: startGameTransition)
                    if #available(iOS 10.0, *) {
                        view?.preferredFramesPerSecond = 60
                    } else {
                        // Fallback on earlier versions
                    }            }
                
                /*
                 purchasedPushed = true
                 newScene = NewSceneEnum.PurchaseScene
                 newScene(newSceneLoc: newScene)
                 */
            }
        }
    }
    
    // MARK: Deinit all memory junk
    func deinitMemoryJunk() {
        distortButtonTimer?.invalidate()
        underScoreTimer?.invalidate()
    }
    
    // Auth
    private func auth() {
        Auth.auth().signIn(withEmail: "***", password: "***") { [weak self] (user, error) in  // PASSWORD GITHUB
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let defaults = UserDefaults()
                let defaultsIsExist = self?.isKeyPresentInUserDefaults(key: "userId")
                if !defaultsIsExist! {
                    // Set user id
                    let childRef = self?.ref?.childByAutoId()
                    
                    //highScoreNumber = 0
                    
                    // read user id
                    let userKey = childRef?.key
                    if userKey != nil {
                        userId = userKey!
                    }
                    
                    // set user id and high score to defautls
                    defaults.set(userId, forKey: "userId")
                    defaults.set(highScoreNumber, forKey: "highScoreSaved")
                    defaults.set(highScoreNumberSurvival, forKey: "highScoreSavedSurvival")
                    
                    // set user id and high score to FIREBASE
                    childRef?.child("highscore").setValue(highScoreNumber)
                    childRef?.child("nickname").setValue(nickName)
                    
                    for i in 1...lvlScore.count {
                        let lvlKeyIsExist = self?.isKeyPresentInUserDefaults(key: "A\(i)")
                        if !lvlKeyIsExist! {
                            defaults.set(lvlScore[i-1], forKey: "A\(i)")
                            //print(lvlScore[i])
                            //print("sheet")
                        }
                    }
                    
                    for i in 1...lvl2Score.count {
                        let lvlKeyIsExist = self?.isKeyPresentInUserDefaults(key: "B\(i)")
                        if !lvlKeyIsExist! {
                            defaults.set(lvl2Score[i-1], forKey: "B\(i)")
                            //print(lvlScore[i])
                            //print("sheet")
                        }
                    }
                    
                    for i in 1...lvl3Score.count {
                        let lvlKeyIsExist = self?.isKeyPresentInUserDefaults(key: "C\(i)")
                        if !lvlKeyIsExist! {
                            defaults.set(lvl3Score[i-1], forKey: "C\(i)")
                            //print(lvlScore[i])
                            //print("sheet")
                        }
                    }
                    
                    
                    
                    for i in 1...activeLevel.count {
                        let lvlKeyIsExist = self?.isKeyPresentInUserDefaults(key: "level\(i)IsAcitve")
                        if !lvlKeyIsExist! {
                            defaults.set(activeLevel[i-1], forKey: "level\(i)IsAcitve")
                            //print(activeLevel[i-1])
                            //print("sheet")
                        }
                    }
                    
                    for i in 1...active2Level.count {
                        let lvlKeyIsExist = self?.isKeyPresentInUserDefaults(key: "2level\(i)IsAcitve")
                        if !lvlKeyIsExist! {
                            defaults.set(active2Level[i-1], forKey: "2level\(i)IsAcitve")
                            //print(active2Level[i-1])
                            //print("sheet")
                        }
                    }
                    
                    for i in 1...active3Level.count {
                        let lvlKeyIsExist = self?.isKeyPresentInUserDefaults(key: "3level\(i)IsAcitve")
                        if !lvlKeyIsExist! {
                            defaults.set(active3Level[i-1], forKey: "3level\(i)IsAcitve")
                            //print(active3Level[i-1])
                            //print("sheet")
                        }
                    }
                    
                    let adsAttemtpsExist = self?.isKeyPresentInUserDefaults(key: "adsAttempts")
                    if !adsAttemtpsExist! {
                        defaults.set(adsAttemtps, forKey: "adsAttempts")
                    }
                    
                    userId = defaults.string(forKey: "userId")!
                    self?.highScore.alpha = 1.0
                    
                    let programmIsPaidExist = self?.isKeyPresentInUserDefaults(key: "ProgrammIsPaid")
                    if !programmIsPaidExist! {
                        defaults.set(programmIsPaid, forKey: "ProgrammIsPaid")
                    }
                }
                
                
                //defaults.set(adsAttemtps, forKey: "adsAttempts")
                
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
    
    private func loadReviewInvintationCount() {
        let defaults = UserDefaults()
        let invintationCountExist = self.isKeyPresentInUserDefaults(key: "reviewInvintationCount")
        if !invintationCountExist {
            defaults.set(inviteCount, forKey: "reviewInvintationCount")
        } else {
            inviteCount = defaults.integer(forKey: "reviewInvintationCount") //double(forKey: "TrioSeconds")
        }
        
        let invintationExist = self.isKeyPresentInUserDefaults(key: "reviewInvintation")
        if !invintationExist {
            defaults.set(inviteToReview, forKey: "reviewInvintation")
        } else {
            inviteToReview = defaults.bool(forKey: "reviewInvintation") //double(forKey: "TrioSeconds")
        }
    }
    
    private func loadDisabilities() {
        let defaults = UserDefaults()
        let disabilitiesExist = self.isKeyPresentInUserDefaults(key: "visualyImpaired")
        if !disabilitiesExist {
            defaults.set(visualyImpairedStatus, forKey: "visualyImpaired")
        } else {
            visualyImpairedStatus = defaults.bool(forKey: "visualyImpaired") //double(forKey: "TrioSeconds")
        }
    }
    
    private func loadAdsAttemtps() {
        let defaults = UserDefaults()
        let adsAttemtpsExist = self.isKeyPresentInUserDefaults(key: "adsAttempts")
        if !adsAttemtpsExist {
            defaults.set(adsAttemtps, forKey: "adsAttempts")
            //trioTimeActive = 100
            //print(active2Level[i-1])
        } else {
            adsAttemtps = defaults.integer(forKey: "adsAttempts") //double(forKey: "TrioSeconds")
        }
    }
    
    private func programmPaidOrNot() {
        let defaults = UserDefaults()
        let defaultsIsExist = self.isKeyPresentInUserDefaults(key: "ProgrammIsPaid")
        if !defaultsIsExist {
            defaults.set(programmIsPaid, forKey: "ProgrammIsPaid")
            //trioTimeActive = 100
            //print(active2Level[i-1])
        } else {
            programmIsPaid = defaults.bool(forKey: "ProgrammIsPaid") //double(forKey: "TrioSeconds")
        }
    }
    
    private func loadSeconds() {
        let defaults = UserDefaults()
        var defaultsIsExist = self.isKeyPresentInUserDefaults(key: "TrioSeconds")
        if !defaultsIsExist {
            defaults.set(400, forKey: "TrioSeconds")
            trioTimeActive = 400
            //print(active2Level[i-1])
        } else {
            trioTimeActive = defaults.double(forKey: "TrioSeconds")
        }
        
        defaultsIsExist = self.isKeyPresentInUserDefaults(key: "RougeSeconds")
        if !defaultsIsExist {
            defaults.set(600, forKey: "RougeSeconds")
            rougeOneTimeActive = 600
            //print(active2Level[i-1])
        } else {
            rougeOneTimeActive = defaults.double(forKey: "RougeSeconds")
        }
        
        defaultsIsExist = self.isKeyPresentInUserDefaults(key: "InvisibleSeconds")
        if !defaultsIsExist {
            defaults.set(150, forKey: "InvisibleSeconds")
            InvisibleTimeActive = 150
            //print(active2Level[i-1])
        } else {
            InvisibleTimeActive = defaults.double(forKey: "InvisibleSeconds")
        }
    }
    
    @objc private func loadScores() {
        let defaults = UserDefaults()
        //defaults.set(0, forKey: "level\(3)IsAcitve")
        for i in 1...lvlScore.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "A\(i)")
            if lvlKeyIsExist {
                lvlScore[i-1] = defaults.integer(forKey: "A\(i)")
                //print(lvlScore[i])
                //print("A\(i) - \(lvlScore[i-1])")
            }
            
        }
        
        for i in 1...lvl2Score.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "B\(i)")
            if lvlKeyIsExist {
                lvl2Score[i-1] = defaults.integer(forKey: "B\(i)")
                //print(lvlScore[i])
                //print("B\(i) - \(lvl2Score[i-1])")
            }
            
        }
        
        for i in 1...lvl3Score.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "C\(i)")
            if lvlKeyIsExist {
                lvl3Score[i-1] = defaults.integer(forKey: "C\(i)")
                //print(lvlScore[i])
                //print("C\(i) - \(lvl3Score[i-1])")
            }
            
        }
        
        let lvlKeyForSurvivalIsExist = self.isKeyPresentInUserDefaults(key: "highScoreSavedSurvival")
        if lvlKeyForSurvivalIsExist {
            highScoreNumberSurvival = defaults.integer(forKey: "highScoreSavedSurvival")
            //print(lvlScore[i])
            //print("\(highScoreNumberSurvival)")
        }
        //defaults.set(10, forKey: "highScoreSaved")
        /*
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value)")
        }
         */
    }
    
    private func loadLevelIsActive() {
        let defaults = UserDefaults()
        for i in 1...activeLevel.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "level\(i)IsAcitve")
            if lvlKeyIsExist {
                activeLevel[i-1] = defaults.integer(forKey: "level\(i)IsAcitve")
                //print(lvlScore[i])
                //print("level\(i)IsAcitve - \(activeLevel[i-1])")
            }
            
        }
        
        for i in 1...active2Level.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "2level\(i)IsAcitve")
            if lvlKeyIsExist {
                active2Level[i-1] = defaults.integer(forKey: "2level\(i)IsAcitve")
                //print(lvlScore[i])
                //print("2level\(i)IsAcitve - \(active2Level[i-1])")
            }
            
        }
        
        for i in 1...active3Level.count {
            let lvlKeyIsExist = self.isKeyPresentInUserDefaults(key: "3level\(i)IsAcitve")
            if lvlKeyIsExist {
                active3Level[i-1] = defaults.integer(forKey: "3level\(i)IsAcitve")
                //print(lvlScore[i-1])
                //print("3level\(i)IsAcitve - \(active3Level[i-1])")
            }
            
        }
    }
    
    private func loadUpgrades() {
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
    
    private func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    // ?????????????????
    private func saveUserDefaults() {
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
        //print("mainmenue deinit")
        motionManeger.stopGyroUpdates()
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}   // class
