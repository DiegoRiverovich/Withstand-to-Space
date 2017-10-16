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
    
    override func didMove(to view: SKView) {
        loadMainScene()
    }
    
    
    
    func loadMainScene() {
        
        backgroundSetup()
        levelButtonsSetup()
        levelsLabel()
    }
    
    // MARK: Background setup
    func backgroundSetup() {
         let background = SKSpriteNode(imageNamed: "backgroundStars")
         background.size = self.size
         background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
         background.zPosition = -100
         self.addChild(background)
    }
    
    func levelsLabel() {
        let levelsLabel = SKSpriteNode(imageNamed: "levelsLabel")
        //levelsLabel.size = self.size
        levelsLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.88)
        levelsLabel.zPosition = -99
        self.addChild(levelsLabel)
    }
    
    func levelButtonsSetup() {
        var x = 1
        var y = 1
        var z = 1
        for i in 1...12 {
            let lvlButton = SKSpriteNode(imageNamed: "lvl\(i)beige")
            lvlButton.name = "lvl\(i)Button"
            //lvlButton.size = self.size
            if i <= 3 {
                lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * i), y: self.size.height * 0.75)
            } else if i <= 6 {
                lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * x), y: self.size.height * 0.75 - CGFloat(350))
                x += 1
            } else if i <= 9 {
                lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * y), y: self.size.height * 0.75 - CGFloat(700))
                y += 1
            } else if i <= 12 {
                lvlButton.position = CGPoint(x: self.size.width * 0.1 + CGFloat(300 * z), y: self.size.height * 0.75 - CGFloat(1050))
                z += 1
            }
            lvlButton.zPosition = -99
            lvlButton.xScale += 0.4
            lvlButton.yScale += 0.4
            self.addChild(lvlButton)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "lvl1Button" {
                level = 0  // 1
                let scene = GameScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let newGameTransition = SKTransition.reveal(with: SKTransitionDirection.up, duration: 1)//moveIn(with: SKTransitionDirection.left, duration: 2) //doorsCloseHorizontal(withDuration: 0.5)
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
            } else if atPoint(location).name == "lvl2Button" {
                
                level = 1 // 2
                let scene = GameScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let newGameTransition = SKTransition.reveal(with: SKTransitionDirection.up, duration: 1)//moveIn(with: SKTransitionDirection.left, duration: 2) //doorsCloseHorizontal(withDuration: 0.5)
                // Present the scene
                view?.presentScene(scene, transition: newGameTransition)
                if #available(iOS 10.0, *) {
                    view?.preferredFramesPerSecond = 60
                } else {
                    // Fallback on earlier versions
                }
                
                print("level2")
            } else if atPoint(location).name == "lvl3Button" {
                print("level3")
            } else if atPoint(location).name == "lvl4Button" {
                print("level4")
            } else if atPoint(location).name == "lvl5Button" {
                print("level5")
            } else if atPoint(location).name == "lvl6Button" {
                print("level6")
            } else if atPoint(location).name == "lvl7Button" {
                print("level7")
            } else if atPoint(location).name == "lvl8Button" {
                print("level8")
            } else if atPoint(location).name == "lvl9Button" {
                print("level9")
            } else if atPoint(location).name == "lvl10Button" {
                print("level10")
            } else if atPoint(location).name == "lvl11Button" {
                print("level11")
            } else if atPoint(location).name == "lvl12Button" {
                print("level12")
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}   //class
