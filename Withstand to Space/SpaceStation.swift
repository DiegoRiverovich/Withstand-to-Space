//
//  SpaceStation.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 11.10.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit

class SpaceStation: SKSpriteNode {
    
    let stations = ["ISS", "Space_Station", "Sputnik"]
    let positionsX: [CGFloat] = [-500, -500, -500, -500, 1800, 1800, 1800, 1800]
    let positionsY: [CGFloat] = [1700, 1300, 2000, 1000]
    let toPositionRight:[CGPoint] = [CGPoint(x: 1800, y: -200), CGPoint(x: 1800, y: 700), CGPoint(x: 1800, y: 1300), CGPoint(x: 1800, y: 2000)]
    let toPositionLeft:[CGPoint] = [CGPoint(x: -200, y: -200), CGPoint(x: -200, y: 700), CGPoint(x: -200, y: 1300), CGPoint(x: -200, y: 2000)]
    
    var positionX: CGFloat?
    var positionY: CGFloat?
    
    init() {
        
        // Initialize whith RANDOM pic from array barriers.
        let texture = SKTexture(imageNamed: stations[Int(arc4random()%3)])
        positionX = positionsX[Int(arc4random()%8)]
        positionY = positionsY[Int(arc4random()%4)]
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        
        self.position.x = positionX!
        self.position.y = positionY!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(/*name: String,*/ texture: SKTexture) {
        self.init()
        
        //self.name = name
        self.texture = texture
        self.size = texture.size()
    }
    
    func rundomToPosition() -> CGPoint {
        var toPositionPoint: CGPoint
        if Int(positionX!) < 0 {
            toPositionPoint = toPositionRight[Int(arc4random()%4)]
        } else {
            toPositionPoint = toPositionLeft[Int(arc4random()%4)]
        }
        
        return toPositionPoint
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}     // class
