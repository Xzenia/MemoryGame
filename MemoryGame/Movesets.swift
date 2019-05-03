//
//  Movesets.swift
//  MemoryGame
//
//  Created by Student on 26/04/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import Foundation

public class Movesets{
    
    //Shou Movesets
    public static let cleave = Move(_id: 1, _name: "Cleave" , _description: "Shou slashes at the enemy. Deals light damage.",_attack: 25, _defense: 0)
    public static let lightningSlash = Move(_id: 2, _name: "Lightning Slash", _description: "Shou slashes at the enemy at lightning speed. Deals medium damage",_attack: 25, _defense: 0)
    public static let powerSlash = Move(_id: 3, _name: "Power Slash", _description: "Shou slashes at the enemy with deadly force. Deals heavy damage", _attack: 25, _defense: 0)
    public static let zanKei = Move(_id: 4, _name: "Zan-Kei", _description: "Shou uses an ancient technique to punish his enemy. Deals heavy damage", _attack: 25, _defense: 0)
    
    //Rikko Movesets
    public static let agi = Move(_id: 5, _name: "Agi", _description: "Rikkou casts a burst of fire at the enemy. Deals light damage.", _attack: 20, _defense: 0)
    
    public static let bufu = Move(_id: 6, _name: "Bufu", _description: "Rikkou casts a torrent of ice at the enemy. Deals light damage", _attack: 20, _defense: 0)
    
    public static let zio = Move(_id: 7, _name: "Zio", _description: "Rikkou casts a lightning strike at the enemy. Slight chance of paralyzation to enemy. Deals light damage.", _attack: 20, _defense: 0)
    
    public static let hama = Move(_id: 8, _name: "Hama", _description: "Rikkou casts rays of Holy Light at the enemy. Deals light damage.", _attack: 30, _defense: 0)
    
}
