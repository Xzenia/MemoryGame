//
//  TileController.swift
//  MemoryGame
//
//  Created by Metis on 06/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class TileController {
    
    public static let offenseTiles = [SKTexture(imageNamed:"offense_tile_1"), SKTexture(imageNamed:"offense_tile_2"), SKTexture(imageNamed:"offense_tile_3"), SKTexture(imageNamed:"offense_tile_4")]
    
    public static let defenseTiles = [SKTexture(imageNamed:"defense_tile_1"), SKTexture(imageNamed:"defense_tile_2"), SKTexture(imageNamed:"defense_tile_3"), SKTexture(imageNamed:"defense_tile_4")]
    
    public static let healingTiles = [SKTexture(imageNamed:"healing_tile_1"), SKTexture(imageNamed:"healing_tile_2"), SKTexture(imageNamed:"healing_tile_3"), SKTexture(imageNamed:"healing_tile_4")]
    
    
    public static func increaseAttackStat(increase: Float){
        Player.attackStat = Player.baseAttackStat + increase
    }
    
    public static func increaseDefenseStat(increase: Float){
        Player.defenseStat = Player.baseDefenseStat + increase
    }
    
    public static func increasePlayerHealth (increase: Float){
        Player.health += increase
    }
    

    
}