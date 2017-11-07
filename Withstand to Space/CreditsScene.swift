//
//  CreditsScene.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 20.10.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit

class CreditsScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundSetup()
        backToMenuButtonsSetup()
        //multilineText()
        
        mainShipLinkLabel()
        mineLinkLabel()
    }
    
    // MARK: Background setup
    func backgroundSetup() {
        
        let background = SKSpriteNode(imageNamed: "menuBackground2")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    func backToMenuButtonsSetup() {
        
        let backToMenuButton = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        backToMenuButton.name = "Back to menu"
        if preferredLanguage == .ru {
            backToMenuButton.text = "назад"
        } else {
            backToMenuButton.text = "BACK"
        }
        
        
        backToMenuButton.position = CGPoint(x: self.size.width * 0.26, y: self.size.height * 0.94)
        backToMenuButton.zPosition = -99
        backToMenuButton.fontSize = 60
        //        backToMenuButton.xScale += 0.4
        //        backToMenuButton.yScale += 0.4
        self.addChild(backToMenuButton)
    }
    
    func mainShipLinkLabel() {
        let mainShipLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mainShipLabel.text = "Main ship sprite:\nRawdanitsu. (clickable)"
        //mainShipLabel.name = "Main ship label"
        mainShipLabel.horizontalAlignmentMode = .left
        mainShipLabel.fontSize = 40
        mainShipLabel.fontColor = UIColor.white
        //mainShipLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.8)
        //mainShipLabel.zPosition = -99
        
        let message = mainShipLabel.multilined(name: "Main ship label")
        message.name = "Main ship label"
        message.zPosition = 1001
        //message.fontName = SomeNames.fontName
        message.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.85)
        self.addChild(message)
        //self.addChild(mainShipLabel)
    }
    
    func mineLinkLabel() {
        let mineLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mineLabel.text = "Mine sprite:\nJonas Wagner. (clickable)"
        //mineLabel.name = "Mine sprite"
        mineLabel.horizontalAlignmentMode = .left
        mineLabel.fontSize = 40
        mineLabel.fontColor = UIColor.white
        //mineLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.65)
        //mineLabel.zPosition = -99
        
        let message = mineLabel.multilined(name: "Mine sprite")
        message.name = "Mine sprite"
        message.position = self.position //CGPoint(x: self.size.width * 0.2 /*frame.midX*/, y: self.size.height * 0.75 /*frame.midY*/)
        message.zPosition = 1001
        //message.fontName = SomeNames.fontName
        message.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.80)
        self.addChild(message)
    }
    
    
    
    
    
    
    func multilineText() {
        let text = "Main spaceship sprite: \n https://opengameart.org/content/some-top-down-spaceships \n" +
        "cold beer \n " +
        " \n " +
        "team jersey \n" +
        "cold beer\n " +
        "team jersey \n" +
        "cold beer\n " +
        "team jersey \n"
        let singleLineMessage = SKLabelNode()
        singleLineMessage.fontSize = min(size.width, size.height) / CGFloat(text.components(separatedBy: "\n").count)
        singleLineMessage.verticalAlignmentMode = .center
        singleLineMessage.text = text
        singleLineMessage.fontName = SomeNames.fontName
        let message = singleLineMessage.multilined(name: "yo")
        message.position = CGPoint(x: self.size.width * 0.2 /*frame.midX*/, y: self.size.height * 0.75 /*frame.midY*/)
        message.zPosition = 1001
        message.fontName = SomeNames.fontName
        addChild(message)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if atPoint(location).name == "Back to menu" {
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
                
                //                view?.ignoresSiblingOrder = true
                //
                //                view?.showsFPS = true
                //                view?.showsNodeCount = true
                //                view?.showsPhysics = true
            } else if atPoint(location).name == "highScoreButton" {
                self.view?.window?.rootViewController?.performSegue(withIdentifier: "highScoreSegue", sender: self)
            } else if atPoint(location).name == "creditsButton" {

            } else if atPoint(location).name == "Main ship label" {
                UIApplication.shared.open(NSURL(string: "https://opengameart.org/content/some-top-down-spaceships")! as URL, options: [:], completionHandler: nil)
                //print("helo")
            } else if atPoint(location).name == "Mine sprite" {
                UIApplication.shared.open(NSURL(string: "https://opengameart.org/content/asteroid-explosions-rocket-mine-and-laser")! as URL, options: [:], completionHandler: nil)
                //print("helo")
            }
        }
    }
    
}

extension SKLabelNode {
    func multilined(name: String) -> SKLabelNode {
        let substrings: [String] = self.text!.components(separatedBy: "\n")
        return substrings.enumerated().reduce(SKLabelNode()) {
            let label = SKLabelNode(fontNamed: self.fontName)
            label.text = $1.element
            label.fontColor = self.fontColor
            label.fontSize = self.fontSize
            label.position = self.position
            label.name = name
            label.horizontalAlignmentMode = .left //self.horizontalAlignmentMode
            label.verticalAlignmentMode = self.verticalAlignmentMode
            let y = CGFloat($1.offset - substrings.count / 2) * self.fontSize
            label.position = CGPoint(x: 0, y: -y)
            $0.addChild(label)
            return $0
        }
    }
}
