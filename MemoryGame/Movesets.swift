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
    public static let cleave = Move(_id: 1, _name: "Cleave", _type: MoveType.Offense, _description: "Shou slashes at the enemy. Deals light damage.")
    public static let lightningSlash = Move(_id: 2, _name: "Lightning Slash", _type: MoveType.Offense, _description: "Shou slashes at the enemy at lightning speed. Deals medium damage")
    public static let powerSlash = Move(_id: 3, _name: "Power Slash", _type: MoveType.Offense, _description: "Shou slashes at the enemy with deadly force. Deals heavy damage")
    public static let zanKei = Move(_id: 4, _name: "Zan-Kei", _type: MoveType.Offense, _description: "Shou uses an ancient technique to punish his enemy. Deals heavy damage")
    
}
