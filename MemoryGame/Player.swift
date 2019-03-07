//
//  Player.swift
//  MemoryGame
//
//  Created by Metis on 07/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class Player {
    
    public static var health = Float(100)
    
    public static var baseAttackStat = Float(10)
    
    public static var baseDefenseStat = Float(5)
    
    public static var attackStat = Player.baseAttackStat
    
    public static var defenseStat = Player.baseDefenseStat
    
    public static func revertToBaseValues(){
        Player.attackStat = Player.baseAttackStat
        Player.defenseStat = Player.baseDefenseStat
    }
    
}
