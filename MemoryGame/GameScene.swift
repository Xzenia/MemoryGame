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
    
    public static var turns = 3
    
    public static var gold = 0
    
    public static var health = CGFloat(100)
    
    public static var gameStarted = false
    
    let rows: Int = 5
    let cols: Int = 5
    
    var grid : Grid!
    
    //UI Elements
    let background = SKSpriteNode(imageNamed: "grid_background")
    let healthBar = SKSpriteNode(imageNamed: "health_bar")
    let healthBarAmount = SKSpriteNode(imageNamed: "health_bar_amount")
    let goldCounterIcon = SKSpriteNode(imageNamed: "coin_icon")
    let goldCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    override func didMove(to view: SKView) {
        
        setupUI()
    
        grid = Grid(blockSize: 40.0, rows:rows, cols:cols)!
        grid.position = CGPoint (x:frame.midX, y:frame.midY/2)
        grid.zPosition = 3
        
        generateTiles()
        addChild(grid)
        
        generateGridContents(revealTiles: true)
        
        let wait = SKAction.wait(forDuration: 5)
        let run = SKAction.run {
            self.grid.removeAllChildren()	
            self.generateGridContents(revealTiles: false)
            GameScene.gameStarted = true
        }
        self.run(SKAction.sequence([wait, run]))
        
        GameScene.chosenNode1 = nil
        GameScene.chosenNode2 = nil
        
        print("Turns: \(GameScene.turns)")
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (GameScene.turns <= 0){
            
            playerTurnEnded()
            generateTiles()
            generateGridContents(revealTiles: true)
            
            GameScene.gameStarted = false
            let wait = SKAction.wait(forDuration: 5)
            let run = SKAction.run {
                self.generateGridContents(revealTiles: false)
                GameScene.gameStarted = true
            }
            self.run(SKAction.sequence([wait, run]))
        }
        
        if (GameScene.health > 0){
            healthBarAmount.xScale = GameScene.health/100
        }
        goldCounterLabel.text = String(GameScene.gold)
    }
    
    func setupUI(){
        
        background.size.width = CGFloat(frame.size.width)
        background.size.height = CGFloat(frame.size.height)
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 10)
        background.zPosition = 0
        addChild(background)
        
        healthBar.position = CGPoint(x: frame.size.width / 3.3, y: frame.size.height/2)
        healthBar.zPosition = 4
        addChild(healthBar)
        
        healthBarAmount.zPosition = 3
        healthBarAmount.xScale = GameScene.health/100
        healthBarAmount.position = CGPoint(x: frame.size.width / 25, y: frame.size.height/2)
        healthBarAmount.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(healthBarAmount)
        
        goldCounterIcon.zPosition = 3
        goldCounterIcon.position = CGPoint(x: healthBar.position.x * 2.8, y: frame.size.height/2)
        addChild(goldCounterIcon)
        
        goldCounterLabel.zPosition = 3
        goldCounterLabel.position = CGPoint (x: healthBar.position.x * 3.07, y: goldCounterIcon.position.y - 15)
        
        goldCounterLabel.text = String(GameScene.gold)
        goldCounterLabel.fontColor = UIColor.black
        addChild(goldCounterLabel)
    }
    
    
    func playerTurnEnded(){
        let action = SKAction.setTexture(GameScene.defaultTile)
        for tile in GameScene.pairedTiles{
            tile.run(action)
        }
        
        GameScene.turns = 3
        GameScene.pairedTiles = [SKNode]()
        GameScene.tiles = [Tile]()
        
        GameScene.chosenNode1 = nil
        GameScene.chosenNode2 = nil
        
        grid.removeAllChildren()
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
                tileSprite.zPosition = 3
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
