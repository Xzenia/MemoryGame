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
        
        if (pairedTile.character == "Shou"){
            switch pairedTile.effectId {
            case 1:
                playerMove = Movesets.cleave
            case 2:
                playerMove = Movesets.lightningSlash
            case 3:
                playerMove = Movesets.powerSlash
            case 4:
                playerMove = Movesets.zanKei
            default:
                print("GenerateMove() defaulted!")
                playerMove = Movesets.cleave
            }
        }
        
        else if (pairedTile.character == "Rikko"){
            switch pairedTile.effectId{
            case 1:
                playerMove = Movesets.agi
            case 2:
                playerMove = Movesets.bufu
            case 3:
                playerMove = Movesets.zio
            case 4:
                playerMove = Movesets.hama
            default:
                print("GenerateMove() defaulted!")
                playerMove = Movesets.agi
            }
        }
        
        else if (pairedTile.character == "Emily"){
            switch pairedTile.effectId{
            case 1:
                playerMove = Movesets.arrowRain
            case 2:
                playerMove = Movesets.frostShot
            case 3:
                playerMove = Movesets.holyArrow
            case 4:
                playerMove = Movesets.torrentShot
            default:
                print("GenerateMove() defaulted!")
                playerMove = Movesets.arrowRain

            }
        }
        return playerMove
    }
}

func sortList(_list: [Enemy]) -> [Enemy]{
    var beginningIndex = 0
    var endingIndex = _list.count - 1
    
    var list = _list
    
    //Decreases the amount of comparisons that insertion sort has to do.
    while beginningIndex < endingIndex{
        if ((list[beginningIndex].baseAttackStat + list[beginningIndex].baseDefenseStat) > (list[endingIndex].baseAttackStat + list[endingIndex].baseDefenseStat)){
            let temp = list[beginningIndex]
            list[beginningIndex] = list[endingIndex]
            list[endingIndex] = temp
        }
        beginningIndex = beginningIndex + 1
        endingIndex = endingIndex - 1
    }
    
    //Insertion Sort
    for i in 1...list.count - 1 {
        let key = list[i]
        var j = i - 1
        
        while(j >= 0 && (list[j].baseAttackStat + list[j].baseDefenseStat) > (key.baseAttackStat + key.baseDefenseStat)){
            list[j + 1] = list[j]
            j = j - 1
        }
        list[j + 1] = key
    }
    return list
}

