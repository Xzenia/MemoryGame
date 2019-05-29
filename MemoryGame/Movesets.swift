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
    public static let cleave = Move(_id: 1, _name: "Cleave" , _description: "Shou slashes at the enemy. Deals light damage.",_attack: 25)
    
    public static let lightningSlash = Move(_id: 2, _name: "Lightning Slash", _description: "Shou slashes at the enemy at lightning speed. Deals medium damage",_attack: 25)
    
    public static let powerSlash = Move(_id: 3, _name: "Power Slash", _description: "Shou slashes at the enemy with deadly force. Deals heavy damage", _attack: 25)
    
    public static let zanKei = Move(_id: 4, _name: "Zan-Kei", _description: "Shou uses an ancient technique to punish his enemy. Deals heavy damage", _attack: 25)
    
    //Rikko Movesets
    public static let agi = Move(_id: 5, _name: "Agi", _description: "Rikkou casts a burst of fire at the enemy. Deals light damage.", _attack: 20)
    
    public static let bufu = Move(_id: 6, _name: "Bufu", _description: "Rikkou casts a torrent of ice at the enemy. Deals light damage", _attack: 20)
    
    public static let zio = Move(_id: 7, _name: "Zio", _description: "Rikkou casts a lightning strike at the enemy. Slight chance of paralyzation to enemy. Deals light damage.", _attack: 20)
    
    public static let hama = Move(_id: 8, _name: "Hama", _description: "Rikkou casts rays of Holy Light at the enemy. Deals light damage.", _attack: 30)
    
    //Emily Movesets
    public static let arrowRain = Move(_id: 9, _name: "Arrow Rain", _description: "Emily unleashes a rain of arrows in quick succession. Deals light damage. ", _attack: 20)
    
    public static let frostShot = Move(_id: 10, _name: "Frost Shot", _description: "Emily shoots an arrow with a tip coated in Frostbite potion. Slight chance of paralyzation to enemy. Deals medium damage.", _attack: 20)
    
    public static let holyArrow = Move(_id: 11, _name: "Holy Arrow", _description: "Emily shoots an arrow blessed in the Temple of Amon'rah. Deals medium damage.", _attack: 20)
    
    public static let torrentShot = Move(_id: 12, _name: "Torrent Shot", _description: "Emily unleashes multiple high velocity arrows at the enemy in quick succession. Deals heavy damage.", _attack: 20)
    
    
    
}
