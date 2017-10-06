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
    
    override func didMove(to view: SKView) {
        loadMainScene()
    }
    
    func loadMainScene() {
        
        ref = Database.database().reference().child("user")        
        auth()
        
        getNickname()
        
        backgroundSetup()
        startButtonSetup()
        
        highScoreMenu()
        
        saveUserDefaults()
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
        
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    // MARK: START BUTTON
    func startButtonSetup() {
        
        let startButton = SKSpriteNode(imageNamed: "startButton")
        startButton.name = "Start"
        //startButton.size = self.size
        startButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Start" {
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
                
                view?.ignoresSiblingOrder = true
                
                view?.showsFPS = true
                view?.showsNodeCount = true
                view?.showsPhysics = true
            } else if atPoint(location).name == "highScoreNodeMenu" {
                self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
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
                    
                }
                
                userId = defaults.string(forKey: "userId")!
                self.highScore.alpha = 1.0
            }
            
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func saveUserDefaults() {
        let defaults = UserDefaults()
        highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if score > highScoreNumber {
            highScoreNumber = score
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            
            
        }
    }
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}   // class
