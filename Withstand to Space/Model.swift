//
//  Model.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 12.10.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import Foundation
import SpriteKit

//++GameScene
enum BodyType: UInt32 {
    case player = 1
    case barrier = 2
    case cD = 4
    case other = 8
    case partition = 16
    case debris = 32
}

enum gameState {
    case beforeGame
    case inGame
    case afterGame
}

struct SomeNames {
    static let fontName = "elitedanger"
    static let blowTheShip = NSNotification.Name("Ship Contact Partition")
    // Buttons
    static let normalStatusButton = "statusNormalButton"
    static let trioStatusButton = "statusTrioButton"
    static let rougeOneStatusButton = "statusRougeOneButton"
    static let invisibleStatusButton = "statusInvisibleButton"
}

enum DebrisSpeed {
    case slow
    case middle
    case fast
}

var debrisSpeed = DebrisSpeed.slow
var score = 0
var level = 0

var currentGameStatus = gameState.inGame
//--GameScene


//++Plaer
enum ShipStatus {
    case noraml
    case trio
    case rogueOne
    case invisible
}

struct PlayerPosition {
    static let lowLeft620 = CGPoint(x: /*620*//*570*//*550*/555, y: 512)
    static let lowCenter768 = CGPoint(x: 768, y: 512)
    static let lowRight925 = CGPoint(x: /*925*//*975*//*995*/990, y: 512)
    
    static let middleLeft535 = CGPoint(x: /*535*//*455*//*475*//*465*/460, y: 512)
    static let middleCenter768 = CGPoint(x: 768, y: 512)
    static let middleRight1010 = CGPoint(x: /*1010*//*1070*//*1080*/1095, y: 512)
    
    static let highLeft450 = CGPoint(x: /*450*//*350*//*360*/330, y: 512)
    static let highCenter768 = CGPoint(x: 768, y: 512)
    static let highRight1095 = CGPoint(x: /*1095*//*1195*//*1185*/1220, y: 512)
}

struct DebrisPosition {
    static let lowLeft620 = CGPoint(x: /*620*//*570*//*550*/555, y: 2200)
    static let lowCenter768 = CGPoint(x: 768, y: 2200)
    static let lowRight925 = CGPoint(x: /*925*//*975*//*995*/990, y: 2200)
    
    static let middleLeft535 = CGPoint(x: /*535*//*455*//*475*//*435*/445, y: 2500)
    static let middleCenter768 = CGPoint(x: 768, y: 2500)
    static let middleRight1010 = CGPoint(x: /*1010*//*1070*//*1110*/1100, y: 2500)
    
    static let highLeft450 = CGPoint(x: /*450*//*350*//*360*//*280*//*300*/310, y: 2900)
    static let highCenter768 = CGPoint(x: 768, y: 2900)
    static let highRight1095 = CGPoint(x: /*1095*//*1195*//*1185*//*1265*//*1245*/1235, y: 2900)
}


struct MiddleBarrierPosition {
    static let lowLeft620 = CGPoint(x: /*694*//*674*/664, y: 2200)
    //static let lowCenter768 = CGPoint(x: 768, y: 2200)
    static let lowRight925 = CGPoint(x: /*848.5*//*868.5*/878.5, y: 2200)
    
    static let middleLeft535 = CGPoint(x: /*651.5*//*631.5*/611.5, y: 2500)
    //static let middleCenter768 = CGPoint(x: 768, y: 2500)
    static let middleRight1010 = CGPoint(x: /*889*//*909*/929, y: 2500)
    
    static let highLeft450 = CGPoint(x: /*609*//*569*//*534*/544, y: 2900)
    //static let highCenter768 = CGPoint(x: 768, y: 2900)
    static let highRight1095 = CGPoint(x: /*931.5*//*971.5*//*1006.5*/996.5, y: 2900)
}

struct ShipScale {
    static let small: CGFloat = 0.6
    static let middle: CGFloat = 0.9
    static let big: CGFloat = 1.3
}

var shipStatus = ShipStatus.noraml

//--Player

let levels = [levelOne, levelTwo, levelThree, levelFour]

let levelOne: [[Int]] = [
    [1,4,1,4,1,1,4,2,4,1,1,4,1,4,1],
    [1,4,1,4,1,1,4,2,4,1,1,4,1,4,1],
    [0,4,0,4,0,0,4,2,4,0,0,4,0,4,0],
    [0,4,0,4,1,1,4,2,4,0,1,4,0,4,1],
    [1,4,1,4,0,0,4,2,4,0,1,4,0,4,1],
    [1,4,1,4,1,1,4,2,4,1,1,4,1,4,1],
    [0,4,0,4,1,1,4,2,4,1,1,4,0,4,0],
    [1,4,0,4,1,0,4,2,4,1,0,4,1,4,0],
    [1,4,0,4,1,0,4,2,4,1,1,4,1,4,1],
    [1,4,1,4,1,1,4,2,4,1,1,4,1,4,1],
    [0,4,0,4,0,0,4,2,4,0,1,4,1,4,1],
    [1,4,0,4,1,0,4,2,4,1,0,4,1,4,0],
    [1,4,0,4,1,0,4,2,4,1,1,4,1,4,1],
    [1,4,1,4,1,1,4,2,4,1,1,4,1,4,1],
    [0,4,0,4,0,0,4,2,4,0,1,4,1,4,1]
]

let levelTwo: [[Int]] = [
    [1,0,1,0,1,1,0,2,0,1,1,0,1,0,1],
    [1,0,1,0,1,1,0,2,0,1,1,0,1,0,1],
    [0,0,0,0,0,0,0,2,0,0,0,0,0,0,0],
    [0,0,0,0,1,1,0,2,0,0,1,0,0,0,1],
    [1,0,1,0,0,0,0,2,0,0,1,0,0,0,1],
    [1,4,1,4,1,1,4,2,4,1,1,4,1,4,1],
    [0,4,0,4,1,1,4,2,4,1,1,4,0,4,0],
    [1,0,0,0,1,0,0,2,0,1,0,0,1,0,0],
    [1,4,0,4,1,0,4,2,4,1,1,4,1,4,1],
    [1,0,1,0,1,1,0,2,0,1,1,0,1,0,1],
    [0,0,0,0,0,0,4,2,4,0,1,0,1,0,1],
    [1,4,0,4,1,0,4,2,4,1,0,4,1,4,0],
    [1,4,0,4,1,0,4,2,4,1,1,4,1,4,1],
    [1,4,1,4,1,1,4,2,4,1,1,4,1,4,1],
    [0,4,0,4,0,0,4,2,4,0,1,4,1,4,1]
]

let levelThree: [[Int]] = [
    [1,0,0,0,0,0],
    [1,1,0,0,0,0],
    [1,1,1,0,0,0],
    [1,1,1,1,1,1]
]

let levelFour: [[Int]] = [
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1],
    [1,1,1,1,1,1]
]

//let middleBarrierLevel: [[]]

let constructionTimeIntervalArray: [[Int]] = [
    [2,4,1,1,1,1,1,2,5,7,1,1,1,1,1],   //15
    [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]    //15
]






























