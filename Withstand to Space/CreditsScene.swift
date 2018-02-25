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
        mine2LinkLabel()
        puzzleButtonsLinkLabel()
        planetButtonsLinkLabel()
        megafonLinkLabel()
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
        
        specialThanksLabel()
        thanksPersonLinkLabel()
        
        supportLabel()
        contactsLinkLabel()
    }
    
    // MARK: Background setup
    private func backgroundSetup() {
        
        let background = SKSpriteNode(imageNamed: "backgroundStars02" /*"menuBackground2"*/)
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -100
        self.addChild(background)
    }
    
    private func backToMenuButtonsSetup() {
        
        let backToMenuButton = SKLabelNode(fontNamed: SomeNames.fontNameVenusrising)
        if preferredLanguage == .ch || preferredLanguage == .jp {
            backToMenuButton.fontSize = 85
        } else {
            backToMenuButton.fontSize = 70
        }
        
        backToMenuButton.name = "Back to menu"
        if preferredLanguage == .ru {
            backToMenuButton.text = "НА3АД"
        } else if preferredLanguage == .ch {
            backToMenuButton.text = "后退"
        } else if preferredLanguage == .es {
            backToMenuButton.text = "Atrás"
        } else if preferredLanguage == .jp {
            backToMenuButton.text = "戻る"
        } else if preferredLanguage == .fr {
            backToMenuButton.text = "Retour"
        } else if preferredLanguage == .gr {
            backToMenuButton.text = "Zurück"
        } else {
            backToMenuButton.text = "BACK"
        }
        
        
        backToMenuButton.position = CGPoint(x: self.size.width * 0.26, y: self.size.height * 0.94)
        backToMenuButton.zPosition = -99
        
        let backgroundForLabel = SKSpriteNode(imageNamed: "backBackground5")
        backgroundForLabel.name = "backBackground"
        backgroundForLabel.position = backToMenuButton.position
        backgroundForLabel.zPosition = backToMenuButton.zPosition - 1
        
        //        backToMenuButton.xScale += 0.4
        //        backToMenuButton.yScale += 0.4
        self.addChild(backToMenuButton)
        self.addChild(backgroundForLabel)
    }
    
    private func designLabel() {
        let designLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            designLabel.text = "Дизайн"
        } else if preferredLanguage == .ch {
            designLabel.text = "設計"
        } else if preferredLanguage == .es {
            designLabel.text = "Diseño"
        } else if preferredLanguage == .jp {
            designLabel.text = "設計"
        } else if preferredLanguage == .fr {
            designLabel.text = "Conception"
        } else if preferredLanguage == .gr {
            designLabel.text = "Design"
        } else {
            designLabel.text = "Design"
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
        message.position = CGPoint(x: (self.size.width * 0.5) - 100, y: self.size.height * 0.90)
        self.addChild(message)
        //self.addChild(mainShipLabel)
    }
    
    private func mainShipLinkLabel() {
        let mainShipLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mainShipLabel.text = "nRawdanitsu. (opengameart.org)" /*"Main ship sprite:\nRawdanitsu. (clickable)"*/
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
    
    private func mineLinkLabel() {
        let mineLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mineLabel.text = "Jonas Wagner. (opengameart.org)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
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
    
    private func mine2LinkLabel() {
        let mineLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mineLabel.text = "MillionthVector. (opengameart.org)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        //mineLabel.name = "Mine sprite"
        mineLabel.horizontalAlignmentMode = .left
        mineLabel.fontSize = 40
        mineLabel.fontColor = UIColor.white
        mineLabel.name = "Mine2 sprite"
        mineLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.81)
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
    
    private func puzzleButtonsLinkLabel() {
        let mineLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mineLabel.text = "WeaponGuy. (opengameart.org)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        //mineLabel.name = "Mine sprite"
        mineLabel.horizontalAlignmentMode = .left
        mineLabel.fontSize = 40
        mineLabel.fontColor = UIColor.white
        mineLabel.name = "Puzzle Buttons"
        mineLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.79)
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
    
    private func planetButtonsLinkLabel() {
        let mineLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        mineLabel.text = "phip-phantom. (phip-phantom.deviantart.com)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        //mineLabel.name = "Mine sprite"
        mineLabel.horizontalAlignmentMode = .left
        mineLabel.fontSize = 40
        mineLabel.fontColor = UIColor.white
        mineLabel.name = "Planet Button"
        mineLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.77)
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
    
    private func megafonLinkLabel() {
        let megafonLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        megafonLabel.text = "Icons8 (https://icons8.com/icon/441/advertising)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        //mineLabel.name = "Mine sprite"
        megafonLabel.horizontalAlignmentMode = .left
        megafonLabel.fontSize = 40
        megafonLabel.fontColor = UIColor.white
        megafonLabel.name = "Megafon label"
        megafonLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.75)
        //mineLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.65)
        megafonLabel.zPosition = 10
        /*
         let message = mineLabel.multilined(name: "Mine sprite")
         message.name = "Mine sprite"
         message.position = self.position //CGPoint(x: self.size.width * 0.2 /*frame.midX*/, y: self.size.height * 0.75 /*frame.midY*/)
         message.zPosition = 1001
         //message.fontName = SomeNames.fontName
         message.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.80)
         */
        self.addChild(megafonLabel)
    }
    
    private func meLinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            meLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else if preferredLanguage == .ch {
            meLabel.text = "Andrey Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else {
            meLabel.text = "Andrey Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //mineLabel.name = "Mine sprite"
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "Mine sprite"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.73)
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
    
    private func musicAndSoundsLabel() {
        let musicSoundsLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            musicSoundsLabel.text = "Музыка и звуки (freesound.org)"
        } else if preferredLanguage == .ch {
            musicSoundsLabel.text = "音樂和聲音 (freesound.org)"
        } else if preferredLanguage == .es {
            musicSoundsLabel.text = "Music and sound (freesound.org)"
        } else if preferredLanguage == .jp {
            musicSoundsLabel.text = "音楽とサウンド (freesound.org)"
        } else if preferredLanguage == .fr {
            musicSoundsLabel.text = "musique et son (freesound.org)"
        } else if preferredLanguage == .gr {
            musicSoundsLabel.text = "Musik und Sound (freesound.org)"
        } else {
            musicSoundsLabel.text = "Music and sound (freesound.org)"
        }
        //mainShipLabel.name = "Main ship label"
        musicSoundsLabel.horizontalAlignmentMode = .center
        musicSoundsLabel.fontSize = 40
        musicSoundsLabel.fontColor = UIColor.white
        musicSoundsLabel.name = "Music and sound Label"
        musicSoundsLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.69)
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
    
    private func sound1LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "Valo. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound1"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.64)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func sound2LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "InspectorJ. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound2"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.62)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func sound3LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "morganpurkis. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound3"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.60)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func sound4LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "Tritus. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound4"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.58)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func sound5LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "ejfortin. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound5"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.56)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func sound6LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "chripei. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound6"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.54)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func sound7LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "JohanDeecke. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound7"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.52)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func sound8LinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "sound8"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.50)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func programmersLabel() {
        let musicSoundsLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            musicSoundsLabel.text = "Разработка"
        } else if preferredLanguage == .ch {
            musicSoundsLabel.text = "程序員"
        } else if preferredLanguage == .es {
            musicSoundsLabel.text = "Programadores"
        } else if preferredLanguage == .jp {
            musicSoundsLabel.text = "プログラマー"
        } else if preferredLanguage == .fr {
            musicSoundsLabel.text = "Programmeurs"
        } else if preferredLanguage == .gr {
            musicSoundsLabel.text = "Programmierer"
        } else {
            musicSoundsLabel.text = "Programmers"
        }
        //mainShipLabel.name = "Main ship label"
        musicSoundsLabel.horizontalAlignmentMode = .center
        musicSoundsLabel.fontSize = 40
        musicSoundsLabel.fontColor = UIColor.white
        musicSoundsLabel.name = "Programmers Label"
        musicSoundsLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.45)
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
    
    private func programmersLinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            meLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else if preferredLanguage == .ch {
            meLabel.text = "Andrey Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else {
            meLabel.text = "Andrey Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "programmer1"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.40)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func producersLabel() {
        let prodLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            prodLabel.text = "Продюсеры"
        } else if preferredLanguage == .ch {
            prodLabel.text = "生產者"
        } else if preferredLanguage == .es {
            prodLabel.text = "Productores"
        } else if preferredLanguage == .jp {
            prodLabel.text = "プロデューサー"
        } else if preferredLanguage == .fr {
            prodLabel.text = "Les producteurs"
        } else if preferredLanguage == .gr {
            prodLabel.text = "Produzenten"
        } else {
            prodLabel.text = "Producers"
        }
        //mainShipLabel.name = "Main ship label"
        prodLabel.horizontalAlignmentMode = .center
        prodLabel.fontSize = 40
        prodLabel.fontColor = UIColor.white
        prodLabel.name = "Music and sound Label"
        prodLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.35)
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
    
    private func producersLinkLabel() {
        let prodLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            prodLabel.text = "Бабий Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else if preferredLanguage == .ch {
            prodLabel.text = "Andrey Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else {
            prodLabel.text = "Andrey Babiy" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        prodLabel.horizontalAlignmentMode = .left
        prodLabel.fontSize = 40
        prodLabel.fontColor = UIColor.white
        prodLabel.name = "producer1"
        prodLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.30)
        prodLabel.zPosition = 10
        self.addChild(prodLabel)
    }
    
    private func specialThanksLabel() {
        let thanksLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            thanksLabel.text = "Благодарноcти:"
        } else if preferredLanguage == .ch {
            thanksLabel.text = "謝謝"
        } else if preferredLanguage == .es {
            thanksLabel.text = "Gracias"
        } else if preferredLanguage == .jp {
            thanksLabel.text = "ありがとう"
        } else if preferredLanguage == .fr {
            thanksLabel.text = "Merci"
        } else if preferredLanguage == .gr {
            thanksLabel.text = "Vielen Dank"
        } else {
            thanksLabel.text = "Special thanks"
        }
        //mainShipLabel.name = "Main ship label"
        thanksLabel.horizontalAlignmentMode = .center
        thanksLabel.fontSize = 40
        thanksLabel.fontColor = UIColor.white
        thanksLabel.name = "Thanks Label"
        thanksLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.25)
        thanksLabel.zPosition = 10
        /*
         let message = designLabel.multilined(name: "Design label")
         message.name = "Design label"
         message.zPosition = 1001
         //message.fontName = SomeNames.fontName
         message.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.90)
         */
        self.addChild(thanksLabel)
        //self.addChild(mainShipLabel)
    }
    
    private func thanksPersonLinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            meLabel.text = "Боклин Роман, Пляц Дмитрий, Сидоров Андрей" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else if preferredLanguage == .ch {
            meLabel.text = "Roman Boklin, Dmitry Plyats, Andrey Sidorov" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else {
            meLabel.text = "Roman Boklin, Dmitry Plyats, Andrey Sidorov" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "programmer1"
        meLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.20)
        meLabel.zPosition = 10
        self.addChild(meLabel)
    }
    
    private func supportLabel() {
        let thanksLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ru {
            thanksLabel.text = "Поддержка:"
        } else if preferredLanguage == .ch {
            thanksLabel.text = "援助"
        } else if preferredLanguage == .es {
            thanksLabel.text = "Manutención"
        } else if preferredLanguage == .jp {
            thanksLabel.text = "援助"
        } else if preferredLanguage == .fr {
            thanksLabel.text = "Support"
        } else if preferredLanguage == .gr {
            thanksLabel.text = "Unterstützung"
        } else {
            thanksLabel.text = "Support"
        }
        //mainShipLabel.name = "Main ship label"
        thanksLabel.horizontalAlignmentMode = .center
        thanksLabel.fontSize = 40
        thanksLabel.fontColor = UIColor.white
        thanksLabel.name = "Thanks Label"
        thanksLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.15)
        thanksLabel.zPosition = 10
        /*
         let message = designLabel.multilined(name: "Design label")
         message.name = "Design label"
         message.zPosition = 1001
         //message.fontName = SomeNames.fontName
         message.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.90)
         */
        self.addChild(thanksLabel)
        //self.addChild(mainShipLabel)
    }
    
    private func contactsLinkLabel() {
        let meLabel = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ch {
            meLabel.text = "E-mail: populateThisPlanet@yandex.ru" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        } else {
            meLabel.text = "E-mail: populateThisPlanet@gmail.com" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel.horizontalAlignmentMode = .left
        meLabel.fontSize = 40
        meLabel.fontColor = UIColor.white
        meLabel.name = "contactEmail"
        meLabel.position = CGPoint(x: self.size.width * 0.17, y: self.size.height * 0.10)
        meLabel.zPosition = 10
        self.addChild(meLabel)
        
        
        let meLabel2 = SKLabelNode(fontNamed: "Futura" /*SomeNames.fontName*/)
        if preferredLanguage == .ch {
            meLabel2.text = "https://vk.com/club159232434"
        } else {
            meLabel2.text = "https://www.facebook.com/groups/135500117234612/" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        }
        //meLabel.text = "movieman739. (clickable)" /*"Mine sprite:\nJonas Wagner. (clickable)"*/
        meLabel2.horizontalAlignmentMode = .left
        meLabel2.fontSize = 40
        meLabel2.fontColor = UIColor.white
        meLabel2.name = "contactFacebook"
        meLabel2.position = CGPoint(x: self.size.width * 0.17, y: self.size.height * 0.05)
        meLabel2.zPosition = 10
        self.addChild(meLabel2)
    }
    
    private func multilineText() {
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
            if atPoint(location).name == "Back to menu" || atPoint(location).name == "backBackground" {
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
            } else if atPoint(location).name == "Mine2 sprite" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "https://opengameart.org/content/set-faction10-spacestations")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "https://opengameart.org/content/set-faction10-spacestations") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "Puzzle Buttons" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "https://opengameart.org/content/gui-buttons-activehover")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "https://opengameart.org/content/gui-buttons-activehover") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "Planet Button" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "https://phip-phantom.deviantart.com/art/Planet-3-png-340830993")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "https://phip-phantom.deviantart.com/art/Planet-3-png-340830993") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "Megafon label" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "https://icons8.com/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "https://icons8.com/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound1" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/Valo/sounds/398340/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://freesound.org/people/Valo/sounds/398340/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound2" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/InspectorJ/sounds/403019/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://freesound.org/people/InspectorJ/sounds/403019/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound3" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/morganpurkis/sounds/392972/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://freesound.org/people/morganpurkis/sounds/392972/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound4" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/Tritus/sounds/251420/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://freesound.org/people/Tritus/sounds/251420/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound5" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/ejfortin/sounds/49671/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://freesound.org/people/ejfortin/sounds/49671/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound6" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/chripei/sounds/165492/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://freesound.org/people/chripei/sounds/165492/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound7" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/JohanDeecke/sounds/367760/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://freesound.org/people/JohanDeecke/sounds/367760/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "sound8" {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: "http://freesound.org/people/movieman739/sounds/188790/")! as URL, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://freesound.org/people/movieman739/sounds/188790/") {
                        UIApplication.shared.openURL(url)
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            } else if atPoint(location).name == "contactFacebook" {
                if #available(iOS 10.0, *) {
                    if preferredLanguage == .ch {
                        UIApplication.shared.open(NSURL(string: "https://vk.com/club159232434")! as URL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(NSURL(string: "https://www.facebook.com/groups/135500117234612/")! as URL, options: [:], completionHandler: nil)
                    }
                } else {
                    if preferredLanguage == .ch {
                        if let url = URL(string: "https://vk.com/club159232434") {
                            UIApplication.shared.openURL(url)
                        }
                    } else {
                        if let url = URL(string: "https://www.facebook.com/groups/135500117234612/") {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    // Fallback on earlier versions
                }
                //print("helo")
            }
        }
    }
    
    deinit {
        //print("credits scene deinit")
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
