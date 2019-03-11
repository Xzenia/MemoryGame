//
//  Enemy.swift
//  MemoryGame
//
//  Created by Metis on 10/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import Foundation
class Enemy {
    public static var enemyName = "Cacodemon"
    
    public static var baseAttackStat = Float(10)
    
    public static var baseDefenseStat = Float(5)
    
    public static var maxHealth = Float(150)
    
    public static var health = Float(150)
    
    public static var attackStat = Player.baseAttackStat
    
    public static var defenseStat = Player.baseDefenseStat
    
    public static func revertToBaseValues(){
        Enemy.attackStat = Enemy.baseAttackStat
        Enemy.defenseStat = Enemy.baseDefenseStat
    }
}
