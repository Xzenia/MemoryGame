//
//  Tile.swift
//  Test Project
//
//  Created by Metis on 21/02/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import Foundation
import SpriteKit

class Tile {
    var row : Int
    var col : Int
    var tile : SKTexture
    var effectId: Int
    var tileType: TileType
    var id: Int
    
    init (row: Int, col: Int, id: Int, effectId: Int, tileType: TileType, tile: SKTexture){
        self.row = row
        self.col = col
        self.id = id
        self.effectId = effectId
        self.tileType = tileType
        self.tile = tile
    }
}
