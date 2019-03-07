//
//  GameScene.swift
//  Test Project
//
//  Created by Metis on 12/02/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    public static var tiles = [Tile]()
    
    public static var pairedTiles = [SKNode]()
    
    public static var chosenNode1 : SKNode!
    public static var chosenNode2 : SKNode!
    
    public static var defaultTile : SKTexture! = SKTexture(imageNamed: "tile_0")
    
    public static var turns = 3
    
    public static var gold = 0
    
    public static var gameStarted = false
    
    public static var enemyHealth = Float(100)
    public static var enemyAttackStat = Float(15)
    public static var enemyDefenseStat = Float(8)
        
    let rows: Int = 5
    let cols: Int = 5
    
    var grid : Grid!
    
    //UI Elements
    let background = SKSpriteNode(imageNamed: "grid_background")
    let healthBar = SKSpriteNode(imageNamed: "health_bar")
    let healthBarAmount = SKSpriteNode(imageNamed: "health_bar_amount")
    let goldCounterIcon = SKSpriteNode(imageNamed: "coin_icon")
    let goldCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    let enemyHealthBar = SKSpriteNode(imageNamed: "enemy_health_bar")
    let enemyHealthBarAmount = SKSpriteNode(imageNamed: "enemy_health_bar_amount")
    
    
    var chosenOffenseTile : Int = 0
    var chosenDefenseTile : Int = 0
    var chosenHealingTile : Int = 0
    
    var chosenTiles = [SKTexture]()
    
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
            beginEnemyTurn()
            Player.revertToBaseValues()
            generateTiles()
            generateGridContents(revealTiles: true)
            
            GameScene.gameStarted = false
            
            let wait = SKAction.wait(forDuration: 3)
            let run = SKAction.run {
                self.generateGridContents(revealTiles: false)
                GameScene.gameStarted = true
            }
            self.run(SKAction.sequence([wait, run]))
        }
        
        if (Player.health > 0){
            healthBarAmount.xScale = CGFloat(Player.health)/100
        } else {
            GameScene.gameStarted = false
            print("Game over!")
        }
        
        if (GameScene.enemyHealth > 0){
            enemyHealthBarAmount.xScale = CGFloat(GameScene.enemyHealth)/100
        } else {
            GameScene.gameStarted = true
            print ("You win!")
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
        healthBarAmount.xScale = CGFloat(Player.health) / CGFloat(Player.health)
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
        
        enemyHealthBar.position = CGPoint(x: frame.size.width/2, y: frame.size.height - 20)
        enemyHealthBar.zPosition = 4
        addChild(enemyHealthBar)
        
        enemyHealthBarAmount.zPosition = 3
        enemyHealthBarAmount.xScale = CGFloat(GameScene.enemyHealth) / CGFloat(GameScene.enemyHealth)
        enemyHealthBarAmount.position = CGPoint(x: frame.size.width/4.3, y: frame.size.height - 20)
        enemyHealthBarAmount.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(enemyHealthBarAmount)
    }
    
    
    func playerTurnEnded(){
        
        for tile in GameScene.pairedTiles{
            let pairedTile = GameScene.tiles[Int(tile.name!)!]
            
            if (pairedTile.tileType == TileType.offense){
                switch pairedTile.effectId {
                case 0:
                    TileController.increaseAttackStat(increase: 10)
                case 1:
                    TileController.increaseAttackStat(increase: 20)
                case 2:
                    TileController.increaseAttackStat(increase: 30)
                case 3:
                    TileController.increaseAttackStat(increase: 40)
                default:
                    TileController.increaseAttackStat(increase: 10)
                }
            }
            else if(pairedTile.tileType == TileType.defense){
                switch pairedTile.effectId {
                case 0:
                    TileController.increaseDefenseStat(increase: 10)
                case 1:
                    TileController.increaseDefenseStat(increase: 20)
                case 2:
                    TileController.increaseDefenseStat(increase: 30)
                case 3:
                    TileController.increaseDefenseStat(increase: 40)
                default:
                    TileController.increaseDefenseStat(increase: 10)
                }
            }
            else if (pairedTile.tileType == TileType.healing){
                switch pairedTile.effectId {
                case 0:
                    TileController.increasePlayerHealth(increase: 10)
                case 1:
                    TileController.increasePlayerHealth(increase: 20)
                case 2:
                    TileController.increasePlayerHealth(increase: 30)
                case 3:
                    TileController.increasePlayerHealth(increase: 40)
                default:
                    TileController.increasePlayerHealth(increase: 10)
                }
            }
        }
        print("Player attack stat: \(Player.attackStat)")
        print("Player defense stat: \(Player.defenseStat)")
        
        GameScene.enemyHealth -= (Player.attackStat * (GameScene.enemyDefenseStat/100))
        
        let action = SKAction.setTexture(GameScene.defaultTile)
        for tile in GameScene.pairedTiles{
            tile.run(action)
        }
        
        GameScene.turns = 3
        GameScene.pairedTiles = [SKNode]()
        GameScene.tiles = [Tile]()
        
        GameScene.chosenNode1 = nil
        GameScene.chosenNode2 = nil
        
    }
    
    func beginEnemyTurn(){
        Player.health -= (GameScene.enemyAttackStat * (Player.defenseStat/100))
    }
    
    
    func generateTiles(){
        var x = 1
        var counter = 0

        chosenOffenseTile = Int(arc4random_uniform(UInt32(TileController.offenseTiles.count)))
        chosenDefenseTile = Int(arc4random_uniform(UInt32(TileController.defenseTiles.count)))
        chosenHealingTile = Int(arc4random_uniform(UInt32(TileController.healingTiles.count)))
        
        chosenTiles = [TileController.offenseTiles[chosenOffenseTile], TileController.defenseTiles[chosenDefenseTile], TileController.healingTiles[chosenHealingTile]]
        
        while x <= rows {
            var y = 0
            while y < cols {
                let randomNum = Int(arc4random_uniform(UInt32(chosenTiles.count)))
                
                var effectId : Int
                var tileType: TileType
                
                switch randomNum {
                case 0:
                    effectId = chosenOffenseTile
                    tileType = TileType.offense
                case 1:
                    effectId = chosenDefenseTile
                    tileType = TileType.defense
                case 2:
                    effectId = chosenHealingTile
                    tileType = TileType.healing
                default:
                    effectId = 0
                    tileType = TileType.offense
                }
                
                let tile = Tile(row: x-1, col: y, id: counter, effectId: effectId, tileType: tileType, tile: chosenTiles[randomNum])
                
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
        
        var tileSprite: SKSpriteNode!
        
        grid.removeAllChildren()
        
        while x <= rows {
            var y = 0
            while y < cols {
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
