//
//  PlayerController.swift
//  MemoryGame
//
//  Created by Student on 26/04/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import Foundation

public class PlayerController{
    
    func generateMove(pairedTile: Tile) -> Move{
        var playerMove: Move = Movesets.cleave
        for _ in GameScene.pairedTiles{
            if (pairedTile.tileType == TileType.offense){
                switch pairedTile.effectId {
                case 0:
                    playerMove = Movesets.cleave
                case 1:
                    playerMove = Movesets.lightningSlash
                case 2:
                    playerMove = Movesets.powerSlash
                case 3:
                    playerMove = Movesets.zanKei
                default:
                    playerMove = Movesets.cleave
                }
            }
        }
        return playerMove
    }
}
