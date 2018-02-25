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
import GoogleMobileAds
import NVActivityIndicatorView
import StoreKit

class GameOverScene: SKScene, GADInterstitialDelegate {
    
    private var newActivityIndicator: NVActivityIndicatorView?
    
    private var ref: DatabaseReference?
    
    private let highScore = SKSpriteNode(imageNamed: "alien3")
    
    private let overallHighScoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let lvlHighScoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let survivalScoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let levelNumberLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    private let planetNumberLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
    
    private var starsTimer: Timer?
    
    let levelScene = LevelsScene()
    
    //var userName = "SuperUser"
    
    //var highscoreTableView = HighscoreTableView(coder: NSCoder)
    
    //weak var mainScene: SKScene?
    
    private var interstitial: GADInterstitial! = ads
    
    override func didMove(to view: SKView) {
        let defaults = UserDefaults()
        interstitial.delegate = self
        //loadMainScene()
        if !programmIsPaid {
            if adsAttemtps <= 0 {
                adsAttemtps = 4
                defaults.set(adsAttemtps, forKey: "adsAttempts")
                runAds()
            } else {
                adsAttemtps -= 1
                defaults.set(adsAttemtps, forKey: "adsAttempts")
                loadMainScene()
            }
            
            //runAds()
        } else {
            loadMainScene()
        }
        
    }
    
    override func willMove(from view: SKView) {
        //  highscoreTableView.removeFromSuperview()
    }
    
    private func loadMainScene() {
        
        ref = Database.database().reference()
        
        auth()
        
        
        backgroundSetup()
        
        scoreButtonSetup()
        levelsButtonSetup()
        goToMenuButtonSetup()
        shareButtonSetup()
        
        if shipExplode {
            
            if gameMode == .normal {
                youLoseSetup()
                setHithScoreLabel()
                setOverallHithScoreLabel()
                addLevelAndPlanetNumberLabel()
            } else if gameMode == .survival {
                setOverallHithScoreLabel()
                setSurvivalScoreLabel()
                setScoreLabel()
                saveUserDefaults()
                
            }
            
            if soundsIsOn {
                run(SKAction.playSoundFileNamed("youLoseSound.m4a", waitForCompletion: false))
            }
            
        } else {
            if gameMode == .normal {
                setScoreLabel()
                setHithScoreLabel()
                setOverallHithScoreLabel()
                //sethighScoreMenu()
                addLevelAndPlanetNumberLabel()
                highScore.alpha = 0.0
                
                saveUserDefaults()
                
                starsTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameOverScene.addStar), userInfo: nil, repeats: false)
                auth()
                
                if soundsIsOn {
                    run(SKAction.playSoundFileNamed("vicrotySound.m4a", waitForCompletion: false))
                }
                unlockNextLevel()
            } else if gameMode == .survival {
                setOverallHithScoreLabel()
                setSurvivalScoreLabel()
                setScoreLabel()
                saveUserDefaults()
            }
            
            
        }
        
        
        startButtonSetup()
        nextLevelButtonSetup()
        saveTimeActiveSeconds()
        
        
        addPlanetFunc()
        
        popupReviewInvite()
    }
    
    private func popupReviewInvite() {
        let defaults = UserDefaults()
        if inviteToReview {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                //do nothing
            }
            inviteToReview = false
            defaults.set(inviteToReview, forKey: "reviewInvintation")
        }
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
        //myActivityIndicator.hidesWhenStopped = true
        //scene!.view?.addSubview(newActivityIndicator!)
        
        
        DispatchQueue.main.async { [weak self] in
            self?.scene!.view?.addSubview(self!.newActivityIndicator!)
        }
        
        newActivityIndicator?.startAnimating()
    }
    
    private func stopNewAcitvityIndicator() {
        newActivityIndicator?.stopAnimating()
        newActivityIndicator?.removeFromSuperview()
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        //print("interstitialWillDismissScreen")
        loadMainScene()
        //loadMainScene()
    }
    
    private func runAds() {
        
        if interstitial.isReady {
            /*
            let defaults = UserDefaults()
            InvisibleTimeActive += 3
            rougeOneTimeActive += 3
            trioTimeActive += 3
            defaults.set(InvisibleTimeActive, forKey: "InvisibleSeconds")
            defaults.set(rougeOneTimeActive, forKey: "RougeSeconds")
            defaults.set(trioTimeActive, forKey: "TrioSeconds")
            */
            interstitial.present(fromRootViewController: (self.view?.window?.rootViewController)!)
        } else {
            //print("Ad wasn't ready")
            loadMainScene()
        }
    }
    
    // MARK: START BUTTON
    private func addPlanetFunc() {
        let mainPlanet = SKSpriteNode(imageNamed: "venus_500")
        mainPlanet.position = CGPoint(x: self.size.width * (0.22), y: self.size.height * (0.05))
        if planet == 1 {
            mainPlanet.texture = SKTexture(imageNamed: "planet01_400")
            mainPlanet.zRotation = 0.6
        } else if planet == 2 {
            mainPlanet.texture = SKTexture(imageNamed: "venus_500")
            mainPlanet.position = CGPoint(x: self.size.width * (0.22), y: self.size.height * (0.01))
        } else if planet == 3 {
            mainPlanet.texture = SKTexture(imageNamed: "planet_31")
            mainPlanet.zRotation = 1.0
        }
        mainPlanet.name = "Main Planet"
        mainPlanet.xScale = 2.6
        mainPlanet.yScale = 2.6
        
        //startButton.size = self.size
        mainPlanet.position = CGPoint(x: self.size.width * (0.22), y: self.size.height * (0.05))
        mainPlanet.zPosition = -100
        self.addChild(mainPlanet)
    }
    
    // MARK: Level and planet number
    private func addLevelAndPlanetNumberLabel() {
        levelNumberLabel.position = CGPoint(x: self.size.width * 0.68, y: self.size.height * 0.77)
        levelNumberLabel.zPosition = -99
        levelNumberLabel.fontSize = 60
        
        
        planetNumberLabel.position = CGPoint(x: self.size.width * 0.32, y: self.size.height * 0.77)
        planetNumberLabel.zPosition = -99
        planetNumberLabel.fontSize = 60
        
        
        if shipExplode {
            planetNumberLabel.fontColor = UIColor(red: 166.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0) //UIColor.white //UIColor.white
            levelNumberLabel.fontColor = UIColor(red: 166.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1.0) //UIColor.white //UIColor.white
        } else {
            planetNumberLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
            levelNumberLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
        }
        
        if preferredLanguage == .ru {
            levelNumberLabel.text = "Уровень \(level + 1)"
            planetNumberLabel.text = "Планета \(planet)"
        } else if preferredLanguage == .ch {
            levelNumberLabel.text = "水平 \(level + 1)"
            planetNumberLabel.text = "行星 \(planet)"
        } else if preferredLanguage == .es {
            levelNumberLabel.text = "Nivel \(level + 1)"
            planetNumberLabel.text = "Planeta \(planet)"
        } else if preferredLanguage == .jp {
            levelNumberLabel.text = "レベル \(level + 1)"
            planetNumberLabel.text = "惑星 \(planet)"
        } else if preferredLanguage == .fr {
            levelNumberLabel.text = "Niveau \(level + 1)"
            planetNumberLabel.text = "Planète \(planet)"
        } else if preferredLanguage == .gr {
            levelNumberLabel.text = "Niveau \(level + 1)"
            planetNumberLabel.text = "Planet \(planet)"
        } else if preferredLanguage == .en {
            levelNumberLabel.text = "Level \(level + 1)"
            planetNumberLabel.text = "Planet \(planet)"
        }
        
        
        //youLose.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.91)
        
        self.addChild(levelNumberLabel)
        self.addChild(planetNumberLabel)
    }
    
    // Auth
    private func auth() {
        Auth.auth().signIn(withEmail: "withstandtospace@test.com", password: "123ASDasd") { [weak self] (user, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                //let defaults = UserDefaults()
                if let weakSelf = self {
                    if weakSelf.isKeyPresentInUserDefaults(key: "userId") {
                        //let userId = defaults.string(forKey: "userId")
                        //print(userId)
                        //print(highScoreNumber)
                        //print(nickName)
                        
                        if gameMode == .normal {
                            weakSelf.ref?.child("user").child(userId).child("highscore"/*self.userName*/).setValue(highScoreNumber)
                            weakSelf.ref?.child("user").child(userId).child("nickname"/*self.userName*/).setValue(nickName)
                        } else if gameMode == .survival {
                            weakSelf.ref?.child("user").child(userId).child("highscoreSurvival"/*self.userName*/).setValue(highScoreNumberSurvival)
                        }
                        
                        
                        //self.ref?.child("user").child(userId).child("A\(level+1)"/*self.userName*/).setValue(currentLevelHighScore)
                        
                        //self.saveUserDefaults()
                        self?.highScore.alpha = 1.0
                    }
                }
                if shipExplode {
                    if gameMode == .survival {
                        self?.ref?.child("user").child(userId).child("highscoreSurvival"/*self.userName*/).setValue(highScoreNumberSurvival)
                        self?.saveUserDefaults()
                    }
                } else {
                    if gameMode == .normal {
                        self?.ref?.child("user").child(userId).child("highscore"/*self.userName*/).setValue(highScoreNumber)
                        self?.saveUserDefaults()
                    }
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
    private func backgroundSetup() {
        
        let background = SKSpriteNode(imageNamed: "backgroundStars02" /*"menuBackground2"*/ /*"menuBackground"*/)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    // MARK: START BUTTON
    private func startButtonSetup() {
        
        let defaults = UserDefaults()
        if planet == 1 {
            currentLevelHighScore = defaults.integer(forKey: "A\(level+1)")
        } else if planet == 2 {
            currentLevelHighScore = defaults.integer(forKey: "B\(level+1)")
        } else if planet == 3 {
            currentLevelHighScore = defaults.integer(forKey: "C\(level+1)")
        }
        if currentLevelHighScore > scoreOneStar {
            
            var startButton = SKSpriteNode()
            if preferredLanguage == .ru {
                if level < 11 {
                    startButton = SKSpriteNode(imageNamed: "replayGameOverButtonRU1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.60)
                } else {
                    startButton = SKSpriteNode(imageNamed: "restartButtonRU1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.60)
                }
            } else if preferredLanguage == .ch {
                if level < 11 {
                    startButton = SKSpriteNode(imageNamed: "replayGameOverButtonCH1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.60)
                } else {
                    startButton = SKSpriteNode(imageNamed: "restartButtonCH1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.60)
                }
            } else if preferredLanguage == .es {
                if level < 11 {
                    startButton = SKSpriteNode(imageNamed: "replayGameOverButtonSP1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.60)
                } else {
                    startButton = SKSpriteNode(imageNamed: "restartButtonSP1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.60)
                }
            } else if preferredLanguage == .jp {
                if level < 11 {
                    startButton = SKSpriteNode(imageNamed: "replayGameOverButtonJP1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.60)
                } else {
                    startButton = SKSpriteNode(imageNamed: "restartButtonJP1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.60)
                }
            } else if preferredLanguage == .fr {
                if level < 11 {
                    startButton = SKSpriteNode(imageNamed: "replayGameOverButtonFR1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.60)
                } else {
                    startButton = SKSpriteNode(imageNamed: "restartButtonFR1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.60)
                }
            } else if preferredLanguage == .gr {
                if level < 11 {
                    startButton = SKSpriteNode(imageNamed: "replayGameOverButtonDE1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.60)
                } else {
                    startButton = SKSpriteNode(imageNamed: "restartButtonDE1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.60)
                }
            } else {
                if level < 11 {
                    startButton = SKSpriteNode(imageNamed: "replayGameOverButton1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.60)
                } else {
                    startButton = SKSpriteNode(imageNamed: "restartButton1" /*"gameOverButton"*/)
                    startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.60)
                }
            }
            //let startButton = SKSpriteNode(imageNamed: "playAgainButton" /*"gameOverButton"*/)
            startButton.name = "Play Again"
            //startButton.size = self.size
//            if level < 11 {
//                startButton.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.65)
//            } else if level == 11 {
//                startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.65)
//            }
            startButton.zPosition = -99
            self.addChild(startButton)
        } else {
            var startButton = SKSpriteNode()
            if preferredLanguage == .ru {
                startButton = SKSpriteNode(imageNamed: "restartButtonRU1" /*"gameOverButton"*/)
            } else if preferredLanguage == .ch {
                startButton = SKSpriteNode(imageNamed: "restartButtonCH1" /*"gameOverButton"*/)
            } else if preferredLanguage == .es {
                startButton = SKSpriteNode(imageNamed: "restartButtonSP1" /*"gameOverButton"*/)
            } else if preferredLanguage == .jp {
                startButton = SKSpriteNode(imageNamed: "restartButtonJP1" /*"gameOverButton"*/)
            } else if preferredLanguage == .fr {
                startButton = SKSpriteNode(imageNamed: "restartButtonFR1" /*"gameOverButton"*/)
            } else if preferredLanguage == .gr {
                startButton = SKSpriteNode(imageNamed: "restartButtonDE1" /*"gameOverButton"*/)
            } else {
                startButton = SKSpriteNode(imageNamed: "restartButton1" /*"gameOverButton"*/)
            }
            //let startButton = SKSpriteNode(imageNamed: "playAgainButton" /*"gameOverButton"*/)
            startButton.name = "Play Again"
            //startButton.size = self.size
            startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.60)
            startButton.zPosition = -99
            self.addChild(startButton)
        }
    }
    
    // MARK: NEXT LEVEL BUTTON
    private func nextLevelButtonSetup() {
        
        let defaults = UserDefaults()
        if planet == 1 {
            currentLevelHighScore = defaults.integer(forKey: "A\(level+1)")
        } else if planet == 2 {
            currentLevelHighScore = defaults.integer(forKey: "B\(level+1)")
        } else if planet == 3 {
            currentLevelHighScore = defaults.integer(forKey: "C\(level+1)")
        }
        if currentLevelHighScore > scoreOneStar {
            
            var nextLevelButton = SKSpriteNode()
            if preferredLanguage == .ru {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButtonRU1" /*"gameOverButton"*/)
                
                
            } else if preferredLanguage == .ch {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButtonCH1" /*"gameOverButton"*/)
                
            } else if preferredLanguage == .es {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButtonSP1" /*"gameOverButton"*/)
                
            } else if preferredLanguage == .jp {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButtonJP1" /*"gameOverButton"*/)
                
            } else if preferredLanguage == .fr {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButtonFR1" /*"gameOverButton"*/)
                
            } else if preferredLanguage == .gr {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButtonDE1" /*"gameOverButton"*/)
                
            } else {
                nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButton1" /*"gameOverButton"*/)
                
            }
            
            
            let levelLock = SKSpriteNode(imageNamed: "levelLock")
            levelLock.yScale = 0.7
            levelLock.xScale = 0.7
            levelLock.position = CGPoint(x: nextLevelButton.size.width - (nextLevelButton.size.width), y: nextLevelButton.size.height - (nextLevelButton.size.height))
            
            if level < 11 {
                if planet == 1 && paidLevel[level + 1] == 1 {
                    
                } else if planet == 1 && paidLevel[level + 1] == 0 {
                    nextLevelButton.addChild(levelLock)
                } else if planet == 2 && paid2Level[level + 1] == 1 {
                    
                } else if planet == 2 && paid2Level[level + 1] == 0 {
                    nextLevelButton.addChild(levelLock)
                } else if planet == 3 && paid3Level[level + 1] == 1 {
                    
                } else if planet == 3 && paid3Level[level + 1] == 0 {
                    nextLevelButton.addChild(levelLock)
                }
            } else if level == 11 {
                
            }
            
            
            //let startButton = SKSpriteNode(imageNamed: "playAgainButton" /*"gameOverButton"*/)
            nextLevelButton.name = "Next level"
            //startButton.size = self.size
            nextLevelButton.position = CGPoint(x: self.size.width * 0.65, y: self.size.height * 0.60)
            nextLevelButton.zPosition = -99
            if level < 11 {
                self.addChild(nextLevelButton)
            }
        }
    }
    
    // MARK: SCORE BUTTON
    private func scoreButtonSetup() {
        var startButton = SKSpriteNode()
        if preferredLanguage == .ru {
            startButton = SKSpriteNode(imageNamed: "topScoreIcon" /*"gameOverButton"*/)
        } else if preferredLanguage == .ch {
            startButton = SKSpriteNode(imageNamed: "topScoreIcon" /*"gameOverButton"*/)
        } else {
            startButton = SKSpriteNode(imageNamed: "topScoreIcon" /*"gameOverButton"*/)
        }
        //let startButton = SKSpriteNode(imageNamed: "highScore" /*"gameOverButton"*/)
        startButton.name = "High Score"
        //startButton.size = self.size
        startButton.xScale = 0.7
        startButton.yScale = 0.7
        startButton.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.05)
        startButton.zPosition = -99
        self.addChild(startButton)
    }
 
    
    // MARK: SCORE BUTTON
    private func levelsButtonSetup() {
        var startButton = SKSpriteNode()
        if preferredLanguage == .ru {
            startButton = SKSpriteNode(imageNamed: "levelsMenuButtonRU1" /*"gameOverButton"*/)
        } else if preferredLanguage == .ch {
            startButton = SKSpriteNode(imageNamed: "levelsMenuButtonCH1" /*"gameOverButton"*/)
        } else if preferredLanguage == .es {
            startButton = SKSpriteNode(imageNamed: "levelsMenuButtonSP1" /*"gameOverButton"*/)
        } else if preferredLanguage == .jp {
            startButton = SKSpriteNode(imageNamed: "levelsMenuButtonJP1" /*"gameOverButton"*/)
        } else if preferredLanguage == .fr {
            startButton = SKSpriteNode(imageNamed: "levelsMenuButtonFR1" /*"gameOverButton"*/)
        } else if preferredLanguage == .gr {
            startButton = SKSpriteNode(imageNamed: "levelsMenuButtonDE1" /*"gameOverButton"*/)
        } else {
            startButton = SKSpriteNode(imageNamed: "levelsMenuButton1" /*"gameOverButton"*/)
        }
        //let startButton = SKSpriteNode(imageNamed: "highScore" /*"gameOverButton"*/)
        startButton.name = "Levels Button"
        //startButton.size = self.size
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.45)
        startButton.zPosition = -99
        self.addChild(startButton)
    }
    
    // MARK: GO To menu Button
    private func goToMenuButtonSetup() {
        var startButton = SKSpriteNode()
        if preferredLanguage == .ru {
            startButton = SKSpriteNode(imageNamed: "goToMenuButtonRU1" /*"gameOverButton"*/)
        } else if preferredLanguage == .ch {
            startButton = SKSpriteNode(imageNamed: "goToMenuButtonCH1" /*"gameOverButton"*/)
        } else if preferredLanguage == .es {
            startButton = SKSpriteNode(imageNamed: "goToMenuButtonSP1" /*"gameOverButton"*/)
        } else if preferredLanguage == .jp {
            startButton = SKSpriteNode(imageNamed: "goToMenuButtonJP1" /*"gameOverButton"*/)
        } else if preferredLanguage == .fr {
            startButton = SKSpriteNode(imageNamed: "goToMenuButtonFR1" /*"gameOverButton"*/)
        } else if preferredLanguage == .gr {
            startButton = SKSpriteNode(imageNamed: "goToMenuButtonDE1" /*"gameOverButton"*/)
        } else {
            startButton = SKSpriteNode(imageNamed: "goToMenuButton1" /*"gameOverButton"*/)
        }
        //let startButton = SKSpriteNode(imageNamed: "goToMenuButton" /*"gameOverButton"*/)
        startButton.name = "Go To Menu"
        //startButton.size = self.size
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.30)
        startButton.zPosition = -99
        self.addChild(startButton)
    }
    
    // MARK: Share Button
    private func shareButtonSetup() {
        var shareButton = SKSpriteNode()
        if preferredLanguage == .ru {
            shareButton = SKSpriteNode(imageNamed: "shareButtonRU1" /*"gameOverButton"*/)
        } else if preferredLanguage == .ch {
            shareButton = SKSpriteNode(imageNamed: "shareButtonCH1" /*"gameOverButton"*/)
        } else if preferredLanguage == .es {
            shareButton = SKSpriteNode(imageNamed: "shareButtonSP1" /*"gameOverButton"*/)
        } else if preferredLanguage == .jp {
            shareButton = SKSpriteNode(imageNamed: "shareButtonJP1" /*"gameOverButton"*/)
        } else if preferredLanguage == .fr {
            shareButton = SKSpriteNode(imageNamed: "shareButtonFR1" /*"gameOverButton"*/)
        } else if preferredLanguage == .gr {
            shareButton = SKSpriteNode(imageNamed: "shareButtonDE1" /*"gameOverButton"*/)
        } else {
            shareButton = SKSpriteNode(imageNamed: "shareButton1" /*"gameOverButton"*/)
        }
        shareButton.name = "Share Button"
        //startButton.size = self.size
        shareButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.15)
        shareButton.zPosition = -99
        self.addChild(shareButton)
    }
    
    // MARK: You lose sign setup
    private func youLoseSetup() {
        var youLose = SKSpriteNode()
        if preferredLanguage == .ru {
            youLose = SKSpriteNode(imageNamed: "youLoseRU1" /*"gameOverButton"*/)
        } else if preferredLanguage == .ch {
            youLose = SKSpriteNode(imageNamed: "youLoseCH1" /*"gameOverButton"*/)
        } else if preferredLanguage == .es {
            youLose = SKSpriteNode(imageNamed: "youLoseSP1" /*"gameOverButton"*/)
        } else if preferredLanguage == .jp {
            youLose = SKSpriteNode(imageNamed: "youLoseJP1" /*"gameOverButton"*/)
        } else if preferredLanguage == .fr {
            youLose = SKSpriteNode(imageNamed: "youLoseFR1" /*"gameOverButton"*/)
        } else if preferredLanguage == .gr {
            youLose = SKSpriteNode(imageNamed: "youLoseDE1" /*"gameOverButton"*/)
        } else {
            youLose = SKSpriteNode(imageNamed: "youLose1" /*"gameOverButton"*/)
        }
        //let youLose = SKSpriteNode(imageNamed: "youLose" /*"gameOverButton"*/)
        youLose.name = "You lose"
        //startButton.size = self.size
        youLose.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.88)
        youLose.zPosition = -99
        //youLose.xScale += 0.4
        //youLose.yScale += 0.4
        self.addChild(youLose)
    }
    
    // MARK: Score label
    private func setScoreLabel() {
        let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        scoreLabel.fontSize = 140
        if preferredLanguage == .ru {
            scoreLabel.text = "Счет: \(score)"
        } else if preferredLanguage == .ch {
            scoreLabel.text = "积分 / 得分: \(score)"
        } else if preferredLanguage == .es {
            scoreLabel.fontSize = 75
            scoreLabel.text = "Puntuaciones: \(score)"
        } else if preferredLanguage == .jp {
            scoreLabel.fontSize = 85
            scoreLabel.text = "スコア: \(score)"
        } else if preferredLanguage == .fr {
            scoreLabel.fontSize = 75
            scoreLabel.text = "Score: \(score)"
        } else if preferredLanguage == .gr {
            scoreLabel.fontSize = 75
            scoreLabel.text = "Punktestand: \(score)"
        } else {
            scoreLabel.text = "Score: \(score)"
        }
        
        if gameMode == .normal {
            if score < scoreOneStar {
                scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.85)
            } else {
                scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.91)
            }
        } else if gameMode == .survival {
            scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.85)
        }
        
        scoreLabel.fontColor = UIColor.red
        
        scoreLabel.zPosition = -99
        self.addChild(scoreLabel)
    }
    
    // MARK: Level Highscore label
    private func setHithScoreLabel() {
        
        let defaults = UserDefaults()
        if planet == 1 {
            currentLevelHighScore = defaults.integer(forKey: "A\(level+1)")
        } else if planet == 2 {
            currentLevelHighScore = defaults.integer(forKey: "B\(level+1)")
        } else if planet == 3 {
            currentLevelHighScore = defaults.integer(forKey: "C\(level+1)")
        }
        
        if preferredLanguage == .ru {
            lvlHighScoreLabel.text = "Лучший счет уровня: \(currentLevelHighScore)"
            lvlHighScoreLabel.fontSize = 40
        } else if preferredLanguage == .ch {
            lvlHighScoreLabel.text = "水平高的分數: \(currentLevelHighScore)"
            lvlHighScoreLabel.fontSize = 60
        } else if preferredLanguage == .es {
            lvlHighScoreLabel.text = "Nivel alto puntaje: \(currentLevelHighScore)"
            lvlHighScoreLabel.fontSize = 40
        } else if preferredLanguage == .jp {
            lvlHighScoreLabel.text = "レベルベストスコア: \(currentLevelHighScore)"
            lvlHighScoreLabel.fontSize = 60
        } else if preferredLanguage == .fr {
            lvlHighScoreLabel.text = "Meilleur score de niveau: \(currentLevelHighScore)"
            lvlHighScoreLabel.fontSize = 40
        } else if preferredLanguage == .gr {
            lvlHighScoreLabel.text = "Level beste Punktzahl: \(currentLevelHighScore)"
            lvlHighScoreLabel.fontSize = 40
        } else {
            lvlHighScoreLabel.text = "Level high score: \(currentLevelHighScore)"
            lvlHighScoreLabel.fontSize = 40
        }
        
        //lvlHighScoreLabel.fontSize = 40 //120
        lvlHighScoreLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white //UIColor.white
        lvlHighScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.73)
        lvlHighScoreLabel.zPosition = -99
        self.addChild(lvlHighScoreLabel)
    }
    
    // MARK: Overall Highscore label
    private func setOverallHithScoreLabel() {
        if shipExplode {
            if gameMode == .normal {
                if preferredLanguage == .ru {
                    overallHighScoreLabel.text = "Суммарный счет уровней: \(highScoreNumber)"
                    overallHighScoreLabel.fontSize = 40
                } else if preferredLanguage == .ch {
                    overallHighScoreLabel.text = "總結水平高分: \(highScoreNumber)"
                    overallHighScoreLabel.fontSize = 60
                } else if preferredLanguage == .es {
                    overallHighScoreLabel.text = "Resumen puntaje alto: \(highScoreNumber)"
                    overallHighScoreLabel.fontSize = 40
                } else if preferredLanguage == .jp {
                    overallHighScoreLabel.text = "要約レベルのスコア: \(highScoreNumber)"
                    overallHighScoreLabel.fontSize = 60
                } else if preferredLanguage == .fr {
                    overallHighScoreLabel.text = "Score des niveaux sommaires: \(highScoreNumber)"
                    overallHighScoreLabel.fontSize = 40
                } else if preferredLanguage == .gr {
                    overallHighScoreLabel.text = "Zusammenfassung: \(highScoreNumber)"
                    overallHighScoreLabel.fontSize = 40
                } else {
                    overallHighScoreLabel.text = "Summary levels high score: \(highScoreNumber)"
                    overallHighScoreLabel.fontSize = 40
                }
            }
            
        }
        //overallHighScoreLabel.fontSize = 40 //120
        overallHighScoreLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
        overallHighScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.69)
        overallHighScoreLabel.zPosition = -99
        self.addChild(overallHighScoreLabel)
    }
    
    // MARK: Survival score label
    private func setSurvivalScoreLabel() {
        
        if preferredLanguage == .ru {
            survivalScoreLabel.text = "Лучший ре3ультат: \(highScoreNumberSurvival)"
            survivalScoreLabel.fontSize = 40
        } else if preferredLanguage == .ch {
            survivalScoreLabel.text = "最高纪录: \(highScoreNumberSurvival)"
            survivalScoreLabel.fontSize = 60
        } else if preferredLanguage == .es {
            survivalScoreLabel.text = "Mejores resultados: \(highScoreNumberSurvival)"
            survivalScoreLabel.fontSize = 40
        } else if preferredLanguage == .jp {
            survivalScoreLabel.text = "最高の結果: \(highScoreNumberSurvival)"
            survivalScoreLabel.fontSize = 60
        } else if preferredLanguage == .fr {
            survivalScoreLabel.text = "Meilleurs résultats: \(highScoreNumberSurvival)"
            survivalScoreLabel.fontSize = 40
        } else if preferredLanguage == .gr {
            survivalScoreLabel.text = "Beste Ergebnisse: \(highScoreNumberSurvival)"
            survivalScoreLabel.fontSize = 40
        } else {
            survivalScoreLabel.text = "Best results: \(highScoreNumberSurvival)"
            survivalScoreLabel.fontSize = 40
        }
        
        
        //overallHighScoreLabel.fontSize = 40 //120
        survivalScoreLabel.fontColor = UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0) //UIColor.white
        survivalScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.76)
        survivalScoreLabel.zPosition = -99
        self.addChild(survivalScoreLabel)
    }
    
    // MARK: HighScore menu button
    private func sethighScoreMenu() {
        
        
        highScore.name = "highScoreNodeMenu"
        //startButton.size = self.size
        highScore.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.85)
        highScore.zPosition = -99
        highScore.alpha = 0.0
        self.addChild(highScore)
    }
    
    private func saveTimeActiveSeconds() {
        let defaults = UserDefaults()
        
        defaults.set(InvisibleTimeActive, forKey: "InvisibleSeconds")
        defaults.set(rougeOneTimeActive, forKey: "RougeSeconds")
        defaults.set(trioTimeActive, forKey: "TrioSeconds")
    }
    
    private func unlockNextLevel() {
        if planet == 1 {
            if score >= scoreOneStar {
                let defaults = UserDefaults()
                if level <= 10 {
                    defaults.set(1, forKey: "level\(level+2)IsAcitve")
                    activeLevel[level+1] = 1
                } else if level == 11 {
                    active2Level[0] = 1
                    defaults.set(1, forKey: "2level1IsAcitve")
                }
            }
        }
        if planet == 2 {
            if score >= scoreOneStar {
                let defaults = UserDefaults()
                defaults.set(1, forKey: "2level\(level+2)IsAcitve")
                if level <= 10 {
                    active2Level[level+1] = 1
                } else if level == 11 {
                    active3Level[0] = 1
                    defaults.set(1, forKey: "3level1IsAcitve")
                }
            }
        }
        if planet == 3 {
            if score >= scoreOneStar {
                let defaults = UserDefaults()
                defaults.set(1, forKey: "3level\(level+2)IsAcitve")
                if level <= 10 {
                    active3Level[level+1] = 1
                }
            }
        }
    }
    
    @objc private func addStar() {
        
        var stars = SKSpriteNode()
        if score < scoreOneStar {
            //print("zore")
        } else if score >= scoreOneStar && score < scoreTwoStar {
           stars = SKSpriteNode(imageNamed: "gameOverOneStar"/*"gameOverButton"*/)
            //print("one")
        } else if score >= scoreTwoStar && score < scoreThreeStars {
            stars = SKSpriteNode(imageNamed: "gameOverTwoStars" /*"gameOverButton"*/)
            //print("two")
        } else if score >= scoreThreeStars {
            stars = SKSpriteNode(imageNamed: "gameOverThreeStars" /*"gameOverButton"*/)
            //print("three")
        } else {
            // do nothing
        }
        
        
        //let oneStar = SKSpriteNode(imageNamed: "gameOverOneStar" /*"gameOverButton"*/)
        stars.name = "Game Over One Star"
        //startButton.size = self.size
        stars.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.86)
        stars.zPosition = -99
        //stars.scale(to: CGSize.zero)
        stars.xScale = 0.0
        stars.yScale = 0.0
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
    
    private func saveUserDefaults() {
        let defaults = UserDefaults()
        highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        highScoreNumberSurvival = defaults.integer(forKey: "highScoreSavedSurvival")
        var tempHighScore = 0
        
        if planet == 1 {
            
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
            //print("\(defaults.integer(forKey: "A\(level+1)")) + yyyy")
            //print("A\(level+1)")
            
            tempHighScore = 0
            for i in 1...lvlScore.count {
                tempHighScore += lvlScore[i-1]
            }
            for i in 1...lvl2Score.count {
                tempHighScore += lvl2Score[i-1]
            }
            for i in 1...lvl3Score.count {
                tempHighScore += lvl3Score[i-1]
            }
            
        } else if planet == 2 {
            
            if score > lvl2Score[level] {
                lvl2Score[level] = score
                defaults.set(score, forKey: "B\(level+1)")
            }
            
            
            currentLevelHighScore = defaults.integer(forKey: "B\(level+1)")
            if score > currentLevelHighScore {
                lvl2Score[level] = score
                defaults.set(score, forKey: "B\(level+1)")
                currentLevelHighScore = score
            }
            //print("\(defaults.integer(forKey: "B\(level+1)")) + yyyy")
            //print("B\(level+1)")
            
            tempHighScore = 0
            for i in 1...lvlScore.count {
                tempHighScore += lvlScore[i-1]
            }
            for i in 1...lvl2Score.count {
                tempHighScore += lvl2Score[i-1]
            }
            for i in 1...lvl3Score.count {
                tempHighScore += lvl3Score[i-1]
            }
            
        } else if planet == 3 {
            
            if score > lvl3Score[level] {
                lvl3Score[level] = score
                defaults.set(score, forKey: "C\(level+1)")
            }
            
            
            currentLevelHighScore = defaults.integer(forKey: "C\(level+1)")
            if score > currentLevelHighScore {
                lvl3Score[level] = score
                defaults.set(score, forKey: "C\(level+1)")
                currentLevelHighScore = score
            }
            //print("\(defaults.integer(forKey: "C\(level+1)")) + yyyy")
            //print("C\(level+1)")
            
            tempHighScore = 0
            for i in 1...lvlScore.count {
                tempHighScore += lvlScore[i-1]
            }
            for i in 1...lvl2Score.count {
                tempHighScore += lvl2Score[i-1]
            }
            for i in 1...lvl3Score.count {
                tempHighScore += lvl3Score[i-1]
            }
            
        } else if planet == 5 {
            
            if score > highScoreNumberSurvival {
                highScoreNumber = highScoreNumber - highScoreNumberSurvival
                highScoreNumber = highScoreNumber + score
                highScoreNumberSurvival = score
                defaults.set(score, forKey: "highScoreSavedSurvival")
                defaults.set(highScoreNumber, forKey: "highScoreSaved")
            }
            tempHighScore = highScoreNumber
        }

        
        
        if tempHighScore > highScoreNumber {
            defaults.set(tempHighScore, forKey: "highScoreSaved")
            
            //ref?.child("user").child(userId).child("highscore"/*self.userName*/).setValue(highScoreNumber)
            //ref?.child("user").child(userId).child("nickname"/*self.userName*/).setValue(nickName)
            //print("saved highsocre")
        }
        if preferredLanguage == .ru {
            overallHighScoreLabel.text = "Суммарный счет уровней: \(tempHighScore)"
            lvlHighScoreLabel.text = "Лучший счет уровня: \(currentLevelHighScore)"
            survivalScoreLabel.text = "Лучший ре3ультат: \(highScoreNumberSurvival)"
            lvlHighScoreLabel.fontSize = 40
            overallHighScoreLabel.fontSize = 40
            survivalScoreLabel.fontSize = 40
        } else if preferredLanguage == .ch {
            overallHighScoreLabel.text = "總結水平高分: \(tempHighScore)"
            overallHighScoreLabel.text = "總結水平高分: \(highScoreNumber)"
            lvlHighScoreLabel.text = "水平高的分數: \(currentLevelHighScore)"
            survivalScoreLabel.text = "最高纪录: \(highScoreNumberSurvival)"
            lvlHighScoreLabel.fontSize = 60
            overallHighScoreLabel.fontSize = 60
            survivalScoreLabel.fontSize = 60
        } else if preferredLanguage == .es  {
            
            overallHighScoreLabel.text = "Resumen puntaje alto: \(tempHighScore)"
            lvlHighScoreLabel.text = "Nivel alto puntaje: \(currentLevelHighScore)"
            survivalScoreLabel.text = "Mejores resultados: \(highScoreNumberSurvival)"
            lvlHighScoreLabel.fontSize = 40
            overallHighScoreLabel.fontSize = 40
            survivalScoreLabel.fontSize = 40
        } else if preferredLanguage == .jp  {
            overallHighScoreLabel.text = "要約レベルのスコア: \(tempHighScore)"
            lvlHighScoreLabel.text = "レベルベストスコア: \(currentLevelHighScore)"
            survivalScoreLabel.text = "最高の結果: \(highScoreNumberSurvival)"
            lvlHighScoreLabel.fontSize = 60
            overallHighScoreLabel.fontSize = 60
            survivalScoreLabel.fontSize = 60
        } else if preferredLanguage == .fr  {
            overallHighScoreLabel.text = "Score des niveaux sommaires: \(tempHighScore)"
            lvlHighScoreLabel.text = "Meilleur score de niveau: \(currentLevelHighScore)"
            survivalScoreLabel.text = "Meilleurs résultats: \(highScoreNumberSurvival)"
            lvlHighScoreLabel.fontSize = 40
            overallHighScoreLabel.fontSize = 40
            survivalScoreLabel.fontSize = 40
        } else if preferredLanguage == .gr  {
            overallHighScoreLabel.text = "Zusammenfassung: \(tempHighScore)"
            lvlHighScoreLabel.text = "Level beste Punktzahl: \(currentLevelHighScore)"
            survivalScoreLabel.text = "Beste Ergebnisse: \(highScoreNumberSurvival)"
            lvlHighScoreLabel.fontSize = 40
            overallHighScoreLabel.fontSize = 40
            survivalScoreLabel.fontSize = 40
        } else {
            overallHighScoreLabel.text = "Summary levels high score: \(tempHighScore)"
            lvlHighScoreLabel.text = "Level high score: \(currentLevelHighScore)"
            survivalScoreLabel.text = "Best results: \(highScoreNumberSurvival)"
            lvlHighScoreLabel.fontSize = 40
            overallHighScoreLabel.fontSize = 40
            survivalScoreLabel.fontSize = 40
        }
        
    }
    
    private var doneTouch = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if !doneTouch {
                let location = touch.location(in: self)
                if atPoint(location).name == "Play Again" {
                    doneTouch = true
                    startNewAcitivityIndicator()
                    
                    currentGameStatus = .inGame
                    
                    _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.2), target: self, selector: #selector(GameOverScene.presentSceneFunc), userInfo: nil, repeats: false)
                    
                } else if atPoint(location).name == "High Score" {
                    self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
                } else if atPoint(location).name == "Go To Menu" {
                    doneTouch = true
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
                    
                } else if atPoint(location).name == "Levels Button" {
                    doneTouch = true
                    let scene = LevelsScene(size: CGSize(width: 1536, height: 2048))
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
                    doneTouch = true
                    if planet == 1 && paidLevel[level + 1] == 1 {
                        startNewAcitivityIndicator()
                        level += 1
                        nextLevelFunc()
                        currentGameStatus = .inGame
                        
                        _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.2), target: self, selector: #selector(GameOverScene.presentSceneFunc), userInfo: nil, repeats: false)
                        
                        /*
                         let scene = GameScene(size: CGSize(width: 1536, height: 2048))
                         // Set the scale mode to scale to fit the window
                         scene.scaleMode = .aspectFill
                         
                         //let newGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                         let newGameTransition = SKTransition.fade(withDuration: 1.5)
                         // Present the scene
                         view?.presentScene(scene, transition: newGameTransition)
                         if #available(iOS 10.0, *) {
                         view?.preferredFramesPerSecond = 60
                         } else {
                         // Fallback on earlier versions
                         }
                         */
                    } else if planet == 2 && paid2Level[level + 1] == 1 {
                        startNewAcitivityIndicator()
                        level += 1
                        nextLevelFunc()
                        currentGameStatus = .inGame
                        
                        _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.2), target: self, selector: #selector(GameOverScene.presentSceneFunc), userInfo: nil, repeats: false)
                        
                    } else if planet == 3 && paid3Level[level + 1] == 1 {
                        startNewAcitivityIndicator()
                        level += 1
                        nextLevelFunc()
                        currentGameStatus = .inGame
                        
                        _ = Timer.scheduledTimer(timeInterval: TimeInterval(0.2), target: self, selector: #selector(GameOverScene.presentSceneFunc), userInfo: nil, repeats: false)
                    }
                    
                } else if atPoint(location).name == "Share Button" {
                    //self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
                    shareImageButton()
                } else {
                    
                }
            }
        }
    }
    
    @objc func presentSceneFunc() {
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        //let newGameTransition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        //let newGameTransition = SKTransition.fade(withDuration: 1.5)
        let newGameTransition = SKTransition.crossFade(withDuration: 1.5)
        // Present the scene
        view?.presentScene(scene, transition: newGameTransition)
        if #available(iOS 10.0, *) {
            view?.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
        }
    }

    private func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    private func shareImageButton() {
        let image = takeScreenShot(scene: scene!)
        let text = "Try this game!"
        
        //let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, /*UIActivityType.openInIBooks,*/ UIActivityType.print]
        self.view?.window?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    private func takeScreenShot(scene: SKScene) -> UIImage {
        let bounds = self.scene!.view?.bounds
        UIGraphicsBeginImageContextWithOptions(bounds!.size, true, UIScreen.main.scale)
        self.scene?.view?.drawHierarchy(in: bounds!, afterScreenUpdates: true)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenShot!
    }
    
    
    
    
    
    
    
    deinit {
        stopNewAcitvityIndicator()
        //print("gameover deinit")
        
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








