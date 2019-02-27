//
//  GameScene.swift
//  Test Project
//
//  Created by Metis on 12/02/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    public static let tileSpriteList = [SKTexture(imageNamed: "tile_1"), SKTexture(imageNamed: "tile_6"), SKTexture(imageNamed: "tile_10"), SKTexture(imageNamed: "tile_15")]
    
    public static var tiles = [Tile]()
    
    public static var pairedTiles = [SKNode]()
    
    public static var chosenNode1 : SKNode!
    public static var chosenNode2 : SKNode!
    
    public static var defaultTile : SKTexture! = SKTexture(imageNamed: "tile_0")
    
    let rows: Int = 5
    let cols: Int = 5
    
    var grid : Grid!
    
    override func didMove(to view: SKView) {
        
        grid = Grid(blockSize: 40.0, rows:rows, cols:cols)!
        grid.position = CGPoint (x:frame.midX, y:frame.midY)
        generateTiles()
        addChild(grid)
        
        generateGridContents(revealTiles: true)
        
        let wait = SKAction.wait(forDuration: 5)
        let run = SKAction.run {
            self.grid.removeAllChildren()
            self.generateGridContents(revealTiles: false)
        }
        self.run(SKAction.sequence([wait, run]))
        
        //set the static nodes to default names
        GameScene.chosenNode1 = nil
        GameScene.chosenNode2 = nil
    }
    
    func generateTiles(){
        var x = 1
        var counter = 0
        
        while x <= rows {
            var y = 0
            while y < cols {
                let tile = Tile(row: x-1, col: y, id: counter, tile: GameScene.tileSpriteList[Int(arc4random_uniform(UInt32(GameScene.tileSpriteList.count)))])
                GameScene.tiles.append(tile)
                counter = counter + 1
                y = y + 1
            }
            x = x + 1
        }
    }
    
    func generateGridContents(revealTiles: Bool){
        var x = 1
        var counter = 0
        while x <= rows {
            var y = 0
            while y < cols {
                let tileSprite: SKSpriteNode!
                
                if (revealTiles){
                    tileSprite = SKSpriteNode(texture: GameScene.tiles[counter].tile)
                } else {
                    tileSprite = SKSpriteNode(texture: GameScene.defaultTile)
                }
                
                tileSprite.setScale(1)
                tileSprite.position = grid.gridPosition(row: x-1, col: y)
                grid.addChild(tileSprite)
                
                tileSprite.name = String(counter)
                
                counter = counter + 1
                y = y + 1
            }
            x = x + 1
        }
    }
}
