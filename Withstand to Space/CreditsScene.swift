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
        
        designLabel()
        mainShipLinkLabel()
        mineLinkLabel()
        meLinkLabel()
        
        musicAndSoundsLabel()
        sound1LinkLabel()
        sound2LinkLabel()
        sound3LinkLabel()
        sound4LinkLabel()
        sound5LinkLabel()
        sound6LinkLabel()
        sound7LinkLabel()
        sound8LinkLabel()
        
        programmersLabel()
        programmersLinkLabel()
        
        producersLabel()
        producersLinkLabel()
    }
    
    // MARK: Background setup
    func backgroundSetup() {
        
        let background = SKSpriteNode(imageNamed: "backgroundStars02" /*"menuBackground2"*/)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    func backToMenuButtonsSetup() {
        
        let backToMenuButton = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        backToMenuButton.name = "Back to menu"
        if preferredLanguage == .ru {
            backToMenuButton.text = "НА3АД"
        } else if preferredLanguage == .ch {
            backToMenuButton.text = "后退"
        } else if preferredLanguage == .es {
            backToMenuButton.text = "Atrás"
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
    
    func designLabel() {
        let designLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            designLabel.text = "Дизайн (opengameart.org)"
        } else if preferredLanguage == .ch {
            designLabel.text = "設計 (opengameart.org)"
        } else if preferredLanguage == .es {
            designLabel.text = "Diseño (opengameart.org)"
        } else {
            designLabel.text = "Design (opengameart.org)"
        }
        
        //mainShipLabel.name = "Main ship label"
        designLabel.horizontalAlignmentMode = .center
        designLabel.fontSize = 40
        designLabel.fontColor = UIColor.white
        //mainShipLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.8)
        designLabel.zPosition = 10
        
        let message = designLabel.multilined(name: "Design label")
        message.name = "Design label"
        message.zPosition = 1001
        //message.fontName = SomeNames.fontName
        message.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.90)
        self.addChild(message)
        //self.addChild(mainShipLabel)
    }
    
    func mainShipLinkLabel() {
        let mainShipLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mainShipLabel.text = "nRawdanitsu. (clickable)" /*"Main ship sprite:\nRawdanitsu. (clickable)"*/
        //mainShipLabel.name = "Main ship label"
        mainShipLabel.horizontalAlignmentMode = .left
        mainShipLabel.fontSize = 40
        mainShipLabel.fontColor = UIColor.white
        mainShipLabel.name = "Main ship label"
        mainShipLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.85)
        //mainShipLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.8)
        mainShipLabel.zPosition = 10
        /*
        let message = mainShipLabel.multilined(name: "Main ship label")
        message.name = "Main ship label"
        message.zPosition = 1001
        //message.fontName = SomeNames.fontName
        message.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.85)
        */
        self.addChild(mainShipLabel)
        //self.addChild(mainShipLabel)
    }
    
    func mineLinkLabel() {
        let mineLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mineLabel.text = "Jonas Wagner. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        //mineLabel.name = "Mine sprite"
        mineLabel.horizontalAlignmentMode = .left
        mineLabel.fontSize = 40
        mineLabel.fontColor = UIColor.white
        mineLabel.name = "Mine sprite"
        mineLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.83)
        //mineLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.65)
        mineLabel.zPosition = 10
        /*
        let message = mineLabel.multilined(name: "Mine sprite")
        message.name = "Mine sprite"
        message.position = self.position //CGPoint(x: self.size.width * 0.2 /*frame.midX*/, y: self.size.height * 0.75 /*frame.midY*/)
        message.zPosition = 1001
        //message.fontName = SomeNames.fontName
        message.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.80)
         */
        self.addChild(mineLabel)
    }
    
    func meLinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            meLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else if preferredLanguage == .ch {
            meLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else {
            meLabel.text = "Andrew Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //mineLabel.name = "Mine sprite"
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "Mine sprite"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.81)
        //mineLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.65)
        meLabel.zPosition = 10
        /*
         let message = mineLabel.multilined(name: "Mine sprite")
         message.name = "Mine sprite"
         message.position = self.position //CGPoint(x: self.size.width * 0.2 /*frame.midX*/, y: self.size.height * 0.75 /*frame.midY*/)
         message.zPosition = 1001
         //message.fontName = SomeNames.fontName
         message.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.80)
         */
        self.addChild(meLabel)
    }
    
    func musicAndSoundsLabel() {
        let musicSoundsLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            musicSoundsLabel.text = "Музыка и звуки (freesound.org)"
        } else if preferredLanguage == .ch {
            musicSoundsLabel.text = "音樂和聲音 (freesound.org)"
        } else if preferredLanguage == .es {
            musicSoundsLabel.text = "Music and sound (freesound.org)"
        } else {
            musicSoundsLabel.text = "Music and sound (freesound.org)"
        }
        //mainShipLabel.name = "Main ship label"
        musicSoundsLabel.horizontalAlignmentMode = .center
        musicSoundsLabel.fontSize = 40
        musicSoundsLabel.fontColor = UIColor.white
        musicSoundsLabel.name = "Music and sound Label"
        musicSoundsLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.77)
        musicSoundsLabel.zPosition = 10
        /*
        let message = designLabel.multilined(name: "Design label")
        message.name = "Design label"
        message.zPosition = 1001
        //message.fontName = SomeNames.fontName
        message.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.90)
     */
        self.addChild(musicSoundsLabel)
        //self.addChild(mainShipLabel)
    }
    
    func sound1LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "Valo. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound1"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.72)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func sound2LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "InspectorJ. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound2"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.70)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func sound3LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "morganpurkis. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound3"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.68)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func sound4LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "Tritus. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound4"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.66)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func sound5LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "ejfortin. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound5"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.64)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func sound6LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "chripei. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound6"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.62)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func sound7LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "JohanDeecke. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound7"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.60)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func sound8LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound8"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.58)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func programmersLabel() {
        let musicSoundsLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            musicSoundsLabel.text = "Разработка"
        } else if preferredLanguage == .ch {
            musicSoundsLabel.text = "程序員"
        } else if preferredLanguage == .es {
            musicSoundsLabel.text = "Programadores"
        } else {
            musicSoundsLabel.text = "Programmers"
        }
        //mainShipLabel.name = "Main ship label"
        musicSoundsLabel.horizontalAlignmentMode = .center
        musicSoundsLabel.fontSize = 40
        musicSoundsLabel.fontColor = UIColor.white
        musicSoundsLabel.name = "Programmers Label"
        musicSoundsLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.53)
        musicSoundsLabel.zPosition = 10
        /*
         let message = designLabel.multilined(name: "Design label")
         message.name = "Design label"
         message.zPosition = 1001
         //message.fontName = SomeNames.fontName
         message.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.90)
         */
        self.addChild(musicSoundsLabel)
        //self.addChild(mainShipLabel)
    }
    
    func programmersLinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            meLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else if preferredLanguage == .ch {
            meLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else {
            meLabel.text = "Andrew Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "programmer1"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.48)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    func producersLabel() {
        let prodLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            prodLabel.text = "Продюсеры"
        } else if preferredLanguage == .ch {
            prodLabel.text = "生產者"
        } else if preferredLanguage == .es {
            prodLabel.text = "Productores"
        } else {
            prodLabel.text = "Producers"
        }
        //mainShipLabel.name = "Main ship label"
        prodLabel.horizontalAlignmentMode = .center
        prodLabel.fontSize = 40
        prodLabel.fontColor = UIColor.white
        prodLabel.name = "Music and sound Label"
        prodLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.43)
        prodLabel.zPosition = 10
        /*
         let message = designLabel.multilined(name: "Design label")
         message.name = "Design label"
         message.zPosition = 1001
         //message.fontName = SomeNames.fontName
         message.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.90)
         */
        self.addChild(prodLabel)
        //self.addChild(mainShipLabel)
    }
    
    func producersLinkLabel() {
        let prodLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            prodLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else if preferredLanguage == .ch {
            prodLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else {
            prodLabel.text = "Andrew Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        prodLabel.horizontalAlignmentMode = .left
        prodLabel.fontSize = 40
        prodLabel.fontColor = UIColor.white
        prodLabel.name = "producer1"
        prodLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.38)
        prodLabel.zPosition = 10
        self.addChild(prodLabel)
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
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "https://opengameart.org/content/some-top-down-spaceships")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "Mine sprite" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "https://opengameart.org/content/asteroid-explosions-rocket-mine-and-laser")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound1" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/Valo/sounds/398340/")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound2" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/InspectorJ/sounds/403019/")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound3" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/morganpurkis/sounds/392972/")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound4" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/Tritus/sounds/251420/")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound5" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/ejfortin/sounds/49671/")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound6" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/chripei/sounds/165492/")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound7" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/JohanDeecke/sounds/367760/")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound8" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/movieman739/sounds/188790/")! as URL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
                //print("helo")
            }
        }
    }
    
    deinit {
        print("credits scene deinit")
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
