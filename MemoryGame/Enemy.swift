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
    
    var animationFrames: Int
    
    init(_enemyName: String, _baseAttackStat: Float, _baseDefenseStat: Float, _maxHealth: Float, _animationFrames: Int) {
        enemyName = _enemyName
        baseAttackStat = _baseAttackStat
        baseDefenseStat = _baseDefenseStat
        maxHealth = _maxHealth
        
        animationFrames = _animationFrames
        
        health = maxHealth
        attackStat = baseAttackStat
        defenseStat = baseDefenseStat
    }
    
}
