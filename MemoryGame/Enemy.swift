//
//  Enemy.swift
//  MemoryGame
//
//  Created by Metis on 10/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class Enemy {
    
    var enemyName: String
    
    var baseAttackStat: Float
    
    var baseDefenseStat: Float
    
    var maxHealth: Float
    
    var health: Float
    
    var attackStat: Float
    
    var defenseStat: Float
    
    var idleAnimationFrames: Int
    
    var deathAnimationFrames: Int
    
    init(_enemyName: String, _baseAttackStat: Float, _baseDefenseStat: Float, _maxHealth: Float, _idleAnimationFrames: Int, _deathAnimationFrames: Int) {
        enemyName = _enemyName
        baseAttackStat = _baseAttackStat
        baseDefenseStat = _baseDefenseStat
        maxHealth = _maxHealth
        
        idleAnimationFrames = _idleAnimationFrames
        
        deathAnimationFrames = _deathAnimationFrames
        
        health = maxHealth
        attackStat = baseAttackStat
        defenseStat = baseDefenseStat
    }
    
}
