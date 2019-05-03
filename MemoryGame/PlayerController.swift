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
        
        return playerMove
    }
}

func sortList(_list: [Enemy]) -> [Enemy]{
    var beginningIndex = 0
    var endingIndex = _list.count - 1
    
    var list = _list
    
    //Decreases the amount of comparisons that insertion sort has to do.
    while beginningIndex < endingIndex{
        if ((list[beginningIndex].attackStat + list[endingIndex].defenseStat) > (list[beginningIndex].attackStat + list[endingIndex].defenseStat)){
            let temp = list[beginningIndex]
            list[beginningIndex] = list[endingIndex]
            list[endingIndex] = temp
        }
        beginningIndex = beginningIndex + 1
        endingIndex = endingIndex - 1
    }
    
    //Insertion Sort
    for j in 1...list.count - 1 {
        let key = list[j].attackStat + list[j].defenseStat
        var i = j - 1
        
        while(i >= 0 && (list[j].attackStat + list[j].defenseStat) > key){
            list[i + 1] = list[i]
            i = i - 1
        }
        
        list[i + 1] = list[j]
    }
    return list
}

