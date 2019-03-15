//
//  Player.swift
//  MemoryGame
//
//  Created by Metis on 07/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

struct Player {
    
    var baseAttackStat: Float
    
    var baseDefenseStat: Float
    
    var maxHealth: Float
    
    var health: Float
    
    var attackStat: Float
    
    var defenseStat: Float
    
    
    init(_baseAttackStat: Float, _baseDefenseStat: Float, _maxHealth: Float) {
        baseAttackStat = _baseAttackStat
        baseDefenseStat = _baseDefenseStat
        maxHealth = _maxHealth
        
        health = maxHealth
        attackStat = baseAttackStat
        defenseStat = baseDefenseStat
        
    }
    
    mutating func revertToBaseValues(){
        attackStat = baseAttackStat
        defenseStat = baseDefenseStat
    }
    
    mutating func increaseAttackStat(increase: Float){
        attackStat += increase
    }
    
    mutating func increaseDefenseStat(increase: Float){
        defenseStat += increase
    }
    
    mutating func increaseHealth(increase: Float){
        health += increase
    }
}
