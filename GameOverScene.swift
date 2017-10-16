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

var highScoreNumber: Int = 0
var nickName = "noname"


class GameOverScene: SKScene {
    
    var ref: DatabaseReference?
    
    let highScore = SKSpriteNode(imageNamed: "alien3")
    
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
        saveUserDefaults()
        
        
        backgroundSetup()
        startButtonSetup()
        
        setScoreLabel()
        setHithScoreLabel()
        sethighScoreMenu()
        
        highScore.alpha = 0.0
        
        
        //highscoreTableViewSetup()
        
        
        
        //_ = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameOverScene.highscoreTableViewSetup), userInfo: nil, repeats: false)
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
                    
                    self.saveUserDefaults()
                    self.highScore.alpha = 1.0
                }
                //self.saveUserDefaults()
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
        
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    // MARK: START BUTTON
    func startButtonSetup() {
        
        let startButton = SKSpriteNode(imageNamed: "gameOverButton")
        startButton.name = "Game Over"
        //startButton.size = self.size
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        startButton.zPosition = -99
        self.addChild(startButton)
    }
    
    // MARK: Score label
    func setScoreLabel() {
        let scoreLabel = SKLabelNode(fontNamed: SomeNames.fontName)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 120
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        scoreLabel.zPosition = -99
        self.addChild(scoreLabel)
    }
    
    // MARK: Highscore label
    func setHithScoreLabel() {
        let highScoreLabel = SKLabelNode(fontNamed: SomeNames.fontName)
        highScoreLabel.text = "High score: \(highScoreNumber)"
        highScoreLabel.fontSize = 120
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.3)
        highScoreLabel.zPosition = -99
        self.addChild(highScoreLabel)
    }
    
    // MARK: HighScore menu button
    func sethighScoreMenu() {
        
        
        highScore.name = "highScoreNodeMenu"
        //startButton.size = self.size
        highScore.position = CGPoint(x: self.size.width * 0.7, y: self.size.height * 0.9)
        highScore.zPosition = -99
        highScore.alpha = 0.0
        self.addChild(highScore)
    }
    
    func saveUserDefaults() {
        let defaults = UserDefaults()
        highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if score > highScoreNumber {
            highScoreNumber = score
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Game Over" {
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
                
//                view?.ignoresSiblingOrder = true
//                
//                view?.showsFPS = true
//                view?.showsNodeCount = true
//                view?.showsPhysics = true
            } else if atPoint(location).name == "highScoreNodeMenu" {
                self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
            }
        }
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}   // class
