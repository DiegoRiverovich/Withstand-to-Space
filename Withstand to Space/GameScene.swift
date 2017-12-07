//
//  GameScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 19.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import GoogleMobileAds

//let constructionTimeIntervalArray: Array = [2,4,1,1,1,1,1,2,5,7,1,1,1,1,1]   // 15

class GameScene: SKScene, SKPhysicsContactDelegate, GADInterstitialDelegate {
    
    var restatrButtonPressedForAds: Bool = false
    var newLevelButtonPressedForAds: Bool = false
    var mainMenuButtonPressedForAds: Bool = false
    
    var trioTimeActiveLoc: Double = 0 {
        didSet {
           trioTimeActive += trioTimeActiveLoc.truncate(places: 1)
            popupSPPoints(with: 0)
            trioTimerLabel.text = "\(trioTimeActive.truncate(places: 1))"
            //let invisibleTimerLabel = SKLabelNode(fontNamed: "Helvetica")
            //let rougeOneTimerLabel
        }
    }
    var rougeOneTimeActiveLoc: Double = 0 {
        didSet {
            rougeOneTimeActive += rougeOneTimeActiveLoc.truncate(places: 1)
            popupSPPoints(with: 1)
            rougeOneTimerLabel.text = "\(rougeOneTimeActive.truncate(places: 1))"
        }
    }
    var InvisibleTimeActiveLoc: Double = 0 {
        didSet {
            InvisibleTimeActive += InvisibleTimeActiveLoc.truncate(places: 1)
            popupSPPoints(with: 2)
            invisibleTimerLabel.text = "\(InvisibleTimeActive.truncate(places: 1))"
        }
    }
    
    //var playerShipNotDeinit = PlayerShip()
    var pushedPause = false
    
    var gameOverIsRuning = false
    
    var hackableDebris = Debris()
    
    let gameLayer = SKNode()
    let pauseLayer = SKNode()
    
    var puzzleGameArray = [1, 2, 3, 4, 5]
    var puzzleCurrentGameStatus = false
    var showHintOneTime = false
    var puzzleDotsOnTheScreen = false
    var puzzleTimeOut = false
    var puzzleColocHitVisible = false
    //var puzzleIsColors = true
    
    var levelNumber = 1
    //var livesNumber = 3

    enum ButtonsStatus {
        case settings
        case shipUpgrades
        case hintWindow
        case hintIcon
        case none
    }
    var buttonStatus: ButtonsStatus = .none
    
    enum SuperButtonsStatus {
        case normal
        case trio
        case rouge
        case invisible
    }
    var superButtonStatus: SuperButtonsStatus = .normal
    
    var canMove: Bool = false
    var hintDone: Bool = false
    
    var ship = PlayerShip()
    var tempShipRouge = PlayerShip()
    var rougeOneShipGlobal: PlayerShip?
    
    var partitions = [Partition]()
    
    // Menu buttons
    var restartButton = SKSpriteNode()
    var goToMenuButton = SKSpriteNode()
    var levelsButton = SKSpriteNode()
    var settingsButton = SKSpriteNode()
    //var controlButton = SKSpriteNode()
    var musicOnOffButton = SKSpriteNode()
    var soundsOnOffButton = SKSpriteNode()
    
    //let normalStatusButton = SKSpriteNode(imageNamed: "statusNormalN140.png")
    let trioStatusButton = SKSpriteNode(imageNamed: "statusTrio1" /*"statusTrioN140.png"*/)
    let rougeOneStatusButton = SKSpriteNode(imageNamed: "statusRougeOne1" /*"statusRougeOneN140.png"*/)
    let invisibleStatusButton = SKSpriteNode(imageNamed: "statusInvisible1" /*"statusInvisibleN140.png"*/)
    
    let puzzleBackground = SKSpriteNode(imageNamed: "puzzleBack")
    var redDot = SKSpriteNode(imageNamed: "puzzleRedDot1")
    var yellowDot = SKSpriteNode(imageNamed: "puzzleYellowDot1")
    var blueDot = SKSpriteNode(imageNamed: "puzzleBlueDot1")
    var greenDot = SKSpriteNode(imageNamed: "puzzleGreenDot1")
    var purpleDot = SKSpriteNode(imageNamed: "puzzlePurpleDot1")
    
    var redDotHint = SKSpriteNode(imageNamed: "puzzleRedDot1")
    var yellowDotHint = SKSpriteNode(imageNamed: "puzzleYellowDot1")
    var blueDotHint = SKSpriteNode(imageNamed: "puzzleBlueDot1")
    var greenDotHint = SKSpriteNode(imageNamed: "puzzleGreenDot1")
    var purpleDotHint = SKSpriteNode(imageNamed: "puzzlePurpleDot1")
    
    let timeLine = SKSpriteNode(imageNamed: "timeLine1")
    var timeLinePeg = SKSpriteNode(imageNamed: "shipUpgradesIcon2" /*"timeLinePeg1"*/)
    
    let spacestation = SpaceStation()
    
    //let engineSoundsAction = SKAction.playSoundFileNamed("boom1.m4a", waitForCompletion: false)
    
    //var partitionHigherThenTheShip = false
    //var gameBackgroundMusic: AVAudioPlayer?
    var player = AVAudioPlayer()
    let path = Bundle.main.path(forResource: "gameMusicNew1" /*"SoulStar"*/, ofType: "m4a")
    
    var playerEngine = AVAudioPlayer()
    let pathEngine = Bundle.main.path(forResource: "engineNew" /*"SoulStar"*/, ofType: "m4a")
    
    var coins: Int = 0 {
        didSet {
            if preferredLanguage == .ru {
                coinsLabel.text = "⚡️: \(coins)" //String("Топливо: \(coins)")
            } else if preferredLanguage == .ch {
                coinsLabel.text = "⚡️: \(coins)" //String("能源: \(coins)")
            } else if preferredLanguage == .es {
                coinsLabel.text = "⚡️: \(coins)" // String("Energía: \(coins)")
            } else {
                coinsLabel.text = "⚡️: \(coins)" // String("Energy: \(coins)")
            }
            
            score = coins
            
            popupCoinsCount()
            
            if gameMode == .survival {
                encreaseSpeedDebrisAndCoins()
            }
        }
    }
    
    var lostCoins: Int = 10 {
        didSet {
            lostCoinsLabel.text = String("Lives: \(lostCoins)")
            if lostCoins <= 0 {
                runGameOver()
            }
        }
    }
    
    var barrierTimer: Timer?
    var partitionTimer: Timer?
    var planetTimer: Timer?
    var spacestationTimer: Timer?
    var constructionTimer: Timer?
    var showHintTimer: Timer?
    var dotSequnceTimerShow: Timer?
    var dotSequnceTimerHide: Timer?
    var puzzleDotsHideTimer: Timer?
    var survivalCoinSetupTimer: Timer?
    
    var t1: Timer?
    var t2: Timer?
    var t3: Timer?
    var t4: Timer?
    var t5: Timer?
    
    var constructionTimerfireDate: TimeInterval = 0
    var showHintsTimerfireDate: TimeInterval = 0
    var hideHintsTimerfireDate: TimeInterval = 0
    var puzzleDotsHideTimerfireDate: TimeInterval = 0
    var levelHintTimerfireDate: TimeInterval = 0
    var coinForSurvivalFireDate: TimeInterval = 0
    
    var trioTimerfireDate: TimeInterval = 0
    
    var constructionTimeInterval = 0
    var constructionBarrierAnimationDuration: TimeInterval = 0
    
    var survivorDebrisTimeInterval: TimeInterval = 1.9
    var survivorCoinTimeInterval: TimeInterval = 1.6
    
    let coinsLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)     // Helvetica
    let lostCoinsLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    
    let levelNumberLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    let planetNumberLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    
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
    
    
    
    let musicPlayIcon = SKSpriteNode(imageNamed: "musicMute")
    let hintExclamationIcon = SKSpriteNode(imageNamed: "exclamationPointIcon")
    let shipUpgradesIcon = SKSpriteNode(imageNamed: "shipUpgradesIcon")
    let shipUpgradesWindow = SKSpriteNode(imageNamed: "shipUpgradesHint")
    
    var trioTimer = Timer()
    var invisibleTimer = Timer()
    var rougeOneTimer = Timer()
    
    var interstitial: GADInterstitial!
    
    override func didMove(to view: SKView) {
        
        //runAds()
        loadMainScene()
        
    }

    override func willMove(from view: SKView) {
        //removeSwipeGestures()
    }
    
    func loadMainScene() {
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        
        interstitial.delegate = self
        
        ads = interstitial
        
        
        self.addChild(gameLayer)
        self.addChild(pauseLayer)
        
        self.physicsWorld.contactDelegate = self
        
        canMove = true
        currentGameStatus = .inGame
        shipExplode = false
        
        ship.mainScene = self
        
        
        backgroundSetup()
        playerSetup()
        buttonsSetup()
        
        addBackgroundMusic()
        
        setupRecognizers()
        partitions.removeAll()
        
        let spaceStationYesNo = 1 //Int(arc4random()%2)
        if gameMode == .normal {
            if canMove {
                //barrierTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameScene.barrierSetup), userInfo: nil, repeats: true)
                //partitionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameScene.partitionSetup), userInfo: nil, repeats: true)
                planetTimer = Timer.scheduledTimer(timeInterval: TimeInterval(200), target: self, selector: #selector(GameScene.planetsSetup), userInfo: nil, repeats: false)
                if spaceStationYesNo == 1 {
                    spacestationTimer = Timer.scheduledTimer(timeInterval: TimeInterval(20), target: self, selector: #selector(GameScene.spacestationSetup), userInfo: nil, repeats: false)
                }
                constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
                if hintLevel {
                    showHintTimer = Timer.scheduledTimer(timeInterval: TimeInterval(4), target: self, selector: #selector(GameScene.showHint), userInfo: nil, repeats: false)
                    //print("timer hint")
                }
            }
        } else if gameMode == .survival {
            if canMove {
                constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(survivorDebrisTimeInterval), target: self, selector: #selector(GameScene.invokeConstructionBarrierSetupForSurvival), userInfo: nil, repeats: true)
                survivalCoinSetupTimer = Timer.scheduledTimer(timeInterval: TimeInterval(survivorCoinTimeInterval), target: self, selector: #selector(GameScene.invokeCoinSetupForSurvival), userInfo: nil, repeats: true)
                //barrierTimer = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameScene.barrierSetup), userInfo: nil, repeats: true)
                //partitionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameScene.partitionSetup), userInfo: nil, repeats: true)
                
            }
        }
        
        // Setup score label
        if preferredLanguage == .ru {
            coinsLabel.text = "⚡️: 0" //"Топливо: 0"
        } else if preferredLanguage == .ch {
            coinsLabel.text = "⚡️: 0" //"能源: 0"
        } else if preferredLanguage == .es {
            coinsLabel.text = "⚡️: 0" //"Energía: 0"
        } else {
            coinsLabel.text = "⚡️: 0" //"Energy: 0"
        }
        
        coinsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        coinsLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.95)
        coinsLabel.zPosition = 50
        coinsLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        coinsLabel.fontSize = 60
        //self.addChild(coinsLabel)
        self.gameLayer.addChild(coinsLabel)
        
        if gameMode == .survival {
            // Setup lose label
            lostCoinsLabel.text = "Lives: 10"
            lostCoinsLabel.position = CGPoint(x: self.size.width * 0.70, y: self.size.height * 0.95)
            lostCoinsLabel.fontColor = UIColor.white
            lostCoinsLabel.fontSize = 60
            self.gameLayer.addChild(lostCoinsLabel)   //Disabled lose coins
        } else if gameMode == .normal {
            levelNumberLabelSetup()
            populatedPlanet()
            travelIndicator()
        }
        
        
        
        // Set score to zero. New game
        score = 0
        
        
        
        
        // Notification center on blow the ship
        NotificationCenter.default.addObserver(forName: SomeNames.blowTheShip, object: nil, queue: nil) { [weak self] (notification) in
            self?.runGameOver()
        }
        
        /////////
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.applicationWillResignActive(notification:)), name: NSNotification.Name.UIApplicationWillResignActive, object: app)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(GameScene.applicationDidEnterBackground(notification:)), name: NSNotification.Name.UIAppli, object: app)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.applicationDidEnterBackground(notification:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: app)
        
        
        // Construction setup
        //constructionSetup()
        addPhysicsBodyToConstruction()
        
        ship.jetFire?.isHidden = false
        
        menuButtonsSetup()
        setupShipUpgradesWindow()
        
        //levelNumberLabelSetup()
        
        addEngineBackground()
        runPuzzleSequence()
        
        loadTimeActiveSeconds()
        
        
        checkSP()
        
    }
    
    func encreaseSpeedDebrisAndCoins() {
        switch coins {
        case 1:
            survivorDebrisTimeInterval = 1.8
            survivorCoinTimeInterval = 1.5
        case 2:
            survivorDebrisTimeInterval = 1.7
            survivorCoinTimeInterval = 1.4
        case 3:
            survivorDebrisTimeInterval = 1.6
            survivorCoinTimeInterval = 1.3
        case 4:
            survivorDebrisTimeInterval = 1.5
            survivorCoinTimeInterval = 1.2
        case 5:
            survivorDebrisTimeInterval = 1.4
            survivorCoinTimeInterval = 1.1
        default:
            survivorDebrisTimeInterval = 1.4
            survivorCoinTimeInterval = 1.1
        }
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        if restatrButtonPressedForAds == true {
            newScene()
        } else if mainMenuButtonPressedForAds == true {
            newMainMenuSceneForAds()
        } else if newLevelButtonPressedForAds == true {
            newLevelMenuSceneForAds()
        }
        
    }
    
    func runAds() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: (self.view?.window?.rootViewController)!)
        } else {
            if restatrButtonPressedForAds == true {
                newScene()
            }  else if mainMenuButtonPressedForAds == true {
                newMainMenuSceneForAds()
            } else if newLevelButtonPressedForAds == true {
                newLevelMenuSceneForAds()
            }
            print("Ad wasn't ready")
        }
    }
    
    func newMainMenuSceneForAds() {
        //self.view?.isPaused = false
        saveTimeActiveSeconds()
        gameLayer.isPaused = false
        if soundsIsOn {
            run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
        }
        //self.view?.scene
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        // Present the scene
        view?.presentScene(scene, transition: startGameTransition)
        if #available(iOS 10.0, *) {
            view?.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
        }
        //print("mainmenu")
        clean()
    }
    
    func newLevelMenuSceneForAds() {
        //self.view?.isPaused = false
        saveTimeActiveSeconds()
        gameLayer.isPaused = false
        if soundsIsOn {
            run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
        }
        //self.view?.scene
        let scene = LevelsScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        // Present the scene
        view?.presentScene(scene, transition: startGameTransition)
        if #available(iOS 10.0, *) {
            view?.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
        }
        //print("mainmenu")
        clean()
    }
    
    func settingButtonFunc() {
        print("canmove \(canMove), gameLayer.isPaused \(gameLayer.isPaused), scene?.isPaused \(String(describing: scene?.isPaused)) ")
        
        if pushedPause == false {
            if canMove {
                pauseFuncSettings()
                canMove = false
            } else if !canMove {
                pauseFuncSettings()
                canMove = true
            }
            //pushedPause = false
        } else {
            
            /*if !canMove && gameLayer.isPaused == true {
             scene?.isPaused = true
             print("1")
             }else if !canMove && gameLayer.isPaused == true && scene?.isPaused == true {
             scene?.isPaused = false
             print("2")
             }*/
            
            
            if canMove  {
                //animateMenuButtons()
                scene?.isPaused = true
                pauseFuncSettings()
                
                //gameLayer.isPaused = true
                
                
                canMove = false
                //buttonStatus = .settings
                
                //levelNumberLabel.isHidden = true
                print("3")
            } else if !canMove {
                //gameLayer.isPaused = true
                scene?.isPaused = true
                
                //pauseFuncSettings()
                //canMove = true
                //menuButtonsHide()
                
                //buttonStatus = .none
                
                //levelNumberLabel.isHidden = false
                print("4")
            }
        }
    }
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        //pushedPause = true
        settingButtonFunc()
        
        print("willActive")
    }
    
    @objc func applicationDidEnterBackground(notification: NSNotification) {
        //pushedPause = false
        settingButtonFunc()
        
        print("Didbackground")
    }
    
    //var stepCount = 0
    func moveTimeLinePeg() {
        let travelStep = timeLine.size.height / CGFloat(constructionLevelDurationTimerInterval)
        timeLinePeg.position.y += travelStep //(((timeLine.size.height - (timeLine.size.height / 2))) - timeLine.size.height) + travelStep
        //print("step \(stepCount)")
        //stepCount += 1
    }
    
    func travelIndicator() {
        timeLine.position = CGPoint(x: (self.size.width * 0.15), y: self.size.height * 0.5)
        timeLine.zPosition = 10
        //timeLine.xScale = 0.5
        //timeLine.yScale = 0.5
        timeLine.name = "Time Line"
        //self.addChild(settingsButton)
        self.gameLayer.addChild(timeLine)
        
        timeLinePeg.position = CGPoint(x: (timeLine.size.width - timeLine.size.width) + 40, y: (timeLine.size.height - timeLine.size.height) - (timeLine.size.height / 2))
        timeLinePeg.zPosition = 10
        timeLinePeg.xScale = 0.1
        timeLinePeg.yScale = 0.1
        timeLinePeg.name = "Time Line Peg"
        timeLine.addChild(timeLinePeg)
    }
    
    func populatedPlanet() {
        
        //let planetObject = Planet(texture: SKTexture(imageNamed: "venus"))
        var populatedPlanet = Planet()
        if planet == 1 {
            populatedPlanet = Planet(texture: SKTexture(imageNamed: /*"venus"*/ "planet01_400"))
        } else if planet == 2 {
            populatedPlanet = Planet(texture: SKTexture(imageNamed: "venus_500" /*"planet01_900"*/))
        } else if planet == 3 {
            populatedPlanet = Planet(texture: SKTexture(imageNamed: "planet_31" /*"planet01_900"*/))
        }
        //planetObject.position = CGPoint(x: self.size.width * 0.20, y: self.size.height * 1.30)
        populatedPlanet.position.y = self.size.height * 0.95
        populatedPlanet.position.x = self.size.width / 2
        populatedPlanet.zPosition = -20
        populatedPlanet.yScale = 0.4
        populatedPlanet.xScale = 0.4
        populatedPlanet.name = "Populated planet"
        
        if level == 1 {
            populatedPlanet.position.y = self.size.height * 0.90
            populatedPlanet.yScale = 1.42
            populatedPlanet.xScale = 1.42
        } else if level == 2 {
            populatedPlanet.position.y = self.size.height * 0.85
            populatedPlanet.yScale = 1.44
            populatedPlanet.xScale = 1.44
        } else if level == 3 {
            populatedPlanet.position.y = self.size.height * 0.80
            populatedPlanet.yScale = 1.46
            populatedPlanet.xScale = 1.46
        } else if level == 4 {
            populatedPlanet.position.y = self.size.height * 0.75
            populatedPlanet.yScale = 1.48
            populatedPlanet.xScale = 1.48
        } else if level == 5 {
            populatedPlanet.position.y = self.size.height * 0.70
            populatedPlanet.yScale = 1.50
            populatedPlanet.xScale = 1.50
        } else if level == 6 {
            populatedPlanet.position.y = self.size.height * 0.65
            populatedPlanet.yScale = 1.52
            populatedPlanet.xScale = 1.52
        } else if level == 7 {
            populatedPlanet.position.y = self.size.height * 0.60
            populatedPlanet.yScale = 1.54
            populatedPlanet.xScale = 1.54
        } else if level == 8 {
            populatedPlanet.position.y = self.size.height * 0.55
            populatedPlanet.yScale = 1.56
            populatedPlanet.xScale = 1.56
        } else if level == 9 {
            populatedPlanet.position.y = self.size.height * 0.50
            populatedPlanet.yScale = 1.58
            populatedPlanet.xScale = 1.58
        } else if level == 10 {
            populatedPlanet.position.y = self.size.height * 0.45
            populatedPlanet.yScale = 1.60
            populatedPlanet.xScale = 1.60
        } else if level == 11 {
            populatedPlanet.position.y = self.size.height * 0.40
            populatedPlanet.yScale = 1.62
            populatedPlanet.xScale = 1.62
        }
        
        //self.addChild(planetObject)
        self.gameLayer.addChild(populatedPlanet)
        
        
    }
    
    func runPuzzleSequence() {
        if puzzle {
            puzzleGameArray.shuffle()
            printPuzzleColors()
            print(puzzleGameArray)
            //showDotSequence()
            dotSequnceTimerShow = Timer.scheduledTimer(timeInterval: TimeInterval(8), target: self, selector: #selector(GameScene.showDotSequence), userInfo: nil, repeats: false)
        }
    }
    
    //MAKR: popup SP points
    func popupSPPoints(with SP: Int) {
        let popupSPPointsLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        if SP == 0 {
            popupSPPointsLabel.text = String("Trio +0.1")
        } else if SP == 1 {
            popupSPPointsLabel.text = String("Double +0.1")
        } else if SP == 2 {
            popupSPPointsLabel.text = String("Invisible +0.1")
        }
        //popupCoinsLabel.text = "0"
        popupSPPointsLabel.position = CGPoint(x: spacestation.position.x - 200, y: spacestation.position.y)
        popupSPPointsLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        popupSPPointsLabel.fontSize = 80
        popupSPPointsLabel.zPosition = 100
        popupSPPointsLabel.alpha = 0.0
        
        self.gameLayer.addChild(popupSPPointsLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        let moveUpAction = SKAction.moveTo(y: spacestation.position.y + 50, duration: 0.3)
        let scaleUpAction = SKAction.scale(to: 2.0, duration: 0.3)
        let firstGroupAction = SKAction.group([fadeInAction, scaleUpAction, moveUpAction])
        firstGroupAction.timingMode = SKActionTimingMode.easeInEaseOut
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let moveUpAction2 = SKAction.moveTo(y: spacestation.position.y + 130, duration: 0.3)
        let scaleUpAction2 = SKAction.scale(to: 1.0, duration: 0.3)
        let removeLabel = SKAction.removeFromParent()
        let secondGroupAction = SKAction.group([fadeOutAction, scaleUpAction2, moveUpAction2/*, removeLabel,*/ /*moveBack, scaleBack*/])
        
        
        let popupLabelSequence = SKAction.sequence([firstGroupAction, secondGroupAction, removeLabel])
        popupLabelSequence.timingMode = SKActionTimingMode.easeInEaseOut
        
        popupSPPointsLabel.run(popupLabelSequence)
    }
    
    //MARK: popup coins count
    func popupCoinsCount() {
        let popupCoinsLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        popupCoinsLabel.text = String("\(coins)")
        //popupCoinsLabel.text = "0"
        popupCoinsLabel.position = CGPoint(x: ship.position.x - 200, y: ship.position.y)
        popupCoinsLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        popupCoinsLabel.fontSize = 80
        popupCoinsLabel.zPosition = 100
        popupCoinsLabel.alpha = 0.0
        
        self.gameLayer.addChild(popupCoinsLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        let moveUpAction = SKAction.moveTo(y: ship.position.y + 50, duration: 0.3)
        let scaleUpAction = SKAction.scale(to: 2.0, duration: 0.3)
        let firstGroupAction = SKAction.group([fadeInAction, scaleUpAction, moveUpAction])
        firstGroupAction.timingMode = SKActionTimingMode.easeInEaseOut
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let moveUpAction2 = SKAction.moveTo(y: ship.position.y + 130, duration: 0.3)
        let scaleUpAction2 = SKAction.scale(to: 1.0, duration: 0.3)
        let removeLabel = SKAction.removeFromParent()
        let secondGroupAction = SKAction.group([fadeOutAction, scaleUpAction2, moveUpAction2/*, removeLabel,*/ /*moveBack, scaleBack*/])
        
        
        let popupLabelSequence = SKAction.sequence([firstGroupAction, secondGroupAction, removeLabel])
        popupLabelSequence.timingMode = SKActionTimingMode.easeInEaseOut
        
        popupCoinsLabel.run(popupLabelSequence)
    }
    
    //MARK: show sequence dots
    var printCountShowHint = 1
    @objc func showDotSequence() {
        //print("printCountShowHint \(printCountShowHint) -------")
        if !puzzleIsColors {
            redDotHint = SKSpriteNode(imageNamed: "puzzlePurpleDot1A")
            yellowDotHint = SKSpriteNode(imageNamed: "puzzlePurpleDot1C")
            blueDotHint = SKSpriteNode(imageNamed: "puzzlePurpleDot1B")
            greenDotHint = SKSpriteNode(imageNamed: "puzzlePurpleDot1D")
            purpleDotHint = SKSpriteNode(imageNamed: "puzzlePurpleDot1E")
            //print("sdfafafsdfsafsd")
        }
        
        //let redDotHint = SKSpriteNode(imageNamed: "puzzleRedDot1")
        redDotHint.position = CGPoint(x: /*puzzleBackground.size.width*/ (self.size.width / 2) - 200 , y: self.scene!.size.height * 0.9)
        redDotHint.zPosition = 270
        redDotHint.name = "1"
        redDotHint.alpha = 0.0
        redDotHint.xScale = 1.5
        redDotHint.yScale = 1.5
        
        
        
        //let yellowDotHint = SKSpriteNode(imageNamed: "puzzleYellowDot1")
        yellowDotHint.position = CGPoint(x: /*puzzleBackground.size.width*/ (self.size.width / 2) - 100, y: self.scene!.size.height * 0.9)
        yellowDotHint.zPosition = 270
        yellowDotHint.name = "3"
        yellowDotHint.alpha = 0.0
        yellowDotHint.xScale = 1.5
        yellowDotHint.yScale = 1.5
        
        
        
        //let blueDotHint = SKSpriteNode(imageNamed: "puzzleBlueDot1")
        blueDotHint.position = CGPoint(x: /*puzzleBackground.size.width*/ (self.size.width / 2), y: self.scene!.size.height * 0.9)
        blueDotHint.zPosition = 270
        blueDotHint.name = "2"
        blueDotHint.alpha = 0.0
        blueDotHint.xScale = 1.5
        blueDotHint.yScale = 1.5
        
        
        //let greenDotHint = SKSpriteNode(imageNamed: "puzzleGreenDot1")
        greenDotHint.position = CGPoint(x: /*puzzleBackground.size.width*/ (self.size.width / 2) + 100, y: self.scene!.size.height * 0.9)
        greenDotHint.zPosition = 270
        greenDotHint.name = "4"
        greenDotHint.alpha = 0.0
        greenDotHint.xScale = 1.5
        greenDotHint.yScale = 1.5
        
        
        //let purpleDotHint = SKSpriteNode(imageNamed: "puzzlePurpleDot1")
        purpleDotHint.position = CGPoint(x: /*puzzleBackground.size.width*/ (self.size.width / 2) + 200, y: self.scene!.size.height * 0.9)
        purpleDotHint.zPosition = 270
        purpleDotHint.name = "5"
        purpleDotHint.alpha = 0.0
        purpleDotHint.xScale = 1.5
        purpleDotHint.yScale = 1.5
        
        
        for i in 0...2 {
            if i == 0 {
                if puzzleGameArray[i] == 1 {
                    redDotHint.position = CGPoint(x:(self.size.width / 2) - 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(redDotHint)
                }
                if puzzleGameArray[i] == 2 {
                    blueDotHint.position = CGPoint(x:(self.size.width / 2) - 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(blueDotHint)
                }
                if puzzleGameArray[i] == 3 {
                    yellowDotHint.position = CGPoint(x:(self.size.width / 2) - 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(yellowDotHint)
                }
                if puzzleGameArray[i] == 4 {
                    greenDotHint.position = CGPoint(x:(self.size.width / 2) - 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(greenDotHint)
                }
                if puzzleGameArray[i] == 5 {
                    purpleDotHint.position = CGPoint(x:(self.size.width / 2) - 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(purpleDotHint)
                }
            } else if i == 1 {
                if puzzleGameArray[i] == 1 {
                    redDotHint.position = CGPoint(x:(self.size.width / 2) , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(redDotHint)
                }
                if puzzleGameArray[i] == 2 {
                    blueDotHint.position = CGPoint(x:(self.size.width / 2) , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(blueDotHint)
                }
                if puzzleGameArray[i] == 3 {
                    yellowDotHint.position = CGPoint(x:(self.size.width / 2) , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(yellowDotHint)
                }
                if puzzleGameArray[i] == 4 {
                    greenDotHint.position = CGPoint(x:(self.size.width / 2) , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(greenDotHint)
                }
                if puzzleGameArray[i] == 5 {
                    purpleDotHint.position = CGPoint(x:(self.size.width / 2) , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(purpleDotHint)
                }
            } else if i == 2 {
                if puzzleGameArray[i] == 1 {
                    redDotHint.position = CGPoint(x:(self.size.width / 2) + 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(redDotHint)
                }
                if puzzleGameArray[i] == 2 {
                    blueDotHint.position = CGPoint(x:(self.size.width / 2) + 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(blueDotHint)
                }
                if puzzleGameArray[i] == 3 {
                    yellowDotHint.position = CGPoint(x:(self.size.width / 2) + 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(yellowDotHint)
                }
                if puzzleGameArray[i] == 4 {
                    greenDotHint.position = CGPoint(x:(self.size.width / 2) + 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(greenDotHint)
                }
                if puzzleGameArray[i] == 5 {
                    purpleDotHint.position = CGPoint(x:(self.size.width / 2) + 200 , y: self.scene!.size.height * 0.9)
                    gameLayer.addChild(purpleDotHint)
                }
            }
        }
        redDotHint.run(SKAction.fadeIn(withDuration: 0.5))
        yellowDotHint.run(SKAction.fadeIn(withDuration: 0.5))
        blueDotHint.run(SKAction.fadeIn(withDuration: 0.5))
        greenDotHint.run(SKAction.fadeIn(withDuration: 0.5))
        purpleDotHint.run(SKAction.fadeIn(withDuration: 0.5))
        
        dotSequnceTimerHide = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameScene.hideDotsHitns), userInfo: nil, repeats: false)
        puzzleColocHitVisible = true
        
    }
    
    func printPuzzleColors() {
        for i in 0...2 {
            if puzzleGameArray[i] == 1 {
                //print("red")
            }
            if puzzleGameArray[i] == 2 {
                //print("blue")
            }
            if puzzleGameArray[i] == 3 {
                //print("yellow")
            }
            if puzzleGameArray[i] == 4 {
                //print("green")
            }
            if puzzleGameArray[i] == 5 {
                //print("purple")
            }
        }
    }
    
    var waitToHideDots = SKAction()
    var waitToHideDotsActionDuration = TimeInterval()
    // MARK: Add puzzle game figures
    func addPuzzleGamePics() {
        
        if !puzzleIsColors {
            redDot = SKSpriteNode(imageNamed: "puzzlePurpleDot1A")
            yellowDot = SKSpriteNode(imageNamed: "puzzlePurpleDot1C")
            blueDot = SKSpriteNode(imageNamed: "puzzlePurpleDot1B")
            greenDot = SKSpriteNode(imageNamed: "puzzlePurpleDot1D")
            purpleDot = SKSpriteNode(imageNamed: "puzzlePurpleDot1E")
            //print("sdfafafsdfsafsd")
        }
        
        puzzleTimeOut = false
        
        redDot.xScale = 1.5
        redDot.yScale = 1.5
        
        blueDot.xScale = 1.5
        blueDot.yScale = 1.5
        
        yellowDot.xScale = 1.5
        yellowDot.yScale = 1.5
        
        greenDot.xScale = 1.5
        greenDot.yScale = 1.5
        
        purpleDot.xScale = 1.5
        purpleDot.yScale = 1.5
        
        
        
        firstDot = false
        secondDot = false
        thirdDot = false
        
        puzzleCurrentGameStatus = true
        //let puzzleBackground = SKSpriteNode(imageNamed: "puzzleBack")
        puzzleBackground.position = CGPoint(x: self.size.width/6, y: self.size.height/4)
        puzzleBackground.zPosition = 30
        puzzleBackground.name = "Puzzle Back"
        puzzleBackground.anchorPoint = CGPoint(x: 0, y: 0)
        
        randomPositionDots()
        
        
        //let redDot = SKSpriteNode(imageNamed: "puzzleRedDot")
        redDot.position = CGPoint(x: /*puzzleBackground.size.width*/ (self.scene!.size.width * redXPosition) + 1000, y: self.scene!.size.height * redYPosition)
        redDot.zPosition = 270
        redDot.name = "1"
        gameLayer.addChild(redDot)
        
        //let yellowDot = SKSpriteNode(imageNamed: "puzzleYellowDot")
        yellowDot.position = CGPoint(x: (self.scene!.size.width * yellowXPosition) + 1000, y: self.scene!.size.height * yellowYPosition)
        yellowDot.zPosition = 270
        yellowDot.name = "3"
        gameLayer.addChild(yellowDot)
        
        //let blueDot = SKSpriteNode(imageNamed: "puzzleBlueDot")
        blueDot.position = CGPoint(x: (self.scene!.size.width * blueXPosition) + 1000, y: self.scene!.size.height * blueYPosition)
        blueDot.zPosition = 270
        blueDot.name = "2"
        gameLayer.addChild(blueDot)
        
        
        //let blueDot = SKSpriteNode(imageNamed: "puzzleBlueDot")
        greenDot.position = CGPoint(x: (self.scene!.size.width * greenXPosition) + 1000, y: self.scene!.size.height * greenYPosition)
        greenDot.zPosition = 270
        greenDot.name = "4"
        gameLayer.addChild(greenDot)
        
        //let blueDot = SKSpriteNode(imageNamed: "puzzleBlueDot")
        purpleDot.position = CGPoint(x: (self.scene!.size.width * purpleXPosition) + 1000, y: self.scene!.size.height * purpleYPosition)
        purpleDot.zPosition = 270
        purpleDot.name = "5"
        gameLayer.addChild(purpleDot)
        
        
        redDot.run(SKAction.moveTo(x: redDot.position.x - 1000, duration: 0.5))
        yellowDot.run(SKAction.moveTo(x: yellowDot.position.x - 1000, duration: 0.5))
        blueDot.run(SKAction.moveTo(x: blueDot.position.x - 1000, duration: 0.5))
        greenDot.run(SKAction.moveTo(x: greenDot.position.x - 1000, duration: 0.5))
        purpleDot.run(SKAction.moveTo(x: purpleDot.position.x - 1000, duration: 0.5))
        
        puzzleDotsOnTheScreen = true
        
        puzzleDotsHideTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameScene.puzzleTimeOutFunc), userInfo: nil, repeats: false)
    }
    
    
    
    
    var redXPosition: CGFloat = 0
    var redYPosition: CGFloat = 0
    var blueXPosition: CGFloat = 0
    var blueYPosition: CGFloat = 0
    var yellowXPosition: CGFloat = 0
    var yellowYPosition: CGFloat = 0
    
    var greenXPosition: CGFloat = 0
    var greenYPosition: CGFloat = 0
    var purpleXPosition: CGFloat = 0
    var purpleYPosition: CGFloat = 0
    
    // MARK: Random dots position
    func randomPositionDots() {
        
        //let number: CGFloat
        
        var dotPositionXArray = [0.3,0.4,0.4,0.5,0.6]
        var dotPositionYArray = [0.2,0.3,0.4,0.5,0.6,0.7,0.8]
        
        //for i in 1...dotPositionXArray.count {
        let index1 = Int(arc4random()%(5 /*- UInt32(1)*/))
        redXPosition = CGFloat(dotPositionXArray[index1])
        dotPositionXArray.remove(at: index1)
        
        let index2 = Int(arc4random()%(5 - UInt32(1)))
        blueXPosition = CGFloat(dotPositionXArray[index2])
        dotPositionXArray.remove(at: index2)
        
        let index3 = Int(arc4random()%(5 - UInt32(2)))
        yellowXPosition = CGFloat(dotPositionXArray[index3])
        dotPositionXArray.remove(at: index3)
        
        let index4 = Int(arc4random()%(5 - UInt32(3)))
        greenXPosition = CGFloat(dotPositionXArray[index4])
        dotPositionXArray.remove(at: index4)
        
        let index5 = Int(arc4random()%(5 - UInt32(4)))
        purpleXPosition = CGFloat(dotPositionXArray[index5])
        dotPositionXArray.remove(at: index5)
        
        
        
        let index6 = Int(arc4random()%(7 /*- UInt32(1)*/))
        redYPosition = CGFloat(dotPositionYArray[index6])
        dotPositionYArray.remove(at: index6)
        
        let index7 = Int(arc4random()%(7 - UInt32(1)))
        blueYPosition = CGFloat(dotPositionYArray[index7])
        dotPositionYArray.remove(at: index7)
        
        let index8 = Int(arc4random()%(7 - UInt32(2)))
        yellowYPosition = CGFloat(dotPositionYArray[index8])
        dotPositionYArray.remove(at: index8)
        
        let index9 = Int(arc4random()%(7 - UInt32(3)))
        greenYPosition = CGFloat(dotPositionYArray[index9])
        dotPositionYArray.remove(at: index9)
        
        let index10 = Int(arc4random()%(7 - UInt32(4)))
        purpleYPosition = CGFloat(dotPositionYArray[index10])
        dotPositionYArray.remove(at: index10)
        
        
        
        
    }
    
    //MARK: HIDe dot hints
    @objc func hideDotsHitns() {
        redDotHint.run(SKAction.fadeOut(withDuration: 0.5))
        blueDotHint.run(SKAction.fadeOut(withDuration: 0.5))
        yellowDotHint.run(SKAction.fadeOut(withDuration: 0.5))
        greenDotHint.run(SKAction.fadeOut(withDuration: 0.5))
        purpleDotHint.run(SKAction.fadeOut(withDuration: 0.5))
        puzzleColocHitVisible = false
        showHintOneTime = true
    }
    
    //MARK: PuzzleTimeOut func
    @objc func puzzleTimeOutFunc() {
        puzzleTimeOut = true
        hideDots()
    }
    
    //MARK: Hide dots
    @objc func hideDots() {
        puzzleDotsHideTimer?.invalidate()
        //puzzleCurrentGameStatus = false
        
        redDot.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent(), SKAction.fadeIn(withDuration: 0.3) ]))
        blueDot.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent(), SKAction.fadeIn(withDuration: 0.3) ]))
        yellowDot.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent(), SKAction.fadeIn(withDuration: 0.3) ]))
        greenDot.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent(), SKAction.fadeIn(withDuration: 0.3) ]))
        purpleDot.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent(), SKAction.fadeIn(withDuration: 0.3) ]))
        firstShape.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent(), SKAction.fadeIn(withDuration: 0.3) ]))
        secondShape.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent(), SKAction.fadeIn(withDuration: 0.3) ]))
        
        
        if !puzzleTimeOut {
            gameLayer.enumerateChildNodes(withName: "hackDebris") { [weak self] (node, _) in
                node.zPosition = 50
                let restartPuzzleAction = SKAction.run {
                    self?.puzzleCurrentGameStatus = false
                }
                node.run(SKAction.sequence([SKAction.scale(to: 1.9, duration: 0.5), SKAction.move(to: CGPoint(x: node.position.x - 2000, y: node.position.y - 700), duration: 2), restartPuzzleAction]))
            }
        }
        
        //var hackableDebrisLoc = gameLayer.children
        puzzleDotsOnTheScreen = false
        puzzleTimeOut = false
       // print("hide dots")
    }

    
    // MARK: Draw line
    
    var firstPoint = CGPoint()
    var secondPoint = CGPoint()
    var firstShape = SKShapeNode()
    var secondShape = SKShapeNode()
    
    func drawLineToDot(position: CGPoint) {
        let drawPath = CGMutablePath()
        if !firstDot {
            //drawPath.move(to: position)
            firstPoint = position
            //print("move to point")
        } else if !secondDot {
            secondPoint = position
            drawPath.move(to: firstPoint)
            drawPath.addLine(to: position)
            let shape = SKShapeNode()
            shape.path = drawPath
            shape.strokeColor = UIColor.red
            shape.lineWidth = 10
            shape.zPosition = 50
            gameLayer.addChild(shape)
            firstShape = shape
            //print("draw first line")
        } else if !thirdDot {
            drawPath.move(to: secondPoint)
            drawPath.addLine(to: position)
            drawPath.addLine(to: firstPoint)
            let shape = SKShapeNode()
            shape.path = drawPath
            shape.strokeColor = UIColor.red
            shape.lineWidth = 10
            shape.zPosition = 50
            gameLayer.addChild(shape)
            secondShape = shape
            //print("draw second line")
        } else {
            //print("nothing to draw")
        }
        
    }
    
    
    // MARK: level numbe label
    func levelNumberLabelSetup() {
        levelNumberLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.48)
        planetNumberLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.53)
        if preferredLanguage == .ru {
            levelNumberLabel.text = "Уровень \(level + 1)"
            planetNumberLabel.text = "Планета \(planet)"
        } else if preferredLanguage == .ch {
            levelNumberLabel.text = "水平 \(level + 1)"
            planetNumberLabel.text = "行星 \(planet)"
        } else if preferredLanguage == .es {
            levelNumberLabel.text = "Nivel \(level + 1)"
            planetNumberLabel.text = "Planeta \(planet)"
        } else {
            levelNumberLabel.text = "Level \(level + 1)"
            planetNumberLabel.text = "Planet \(planet)"
        }
        levelNumberLabel.fontSize = 100
        levelNumberLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        levelNumberLabel.yScale = 0.0
        levelNumberLabel.xScale = 0.0
        
        planetNumberLabel.fontSize = 60
        planetNumberLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
        planetNumberLabel.yScale = 0.0
        planetNumberLabel.xScale = 0.0
        //self.addChild(levelNumberLabel)
        self.gameLayer.addChild(levelNumberLabel)
        self.gameLayer.addChild(planetNumberLabel)
        
        let levelWaitAppearAction = SKAction.wait(forDuration: 0.5)
        let levelScaleAppearAction = SKAction.scale(to: 1.0, duration: 0.1)
        let levelFadeInAppearAtion = SKAction.fadeIn(withDuration: 0.1)
        let levelAppearGroup = SKAction.group([levelScaleAppearAction, levelFadeInAppearAtion])
        
        
        let levelWaitAction = SKAction.wait(forDuration: TimeInterval(2.0))
        let levelLabelActionFadeOut = SKAction.fadeOut(withDuration: 0.2)
        let levelLabelActionScale = SKAction.scale(to: 30, duration: 0.2)
        let levelLabelMove = SKAction.move(to: CGPoint(x: self.size.width / 2, y: ((self.size.height / 2) - 1300)), duration: 0.3)
        let levelLabelGroup = SKAction.group([levelLabelActionFadeOut, levelLabelActionScale, levelLabelMove])
        let levelLabelRemove = SKAction.removeFromParent()
        let levelSequence = SKAction.sequence([levelWaitAppearAction, levelAppearGroup, levelWaitAction, levelLabelGroup, levelLabelRemove])
        
        levelNumberLabel.run(levelSequence)
        planetNumberLabel.run(levelSequence)
    }
    
    
    // MARK: shipEngineSound
    func shipEngineSound() {
        let shipEngineSound = SKAction.playSoundFileNamed("engineNew.m4a", waitForCompletion: true)
        //let waitSPActivated = SKAction.wait(forDuration: TimeInterval(1))
        //let spSoundSequens = SKAction.sequence([spSound, waitSPActivated])
        if soundsIsOn {
            run(SKAction.repeatForever(shipEngineSound), withKey: "shipEngineSound")
            //run(SKAction.repeatForever(engineSoundsAction), withKey: "shipEngineSound")
            //run(SKAction.playSoundFileNamed("spActivated.m4a", waitForCompletion: false))
        }
    }
    
    func addEngineBackground() {
        do {
            try playerEngine = AVAudioPlayer(contentsOf: URL(fileURLWithPath: pathEngine!))
        } catch {
            print("error music")
        }
        playerEngine.numberOfLoops = -1
    }
    
    func addBackgroundMusic() {
        
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
        } catch {
            print("error music")
        }
        player.numberOfLoops = -1        //player.volume = 0.6
        //player.setVolume(0, fadeDuration: TimeInterval(1))
        
        //player.stop()
        
        //player.play()
        
        /*
        let bgm = NSURL(fileURLWithPath: "SoulStar.m4a")
        do {
            gameBackgroundMusic = try AVAudioPlayer(contentsOf: bgm as URL)
            gameBackgroundMusic?.prepareToPlay()
            gameBackgroundMusic?.play()
        } catch {
            print("error")
        }
        */
        /*
        let temp = SKAudioNode(fileNamed: "SoulStar.m4a")
        temp.autoplayLooped = true
        gameBackgroundMusic = temp
        
        //gameBackgroundMusic = SKAudioNode(fileNamed: "SoulStar.m4a")
        //self.addChild(gameBackgroundMusic)
        
        run(SKAction.playSoundFileNamed("SoulStar.m4a", waitForCompletion: false))
         */
        
    }
    /*
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
        //var partitionDuration = TimeInterval()
        //partitionDuration = 4
        
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
            //print("cant find level")
        }
        
        if canMove {
            barrierTimer = Timer.scheduledTimer(timeInterval: TimeInterval(barrierDuration), target: self, selector: #selector(GameScene.barrierSetup), userInfo: nil, repeats: true)
            //partitionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(partitionDuration), target: self, selector: #selector(GameScene.partitionSetup), userInfo: nil, repeats: true)
            planetTimer = Timer.scheduledTimer(timeInterval: TimeInterval(100), target: self, selector: #selector(GameScene.planetsSetup), userInfo: nil, repeats: true)
            spacestationTimer = Timer.scheduledTimer(timeInterval: TimeInterval(20), target: self, selector: #selector(GameScene.spacestationSetup), userInfo: nil, repeats: true)
            constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: true)
        }
        
        
    }
    */
    
    var hintNowVisible = false
    @objc func showHint() {
        //let defaults = UserDefaults()
        if false /*isKeyPresentInUserDefaults(key: "hint\(level+1)lvl")*/ {
            return //
        } else {
            
//            if let constTimerLoc = constructionTimer {
//                constructionTimerfireDate = constTimerLoc.fireDate.timeIntervalSinceNow
//            }
//            constructionTimer?.invalidate()
            
            pauseFuncSettings()
            
            var hint = SKSpriteNode()
            if preferredLanguage == .ru {
                if planet == 1 {
                    hint = SKSpriteNode(imageNamed: "hint\(level+1)lvlRU11")
                } else if planet == 2 {
                    hint = SKSpriteNode(imageNamed: "hint2_\(level+1)lvlRU11")
                } else if planet == 3 {
                    hint = SKSpriteNode(imageNamed: "hint3_\(level+1)lvlRU11")
                }
                hint.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                hint.zPosition = 20
                hint.name = "hint"
                hint.alpha = 0.0
                hint.xScale -= 0.4
                hint.yScale -= 0.4
                //self.addChild(hint)
                pauseLayer.addChild(hint)
            } else if preferredLanguage == .ch {
                if planet == 1 {
                    hint = SKSpriteNode(imageNamed: "hint\(level+1)lvlCH11")
                } else if planet == 2 {
                    hint = SKSpriteNode(imageNamed: "hint2_\(level+1)lvlCH11")
                } else if planet == 3 {
                    hint = SKSpriteNode(imageNamed: "hint3_\(level+1)lvlCH11")
                }
                hint.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                hint.zPosition = 20
                hint.name = "hint"
                hint.alpha = 0.0
                hint.xScale -= 0.4
                hint.yScale -= 0.4
                //self.addChild(hint)
                pauseLayer.addChild(hint)
            } else if preferredLanguage == .es {
                if planet == 1 {
                    hint = SKSpriteNode(imageNamed: "hint\(level+1)lvlSP11")
                } else if planet == 2 {
                    hint = SKSpriteNode(imageNamed: "hint2_\(level+1)lvlSP11")
                } else if planet == 3 {
                    hint = SKSpriteNode(imageNamed: "hint3_\(level+1)lvlSP11")
                }
                hint.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                hint.zPosition = 20
                hint.name = "hint"
                hint.alpha = 0.0
                hint.xScale -= 0.4
                hint.yScale -= 0.4
                //self.addChild(hint)
                pauseLayer.addChild(hint)
            } else {
                if planet == 1 {
                    hint = SKSpriteNode(imageNamed: "hint\(level+1)lvl11")
                } else if planet == 2 {
                    hint = SKSpriteNode(imageNamed: "hint2_\(level+1)lvl11")
                } else if planet == 3 {
                    hint = SKSpriteNode(imageNamed: "hint3_\(level+1)lvl11")
                }
                hint.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
                hint.zPosition = 20
                hint.name = "hint"
                hint.alpha = 0.0
                hint.xScale -= 0.4
                hint.yScale -= 0.4
                //self.addChild(hint)
                pauseLayer.addChild(hint)
            }
            
            let hintFadeAction = SKAction.fadeAlpha(by: 1.0, duration: 0.2)
            let hintScaleAction = SKAction.scale(to: 1.0, duration: 0.2)
            let hintGroup = SKAction.group([hintFadeAction, hintScaleAction])
            hint.run(hintGroup)
            
            hintNowVisible = true
            
            gameLayer.isPaused = true
            ///t2 = Timer.scheduledTimer(timeInterval: TimeInterval(0.3), target: self, selector: #selector(GameScene.showHintDelay), userInfo: nil, repeats: false)
            
            buttonStatus = .hintWindow
            canMove = false
            
            //print("func show hint")
            //let setDefaults = true
            //defaults.set(setDefaults, forKey: "hint\(level+1)lvl")
            
            
        }
     
    }
    
    func showHintByButton() {
        var hint = SKSpriteNode()
        if preferredLanguage == .ru {
            if planet == 1 {
                hint = SKSpriteNode(imageNamed: "hint\(level+1)lvlRU11")
            } else if planet == 2 {
                hint = SKSpriteNode(imageNamed: "hint2_\(level+1)lvlRU11")
            } else if planet == 3 {
                hint = SKSpriteNode(imageNamed: "hint3_\(level+1)lvlRU11")
            }
            hint.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            hint.zPosition = 20
            hint.name = "hint"
            hint.alpha = 0.0
            hint.xScale -= 0.4
            hint.yScale -= 0.4
            //self.addChild(hint)
            pauseLayer.addChild(hint)
        } else if preferredLanguage == .ch {
            if planet == 1 {
                hint = SKSpriteNode(imageNamed: "hint\(level+1)lvlRU11")
            } else if planet == 2 {
                hint = SKSpriteNode(imageNamed: "hint2_\(level+1)lvlRU11")
            } else if planet == 3 {
                hint = SKSpriteNode(imageNamed: "hint3_\(level+1)lvlRU11")
            }
            hint.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            hint.zPosition = 20
            hint.name = "hint"
            hint.alpha = 0.0
            hint.xScale -= 0.4
            hint.yScale -= 0.4
            //self.addChild(hint)
            pauseLayer.addChild(hint)
        } else {
            if planet == 1 {
                hint = SKSpriteNode(imageNamed: "hint\(level+1)lvl11")
            } else if planet == 2 {
                hint = SKSpriteNode(imageNamed: "hint2_\(level+1)lvl11")
            } else if planet == 3 {
                hint = SKSpriteNode(imageNamed: "hint3_\(level+1)lvl11")
            }
            hint.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            hint.zPosition = 20
            hint.name = "hint"
            hint.alpha = 0.0
            hint.xScale -= 0.4
            hint.yScale -= 0.4
            //self.addChild(hint)
            pauseLayer.addChild(hint)
        }
        
        let hintFadeAction = SKAction.fadeAlpha(by: 1.0, duration: 0.2)
        let hintScaleAction = SKAction.scale(to: 1.0, duration: 0.2)
        let hintGroup = SKAction.group([hintFadeAction, hintScaleAction])
        hint.run(hintGroup)
        
        //gameLayer.isPaused = true
        ///t2 = Timer.scheduledTimer(timeInterval: TimeInterval(0.3), target: self, selector: #selector(GameScene.showHintDelay), userInfo: nil, repeats: false)
        
        buttonStatus = .hintWindow
        //canMove = false
        
        //print("func show hint")
        //let setDefaults = true
        //defaults.set(setDefaults, forKey: "hint\(level+1)lvl")
        
        
    }
    
    // MARK: Shows ship upgrades
    @objc func setupShipUpgradesWindow() {
      
        shipUpgradesWindow.position = CGPoint(x: self.size.width * 2, y: self.size.height * 0.3)
        shipUpgradesWindow.zPosition = 20
        shipUpgradesWindow.anchorPoint = CGPoint(x: 0, y: 0)
        //shipUpgradesWindow.size =
        shipUpgradesWindow.name = "shipUpgradesHint"
        

        //self.addChild(shipUpgradesWindow)
        self.pauseLayer.addChild(shipUpgradesWindow)
        
        if engineUpgrade /*onlyTopLevel || canMoveUpAndDown*/ {
            let check = SKSpriteNode(imageNamed: "checkIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width/2, y: shipUpgradesWindow.size.height * 0.4)
            check.zPosition = 20
            check.name = "engineCheck"
            //check.anchorPoint = CGPoint(x: -0.5, y: -0.5)
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        } else {
            let check = SKSpriteNode(imageNamed: "uncheckIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width/2, y: shipUpgradesWindow.size.height * 0.4)
            check.zPosition = 20
            check.name = "engineCheck"
            //check.anchorPoint = CGPoint(x: 1, y: 1)
            //check.anchorPoint = CGPoint.zero
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        }
        
        if /*flapsUpgrade*/ onlyTopLevel || canMoveUpAndDown  {
            let check = SKSpriteNode(imageNamed: "checkIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width * 0.3, y: shipUpgradesWindow.size.height/2)
            check.zPosition = 20
            check.name = "flapsChack"
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        } else {
            let check = SKSpriteNode(imageNamed: "uncheckIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width * 0.3, y: shipUpgradesWindow.size.height/2)
            check.zPosition = 20
            check.name = "flapsChack"
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        }
        
        if /*trioUpgrade*/ showTrioSP {
            let check = SKSpriteNode(imageNamed: "checkIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width/2, y: shipUpgradesWindow.size.height * 0.55)
            check.zPosition = 20
            check.name = "trioChack"
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        } else {
            let check = SKSpriteNode(imageNamed: "uncheckIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width/2, y: shipUpgradesWindow.size.height * 0.55)
            check.zPosition = 20
            check.name = "trioChack"
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        }
        
        if /*doubleUpgrade*/ showRougeSP {
            let check = SKSpriteNode(imageNamed: "checkIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width * 0.7, y: shipUpgradesWindow.size.height/2)
            check.zPosition = 20
            check.name = "doubleCheck"
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        } else {
            let check = SKSpriteNode(imageNamed: "uncheckIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width * 0.7, y: shipUpgradesWindow.size.height/2)
            check.zPosition = 20
            check.name = "doubleCheck"
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        }
        
        if /*invisibleUpgrade*/ showInvisibleSP {
            let check = SKSpriteNode(imageNamed: "checkIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width/2, y: shipUpgradesWindow.size.height * 0.65)
            check.zPosition = 20
            check.name = "invisibleCheck"
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        } else {
            let check = SKSpriteNode(imageNamed: "uncheckIcon")
            check.position = CGPoint(x: shipUpgradesWindow.size.width/2, y: shipUpgradesWindow.size.height * 0.65)
            check.zPosition = 20
            check.name = "invisibleCheck"
            //check.alpha = 0.0
            check.xScale -= 0.6
            check.yScale -= 0.6
            shipUpgradesWindow.addChild(check)
        }
        
    }
    
    @objc func showHintDelay() {
        //self.view?.isPaused = true
        gameLayer.isPaused = true
    }
    
    
    @objc func runGameOver() {
        //self.removeAllActions()
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
        
        //if soundsIsOn {
        //run(SKAction.playSoundFileNamed("boom1.m4a", waitForCompletion: false))
        //engineSoundsAction.speed = 0.0
        removeAction(forKey: "shipEngineSound")
        
        //}
        
        //ship.jetFire?.particleLifetime = 1
        ship.jetFire?.particleSpeed = 50
        ship.jetFire?.particleLifetime = 0.1
        ship.jetFire?.particleScale = 0.2
        
        //canMove = false
        
        // stop all barriers
        gameLayer.enumerateChildNodes(withName: "barrier") { (node, _) in
            if node.name == "barrier" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        // stop all partitions
        gameLayer.enumerateChildNodes(withName: "partition") { (node, _) in
            if node.name == "partition" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        // stop middle barrier
        gameLayer.enumerateChildNodes(withName: "mBarrier") { (node, _) in
            if node.name == "mBarrier" {
                //node.speed = 0.0
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        // stop coins
        gameLayer.enumerateChildNodes(withName: "coinDebris") { (node, _) in
            if node.name == "coinDebris" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        // stop galaxy
        gameLayer.enumerateChildNodes(withName: "galaxy") { (node, _) in
            if node.name == "galaxy" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        // stop station
        gameLayer.enumerateChildNodes(withName: "station") { (node, _) in
            if node.name == "station" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        // stop construction
        gameLayer.enumerateChildNodes(withName: "constructionDebris") { (node, _) in
            if node.name == "constructionDebris" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        gameLayer.enumerateChildNodes(withName: "hackDebris") { (node, _) in
            if node.name == "hackDebris" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        gameLayer.enumerateChildNodes(withName: "charegedMine") { (node, _) in
            if node.name == "charegedMine" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        gameLayer.enumerateChildNodes(withName: "3levelMineRotating") { (node, _) in
            if node.name == "3levelMineRotating" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        
        gameLayer.enumerateChildNodes(withName: "3levelMine") { (node, _) in
            if node.name == "3levelMine" {
                //node.speed -= 0.5
                node.run(SKAction.speed(to: 0.0, duration: 1.5))
            }
        }
        //constructionDebris
        
        //coinDebris
        
//        for recognizer in (self.view?.gestureRecognizers)! {
//            
//        }
        
        //self.view?.gestureRecognizers?.removeAll()
        //self.view?.gestureRecognizers = []
        
        currentGameStatus = .afterGame
        
        if #available(iOS 10.0, *) {
            player.setVolume(0, fadeDuration: TimeInterval(2))
        } else {
            player.stop()
        }
        
        t1 = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(GameScene.moveToGameOverScreen), userInfo: nil, repeats: false)
        
        partitions.removeAll()
        
        changeShipStatus()
        gameOverIsRuning = true

    }
    
    func clean() {
        //self.view?.isPaused = false
        gameLayer.isPaused = false
        if soundsIsOn {
            run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
        }
        
        NotificationCenter.default.removeObserver(SomeNames.blowTheShip)
        
        removeAllActions()
        //removeAllChildren()
        
        self.physicsWorld.contactDelegate = nil
        
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
        
        //self.view?.gestureRecognizers?.removeAll()
        
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
        var mBarrier: MiddleBarrier?
        
        // ********** work when player had physics body. Now it has not.
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.barrier.rawValue) {
            player = contact.bodyA.node as? PlayerShip
            barrier = contact.bodyB.node as? Barrier
            mBarrier = contact.bodyB.node as? MiddleBarrier
            //print("touch barrier \(barrier)")
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.barrier.rawValue) {
            player = contact.bodyB.node as? PlayerShip
            barrier = contact.bodyA.node as? Barrier
            mBarrier = contact.bodyA.node as? MiddleBarrier
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
            mBarrier = contact.bodyB.node as? MiddleBarrier
            //print("touch dot")
            if debris != nil && player != nil /*&& debris?.isActive == true*/ {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
               // print("mine")
            } else if mBarrier != nil && player != nil /*&& debris?.isActive == true*/ {
                detectCollisionOnDifferentZPositionWithMiddleBarrier(player: player!, mBarrier: mBarrier!)
                // print("mine")
            }
            // MARK: Contact with debris2
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.debris.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            debris = contact.bodyA.node as? Debris
            mBarrier = contact.bodyA.node as? MiddleBarrier
            //print("END touch barrier 5")
            if debris != nil && player != nil && debris?.isActive == true /*&& player?.rougeIsActive == true*/ {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
                //print("END touch barrier 2")
                //print("mine")
            } else if mBarrier != nil && mBarrier?.isActive == true /*&& debris?.isActive == true*/ {
                detectCollisionOnDifferentZPositionWithMiddleBarrier(player: player!, mBarrier: mBarrier!)
                // print("mine")
            }
            // MARK: Contact with partition
            
            
            
            
         /*
        } else if (contact.bodyA.categoryBitMask == BodyType.cD.rawValue && contact.bodyB.categoryBitMask == BodyType.partition.rawValue) {
            player = (contact.bodyA.node)?.parent as? PlayerShip
            partition = contact.bodyB.node as? Partition
            
            //print("touch dot")
            if partition != nil && player != nil && partition?.isActive == true {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
                
            }
            // MARK: Contact with debris2
         */
            
            
 
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
        var mBarrier: MiddleBarrier?
        
        // ********** work when player had physics body. Now it has not.
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.barrier.rawValue) {
            player = contact.bodyA.node as? PlayerShip
            barrier = contact.bodyB.node as? Barrier
            mBarrier = contact.bodyB.node as? MiddleBarrier
            //print("END touch barrier")
        } else if (contact.bodyB.categoryBitMask == BodyType.player.rawValue && contact.bodyA.categoryBitMask == BodyType.barrier.rawValue) {
            player = contact.bodyB.node as? PlayerShip
            barrier = contact.bodyA.node as? Barrier
            mBarrier = contact.bodyA.node as? MiddleBarrier
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
            mBarrier = contact.bodyB.node as? MiddleBarrier
            
            //print("touch dot")
            if debris != nil && player != nil /*&& debris?.isActive == true*/ {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
                //print("mine")
            } else if mBarrier != nil && player != nil /*&& debris?.isActive == true*/ {
                detectCollisionOnDifferentZPositionWithMiddleBarrier(player: player!, mBarrier: mBarrier!)
                // print("mine")
            }
            // MARK: Contact with debris2
        } else if (contact.bodyB.categoryBitMask == BodyType.cD.rawValue && contact.bodyA.categoryBitMask == BodyType.debris.rawValue) {
            player = (contact.bodyB.node)?.parent as? PlayerShip
            debris = contact.bodyA.node as? Debris
            mBarrier = contact.bodyA.node as? MiddleBarrier
            //print("END touch barrier 4")
            if debris != nil && player != nil && debris?.isActive == true /*&& player?.rougeIsActive == true*/ {
                detectCollisionOnDifferentZPositionWithDebris(player: player!, debris: debris!)
                //print("END touch barrier 3")
                //print("mine")
            } else if mBarrier != nil && mBarrier?.isActive == true /*&& debris?.isActive == true*/ {
                detectCollisionOnDifferentZPositionWithMiddleBarrier(player: player!, mBarrier: mBarrier!)
                // print("mine")
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
    
    func detectCollisionOnDifferentZPositionWithMiddleBarrier (player: PlayerShip, mBarrier: MiddleBarrier) {
        if player.zPosition == mBarrier.zPosition {
            zPositionMatchForMiddleBarrier(player: player, mBarrier: mBarrier)
        } else if player.zPosition > mBarrier.zPosition {
            //print("missed Player over barrier")
        } else if player.zPosition < mBarrier.zPosition {
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
        //print("Bam bitch")
        barrier.isActive = false
        coins += 1
        barrier.removeFromParent()
        
        if soundsIsOn {
            run(SKAction.playSoundFileNamed("coinSound.m4a", waitForCompletion: false))
        }
        
        //checkGameScoreForLevels(coins: coins)
    }
    
    func zPositionMatchForDebris(player: PlayerShip, debris: Debris) {
        //print("Bam Debris bitch")
        debris.isActive = false
        explosion(pos: ship.position, zPos: ship.zPosition)
        // RougeOne explosion
        if superButtonStatus == .rouge {
            explosion(pos: rougeOneShipGlobal!.position, zPos: rougeOneShipGlobal!.zPosition)
            rougeOneShipGlobal?.removeFromParent()
            explosion(pos: tempShipRouge.position, zPos: tempShipRouge.zPosition)
            tempShipRouge.removeFromParent()
        }
        // TrioShip explosion
        if superButtonStatus == .trio {
            //print("trio epxlosiobb22")
            gameLayer.enumerateChildNodes(withName: "trioShip") { [weak self] (node, _) in
                self!.explosion(pos: node.position , zPos: node.zPosition)
                node.removeFromParent()
                print("trio epxlosiobb")
            }
        }
        //coins += 1
        debris.removeFromParent()
        ship.removeFromParent()
        
        //checkGameScoreForLevels(coins: coins)
        runGameOver()
        
    }
    
    func zPositionMatchForMiddleBarrier(player: PlayerShip, mBarrier: MiddleBarrier) {
        //print("Bam Debris bitch")
        mBarrier.isActive = false
        explosion(pos: ship.position, zPos: ship.zPosition)
        // RougeOne explosion
        if superButtonStatus == .rouge {
            explosion(pos: rougeOneShipGlobal!.position, zPos: rougeOneShipGlobal!.zPosition)
            rougeOneShipGlobal?.removeFromParent()
            explosion(pos: tempShipRouge.position, zPos: tempShipRouge.zPosition)
            tempShipRouge.removeFromParent()
        }
        // TrioShip explosion
        if superButtonStatus == .trio {
            //print("trio epxlosiobb22")
            gameLayer.enumerateChildNodes(withName: "trioShip") { [weak self] (node, _) in
                self!.explosion(pos: node.position , zPos: node.zPosition)
                node.removeFromParent()
                print("trio epxlosiobb")
            }
        }
        //coins += 1
        mBarrier.removeFromParent()
        ship.removeFromParent()
        
        //checkGameScoreForLevels(coins: coins)
        runGameOver()
        
    }
    
    /*
    func checkGameScoreForLevels(coins: Int) {
        if coins == 10 || coins == 25 || coins == 50 || coins == 75 {
            //startNewLevel()
           // print("newLevel")
        }
    }
    */
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
            
            if canMoveUpAndDown {
                //UP
                swipeUpRec.addTarget(self, action: #selector(GameScene.swipeUp))
                swipeUpRec.direction = .up
                self.view?.addGestureRecognizer(swipeUpRec)
                //DOWN
                swipeDownRec.addTarget(self, action: #selector(GameScene.swipeDown))
                swipeDownRec.direction = .down
                self.view?.addGestureRecognizer(swipeDownRec)
            }
            
            //TAP
            /* tapGestureRec.addTarget(self, action: #selector(GameScene.tapDown))
            tapGestureRec.numberOfTapsRequired = 2
            self.view?.addGestureRecognizer(tapGestureRec) */
           // print("gestures added")
        }
       // print("not added ?")
        
    }
    
    // MARK: Swipes
    
    @objc func swipeRight() {
        if canMove && !shipExplode {
            if ship.rougeIsActive {
                ship.moveRight()
                //print("ship")
            } else if tempShipRouge.rougeIsActive {
                tempShipRouge.moveRight()
                //print("rouge")
            }
            //print("swipe right")
        }
        //print("rouge right")
    }
    
    @objc func swipeLeft() {
        if canMove && !shipExplode{
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
    
    func invalidateSPTimer() {
        
        switch shipStatus {
        case .noraml:
            print("normal status")
        case .trio:
            trioTimer.invalidate()
            shipStatus = .noraml
        case .rogueOne:
            rougeOneTimer.invalidate()
            shipStatus = .noraml
        case .invisible:
            invisibleTimer.invalidate()
            shipStatus = .noraml
        }
    }
    
    func changeShipStatus() {
        
        let allShips = /*self.children*/ gameLayer.children
        //let fadeOutAction = SKAction.fadeOut(withDuration: 0.2)
        switch shipStatus {
        case .noraml:
            print("normal status")
        case .trio:
            
            
            for trioShip in allShips {
                if trioShip is PlayerShip && trioShip.name == "trioShip" {
                    if let distortShip = trioShip as? PlayerShip {
                        distortShip.distortOutEffect()
                    }
                    /*
                    trioShip.run(fadeOutAction, completion: {
                        trioShip.removeFromParent()
                    })
                    */
                    //trioShip.run(fadeOutAction)
                    //trioShip.removeFromParent()
                }
            }
            
            self.ship.isHidden = false
            trioTimer.invalidate()
            shipStatus = .noraml
            
        case .rogueOne:
            
            var playerShip = PlayerShip()
            var rougeOneShip = PlayerShip()
            /*if*/ let allNodes = /*scene?.children*/ gameLayer.children /*{*/
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
            /*}*/
            
            
            
            if playerShip.rougeIsActive == false {
                
                
                
                
                tempShipRouge = ship
                tempShipRouge.rougeIsActive = false
                ship = playerShip as PlayerShip
                ship.rougeIsActive = true
                /*
                tempShipRouge.removeFromParent()
                */
                tempShipRouge.distortOutEffect()
                
                //shipIsActive = true
                //rougeIsActive = false
                
                //ship.rougeIsActive = true
                //tempShipRouge.removeFromParent()
                
                //rougeOne.removeFromParent()
            } else if rougeOneShip.rougeIsActive == false {
                /*
                rougeOneShip.removeFromParent()
                 */
                rougeOneShip.distortOutEffect()
            } /*else if rougeOneShip.rougeIsActive == true {
                //ship = rougeOneT
                rougeOneShip.removeFromParent()
            } */
            
            
            rougeOneTimer.invalidate()
            shipStatus = .noraml
            
            rougeOneShipGlobal?.stopRougeOneEffect()
            ship.stopRougeOneEffect()
            
            shipIsActive = true
            rougeIsActive = false
            
        case .invisible:
            
            let allDetectors = ship.children
            for cD in allDetectors {
                if cD.name == "cD" {
                    cD.physicsBody?.categoryBitMask = BodyType.cD.rawValue
                    cD.physicsBody?.collisionBitMask = BodyType.other.rawValue
                    cD.physicsBody?.contactTestBitMask = BodyType.barrier.rawValue | BodyType.partition.rawValue | BodyType.debris.rawValue
                    
                    
                    /*
                     // CategoryBitMask, collisionBitMask, contactTestBitMask
                     node.physicsBody?.categoryBitMask = BodyType.cD.rawValue
                     node.physicsBody?.collisionBitMask = /* BodyType.barrier.rawValue //| */ BodyType.other.rawValue
                     node.physicsBody?.contactTestBitMask = BodyType.barrier.rawValue | BodyType.partition.rawValue | BodyType.debris.rawValue
 
                         */
                    
                }
            }
            self.ship.alpha = 1
            invisibleTimer.invalidate()
            shipStatus = .noraml
            
            
            
            //partition?.contactWithShip = true
            //contactBodycD?.isInContactWithSomething = true
            
        }
        
    }
    
    // MARK: Ship setup
    func playerSetup() {
        ship.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
        ship.zPosition = 3
        ship.xScale = ShipScale.middle
        ship.yScale = ShipScale.middle
        ship.name = "playerShip"
        //ship.rougeOneEffect()
        //playerShipNotDeinit = ship
        //self.addChild(ship)
        self.gameLayer.addChild(ship)
        
//        let jetFire = SKEmitterNode(fileNamed: "jetFire.sks")
//        jetFire?.targetNode = ship
//        jetFire?.zPosition = -10
//        //jetFire?.emissionAngle = 180
//        //jetFire?.position = CGPoint(x: ship.position.x, y: (ship.position.y - (ship.size.height / 2)) - 20)
//        self.addChild(jetFire!)
    }
    
    //MARK: Partition setup
    /*@objc*/ func partitionSetup(zPosition: CGFloat, random: Bool, position: CGPoint?, angle: CGFloat?, newTexture: SKTexture?) {
        let partition = Partition(zPosition: zPosition, random: random, angle: angle, newTexture: nil)
        partition.mainScene = self
        partition.playerShipNotDeinit = ship
        if position != nil {
            partition.position = position!
        } else {
            partition.position = CGPoint(x: self.size.width * 0.1, y: self.size.height * 1.60)
        }
        
        //self.addChild(partition)
        self.gameLayer.addChild(partition)
        self.partitions.append(partition)
        
        //partitionAlpha()
        var animationDuration: TimeInterval = 15
        /*
        switch partitionSpeed {
        case .slow:
            if zPosition == 2 {
                animationDuration = PartitionSpeed.slow.rawValue
            } else if zPosition == 4 {
                animationDuration = PartitionSpeed.slow.rawValue
            }
        case .middle:
            if zPosition == 2 {
                animationDuration = PartitionSpeed.middle.rawValue
            } else if zPosition == 4 {
                animationDuration = PartitionSpeed.middle.rawValue
            }
        case .fast:
            if zPosition == 2 {
                animationDuration = PartitionSpeed.fast.rawValue
            } else if zPosition == 4 {
                animationDuration = PartitionSpeed.fast.rawValue
            }
        }
         */
        if zPosition == 2 {
            animationDuration = partitionSpeedLow.rawValue
        } else {   // 4
            animationDuration = partitionSpeedHigh.rawValue
        }
        
        
        
        //var actionArray = [SKAction]()
        let setAlphaToPartition = SKAction.run { [weak self] in
            self?.partitionAlpha()
        }
        let moveAction = SKAction.moveTo(y: (partition.size.height * (-2)) /*- partition.size.height*/, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        let removeFromPartitionsArray = SKAction.run { [weak self] in
            self?.partitions.removeFirst()
        }
        //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([setAlphaToPartition, moveAction, removeFromParent, removeFromPartitionsArray/*, lostCoinsAction*/])
        partition.run(moveSequence, withKey: "setUpPartition")
        
    }
    
    // MARK: alpha partitions
    func partitionAlpha() {
        for partition in partitions {
            if partition.zPosition > ship.zPosition {
                partition.alpha = 0.6
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
    /*
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
            //print("default")
        }
        
        //self.addChild(barrier)
        self.gameLayer.addChild(barrier)
        
        
        //let animationDuration: TimeInterval = 6
        var animationDuration: TimeInterval = 15
        
        switch debrisSpeed {
        case .slow:
            if barrier.zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) //14
            } else if barrier.zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) //15
            } else if barrier.zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) //16.5
            }
        case .middle: //break
            if barrier.zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) //14
            } else if barrier.zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) //15
            } else if barrier.zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) //16.5
            }
        case .fast: //break
            if barrier.zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) //14
            } else if barrier.zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) //15
            } else if barrier.zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) //16.5
            }
        }
        
        
        //var actionArray = [SKAction]()
        
        let moveAction = SKAction.moveTo(y: (barrier.size.height * 0) - barrier.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([moveAction, removeFromParent, lostCoinsAction])
        barrier.run(moveSequence, withKey: "setUpBarrier")
        
    }
    */
    
    @objc func invokeConstructionBarrierSetupForSurvival() {
        _ = constructionBarrierSetup(zPosition: 1, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
    }
    
    // MARK: Construction barrier setup
    func constructionBarrierSetup(zPosition: CGFloat, XPosition: CGFloat, name: String?, texture: Int?, hiddenCoin: Barrier?, hiddenMine: Debris?) -> Debris {
        var debris = Debris(zPosition: zPosition, XPosition: XPosition)
        if gameMode == .normal {
            
            debris.mainScene = self
            if name == nil {
                debris.name = "constructionDebris"
            } else {
                debris.name = name!
            }
            
            if texture != nil && texture == 2 {
                debris.texture = SKTexture(imageNamed: "mine02")
                hackableDebris = debris
                debris.debrisEffectPositionDot()
                debris.debrisEffect()
            } else if texture != nil && texture == 3 && hiddenCoin == nil {
                debris.texture = SKTexture(imageNamed: "mine03_1")
                debris.xScale += 0.1
                debris.yScale += 0.1
                debris.name = "charegedMine"
                //hackableDebris = debris
                debris.greenGlowingMineEffect()
                //debris.debrisEffect()
            } else if texture != nil && texture == 3 && hiddenCoin != nil {
                debris.texture = SKTexture(imageNamed: "mine03_1")
                //debris.isHidden = true
                debris.hiddenCoin = hiddenCoin
                debris.xScale += 0.1
                debris.yScale += 0.1
                debris.name = "charegedMine"
                //hackableDebris = debris
                debris.greenGlowingMineEffect()
                //debris.debrisEffect()
            } else if texture != nil && texture == 4 {
                debris.texture = SKTexture(imageNamed: "mine08_4s")
                debris.xScale += 0.1
                debris.yScale += 0.1
                debris.name = "3levelMineRotating"
                //hackableDebris = debris
                debris.yellowGlowingMineEffect()
                //debris.debrisEffect()
            } else if texture != nil && texture == 5 {
                debris.texture = SKTexture(imageNamed: "mine08_4s")
                debris.xScale += 0.1
                debris.yScale += 0.1
                debris.name = "3levelMine"
                let zRotationArray: [CGFloat] = [CGFloat(Double.pi / 1), CGFloat(Double.pi / 2), CGFloat(Double.pi / 3), CGFloat(Double.pi / 4), CGFloat(Double.pi / 5), CGFloat(Double.pi / 6), CGFloat(Double.pi / 7), CGFloat(Double.pi / 8), CGFloat(Double.pi / 9)]
                let zRotation = zRotationArray[Int(arc4random()%6)]
                debris.zRotation = zRotation
                
            }
            
            if hiddenMine != nil {
                debris.hiddenMine = hiddenMine
            }
            
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
            //self.addChild(debris)
            self.gameLayer.addChild(debris)
            switch debrisSpeed {
            case .slow:
                if zPosition == 1 {
                    animationDuration = TimeInterval(DebrisSpeed.slow.rawValue)
                } else if zPosition == 3 {
                    animationDuration = TimeInterval(DebrisSpeed.slow.rawValue)
                } else if zPosition == 5 {
                    animationDuration = TimeInterval(DebrisSpeed.slow.rawValue)
                }
            case .middle:
                if zPosition == 1 {
                    animationDuration = TimeInterval(DebrisSpeed.middle.rawValue)
                } else if zPosition == 3 {
                    animationDuration = TimeInterval(DebrisSpeed.middle.rawValue)
                } else if zPosition == 5 {
                    animationDuration = TimeInterval(DebrisSpeed.middle.rawValue)
                }
            case .fast:
                if zPosition == 1 {
                    animationDuration = TimeInterval(DebrisSpeed.fast.rawValue)
                } else if zPosition == 3 {
                    animationDuration = TimeInterval(DebrisSpeed.fast.rawValue)
                } else if zPosition == 5 {
                    animationDuration = TimeInterval(DebrisSpeed.fast.rawValue)
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
            //print("animationDuration \(animationDuration)")
            
            let moveAction = SKAction.moveTo(y: (debris.size.height * 0) - debris.size.height, duration: animationDuration)
            let removeFromParent = SKAction.removeFromParent()
            //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
            let moveSequence = SKAction.sequence([moveAction, removeFromParent/*, lostCoinsAction*/])
            debris.run(moveSequence, withKey: "setUpConstruction")
            
            
        } else if gameMode == .survival {
            // Position
            let randomXPostionNumber = Int(arc4random()%3)
            let randomZPostionNumber = Int(arc4random()%3)
            var randomXPosition: CGFloat = 0
            var randomZPosition: CGFloat = 0
            if randomXPostionNumber == 0 {
                randomXPosition = 1
            } else if randomXPostionNumber == 1 {
                randomXPosition = 2
            } else if randomXPostionNumber == 2 {
                randomXPosition = 3
            }
            
            if randomZPostionNumber == 0 {
                randomZPosition = 1
            } else if randomZPostionNumber == 1 {
                randomZPosition = 3
            } else if randomZPostionNumber == 2 {
                randomZPosition = 5
            }
            
            debris = Debris(zPosition: randomZPosition, XPosition: randomXPosition)
            
            // Texture
            
            let textureNumber = Int(arc4random()%2)
            if textureNumber == 0 {
                debris.texture = SKTexture(imageNamed: "mine07")
            } else if textureNumber == 1 {
                debris.texture = SKTexture(imageNamed: "mine01")
            } else if textureNumber == 2 {
                debris.texture = SKTexture(imageNamed: "mine08_4s")
                debris.xScale += 0.1
                debris.yScale += 0.1
                debris.name = "3levelMineRotating"
                //hackableDebris = debris
                debris.yellowGlowingMineEffect()
                //debris.debrisEffect()
            } else if textureNumber == 3 {
                debris.texture = SKTexture(imageNamed: "mine08_4s")
                debris.xScale += 0.1
                debris.yScale += 0.1
                debris.name = "3levelMine"
                let zRotationArray: [CGFloat] = [CGFloat(Double.pi / 1), CGFloat(Double.pi / 2), CGFloat(Double.pi / 3), CGFloat(Double.pi / 4), CGFloat(Double.pi / 5), CGFloat(Double.pi / 6), CGFloat(Double.pi / 7), CGFloat(Double.pi / 8), CGFloat(Double.pi / 9)]
                let zRotation = zRotationArray[Int(arc4random()%6)]
                debris.zRotation = zRotation
            } else if textureNumber == 4 {
                debris.texture = SKTexture(imageNamed: "mine03_1")
                debris.xScale += 0.1
                debris.yScale += 0.1
                debris.name = "charegedMine"
                //hackableDebris = debris
                debris.greenGlowingMineEffect()
            }
            
            self.gameLayer.addChild(debris)
            
            var animationDuration: TimeInterval = 15
            switch debrisSpeed {
            case .slow:
                if zPosition == 1 {
                    animationDuration = TimeInterval(DebrisSpeed.slow.rawValue)
                } else if zPosition == 3 {
                    animationDuration = TimeInterval(DebrisSpeed.slow.rawValue)
                } else if zPosition == 5 {
                    animationDuration = TimeInterval(DebrisSpeed.slow.rawValue)
                }
            case .middle:
                if zPosition == 1 {
                    animationDuration = TimeInterval(DebrisSpeed.middle.rawValue)
                } else if zPosition == 3 {
                    animationDuration = TimeInterval(DebrisSpeed.middle.rawValue)
                } else if zPosition == 5 {
                    animationDuration = TimeInterval(DebrisSpeed.middle.rawValue)
                }
            case .fast:
                if zPosition == 1 {
                    animationDuration = TimeInterval(DebrisSpeed.fast.rawValue)
                } else if zPosition == 3 {
                    animationDuration = TimeInterval(DebrisSpeed.fast.rawValue)
                } else if zPosition == 5 {
                    animationDuration = TimeInterval(DebrisSpeed.fast.rawValue)
                }
            }
            
            let moveAction = SKAction.moveTo(y: (debris.size.height * 0) - debris.size.height, duration: animationDuration)
            let removeFromParent = SKAction.removeFromParent()
            let moveSequence = SKAction.sequence([moveAction, removeFromParent/*, lostCoinsAction*/])
            debris.run(moveSequence, withKey: "setUpConstruction")
        }
        
        return debris
    }
    // MARK: Invore coin seup for survival mode
    @objc func invokeCoinSetupForSurvival() {
        _ = coinSetup(zPosition: 1, XPosition: 1)
    }
    
    // MARK: Coin setup
    func coinSetup(zPosition: CGFloat, XPosition: CGFloat) -> Barrier {
        var barrier = Barrier(zPosition: zPosition, XPosition: XPosition)
        var animationDuration: TimeInterval = 15
        
        if gameMode == .normal {
            barrier.mainScene = self
            barrier.name = "coinDebris"
            
        } else if gameMode == .survival {
            let randomXPostionNumber = Int(arc4random()%3)
            let randomZPostionNumber = Int(arc4random()%3)
            var randomXPosition: CGFloat = 0
            var randomZPosition: CGFloat = 0
            if randomXPostionNumber == 0 {
                randomXPosition = 1
            } else if randomXPostionNumber == 1 {
                randomXPosition = 2
            } else if randomXPostionNumber == 2 {
                randomXPosition = 3
            }
            
            if randomZPostionNumber == 0 {
                randomZPosition = 1
            } else if randomZPostionNumber == 1 {
                randomZPosition = 3
            } else if randomZPostionNumber == 2 {
                randomZPosition = 5
            }
            
            barrier = Barrier(zPosition: randomZPosition, XPosition: randomXPosition)
        }
        
        
        self.gameLayer.addChild(barrier)
        
        switch debrisSpeed {
        case .slow:
            if zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) // 15
            } else if zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) // 15
            } else if zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) // 15
            }
        case .middle:
            if zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) // 10
            } else if zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) // 10
            } else if zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) // 10
            }
        case .fast:
            if zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) // 5
            } else if zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) // 5
            } else if zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) // 5
            }
        }
        
        
        let moveAction = SKAction.moveTo(y: (barrier.size.height * 0) - barrier.size.height, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        var moveSequence = SKAction()
        if gameMode == .normal {
            moveSequence = SKAction.sequence([moveAction, removeFromParent/*, lostCoinsAction*/])
        } else if gameMode == .survival {
            let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
            moveSequence = SKAction.sequence([moveAction, removeFromParent, lostCoinsAction])
        }
        
        barrier.run(moveSequence, withKey: "setUpCoin")
        
        
        return barrier
    }
    
    // MARK: Middle barrier setup
    func middleBarrierSetup(zPosition: CGFloat, XPosition: CGFloat) {
        let mBarrier = MiddleBarrier(zPosition: zPosition, XPosition: XPosition)
        mBarrier.mainScene = self
        mBarrier.name = "mBarrier"
        
        var animationDuration: TimeInterval = 15
        //self.addChild(mBarrier)
        self.gameLayer.addChild(mBarrier)
        
        switch debrisSpeed {
        case .slow:
            if zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) // 15
            } else if zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) // 15
            } else if zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.slow.rawValue) // 15
            }
        case .middle:
            if zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) // 10
            } else if zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) // 10
            } else if zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.middle.rawValue) // 10
            }
        case .fast:
            if zPosition == 1 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) // 5
            } else if zPosition == 3 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) // 5
            } else if zPosition == 5 {
                animationDuration = TimeInterval(DebrisSpeed.fast.rawValue) // 5
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
        let allObjects = /*self.children*/ gameLayer.children
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
            let backgroundStars = SKSpriteNode(imageNamed: "backgroundStars02")
            backgroundStars.size = self.size
            backgroundStars.anchorPoint = CGPoint(x: 0.5, y: 0)
            backgroundStars.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
            backgroundStars.zPosition = -100
            backgroundStars.name = "BackgroudStars"
            //self.addChild(backgroundStars)
            self.gameLayer.addChild(backgroundStars)
        }
        
        for i in 0...1 {
            let backgroundPngStars = SKSpriteNode(imageNamed: "backgroundPngStars")
            backgroundPngStars.size = self.size
            backgroundPngStars.anchorPoint = CGPoint(x: 0.5, y: 0)
            backgroundPngStars.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
            backgroundPngStars.zPosition = -99
            backgroundPngStars.name = "BackgroundPngStars"
            //self.addChild(backgroundPngStars)
            self.gameLayer.addChild(backgroundPngStars)
        }
        
        for i in 0...1 {
            let backgroundPngStars2 = SKSpriteNode(imageNamed: "backgroundPngStars2")
            backgroundPngStars2.size = self.size
            backgroundPngStars2.anchorPoint = CGPoint(x: 0.5, y: 0)
            backgroundPngStars2.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i))
            backgroundPngStars2.zPosition = -99
            backgroundPngStars2.name = "BackgroundPngStars2"
            //self.addChild(backgroundPngStars2)
            self.gameLayer.addChild(backgroundPngStars2)
        }
    }
    
    // MARK: Setup Buttons
    func buttonsSetup() {
        
        /*
        normalStatusButton.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.70)
        normalStatusButton.zPosition = 10
        normalStatusButton.name = "statusNormalButton"
        self.addChild(normalStatusButton)
        */
        
        if showTrioSP == true {
            trioStatusButton.position = CGPoint(x: self.size.width * 0.82, y: self.size.height * 0.70)
            trioStatusButton.zPosition = 10
            trioStatusButton.name = "statusTrioButton"
            //self.addChild(trioStatusButton)
            self.gameLayer.addChild(trioStatusButton)
        }
        
        if showRougeSP == true {
            rougeOneStatusButton.position = CGPoint(x: self.size.width * 0.82, y: self.size.height * 0.56)
            rougeOneStatusButton.zPosition = 10
            rougeOneStatusButton.name = "statusRougeOneButton"
            //self.addChild(rougeOneStatusButton)
            self.gameLayer.addChild(rougeOneStatusButton)
        }
        
        if showInvisibleSP == true {
            invisibleStatusButton.position = CGPoint(x: self.size.width * 0.82, y: self.size.height * 0.42)
            invisibleStatusButton.zPosition = 10
            invisibleStatusButton.name = "statusInvisibleButton"
            //self.addChild(invisibleStatusButton)
            self.gameLayer.addChild(invisibleStatusButton)
        }
        
        let settingsButton = SKSpriteNode(imageNamed: "settingsButton")
        settingsButton.position = CGPoint(x: (self.size.width * 0.5 - 300), y: self.size.height * 0.04)
        settingsButton.zPosition = 10
        settingsButton.xScale = 0.5
        settingsButton.yScale = 0.5
        settingsButton.name = "settingsButton"
        //self.addChild(settingsButton)
        self.gameLayer.addChild(settingsButton)
        
        
        
        // Setup shipstatus time TRIO
        if showTrioSP == true {
            trioTimerLabel.text = "0"
            trioTimerLabel.position = CGPoint(x: self.size.width * 0.82, y: self.size.height * 0.64)
            trioTimerLabel.fontColor = UIColor.white
            trioTimerLabel.fontSize = 50
            trioTimerLabel.zPosition = 10
            trioTimerLabel.text = String(describing: trioTimeActive.truncate(places: 1))
            //self.addChild(trioTimerLabel)
            self.gameLayer.addChild(trioTimerLabel)
        }
        
        // Setup shipstatus time ROUGEONE
        if showRougeSP == true {
            rougeOneTimerLabel.text = "0"
            rougeOneTimerLabel.position = CGPoint(x: self.size.width * 0.82, y: self.size.height * 0.50)
            rougeOneTimerLabel.fontColor = UIColor.white
            rougeOneTimerLabel.fontSize = 50
            rougeOneTimerLabel.zPosition = 10
            rougeOneTimerLabel.text = String(describing: rougeOneTimeActive.truncate(places: 1))
            //self.addChild(rougeOneTimerLabel)
            self.gameLayer.addChild(rougeOneTimerLabel)
        }
        
        // Setup shipstatus time INVISIBLE
        if showInvisibleSP == true {
            invisibleTimerLabel.text = "0"
            invisibleTimerLabel.position = CGPoint(x: self.size.width * 0.82, y: self.size.height * 0.36)
            invisibleTimerLabel.fontColor = UIColor.white
            invisibleTimerLabel.fontSize = 50
            invisibleTimerLabel.zPosition = 10
            invisibleTimerLabel.text = String(describing: InvisibleTimeActive.truncate(places: 1))
            //self.addChild(invisibleTimerLabel)
            self.gameLayer.addChild(invisibleTimerLabel)
        }
        
        
        shipUpgradesIcon.position = CGPoint(x: (self.size.width * 0.5 - 100), y: self.size.height * 0.04)
        shipUpgradesIcon.zPosition = 10
        shipUpgradesIcon.xScale = 0.5
        shipUpgradesIcon.yScale = 0.5
        shipUpgradesIcon.name = "shipUpgradesIcon"
        //self.addChild(shipUpgradesIcon)
        self.gameLayer.addChild(shipUpgradesIcon)
        //self.pauseLayer.addChild(shipUpgradesIcon)
        
        musicPlayIcon.position = CGPoint(x: (self.size.width * 0.5 + 100), y: self.size.height * 0.04)
        musicPlayIcon.zPosition = 10
        musicPlayIcon.xScale = 0.5
        musicPlayIcon.yScale = 0.5
        musicPlayIcon.name = "musicPlayIcon"
        //self.addChild(musicPlayIcon)
        self.gameLayer.addChild(musicPlayIcon)
        //self.pauseLayer.addChild(musicPlayIcon)
        
        if hintLevel {
            hintExclamationIcon.position = CGPoint(x: (self.size.width * 0.5 + 300), y: self.size.height * 0.04)
            hintExclamationIcon.zPosition = 10
            hintExclamationIcon.xScale = 0.5
            hintExclamationIcon.yScale = 0.5
            hintExclamationIcon.name = "hintExclamationIcon"
            //self.addChild(musicPlayIcon)
            self.gameLayer.addChild(hintExclamationIcon)
            //self.pauseLayer.addChild(musicPlayIcon)
        }
        
    }
    
    func menuButtonsSetup() {
        
        if preferredLanguage == .ru {
            restartButton = SKSpriteNode(imageNamed: "restartButtonRU1" /*"gameOverButton"*/)
            goToMenuButton = SKSpriteNode(imageNamed: "goToMenuButtonRU1" /*"gameOverButton"*/)
            settingsButton = SKSpriteNode(imageNamed: "settingsButtonsRU1" /*"gameOverButton"*/)
            levelsButton = SKSpriteNode(imageNamed: "levelsMenuButtonRU1" /*"gameOverButton"*/)
            //controlButton = SKSpriteNode(imageNamed: "controlButton" /*"gameOverButton"*/)
            
            if soundsIsOn {
                soundsOnOffButton = SKSpriteNode(imageNamed: "soundsOnButtonRU1" /*"gameOverButton"*/)
            } else {
                soundsOnOffButton = SKSpriteNode(imageNamed: "soundsOffButtonRU1" /*"gameOverButton"*/)
            }
            if musicIsPlaying {
                musicOnOffButton = SKSpriteNode(imageNamed: "musicOnButtonRU1" /*"gameOverButton"*/)
            } else {
                musicOnOffButton = SKSpriteNode(imageNamed: "musicOffButtonRU1" /*"gameOverButton"*/)
            }
        } else if preferredLanguage == .ch {
            restartButton = SKSpriteNode(imageNamed: "restartButtonCH1" /*"gameOverButton"*/)
            goToMenuButton = SKSpriteNode(imageNamed: "goToMenuButtonCH1" /*"gameOverButton"*/)
            settingsButton = SKSpriteNode(imageNamed: "settingsButtonsCH1" /*"gameOverButton"*/)
            levelsButton = SKSpriteNode(imageNamed: "levelsMenuButtonCH1" /*"gameOverButton"*/)
            //controlButton = SKSpriteNode(imageNamed: "controlButton" /*"gameOverButton"*/)
            
            if soundsIsOn {
                soundsOnOffButton = SKSpriteNode(imageNamed: "soundsOnButtonCH1" /*"gameOverButton"*/)
            } else {
                soundsOnOffButton = SKSpriteNode(imageNamed: "soundsOffButtonCH1" /*"gameOverButton"*/)
            }
            if musicIsPlaying {
                musicOnOffButton = SKSpriteNode(imageNamed: "musicOnButtonCH1" /*"gameOverButton"*/)
            } else {
                musicOnOffButton = SKSpriteNode(imageNamed: "musicOffButtonCH1" /*"gameOverButton"*/)
            }
        } else if preferredLanguage == .es {
            restartButton = SKSpriteNode(imageNamed: "restartButtonSP1" /*"gameOverButton"*/)
            goToMenuButton = SKSpriteNode(imageNamed: "goToMenuButtonSP1" /*"gameOverButton"*/)
            settingsButton = SKSpriteNode(imageNamed: "settingsButtonsSP1" /*"gameOverButton"*/)
            levelsButton = SKSpriteNode(imageNamed: "levelsMenuButtonSP1" /*"gameOverButton"*/)
            //controlButton = SKSpriteNode(imageNamed: "controlButton" /*"gameOverButton"*/)
            
            if soundsIsOn {
                soundsOnOffButton = SKSpriteNode(imageNamed: "soundsOnButtonSP1" /*"gameOverButton"*/)
            } else {
                soundsOnOffButton = SKSpriteNode(imageNamed: "soundsOffButtonSP1" /*"gameOverButton"*/)
            }
            if musicIsPlaying {
                musicOnOffButton = SKSpriteNode(imageNamed: "musicOnButtonSP1" /*"gameOverButton"*/)
            } else {
                musicOnOffButton = SKSpriteNode(imageNamed: "musicOffButtonSP1" /*"gameOverButton"*/)
            }
        } else {
            restartButton = SKSpriteNode(imageNamed: "restartButton1" /*"gameOverButton"*/)
            goToMenuButton = SKSpriteNode(imageNamed: "goToMenuButton1" /*"gameOverButton"*/)
            settingsButton = SKSpriteNode(imageNamed: "settingsButtons1" /*"gameOverButton"*/)
            levelsButton = SKSpriteNode(imageNamed: "levelsMenuButton1" /*"gameOverButton"*/)
            //controlButton = SKSpriteNode(imageNamed: "controlButton" /*"gameOverButton"*/)
            
            if soundsIsOn {
                soundsOnOffButton = SKSpriteNode(imageNamed: "soundsOnButton1" /*"gameOverButton"*/)
            } else {
                soundsOnOffButton = SKSpriteNode(imageNamed: "soundsOffButton1" /*"gameOverButton"*/)
            }
            if musicIsPlaying {
                musicOnOffButton = SKSpriteNode(imageNamed: "musicOnButton1" /*"gameOverButton"*/)
            } else {
                musicOnOffButton = SKSpriteNode(imageNamed: "musicOffButton1" /*"gameOverButton"*/)
            }
        }
        
        // MARK: START BUTTON
        
        //let restartButton = SKSpriteNode(imageNamed: "restartButton" /*"gameOverButton"*/)
        restartButton.name = "Play Again"
        //startButton.size = self.size
        restartButton.position = CGPoint(x: self.size.width * (-1), y: self.size.height * 0.85)
        restartButton.zPosition = 10
        //self.addChild(restartButton)
        //self.gameLayer.addChild(restartButton)
        self.pauseLayer.addChild(restartButton)
        
        // MARK: GO To menu Button
        
        //let goToMenuButton = SKSpriteNode(imageNamed: "goToMenuButton" /*"gameOverButton"*/)
        goToMenuButton.name = "Go To Menu"
        //startButton.size = self.size
        goToMenuButton.position = CGPoint(x: self.size.width * (-1), y: self.size.height * 0.70)
        goToMenuButton.zPosition = 10
        //self.addChild(goToMenuButton)
        //self.gameLayer.addChild(goToMenuButton)
        self.pauseLayer.addChild(goToMenuButton)
        
        //MARK: levels button
        
        //let controlButton = SKSpriteNode(imageNamed: "controlButton" /*"gameOverButton"*/)
        levelsButton.name = "Settings"
        //startButton.size = self.size
        levelsButton.position = CGPoint(x: self.size.width * (-1), y: self.size.height * 0.55)
        levelsButton.zPosition = 10
        //self.addChild(levelsButton)
        //self.gameLayer.addChild(levelsButton)
        self.pauseLayer.addChild(levelsButton)
        
        /*
        //MARK: Settings button
        
        //let controlButton = SKSpriteNode(imageNamed: "controlButton" /*"gameOverButton"*/)
        settingsButton.name = "Settings"
        //startButton.size = self.size
        settingsButton.position = CGPoint(x: self.size.width * (-1), y: self.size.height * 0.40)
        settingsButton.zPosition = 10
        //self.addChild(settingsButton)
        */
        /*
        // MARK: Control Button
        
        //let controlButton = SKSpriteNode(imageNamed: "controlButton" /*"gameOverButton"*/)
        controlButton.name = "Control"
        //startButton.size = self.size
        controlButton.position = CGPoint(x: self.size.width * (-1), y: self.size.height * 0.55)
        controlButton.zPosition = 10
       // self.addChild(controlButton)
        */
        //MARK: SoundsONOFF button
        
        soundsOnOffButton.name = "SoundsOnOff"
        soundsOnOffButton.position = CGPoint(x: self.size.width * (-1), y: self.size.height * 0.40)
        soundsOnOffButton.zPosition = 10
        //self.addChild(soundsOnOffButton)
        //self.gameLayer.addChild(soundsOnOffButton)
        self.pauseLayer.addChild(soundsOnOffButton)
        
        //MARK: MusicONOFF button
        
        musicOnOffButton.name = "MusicOnOff"
        musicOnOffButton.position = CGPoint(x: self.size.width * (-1), y: self.size.height * 0.40)
        musicOnOffButton.zPosition = 10
        //self.addChild(musicOnOffButton)
        //self.gameLayer.addChild(musicOnOffButton)
        self.pauseLayer.addChild(musicOnOffButton)
    }
    
    func animateMenuButtons() {
        let animationDuration: TimeInterval = 0.1
        
        let moveActionRestartButton = SKAction.moveTo(x: self.size.width/2, duration: animationDuration)  //(y: self.size.width * 0.5, duration: animationDuration)
        let moveActionGoToMenuButton = SKAction.moveTo(x: self.size.width/2, duration: animationDuration)    //(y: (goToMenuButton.size.height * 0) - goToMenuButton.size.height, duration: animationDuration)
        let moveActionLevelsButton = SKAction.moveTo(x: self.size.width/2, duration: animationDuration)
        let moveActionSettingsButton = SKAction.moveTo(x: self.size.width/2, duration: animationDuration)
        
        let moveActionSoundButton = SKAction.moveTo(x: self.size.width * 0.35, duration: animationDuration)
        let moveActionMusicButton = SKAction.moveTo(x: self.size.width * 0.65, duration: animationDuration)
        
        
        restartButton.run(moveActionRestartButton, withKey: "restartButtonActionAnimation")
        goToMenuButton.run(moveActionGoToMenuButton, withKey: "goToMenuButtonActionAnimation")
        levelsButton.run(moveActionLevelsButton, withKey: "controlButtonActionAnimation")
        settingsButton.run(moveActionSettingsButton, withKey: "controlButtonActionAnimation")
        musicOnOffButton.run(moveActionMusicButton, withKey: "musicButtonAction")
        soundsOnOffButton.run(moveActionSoundButton, withKey: "soundButtonAction")
    }
    
    func menuButtonsHide() {
        let animationDuration: TimeInterval = 0.1
        
        let moveActionRestartButton = SKAction.moveTo(x: self.size.width * (-1), duration: animationDuration)  //(y: self.size.width * 0.5, duration: animationDuration)
        let moveActionGoToMenuButton = SKAction.moveTo(x: self.size.width * (-1), duration: animationDuration)    //(y: (goToMenuButton.size.height * 0) - goToMenuButton.size.height, duration: animationDuration)
        let moveActionLevelsButton = SKAction.moveTo(x: self.size.width * (-1), duration: animationDuration)
        let moveActionSettingsButton = SKAction.moveTo(x: self.size.width * (-1), duration: animationDuration)
        
        let moveActionSoundButton = SKAction.moveTo(x: self.size.width * (-1), duration: animationDuration)
        let moveActionMusicButton = SKAction.moveTo(x: self.size.width * (-1), duration: animationDuration)
        
        
        let restartButtonSequence = SKAction.sequence([moveActionRestartButton/*, removeRestartButton*/ /*, lostCoinsAction*/])
        let GoToMenuButtonSequence = SKAction.sequence([moveActionGoToMenuButton/*, removeGoToMenuButton*/ /*, lostCoinsAction*/])
        let levelsButtonSequence = SKAction.sequence([moveActionLevelsButton/*, removeControlButton*/ /*, lostCoinsAction*/])
        let settingsButtonSequence = SKAction.sequence([moveActionSettingsButton/*, removeControlButton*/ /*, lostCoinsAction*/])
        let soundButtonSequence = SKAction.sequence([moveActionSoundButton/*, removeControlButton*/ /*, lostCoinsAction*/])
        let musicButtonSequence = SKAction.sequence([moveActionMusicButton/*, removeControlButton*/ /*, lostCoinsAction*/])
        
        restartButton.run(restartButtonSequence, withKey: "hideRestartButtonAction")
        goToMenuButton.run(GoToMenuButtonSequence, withKey: "hideGoToMenuButtonAction")
        levelsButton.run(levelsButtonSequence, withKey: "hideSettingsButtonAction")
        settingsButton.run(settingsButtonSequence, withKey: "hideSettingsButtonAction")
        soundsOnOffButton.run(soundButtonSequence, withKey: "hidesoundButtonAction")
        musicOnOffButton.run(musicButtonSequence, withKey: "hideMusicButtonAction")
        //controlButton.run(ControlButtonSequence, withKey: "hideControlButtonAction")
        
    }
    // MARK: animate POPUP ship upgrades window
    func animateShipUpgradesWindow() {
        let animationDuration: TimeInterval = 0.1
        let moveActionUpgradesWindow = SKAction.moveTo(x: self.size.width/6, duration: animationDuration)  //(y: self.size.width * 0.5, duration: animationDuration)
        
        shipUpgradesWindow.run(moveActionUpgradesWindow, withKey: "upgradesWindowActionAnimation")

    }
    
    // MARK: animate HIDE ship upgrades window
    func animateHideShipUpgradesWindow() {
        let animationDuration: TimeInterval = 0.1
        let moveActionUpgradesWindow = SKAction.moveTo(x: self.size.width * 2, duration: animationDuration)  //(y: self.size.width * 0.5, duration: animationDuration)
        
        shipUpgradesWindow.run(moveActionUpgradesWindow, withKey: "upgradesWindowActionAnimation")
        
    }
    
    // MARK: Planetes setup
    @objc func planetsSetup() {
        //let planetObject = Planet(texture: SKTexture(imageNamed: "venus"))
        let planetObject = Planet()
        //planetObject.position = CGPoint(x: self.size.width * 0.20, y: self.size.height * 1.30)
        planetObject.position.y = self.size.height * 1.30
        planetObject.zPosition = -20
        planetObject.name = "galaxy"
        //self.addChild(planetObject)
        self.gameLayer.addChild(planetObject)
        
        
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
        
        //planetObject.position = CGPoint(x: self.size.width * 0.20, y: self.size.height * 1.30)
        //spacestation.position.y = self.size.height * 0.50
        spacestation.zPosition = -10
        spacestation.name = "station"
        //self.addChild(spacestation)
        self.gameLayer.addChild(spacestation)
        
        
        let animationDuration: TimeInterval = 10
        //let moveAction = SKAction.moveTo(y: 500, duration: animationDuration)
        let nmoveAction = SKAction.move(to: spacestation.rundomToPosition() /*CGPoint(x: 1500, y: 712)*/, duration: animationDuration)
        let removeFromParent = SKAction.removeFromParent()
        //let lostCoinsAction = SKAction.run(loseCoinsOrAnemy)
        let moveSequence = SKAction.sequence([nmoveAction, removeFromParent/*, lostCoinsAction*/])
        spacestation.run(moveSequence, withKey: "setUpStation")
        
        //player.setVolume(Float(0), fadeDuration: TimeInterval(15))
        //player.set
    }
    
    // MAKR: Construction setup
    var nextRow = 0
    @objc func constructionSetup() {
        var construction = [[Int]]()
        if planet == 1 {
            construction = levels[level]
        } else if planet == 2 {
            construction = levels2[level]
        } else if planet == 3 {
            construction = levels3[level]
        }
        if nextRow < constructionLevelDurationTimerInterval {
            //for row in construction {
            let row = construction[nextRow]
            for (index, element) in row.enumerated() {
                //print("\(index)  \(element)")
                switch index {
                case 0:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 3, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 1, XPosition: 3)
                    } else if element == 4 {
                        //middleBarrierSetup(zPosition: <#T##CGFloat#>, XPosition: <#T##CGFloat#>)
                    } else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 3, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 1, XPosition: 3)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 3, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 3, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 3, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 1, XPosition: 3, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 3, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                case 1:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 2, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 1, XPosition: 2)
                    } else if element == 4 {
                        middleBarrierSetup(zPosition: 1, XPosition: 1)
                    }
                case 2:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 2, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 1, XPosition: 2)
                    } else if element == 4 {
                        
                    } else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 2, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 1, XPosition: 2)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 2, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 2, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 2, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 1, XPosition: 2, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 2, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                case 3:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 3, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 3, XPosition: 3)
                    } else if element == 4 {
                        middleBarrierSetup(zPosition: 1, XPosition: 2)
                    }
                case 4:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 1, XPosition: 1)
                    } else if element == 4 {
                        
                    } else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 1, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 1, XPosition: 1)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 1, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 1, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 1, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 1, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 1, XPosition: 1, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                case 5:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 3, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 3, XPosition: 3)
                    } else if element == 4 {
                        
                    } else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 3, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 3, XPosition: 3)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 3, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 3, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 3, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 3, XPosition: 3, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 3, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                case 6:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 3, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 5, XPosition: 3)
                    } else if element == 4 {
                        middleBarrierSetup(zPosition: 3, XPosition: 1)
                    }
                case 7:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 2, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 3, XPosition: 2)
                    } else if element == 4 {
                        
                    } else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 2, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 3, XPosition: 2)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 2, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 2, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 2, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 3, XPosition: 2, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 2, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                case 8:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 5, XPosition: 1)
                    } else if element == 4 {
                        middleBarrierSetup(zPosition: 3, XPosition: 2)
                    }
                case 9:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 3, XPosition: 1)
                    } else if element == 4 {
                        
                    } else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 1, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 3, XPosition: 1)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 1, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 1, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 1, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 3, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 3, XPosition: 1, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                    
                case 10:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 3, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 5, XPosition: 3)
                    } else if element == 4 {
                        
                    }else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 3, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 5, XPosition: 3)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 3, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 3, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 3, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 5, XPosition: 3, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 3, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                    
                case 11:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 5, XPosition: 1)
                    } else if element == 4 {
                        middleBarrierSetup(zPosition: 5, XPosition: 1)
                    }
                    
                case 12:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 2, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 5, XPosition: 2)
                    } else if element == 4 {
                        
                    } else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 2, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 5, XPosition: 2)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 2, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 2, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 2, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 5, XPosition: 2, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 2, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                    
                case 13:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 5, XPosition: 1)
                    } else if element == 4 {
                        middleBarrierSetup(zPosition: 5, XPosition: 2)
                        //constructionBarrierSetup(zPosition: 5, XPosition: 2)
                    }
                    
                case 14:
                    if element == 0 {
                        
                    } else if element == 1 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                    } else if element == 2 {
                        _ = coinSetup(zPosition: 5, XPosition: 1)
                    } else if element == 4 {
                        
                    } else if element == 9 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: "hackDebris", texture: 2, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 6 {
                        let hiddenCoin = coinSetup(zPosition: 5, XPosition: 1)
                        hiddenCoin.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: "glowingMine", texture: 3, hiddenCoin: hiddenCoin, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 7 {
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: "yellowGlowingMineRotating", texture: 4, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 8 {
                        
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: "yellowGlowingMine", texture: 5, hiddenCoin: nil, hiddenMine: nil)
                        //addPuzzleGamePics()
                    } else if element == 61 {
                        let hiddenMine = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: nil, texture: nil, hiddenCoin: nil, hiddenMine: nil)
                        hiddenMine.isHidden = true
                        _ = constructionBarrierSetup(zPosition: 5, XPosition: 1, name: "glowingMine", texture: 3, hiddenCoin: nil, hiddenMine: hiddenMine)
                        //addPuzzleGamePics()
                    }
                    
                    // 1 MAXleft, 2 MIDLeft 3 center, 4 MIDReight, 5 MAXRight
                    
                case 15:    // Partition setup 2 ZPOSITION Set up
                    if element == 0 {
                        
                    } else if element == 1 {
                        partitionSetup(zPosition: 2, random: false, position: CGPoint(x: self.size.width * (-0.10), y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 2 {
                        partitionSetup(zPosition: 2, random: false, position: CGPoint(x: self.size.width * 0.1, y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 3 {
                        partitionSetup(zPosition: 2, random: false, position: CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 4 {
                        partitionSetup(zPosition: 2, random: false, position: CGPoint(x: self.size.width * 0.9, y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 5 {
                        partitionSetup(zPosition: 2, random: false, position: CGPoint(x: self.size.width * 1.10, y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 6 {
                        partitionSetup(zPosition: 2, random: false, position: CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.80), angle: 90, newTexture: nil)
                    } else if element == 7 {
                        partitionSetup(zPosition: 2, random: false, position: CGPoint(x: self.size.width * 0.15, y: self.size.height * 1.80), angle: 90, newTexture: nil)
                    } else if element == 8 {
                        partitionSetup(zPosition: 2, random: false, position: CGPoint(x: self.size.width * 0.85, y: self.size.height * 1.80), angle: 90, newTexture: nil)
                    }
                    
                case 16:    // Partition setup 4 ZPOSITION Set up
                    if element == 0 {
                        
                    } else if element == 1 {
                        partitionSetup(zPosition: 4, random: false, position: CGPoint(x: self.size.width * (-0.31), y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 2 {
                        partitionSetup(zPosition: 4, random: false, position: CGPoint(x: self.size.width * (-0.1), y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 3 {
                        partitionSetup(zPosition: 4, random: false, position: CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 4 {
                        partitionSetup(zPosition: 4, random: false, position: CGPoint(x: self.size.width * 1.1, y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 5 {
                        partitionSetup(zPosition: 4, random: false, position: CGPoint(x: self.size.width * 1.31, y: self.size.height * 1.80), angle: nil, newTexture: nil)
                    } else if element == 6 {
                        partitionSetup(zPosition: 4, random: false, position: CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.80), angle: 90, newTexture: nil)
                    } else if element == 7 {
                        partitionSetup(zPosition: 4, random: false, position: CGPoint(x: self.size.width * (0.1), y: self.size.height * 1.80), angle: 90, newTexture: nil)
                    } else if element == 8 {
                        partitionSetup(zPosition: 4, random: false, position: CGPoint(x: self.size.width * 0.95, y: self.size.height * 1.80), angle: 90, newTexture: nil)
                    }
                    
                case 17:    // Partition setup 4 ZPOSITION Set up
                    if element == 1 {
                        moveTimeLinePeg()
                    }
                    
                default: break
                }
                
            }
        }
        if nextRow < constructionLevelDurationTimerInterval {
            nextRow += 1
            constructionDelay()
        }
        
    }
    
    // MARK: Construction delay
    func constructionDelay() {
        constructionTimer?.invalidate()
        constructionTimeInterval += 1
        if constructionTimeInterval < constructionLevelDurationTimerInterval /*14*/ {
            if planet == 1 {
            constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimeIntervalArray[level][constructionTimeInterval]), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
                //print("planet1 \(planet)")
            } else if planet == 2 {
                constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimeIntervalArray2[level][constructionTimeInterval]), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
                //print("planet2 \(planet)")
            } else if planet == 3 {
                constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimeIntervalArray3[level][constructionTimeInterval]), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
                //print("planet2 \(planet)")
            }
        } else if constructionTimeInterval == constructionLevelDurationTimerInterval /*14*/ {
            constructionTimer = Timer.scheduledTimer(timeInterval: constructionBarrierAnimationDuration /*TimeInterval(constructionTimeIntervalArray[constructionTimeInterval]*/, target: self, selector: #selector(GameScene.runGameOver), userInfo: nil, repeats: false)
            //runGameOver()
            //print("planetewrwr \(planet)")
            //print("constructionBarrierAnimationDuration \(constructionBarrierAnimationDuration)")
        }
       //print("planet \(planet)")
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
            //runGameOver()
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
    
    func triggerTrioStatus() {
        if trioIsAvaliable {
            for position in 1...3 {
                let trioShip = PlayerShip(name: nil, texture: nil)
                trioShip.name = "trioShip"
                trioShip.alpha = 0.0
                //let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
                //let distortAction = SKAction.animate(with: shipTurningUpArray, timePerFrame: 0.1)
                if ship.zPosition == 1 {
                    
                    if position == 1 {
                        trioShip.position = PlayerPosition.lowLeft620
                        trioShip.zPosition = 1
                        trioShip.xScale = ShipScale.small //0.6 //0.5
                        trioShip.yScale = ShipScale.small //0.6 //0.5
                        trioShip.centerLeftOrRightPosition = 2
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                    } else if position == 2 {
                        trioShip.position = PlayerPosition.lowCenter768
                        trioShip.zPosition = 1
                        trioShip.xScale = ShipScale.small //0.6 //0.5
                        trioShip.yScale = ShipScale.small //0.6 //0.5
                        trioShip.centerLeftOrRightPosition = 3
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                    } else if position == 3 {
                        trioShip.position = PlayerPosition.lowRight925
                        trioShip.zPosition = 1
                        trioShip.xScale = ShipScale.small //0.6 //0.5
                        trioShip.yScale = ShipScale.small //0.6 //0.5
                        trioShip.centerLeftOrRightPosition = 4
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                    }
                    
                } else if ship.zPosition == 3 {
                    
                    if position == 1 {
                        trioShip.position = PlayerPosition.middleLeft535
                        trioShip.zPosition = 3
                        trioShip.xScale = ShipScale.middle //0.9 //0.5
                        trioShip.yScale = ShipScale.middle //0.9 //0.5
                        trioShip.centerLeftOrRightPosition = 2
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                        //print("z 3 1")
                    } else if position == 2 {
                        trioShip.position = PlayerPosition.middleCenter768
                        trioShip.zPosition = 3
                        trioShip.xScale = ShipScale.middle //0.9 //0.5
                        trioShip.yScale = ShipScale.middle //0.9 //0.5
                        trioShip.centerLeftOrRightPosition = 3
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                        //print("z 3 2")
                    } else if position == 3 {
                        trioShip.position = PlayerPosition.middleRight1010
                        trioShip.zPosition = 3
                        trioShip.xScale = ShipScale.middle //0.9 //0.5
                        trioShip.yScale = ShipScale.middle //0.9//0.5
                        trioShip.centerLeftOrRightPosition = 4
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                        //print("z 3 3")
                    }
                    
                } else if ship.zPosition == 5 {
                    
                    if position == 1 {
                        trioShip.position = PlayerPosition.highLeft450
                        trioShip.zPosition = 5
                        trioShip.xScale = ShipScale.big //1.3 //1.5
                        trioShip.yScale = ShipScale.big //1.3 //1.5
                        trioShip.centerLeftOrRightPosition = 2
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                    } else if position == 2 {
                        trioShip.position = PlayerPosition.highCenter768
                        trioShip.zPosition = 5
                        trioShip.xScale = ShipScale.big //1.3 //1.5
                        trioShip.yScale = ShipScale.big //1.3 //1.5
                        trioShip.centerLeftOrRightPosition = 3
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                    } else if position == 3 {
                        trioShip.position = PlayerPosition.highRight1095
                        trioShip.zPosition = 5
                        trioShip.xScale = ShipScale.big //1.3 //1.5
                        trioShip.yScale = ShipScale.big //1.3 //1.5
                        trioShip.centerLeftOrRightPosition = 4
                        //self.addChild(trioShip)
                        self.gameLayer.addChild(trioShip)
                        //trioShip.run(fadeInAction)
                        trioShip.distortInEffect()
                    }
                    
                } else {
                    //print("else")
                }
            }
            //print("end")
            self.ship.isHidden = true
            
            trioTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.trioCounter), userInfo: nil, repeats: true)
            
            shipStatus = .trio
        }
    }
    
    func checkSP() {
        if (InvisibleTimeActive <= 0) {
            invisibilitiIsAvailable = false
        }
        if (rougeOneTimeActive <= 0) {
            //rougeOneTimer.invalidate()
            rougeOneIsAvaliable = false
        }
        if (trioTimeActive <= 0) {
            //trioTimer.invalidate()
            trioIsAvaliable = false
        }
    }
    
    var trioIsAvaliable = true
    @objc func trioCounter() {
        if trioTimeActive > 0 {
            trioTimeActive -= 0.1
            trioTimerLabel.text = String(describing: trioTimeActive.truncate(places: 1))
            if (trioTimeActive <= 0) {
                trioTimer.invalidate()
                trioIsAvaliable = false
                changeShipStatus()
                triggerNormalStatus()
            }
        } else if (trioTimeActive <= 0) {
            trioTimer.invalidate()
            trioIsAvaliable = false
        }

    }
    
    func triggerRogueOneStatus() {
        if rougeOneIsAvaliable {
            /*
             let allShips = self.children
             for trioShip in allShips {
             if trioShip is PlayerShip && trioShip.name == "trioShip" {
             trioShip.removeFromParent()
             }
             }
             self.ship.isHidden = false
             */
            rougeOneShipGlobal?.alpha = 0.0
            if ship.zPosition == 1 {
                rougeOneShipGlobal = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "ship10001" /*"heroRougeOne"*/))
                //rougeOneShip.name = "rougeOneShip"
                rougeOneShipGlobal?.zPosition = 3
                rougeOneShipGlobal?.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
                rougeOneShipGlobal?.rougeIsActive = false
                //self.addChild(rougeOneShipGlobal!)
                self.gameLayer.addChild(rougeOneShipGlobal!)
                rougeOneShipGlobal?.distortInEffect()
            } else if ship.zPosition == 3 {
                rougeOneShipGlobal = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "ship10001" /*"heroRougeOne"*/))
                //rougeOneShip.name = "rougeOneShip"
                rougeOneShipGlobal?.zPosition = 3
                rougeOneShipGlobal?.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
                rougeOneShipGlobal?.rougeIsActive = false
                //self.addChild(rougeOneShipGlobal!)
                self.gameLayer.addChild(rougeOneShipGlobal!)
                rougeOneShipGlobal?.distortInEffect()
            } else if ship.zPosition == 5 {
                rougeOneShipGlobal = PlayerShip(name: "rougeOneShip", texture: SKTexture(imageNamed: "ship10001" /*"heroRougeOne"*/))
                //rougeOneShip.name = "rougeOneShip"
                rougeOneShipGlobal?.zPosition = 3
                rougeOneShipGlobal?.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
                rougeOneShipGlobal?.rougeIsActive = false
                //self.addChild(rougeOneShipGlobal!)
                self.gameLayer.addChild(rougeOneShipGlobal!)
                rougeOneShipGlobal?.distortInEffect()
            } else {
                
            }
            rougeOneTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.rougeOneCounter), userInfo: nil, repeats: true)
            shipStatus = .rogueOne
            ship.rougeOneEffect()
            
        }
    }
    
    var rougeOneIsAvaliable = true
    @objc func rougeOneCounter() {
        if rougeOneTimeActive > 0 {
            rougeOneTimeActive -= 0.1
            rougeOneTimerLabel.text = String(describing: rougeOneTimeActive.truncate(places: 1))
            if (rougeOneTimeActive <= 0) {
                rougeOneTimer.invalidate()
                rougeOneIsAvaliable = false
                changeShipStatus()
                triggerNormalStatus()
            }
        } else if (rougeOneTimeActive <= 0) {
            rougeOneTimer.invalidate()
            rougeOneIsAvaliable = false
        }

    }
    
    func triggerInvisibleStatus() {
        if invisibilitiIsAvailable {
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
            
            
            // +++++++++++++++ Disable contact with partition
            ship.enumerateChildNodes(withName: "cD") { (node, _) in
                if let nodeLoc = node as? CollisionDetector {
                    nodeLoc.isInContactWithSomething = false
                }
            }
            for partition in partitions {
                partition.contactWithShip = false
            }
            // ---------------
 
            
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
            
            invisibleTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.invisibleCounter), userInfo: nil, repeats: true)
            shipStatus = .invisible
        }
    }
    var invisibilitiIsAvailable = true
    @objc func invisibleCounter() {
        
        if (InvisibleTimeActive > 0) {
            InvisibleTimeActive -= 0.1
            invisibleTimerLabel.text = String(describing: InvisibleTimeActive.truncate(places: 1))
            if (InvisibleTimeActive <= 0) {
                invisibleTimer.invalidate()
                invisibilitiIsAvailable = false
                changeShipStatus()
                triggerNormalStatus()
            }
        } else if (InvisibleTimeActive <= 0) {
            invisibleTimer.invalidate()
            invisibilitiIsAvailable = false
        }
    }
    
    var playerShip = PlayerShip()
    //playerShip.name = "testName"
    var rougeOneShip = PlayerShip()
    //rougeOneShip.name = "RougeTestName"
    
    var shipIsActive = true
    var rougeIsActive = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var settingsButtonLoc = SKSpriteNode()
        var hint = SKSpriteNode()
        /*var shipUpgradesClose = SKSpriteNode()*/
        
        /*if*/ let allNodes = gameLayer.children /*scene?.children*/ /*{*/
        for ship in allNodes {
            if let _ship = ship as? PlayerShip {
                if _ship.name == "playerShip" /*&& _ship.rougeIsActive == true*/  {
                    playerShip = _ship
                }
                if _ship.name == "rougeOneShip" /*&& _ship.rougeIsActive == true*/ {
                    rougeOneShip = _ship
                }
                
            }
            if let node = ship as? SKSpriteNode {
                if node.name == "settingsButton" {
                    settingsButtonLoc = node
                }
            }
            
        }
        /*}*/
        
        let allNodesPause = pauseLayer.children
        for node in allNodesPause {
            if let _node = node as? SKSpriteNode {
                if _node.name == "hint" {
                    hint = _node
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
                        
                        //rougeOneShipGlobal = tempShipRouge
                        
                        //ship.texture = SKTexture(imageNamed: "ship10001")
                        //rougeOneShipT = tempShipRouge
                        tempShipRouge.rougeIsActive = false
                        ship.rougeIsActive = true
                        print("rouge 3")
                    }
                    
                    if !rougeIsActive {
                        tempShipRouge.stopRougeOneEffect()
                        //rougeOneShipGlobal?.stopRougeOneEffect()
                        
                        ship.rougeOneEffect()
                        shipIsActive = false
                        rougeIsActive = true
                        print("rouge 1")
                    }
                    print("rouge 2")
                    
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
                        print("rouge 31")
                    }
                    
                    if !shipIsActive {
                        ship.rougeOneEffect()
                        rougeOneShipGlobal?.stopRougeOneEffect()
                        rougeIsActive = false
                        shipIsActive = true
                        print("ship 11")
                    }
                    print("ship 21")
                }
            }
            
            if hackableDebris.contains(pointTouch) /*.contains("1")*/ /*== redDot.name*/ {
                //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                if !puzzleDotsOnTheScreen && !puzzleCurrentGameStatus {
                    addPuzzleGamePics()
                }
            }
            
            if puzzleCurrentGameStatus  {
                if !firstDot {
                    //print("PUZZZLE FIRST")
                    if redDot.contains(pointTouch) && puzzleGameArray[0] == Int(redDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        redDot.xScale -= 0.5
                        redDot.yScale -= 0.5
                        
                       // print("RED first DOt puzzle game !!1")
                        drawLineToDot(position: redDot.position)
                        firstDot = true
                    } else
                    if blueDot.contains(pointTouch) && puzzleGameArray[0] == Int(blueDot.name!) /*.contains("2")*/ /*== blueDot.name*/ {
                        //blueDot.texture = SKTexture(imageNamed: "puzzleBlueDot")
                        blueDot.xScale -= 0.5
                        blueDot.yScale -= 0.5
                        //firstDot = true
                        //print("BLUE first DOt puzzle game !!1")
                        drawLineToDot(position: blueDot.position)
                        firstDot = true
                    } else
                    if yellowDot.contains(pointTouch) && puzzleGameArray[0] == Int(yellowDot.name!)  /*.contains("3")*/ /*== yellowDot.name*/ {
                        //yellowDot.texture = SKTexture(imageNamed: "puzzleYellowDot")
                        yellowDot.xScale -= 0.5
                        yellowDot.yScale -= 0.5
                        //firstDot = true
                        //print("YELLOW first DOt puzzle game !!1")
                        drawLineToDot(position: yellowDot.position)
                        firstDot = true
                    } else if greenDot.contains(pointTouch) && puzzleGameArray[0] == Int(greenDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        greenDot.xScale -= 0.5
                        greenDot.yScale -= 0.5
                        
                        //print("RED first DOt puzzle game !!1")
                        drawLineToDot(position: greenDot.position)
                        firstDot = true
                    } else if purpleDot.contains(pointTouch) && puzzleGameArray[0] == Int(purpleDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        purpleDot.xScale -= 0.5
                        purpleDot.yScale -= 0.5
                        
                        //print("RED first DOt puzzle game !!1")
                        drawLineToDot(position: purpleDot.position)
                        firstDot = true
                    }
                    
                    
                    else if redDot.contains(pointTouch) && puzzleGameArray[0] != Int(redDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else if blueDot.contains(pointTouch) && puzzleGameArray[0] != Int(blueDot.name!) /*.contains("2")*/ /*== blueDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else if yellowDot.contains(pointTouch) && puzzleGameArray[0] != Int(yellowDot.name!)  /*.contains("3")*/ /*== yellowDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else if greenDot.contains(pointTouch) && puzzleGameArray[0] != Int(greenDot.name!) /*.contains("2")*/ /*== blueDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else if purpleDot.contains(pointTouch) && puzzleGameArray[0] != Int(purpleDot.name!)  /*.contains("3")*/ /*== yellowDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    }
                        
                    else {
                        //print("nothingy")
                        //explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                    }
                } else
                if !secondDot {
                    if redDot.contains(pointTouch) && puzzleGameArray[1] == Int(redDot.name!) {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        redDot.xScale -= 0.5
                        redDot.yScale -= 0.5
                        //secondDot = true
                        //firstDot = true
                        //print("RED second DOt puzzle game !!1")
                        drawLineToDot(position: redDot.position)
                        secondDot = true
                    } else if blueDot.contains(pointTouch) && puzzleGameArray[1] == Int(blueDot.name!) {
                        //blueDot.texture = SKTexture(imageNamed: "puzzleBlueDot")
                        blueDot.xScale -= 0.5
                        blueDot.yScale -= 0.5
                        //secondDot = true
                        //firstDot = true
                        //print("BLUE second DOt puzzle game !!1")
                        drawLineToDot(position: blueDot.position)
                        secondDot = true
                    } else if yellowDot.contains(pointTouch) && puzzleGameArray[1] == Int(yellowDot.name!) {
                        //yellowDot.texture = SKTexture(imageNamed: "puzzleYellowDot")
                        yellowDot.xScale -= 0.5
                        yellowDot.yScale -= 0.5
                        //secondDot = true
                        //firstDot = false
                        //print("YELLLOW second DOt puzzle game !!1")
                        drawLineToDot(position: yellowDot.position)
                        secondDot = true
                    } else if greenDot.contains(pointTouch) && puzzleGameArray[1] == Int(greenDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        greenDot.xScale -= 0.5
                        greenDot.yScale -= 0.5
                        
                        //print("RED first DOt puzzle game !!1")
                        drawLineToDot(position: greenDot.position)
                        secondDot = true
                    } else if purpleDot.contains(pointTouch) && puzzleGameArray[1] == Int(purpleDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        purpleDot.xScale -= 0.5
                        purpleDot.yScale -= 0.5
                        
                        //print("RED first DOt puzzle game !!1")
                        drawLineToDot(position: purpleDot.position)
                        secondDot = true
                    }
                    
                    
                    else if redDot.contains(pointTouch) && puzzleGameArray[1] != Int(redDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else if blueDot.contains(pointTouch) && puzzleGameArray[1] != Int(blueDot.name!) /*.contains("2")*/ /*== blueDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else if yellowDot.contains(pointTouch) && puzzleGameArray[1] != Int(yellowDot.name!)  /*.contains("3")*/ /*== yellowDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else
                    if greenDot.contains(pointTouch) && puzzleGameArray[1] != Int(greenDot.name!) /*.contains("2")*/ /*== blueDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else
                    if purpleDot.contains(pointTouch) && puzzleGameArray[1] != Int(purpleDot.name!)  /*.contains("3")*/ /*== yellowDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    }
                    
                    
                } else
                if !thirdDot {
                    if redDot.contains(pointTouch) && puzzleGameArray[2] == Int(redDot.name!) {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        redDot.xScale -= 0.5
                        redDot.yScale -= 0.5
                        //thirdDot = true
                        //secondDot = false
                        //print("RED done puzzle game !!1")
                        drawLineToDot(position: redDot.position)
                        t4 = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.hideDots), userInfo: nil, repeats: false)
                        //hideDots()
                        thirdDot = true
                    } else if blueDot.contains(pointTouch) && puzzleGameArray[2] == Int(blueDot.name!) {
                        //blueDot.texture = SKTexture(imageNamed: "puzzleBlueDot")
                        blueDot.xScale -= 0.5
                        blueDot.yScale -= 0.5
                        //thirdDot = true
                        //secondDot = false
                        //print("BLUE done puzzle game !!1")
                        drawLineToDot(position: blueDot.position)
                        t4 = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.hideDots), userInfo: nil, repeats: false)
                        //hideDots()
                        thirdDot = true
                    } else if yellowDot.contains(pointTouch) && puzzleGameArray[2] == Int(yellowDot.name!) {
                        //yellowDot.texture = SKTexture(imageNamed: "puzzleYellowDot")
                        yellowDot.xScale -= 0.5
                        yellowDot.yScale -= 0.5
                        //thirdDot = true
                        //secondDot = false
                        //print("Yellow done puzzle game !!1")
                        drawLineToDot(position: yellowDot.position)
                        t4 = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.hideDots), userInfo: nil, repeats: false)
                        //hideDots()
                        thirdDot = true
                    } else if greenDot.contains(pointTouch) && puzzleGameArray[2] == Int(greenDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        greenDot.xScale -= 0.5
                        greenDot.yScale -= 0.5
                        
                        //print("RED first DOt puzzle game !!1")
                        drawLineToDot(position: greenDot.position)
                        t4 = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.hideDots), userInfo: nil, repeats: false)
                        thirdDot = true
                    } else if purpleDot.contains(pointTouch) && puzzleGameArray[2] == Int(purpleDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        //redDot.texture = SKTexture(imageNamed: "puzzleRedDot")
                        purpleDot.xScale -= 0.5
                        purpleDot.yScale -= 0.5
                        
                        //print("RED first DOt puzzle game !!1")
                        drawLineToDot(position: purpleDot.position)
                        t4 = Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.hideDots), userInfo: nil, repeats: false)
                        thirdDot = true
                    }
                    
                    
                    else if redDot.contains(pointTouch) && puzzleGameArray[2] != Int(redDot.name!) /*.contains("1")*/ /*== redDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else if blueDot.contains(pointTouch) && puzzleGameArray[2] != Int(blueDot.name!) /*.contains("2")*/ /*== blueDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else if yellowDot.contains(pointTouch) && puzzleGameArray[2] != Int(yellowDot.name!)  /*.contains("3")*/ /*== yellowDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else
                    if greenDot.contains(pointTouch) && puzzleGameArray[2] != Int(greenDot.name!) /*.contains("2")*/ /*== blueDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    } else
                    if purpleDot.contains(pointTouch) && puzzleGameArray[2] != Int(purpleDot.name!)  /*.contains("3")*/ /*== yellowDot.name*/ {
                        explosion(pos: playerShip.position, zPos: playerShip.zPosition)
                        playerShip.removeFromParent()
                        runGameOver()
                    }
                    
                }
            }
            
            //MARK: PAUSE game SETTINGS. Sets timer to weit to buttons to appear.
            if settingsButtonLoc.contains(pointTouch) {
                //print("first")
                if buttonStatus == .settings && !shipExplode || buttonStatus == .none && !shipExplode {
                    if !puzzleDotsOnTheScreen {
                        //print("second")
                        if canMove {
                            animateMenuButtons()
                            pauseFuncSettings()
                            
                            gameLayer.isPaused = true
                            
                            canMove = false
                            buttonStatus = .settings
                            
                            levelNumberLabel.isHidden = true
                            pushedPause = true
                        } else if !canMove {
                            gameLayer.isPaused = false
                            
                            pauseFuncSettings()
                            canMove = true
                            menuButtonsHide()
                            
                            buttonStatus = .none
                            
                            levelNumberLabel.isHidden = false
                            pushedPause = false
                        }
                    }  else if puzzleDotsOnTheScreen {
                        let youCantPauseHere = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
                        if preferredLanguage == .ru {
                            youCantPauseHere.text = "Пау3а не активна."
                        } else if preferredLanguage == .ch {
                            youCantPauseHere.text = "Пау3а не активна."
                        } else {
                            youCantPauseHere.text = "You can't pause here."
                        }
                        //popupCoinsLabel.text = "0"
                        youCantPauseHere.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
                        youCantPauseHere.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                        youCantPauseHere.fontSize = 60
                        youCantPauseHere.zPosition = 100
                        youCantPauseHere.alpha = 0.0
                        
                        self.gameLayer.addChild(youCantPauseHere)
                        
                        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
                        let waitAction = SKAction.wait(forDuration: 1)
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
                        let removeLabel = SKAction.removeFromParent()
                        
                        
                        let popupLabelSequence = SKAction.sequence([fadeInAction, waitAction, fadeOutAction, removeLabel])
                        popupLabelSequence.timingMode = SKActionTimingMode.easeInEaseOut
                        
                        youCantPauseHere.run(popupLabelSequence)
                        //pushedPause = false
                    }
                }////////////////fsdffsdfsdfsd
                if scene?.isPaused == true {
                    scene?.isPaused = false
                }
                
            } else if musicPlayIcon.contains(pointTouch) {
                
                if musicIsPlaying {
                    player.pause()
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                    }
                    musicIsPlaying = false
                    musicPlayIcon.texture = SKTexture(imageNamed: "musicMute")
                } else {
                    player.play()
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                    }
                    musicIsPlaying = true
                    musicPlayIcon.texture = SKTexture(imageNamed: "musicPlay")
                }
                
                /*
                if buttonStatus == .hintWindow {
                    self.view?.isPaused = false
                    constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimerfireDate), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
                    canMove = true
                    hint.removeFromParent()
                    buttonStatus = .none
                }*/
            } else if hint.contains(pointTouch) {
                if buttonStatus == .hintWindow {
                    pauseFuncSettings()
                    //self.view?.isPaused = false
                    gameLayer.isPaused = false
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                    }
                    //constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimerfireDate), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
                    
                    //if !hintDone && !hintNowVisible {
                        //pauseFuncSettings()
                    //}
                    hintNowVisible = false
                    canMove = true
                    hint.removeFromParent()
                    buttonStatus = .none
                    hintDone = true
                    levelNumberLabel.isHidden = false
                    pushedPause = false
                    
                }
            } else if restartButton.contains(pointTouch) {
                //runAds()
                changeShipStatus()
                restatrButtonPressedForAds = true
                if !programmIsPaid {
                    runAds()
                } else {
                    newScene()
                }
                //newScene()
                
            } else if goToMenuButton.contains(pointTouch) {
                if buttonStatus == .settings || buttonStatus == .none {
                    changeShipStatus()
                    mainMenuButtonPressedForAds = true
                    if !programmIsPaid {
                        runAds()
                    } else {
                        newMainMenuSceneForAds()
                    }
                   
                }
            } else if levelsButton.contains(pointTouch) /*controlButton.contains(pointTouch)*/ {
                if buttonStatus == .settings || buttonStatus == .none {
                    changeShipStatus()
                    newLevelButtonPressedForAds = true
                    if !programmIsPaid {
                        runAds()
                    } else {
                        newLevelMenuSceneForAds()
                    }
                    
                }
                
            } else if musicOnOffButton.contains(pointTouch) /*controlButton.contains(pointTouch)*/ {
                if musicIsPlaying {
                    musicIsPlaying = false
                    musicPlayIcon.texture = SKTexture(imageNamed: "musicMute")
                    player.pause()
                    if preferredLanguage == .ru {
                        musicOnOffButton.texture = SKTexture(imageNamed: "musicOffButtonRU1")
                    } else if preferredLanguage == .ch {
                        musicOnOffButton.texture = SKTexture(imageNamed: "musicOffButtonCH1")
                    } else if preferredLanguage == .es {
                        musicOnOffButton.texture = SKTexture(imageNamed: "musicOffButtonSP1")
                    } else {
                        musicOnOffButton.texture = SKTexture(imageNamed: "musicOffButton1")
                    }
                } else if !musicIsPlaying {
                    musicIsPlaying = true
                    musicPlayIcon.texture = SKTexture(imageNamed: "musicPlay")
                    player.play()
                    if preferredLanguage == .ru {
                        musicOnOffButton.texture = SKTexture(imageNamed: "musicOnButtonRU1")
                    } else if preferredLanguage == .ch {
                        musicOnOffButton.texture = SKTexture(imageNamed: "musicOnButtonCH1")
                    } else if preferredLanguage == .es {
                        musicOnOffButton.texture = SKTexture(imageNamed: "musicOnButtonSP1")
                    } else {
                        musicOnOffButton.texture = SKTexture(imageNamed: "musicOnButton1")
                    }
                }
                
            } else if soundsOnOffButton.contains(pointTouch) /*controlButton.contains(pointTouch)*/ {
                if soundsIsOn {
                    soundsIsOn = false
                    //engineSoundsAction.speed = 0.0
                    //removeAction(forKey: "shipEngineSound")
                    playerEngine.pause()
                    if preferredLanguage == .ru {
                        soundsOnOffButton.texture = SKTexture(imageNamed: "soundsOffButtonRU1")
                    } else if preferredLanguage == .ch {
                        soundsOnOffButton.texture = SKTexture(imageNamed: "soundsOffButtonCH1")
                    } else if preferredLanguage == .es {
                        soundsOnOffButton.texture = SKTexture(imageNamed: "soundsOffButtonSP1")
                    } else {
                        soundsOnOffButton.texture = SKTexture(imageNamed: "soundsOffButton1")
                    }
                } else if !soundsIsOn {
                    soundsIsOn = true
                    //shipEngineSound()
                    playerEngine.play()
                    if preferredLanguage == .ru {
                        soundsOnOffButton.texture = SKTexture(imageNamed: "soundsOnButtonRU1")
                    } else if preferredLanguage == .ch {
                        soundsOnOffButton.texture = SKTexture(imageNamed: "soundsOnButtonCH1")
                    } else if preferredLanguage == .es {
                        soundsOnOffButton.texture = SKTexture(imageNamed: "soundsOnButtonSP1")
                    } else {
                        soundsOnOffButton.texture = SKTexture(imageNamed: "soundsOnButton1")
                    }
                }
                
            } else if shipUpgradesIcon.contains(pointTouch) {
                if buttonStatus == .shipUpgrades && !shipExplode || buttonStatus == .none && !shipExplode {
                    if !puzzleDotsOnTheScreen {
                        if canMove {
                            animateShipUpgradesWindow() //setupShipUpgradesWindow()//animateMenuButtons()
                            pauseFuncSettings()
                            gameLayer.isPaused = true
                            canMove = false
                            buttonStatus = .shipUpgrades
                            levelNumberLabel.isHidden = true
                            pushedPause = true
                        } else if !canMove {
                            gameLayer.isPaused = false
                            pauseFuncSettings()
                            canMove = true
                            buttonStatus = .none
                            animateHideShipUpgradesWindow()
                            levelNumberLabel.isHidden = false
                            pushedPause = false
                        }
                    } else if puzzleDotsOnTheScreen {
                        let youCantPauseHere = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
                        if preferredLanguage == .ru {
                            youCantPauseHere.text = "Пау3а не активна."
                        } else if preferredLanguage == .ch {
                            youCantPauseHere.text = "Пау3а не активна."
                        } else {
                            youCantPauseHere.text = "You can't pause here."
                        }
                        //popupCoinsLabel.text = "0"
                        youCantPauseHere.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
                        youCantPauseHere.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0)
                        youCantPauseHere.fontSize = 60
                        youCantPauseHere.zPosition = 100
                        youCantPauseHere.alpha = 0.0
                        
                        self.gameLayer.addChild(youCantPauseHere)
                        
                        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
                        let waitAction = SKAction.wait(forDuration: 1)
                        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
                        let removeLabel = SKAction.removeFromParent()
                        
                        
                        let popupLabelSequence = SKAction.sequence([fadeInAction, waitAction, fadeOutAction, removeLabel])
                        popupLabelSequence.timingMode = SKActionTimingMode.easeInEaseOut
                        
                        youCantPauseHere.run(popupLabelSequence)
                    }
                }
                //self.view?.isPaused = false
                
                //showShipUpgrades()   hintExclamationIcon
                
                
            } else if hintExclamationIcon.contains(pointTouch) {
                if buttonStatus == .hintWindow && !shipExplode || buttonStatus == .none && !shipExplode {
                    
                    if canMove {
                        //animateMenuButtons()
                        showHintByButton()
                        pauseFuncSettings()
                        
                        buttonStatus = .hintWindow
                        gameLayer.isPaused = true
                        canMove = false
                        levelNumberLabel.isHidden = true
                        pushedPause = true
                    } else if !canMove {
                        pauseFuncSettings()
                        //menuButtonsHide()
                        hint.removeFromParent()
                        hintDone = true
                        
                        gameLayer.isPaused = false
                        canMove = true
                        buttonStatus = .none
                        levelNumberLabel.isHidden = false
                        pushedPause = false
                    }
                }
                
                
            } else if shipUpgradesWindow.contains(pointTouch) {
                if buttonStatus == .shipUpgrades {
                    //self.view?.isPaused = false
                    gameLayer.isPaused = false
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                    }
                    constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimerfireDate), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
                    canMove = true
                    animateHideShipUpgradesWindow() //shipUpgradesWindow.removeFromParent()
                    //print("upgradesWindow pushed")
                    buttonStatus = .none
                }
            } else if spacestation.contains(pointTouch) {
                if !pushedPause {
                    let wichSP = Int(arc4random()%3)
                    if wichSP == 0 {
                        trioTimeActiveLoc += 0.1
                    } else if wichSP == 1 {
                        rougeOneTimeActiveLoc += 0.1
                    } else if wichSP == 2 {
                        InvisibleTimeActiveLoc += 0.1
                    }
                }
            } else if musicPlayIcon.contains(pointTouch) {
                
                if musicIsPlaying {
                    player.pause()
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                    }
                    musicIsPlaying = false
                    musicPlayIcon.texture = SKTexture(imageNamed: "musicMute")
                } else {
                    player.play()
                    if soundsIsOn {
                        run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                    }
                    musicIsPlaying = true
                    musicPlayIcon.texture = SKTexture(imageNamed: "musicPlay")
                }
                
            }
            
            
            let buttons = /*self.children*/ gameLayer.children
            if gameLayer.isPaused == false {
                for button in buttons {
                    if button.name == SomeNames.invisibleStatusButton || button.name == SomeNames.normalStatusButton || button.name == SomeNames.trioStatusButton || button.name == SomeNames.rougeOneStatusButton {
                        touchButtonsChangeStatus(button: button, pointTouch: pointTouch)
                    }
                }
            }
            
            if levelWithChargedMine {
                if let touch = touches.first {
                    let touchLocation = touch.location(in: self)
                    if let targetNode = atPoint(touchLocation) as? Debris {
                        
                        //let detonateButton = SKSpriteNode(imageNamed: "buttonDetonate")
                        detonateButton.position.y = self.size.height / 2
                        detonateButton.position.x = self.size.width / 2
                        detonateButton.zPosition = 100
                        detonateButton.yScale = 0.7
                        detonateButton.xScale = 0.7
                        detonateButton.name = "Detonate button"
                        
                        if preferredLanguage == .ru {
                            detonateButton.texture = SKTexture(imageNamed: "buttonDetonateRU1")
                        } else if preferredLanguage == .ch {
                            detonateButton.texture = SKTexture(imageNamed: "buttonDetonateCH1")
                        } else if preferredLanguage == .es {
                            detonateButton.texture = SKTexture(imageNamed: "buttonDetonateSP1")
                        } else {
                            detonateButton.texture = SKTexture(imageNamed: "buttonDetonate1")
                        }
                        
                        if !targetNode.greenMineCharged && detonateDebrisArray.isEmpty {
                            if targetNode.name == "charegedMine" {
                                targetNode.greenCharegedGlowingMineEffect()
                                targetNode.greenMineCharged = true
                                detonateDebrisArray.append(targetNode)
                                detonateDebris = targetNode
                                gameLayer.addChild(detonateButton)
                            }
                        } else if targetNode.greenMineCharged && !detonateDebrisArray.isEmpty {
                            if targetNode.name == "charegedMine" {
                                targetNode.stopGreenCharegedGlowingMineEffect()
                                targetNode.greenMineCharged = false
                                detonateDebrisArray.removeAll()
                                detonateButton.removeFromParent()
                            }
                        } else if !targetNode.greenMineCharged && !detonateDebrisArray.isEmpty {
                            if targetNode.name == "charegedMine" {
                                let oldNode = detonateDebrisArray.first
                                oldNode?.stopGreenCharegedGlowingMineEffect()
                                oldNode?.greenMineCharged = false
                                detonateDebrisArray.removeAll()
                                //detonateButton.removeFromParent()
                                
                                //detonateDebris = targetNode
                                targetNode.greenCharegedGlowingMineEffect()
                                targetNode.greenMineCharged = true
                                detonateDebrisArray.append(targetNode)
                                detonateDebris = targetNode
                                //gameLayer.addChild(detonateButton)
                                
                            }
                        }

                    }
                    
                    if let detonateButtonNode = atPoint(touchLocation) as? SKSpriteNode {
                        if detonateButtonNode.name == "Detonate button" {
                            mineDetonation(pos: detonateDebris.position, zPos: detonateDebris.zPosition)
                            //explosion(pos: detonateDebris.position, zPos: detonateDebris.zPosition)
                            detonateDebris.hiddenCoin?.isHidden = false
                            detonateDebris.hiddenMine?.isHidden = false
                            detonateDebris.greenMineCharged = false
                            detonateDebrisArray.removeAll()
                            detonateDebris.removeFromParent()
                            detonateButton.removeFromParent()
                        }
                    }
                }
            }
        }
        
    }
    
    let detonateButton = SKSpriteNode(imageNamed: "buttonDetonate1")
    var detonateDebris = Debris()
    var detonateDebrisArray = [Debris]()
    
    func pauseFuncSettings() {
        if gameMode == .normal {
            if canMove {
                if soundsIsOn {
                    run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                }
                if hintLevel {
                    if !hintDone && !hintNowVisible {
                        levelHintTimerfireDate = showHintTimer!.fireDate.timeIntervalSinceNow
                        showHintTimer?.invalidate()
                        //print("sdfaslfhslkajdfhkasjdfakjldf")
                    }
                }
                
                if nextRow < constructionLevelDurationTimerInterval {
                    constructionTimerfireDate = constructionTimer!.fireDate.timeIntervalSinceNow
                    constructionTimer?.invalidate()
                    //print("sdfaslfhslkajdfhkasjdfakjldf")
                } else if nextRow == constructionLevelDurationTimerInterval && !gameOverIsRuning {
                    //constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimerfireDate), target: self, selector: #selector(GameScene.runGameOver), userInfo: nil, repeats: false)
                    constructionTimerfireDate = constructionTimer!.fireDate.timeIntervalSinceNow
                    constructionTimer?.invalidate()
                }
                //print("constructionBarrierAnimationDuration \(constructionBarrierAnimationDuration)")
                //print("\(constructionTimerfireDate)")
                
                if puzzle {
                    if puzzleDotsOnTheScreen {
                        puzzleDotsHideTimerfireDate = puzzleDotsHideTimer!.fireDate.timeIntervalSinceNow
                        puzzleDotsHideTimer?.invalidate()
                    }
                }
                
                if puzzle {
                    if !puzzleColocHitVisible {
                        if let show = dotSequnceTimerShow {
                            showHintsTimerfireDate = show.fireDate.timeIntervalSinceNow
                            dotSequnceTimerShow?.invalidate()
                            print("puz1")
                        }
                        print("puz2")
                    }
                    if puzzleColocHitVisible {
                        if let hide = dotSequnceTimerHide {
                            hideHintsTimerfireDate = hide.fireDate.timeIntervalSinceNow
                            dotSequnceTimerHide?.invalidate()
                            print("puz3")
                        }
                        print("puz4")
                    }
                    print("puz5")
                }
                
                stopSPCounters()
                
                //buttonStatus = .hintWindow
                //waitToHideDotsActionDuration = waitToHideDots.duration
                
            } else if !canMove {
                if soundsIsOn {
                    run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                }
                if hintLevel {
                    if !hintDone && !hintNowVisible {
                        showHintTimer = Timer.scheduledTimer(timeInterval: TimeInterval(levelHintTimerfireDate), target: self, selector: #selector(GameScene.showHint), userInfo: nil, repeats: false)
                    }
                }
                
                if nextRow < constructionLevelDurationTimerInterval && !gameOverIsRuning {
                    constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimerfireDate), target: self, selector: #selector(GameScene.constructionSetup), userInfo: nil, repeats: false)
                    
                    //print("\(constructionTimerfireDate)")
                } else if nextRow == constructionLevelDurationTimerInterval {
                    constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimerfireDate), target: self, selector: #selector(GameScene.runGameOver), userInfo: nil, repeats: false)
                }
                if puzzle {
                    if puzzleDotsOnTheScreen {
                        puzzleDotsHideTimer = Timer.scheduledTimer(timeInterval: TimeInterval(puzzleDotsHideTimerfireDate), target: self, selector: #selector(GameScene.hideDots), userInfo: nil, repeats: false)
                    }
                }
                
                
                if puzzle {
                    if !showHintOneTime {
                        if !puzzleColocHitVisible {
                            dotSequnceTimerShow = Timer.scheduledTimer(timeInterval: TimeInterval(showHintsTimerfireDate), target: self, selector: #selector(GameScene.showDotSequence), userInfo: nil, repeats: false)
                            print("puz21")
                        }
                        print("puz22")
                    }
                    if !showHintOneTime {
                        if puzzleColocHitVisible {
                            dotSequnceTimerHide = Timer.scheduledTimer(timeInterval: TimeInterval(hideHintsTimerfireDate), target: self, selector: #selector(GameScene.hideDotsHitns), userInfo: nil, repeats: false)
                            print("puz23")
                        }
                        print("puz24")
                    }
                    print("puz25")
                }
                
                runSPCountersAfterPause()
                
                //waitToHideDots.duration = waitToHideDotsActionDuration
            }
        } else if gameMode == .survival {
            if canMove {
                if soundsIsOn {
                    run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                }
                constructionTimerfireDate = constructionTimer!.fireDate.timeIntervalSinceNow
                constructionTimer?.invalidate()
                
                coinForSurvivalFireDate = survivalCoinSetupTimer!.fireDate.timeIntervalSinceNow
                survivalCoinSetupTimer?.invalidate()
                
                stopSPCounters()
                
            } else if !canMove {
                if soundsIsOn {
                    run(SKAction.playSoundFileNamed("pause1.m4a", waitForCompletion: false))
                }
                constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(constructionTimerfireDate), target: self, selector: #selector(GameScene.repeatInvokeConstructionBarrierSetupForSurvival), userInfo: nil, repeats: false)
                
                survivalCoinSetupTimer = Timer.scheduledTimer(timeInterval: TimeInterval(coinForSurvivalFireDate), target: self, selector: #selector(GameScene.repeatInvokeCoinSetupForSurvival), userInfo: nil, repeats: true)
                
                runSPCountersAfterPause()
            }
         
        }
        
    }
    
    func runSPCountersAfterPause() {
        if shipStatus == .trio {
            trioTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.trioCounter), userInfo: nil, repeats: true)
        } else if shipStatus == .rogueOne {
            rougeOneTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.rougeOneCounter), userInfo: nil, repeats: true)
        } else if shipStatus == .invisible {
            invisibleTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.invisibleCounter), userInfo: nil, repeats: true)
        }
    }
    
    func stopSPCounters() {
        if shipStatus == .trio {
            trioTimer.invalidate()
        } else if shipStatus == .rogueOne {
            rougeOneTimer.invalidate()
        } else if shipStatus == .invisible {
            invisibleTimer.invalidate()
        }
    }
    
    @objc func repeatInvokeConstructionBarrierSetupForSurvival () {
        invokeConstructionBarrierSetupForSurvival()
        constructionTimer?.invalidate()
        constructionTimer = Timer.scheduledTimer(timeInterval: TimeInterval(survivorDebrisTimeInterval), target: self, selector: #selector(GameScene.invokeConstructionBarrierSetupForSurvival), userInfo: nil, repeats: true)
    }
    @objc func repeatInvokeCoinSetupForSurvival () {
        invokeCoinSetupForSurvival()
        survivalCoinSetupTimer?.invalidate()
        survivalCoinSetupTimer = Timer.scheduledTimer(timeInterval: TimeInterval(survivorCoinTimeInterval), target: self, selector: #selector(GameScene.invokeCoinSetupForSurvival), userInfo: nil, repeats: true)
    }
    // MARK: Run new scene after explosion or restartButton
    func newScene() {
        if /*self.view!.isPaused*/ gameLayer.isPaused {
            //self.view?.isPaused = false
            saveTimeActiveSeconds()
            gameLayer.isPaused = false
            NotificationCenter.default.removeObserver(SomeNames.blowTheShip)
            
            removeAllActions()
            removeAllChildren()
            
            self.physicsWorld.contactDelegate = nil
            
            barrierTimer?.invalidate()
            partitionTimer?.invalidate()
            planetTimer?.invalidate()
            spacestationTimer?.invalidate()
            clean()
            //constructionTimer?.invalidate()
            
            //trioTimer.invalidate()
            //invisibleTimer.invalidate()
            //rougeOneTimer.invalidate()
            
            //t1?.invalidate()
            //t2?.invalidate()
            //t3?.invalidate()
            
            //self.view?.gestureRecognizers?.removeAll()
            canMove = false
            
            //_ = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.newScene), userInfo: nil, repeats: false)
            
            let scene = GameScene(size: CGSize(width: 1536, height: 2048))
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
            // Present the scene
            view?.presentScene(scene, transition: startGameTransition)
            if #available(iOS 10.0, *) {
                view?.preferredFramesPerSecond = 60
            } else {
                // Fallback on earlier versions
            }
        } else {
            NotificationCenter.default.removeObserver(SomeNames.blowTheShip)
            
            removeAllActions()
            removeAllChildren()
            
            self.physicsWorld.contactDelegate = nil
            
            barrierTimer?.invalidate()
            partitionTimer?.invalidate()
            planetTimer?.invalidate()
            spacestationTimer?.invalidate()
            clean()
            //constructionTimer?.invalidate()
            
            //trioTimer.invalidate()
            //invisibleTimer.invalidate()
            //rougeOneTimer.invalidate()
            
            //t1?.invalidate()
            //t2?.invalidate()
            //t3?.invalidate()
            
            //self.view?.gestureRecognizers?.removeAll()
            canMove = false
            
            //_ = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.newScene), userInfo: nil, repeats: false)
            
            let scene = GameScene(size: CGSize(width: 1536, height: 2048))
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            let startGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
            // Present the scene
            view?.presentScene(scene, transition: startGameTransition)
            if #available(iOS 10.0, *) {
                view?.preferredFramesPerSecond = 60
            } else {
                // Fallback on earlier versions
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
        //print("touch buttons CHANGE STATUS")
        let spSound = SKAction.playSoundFileNamed("spActivated1.m4a", waitForCompletion: true)
        let waitSPActivated = SKAction.wait(forDuration: TimeInterval(1))
        let spSoundSequens = SKAction.sequence([spSound, waitSPActivated])
        
        if button.name == "statusNormalButton" && buttonStatus == .none {
            if button.contains(pointTouch) {
                changeShipStatus()
                triggerNormalStatus()
                //print("normal")
            }
        }
           /*
             let trioTimerLabel = SKLabelNode(fontNamed: "Helvetica")
             let invisibleTimerLabel = SKLabelNode(fontNamed: "Helvetica")
             let rougeOneTimerLabel = SKLabelNode(fontNamed: "Helvetica")
          */
            
            
        else if button.name == "statusTrioButton" && buttonStatus == .none && !shipExplode {
            if superButtonStatus == .normal {
                if button.contains(pointTouch) {
                    changeShipStatus()
                    triggerTrioStatus()
                    print("trio")
                    superButtonStatus = .trio
                    rougeOneStatusButton.alpha = 0.3
                    invisibleStatusButton.alpha = 0.3
                    rougeOneTimerLabel.alpha = 0.3
                    invisibleTimerLabel.alpha = 0.3
                    if soundsIsOn {
                        run(SKAction.repeatForever(spSoundSequens), withKey: "spSound")
                        //run(SKAction.playSoundFileNamed("spActivated.m4a", waitForCompletion: false))
                    }
                }
            } else if superButtonStatus == .trio && buttonStatus == .none {
                if button.contains(pointTouch) {
                    changeShipStatus()
                    triggerNormalStatus()
                    print("normal")
                    superButtonStatus = .normal
                    rougeOneStatusButton.alpha = 1
                    invisibleStatusButton.alpha = 1
                    rougeOneTimerLabel.alpha = 1
                    invisibleTimerLabel.alpha = 1
                    self.removeAction(forKey: "spSound")
                }
            }
            
            
            
            
        } else if button.name == "statusRougeOneButton" && buttonStatus == .none && !shipExplode {
            if superButtonStatus == .normal {
                if button.contains(pointTouch) {
                    changeShipStatus()
                    triggerRogueOneStatus()
                    print("rouge")
                    superButtonStatus = .rouge
                    trioStatusButton.alpha = 0.3
                    invisibleStatusButton.alpha = 0.3
                    trioTimerLabel.alpha = 0.3
                    invisibleTimerLabel.alpha = 0.3
                    if soundsIsOn {
                        run(SKAction.repeatForever(spSoundSequens), withKey: "spSound")
                        //run(SKAction.playSoundFileNamed("spActivated.m4a", waitForCompletion: false))
                    }
                }
            } else if superButtonStatus == .rouge && buttonStatus == .none  {
                if button.contains(pointTouch) {
                    if rougeIsActive {
                        /*
                        tempShipRouge = ship
                        ship = rougeOneShipGlobal!
                        tempShipRouge.rougeIsActive = false
                        ship.rougeIsActive = true
                        
                        ship.rougeOneEffect()
                        rougeOneShipGlobal?.stopRougeOneEffect()
                        rougeIsActive = false
                        shipIsActive = true
                        print("ship kjhkj11")
                        
                        playerShip = PlayerShip()
                        //playerShip.name = "testName"
                        rougeOneShip = PlayerShip()
                             */
                        /*
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
                         print("rouge 31")
                         }
                         
                         if !shipIsActive {
                         ship.rougeOneEffect()
                         rougeOneShipGlobal?.stopRougeOneEffect()
                         rougeIsActive = false
                         shipIsActive = true
                         print("ship 11")
                         }
                         print("ship 21")
                        */
                    }
                    
                    changeShipStatus()
                    triggerNormalStatus()
                    print("normal")
                    superButtonStatus = .normal
                    trioStatusButton.alpha = 1
                    invisibleStatusButton.alpha = 1
                    trioTimerLabel.alpha = 1
                    invisibleTimerLabel.alpha = 1
                    self.removeAction(forKey: "spSound")
                }
            }
            
            
        } else if button.name == "statusInvisibleButton" && buttonStatus == .none && !shipExplode  {
            if superButtonStatus == .normal {
                if button.contains(pointTouch) {
                    changeShipStatus()
                    triggerInvisibleStatus()
                    print("invisible")
                    superButtonStatus = .invisible
                    trioStatusButton.alpha = 0.3
                    rougeOneStatusButton.alpha = 0.3
                    trioTimerLabel.alpha = 0.3
                    rougeOneTimerLabel.alpha = 0.3
                    if soundsIsOn {
                        run(SKAction.repeatForever(spSoundSequens), withKey: "spSound")
                        //run(SKAction.playSoundFileNamed("spActivated.m4a", waitForCompletion: false))
                    }
                }
            } else if superButtonStatus == .invisible && buttonStatus == .none  {
                if button.contains(pointTouch) {
                    changeShipStatus()
                    triggerNormalStatus()
                    print("normal")
                    superButtonStatus = .normal
                    trioStatusButton.alpha = 1
                    rougeOneStatusButton.alpha = 1
                    trioTimerLabel.alpha = 1
                    rougeOneTimerLabel.alpha = 1
                    self.removeAction(forKey: "spSound")
                }
            }
        }
    }
    
    // MARK: moving backgroup variables
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 0 //15.0
    var amountToMovePerSecondPNG: CGFloat = 0 //30.0
    var amountToMovePerSecondPNG2: CGFloat = 0 //45.0
    
    override func update(_ currentTime: TimeInterval) {
        
        if !shipExplode && currentGameStatus == .inGame {   // MARK: Smooth start
            if amountToMovePerSecond < /*90*/ 45 {
                amountToMovePerSecond += 1.4
            }
            if amountToMovePerSecondPNG < /*127*/ /*63.5*/ 55 {
                amountToMovePerSecondPNG += 2
            }
            if amountToMovePerSecondPNG2 < /*165*/ /*82.5*/ 72 {
                amountToMovePerSecondPNG2 += 2.6
            }
        } else {  // MARK: Smooth stop
            if amountToMovePerSecond >= 0 {
                amountToMovePerSecond -= 1.4
            }
            if amountToMovePerSecondPNG >= 0 {
                amountToMovePerSecondPNG -= 2
            }
            if amountToMovePerSecondPNG2 >= 0 {
                amountToMovePerSecondPNG2 -= 2.6
            }
        }
        /*
        if constructionTimeInterval == constructionLevelDurationTimerInterval && currentGameStatus == .afterGame {  // MARK: Smooth stop
            if amountToMovePerSecond <= 90 {
                amountToMovePerSecond -= 0.5
            }
            if amountToMovePerSecondPNG <= 127 {
                amountToMovePerSecondPNG -= 1
            }
            if amountToMovePerSecondPNG2 <= 165 {
                amountToMovePerSecondPNG2 -= 1.5
            }
        }
         
         
         e.name == "coinDebris" {
         node.speed -= 0.5
         }
         }
         // stop galaxy
         enumerateChildNodes(withName: "galaxy") { (node, _) in
         if node.name == "galaxy" {
         node.speed -= 0.5
         }
         }
         // stop station
         enumerateChildNodes(withName: "station") { (node, _) in
         if node.name == "station" {
         node.speed -= 0.5
         }
         }
         // stop construction
         enumerateChildNodes(withName: "constructionDebris") { (node, _) in
         if node.name == "constructionDebris"
         
         
         
 */
        
        
        // MARK: ++++++++++++++++++ moving backgroup
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
       
        
        /*self.*/ gameLayer.enumerateChildNodes(withName: "BackgroudStars") { [weak self] (background, stop) in
            
            if self!.canMove {
                background.position.y -= amountToMoveBackground
                
                if background.position.y < -self!.size.height {
                    background.position.y += self!.size.height * 2
                }
            } else if !self!.canMove && shipExplode {  // MARK: Smooth stop
                background.position.y -= amountToMoveBackground
                
                if background.position.y < -self!.size.height {
                    background.position.y += self!.size.height * 2
                }
            } else {
                // do nothing
            }
        }
        // ------------------------- moving backgroup
        
        // MARK: ++++++++++++++++++ moving backgroup PNG
        
        let amountToMoveBackgroundPNG = amountToMovePerSecondPNG * CGFloat(deltaFrameTime)
        
        
        /*self.*/ gameLayer.enumerateChildNodes(withName: "BackgroundPngStars") { [weak self] (background, stop) in
            
            if self!.canMove {
                background.position.y -= amountToMoveBackgroundPNG
                
                if background.position.y < -self!.size.height {
                    background.position.y += self!.size.height * 2
                }
            } else if !self!.canMove && shipExplode {   // MARK: Smooth stop
                background.position.y -= amountToMoveBackground
                
                if background.position.y < -self!.size.height {
                    background.position.y += self!.size.height * 2
                }
            }
        }
        // ------------------------- moving backgroup PNG
        
        // MARK: ++++++++++++++++++ moving backgroup2 PNG

        let amountToMoveBackgroundPNG2 = amountToMovePerSecondPNG2 * CGFloat(deltaFrameTime)


        /*self.*/ gameLayer.enumerateChildNodes(withName: "BackgroundPngStars2") { [weak self] (background, stop) in

            if self!.canMove {
                background.position.y -= amountToMoveBackgroundPNG2

                if background.position.y < -self!.size.height {
                    background.position.y += self!.size.height * 2
                }
            } else if !self!.canMove && shipExplode {    // MARK: Smooth stop
                background.position.y -= amountToMoveBackground
                
                if background.position.y < -self!.size.height {
                    background.position.y += self!.size.height * 2
                }
            }
        }
        // ------------------------- moving backgroup2 PNG

    }
    
    func saveTimeActiveSeconds() {
        let defaults = UserDefaults()
        
        defaults.set(InvisibleTimeActive, forKey: "InvisibleSeconds")
        defaults.set(rougeOneTimeActive, forKey: "RougeSeconds")
        defaults.set(trioTimeActive, forKey: "TrioSeconds")
    }
    
    func loadTimeActiveSeconds() {
        let defaults = UserDefaults()
        
        trioTimeActive = defaults.double(forKey: "TrioSeconds")
        
        rougeOneTimeActive = defaults.double(forKey: "RougeSeconds")
        
        InvisibleTimeActive = defaults.double(forKey: "InvisibleSeconds")
        
    }
    
    func explosion(pos: CGPoint, zPos: CGFloat) {
        if let explosion = SKEmitterNode(fileNamed: "explosion.sks") {
            if soundsIsOn {
                run(SKAction.playSoundFileNamed("boom1.m4a", waitForCompletion: false))
                //engineSoundsAction.speed = 0.0
                removeAction(forKey: "shipEngineSound")
            }
            explosion.particlePosition = pos
            explosion.zPosition = zPos
            //scene?.addChild(explosion)
            self.gameLayer.addChild(explosion)
            scene?.run(SKAction.wait(forDuration: TimeInterval(2)), completion: { explosion.removeFromParent() } )
            shipExplode = true
            puzzleCurrentGameStatus = false
            
            //changeShipStatus()
            invalidateSPTimer()
            triggerNormalStatus()
            //print("EXPLOSION")
            
        }
        
    }
    
    func mineDetonation(pos: CGPoint, zPos: CGFloat) {
        if let explosion = SKEmitterNode(fileNamed: "explosion.sks") {
            if soundsIsOn {
                run(SKAction.playSoundFileNamed("boom1.m4a", waitForCompletion: false))
                //engineSoundsAction.speed = 0.0
                removeAction(forKey: "shipEngineSound")
            }
            explosion.particlePosition = pos
            explosion.zPosition = zPos
            self.gameLayer.addChild(explosion)
            scene?.run(SKAction.wait(forDuration: TimeInterval(2)), completion: { explosion.removeFromParent() } )
            
        }
        
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    deinit {
        print("scene deinit")
        //levelWithChargedMine = false
        //self.view?.gestureRecognizers?.removeAll()
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

extension MutableCollection {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices , stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}



























