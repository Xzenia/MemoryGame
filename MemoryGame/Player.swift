//
//  Player.swift
//  MemoryGame
//
//  Created by Metis on 07/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

struct Player {
    
    var name: String
    
    var baseAttackStat: Float
    
    var baseDefenseStat: Float
    
    var maxHealth: Float
    
    var health: Float
    
    var attackStat: Float
    
    var defenseStat: Float
    
    var animationFrame: Int
    
    var attackAnimationFrame: Int
    
    init(_name: String, _baseAttackStat: Float, _baseDefenseStat: Float, _maxHealth: Float, _animationFrame: Int, _attackAnimationFrame: Int) {
        baseAttackStat = _baseAttackStat
        baseDefenseStat = _baseDefenseStat
        maxHealth = _maxHealth
        
        animationFrame = _animationFrame
        
        name = _name
        
        health = maxHealth
        attackStat = baseAttackStat
        defenseStat = baseDefenseStat
        
        attackAnimationFrame = _attackAnimationFrame
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
