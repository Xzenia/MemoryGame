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
    var id: Int
    init (row: Int, col: Int, id: Int, tile: SKTexture){
        self.row = row
        self.col = col
        self.id = id
        self.tile = tile
    }
}
