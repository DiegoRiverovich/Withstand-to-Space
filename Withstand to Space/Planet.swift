//
//  Planet.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 11.10.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit
import SpriteKit

class Planet: SKSpriteNode {

    let planets = ["asteroidCloud", "galaxy01", "meteorit300", "planet01_400", "planet02_300"]
    let positions: [CGFloat] = [1536 * 0.20, 1536 * 0.40, 1536 * 0.60, 1536 * 0.80,]
    
    init() {
        
        // Initialize whith RANDOM pic from array barriers.
        let texture = SKTexture(imageNamed: planets[Int(arc4random()%5)])
        let position = positions[Int(arc4random()%4)]
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        
        self.position.x = position
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}     // class
