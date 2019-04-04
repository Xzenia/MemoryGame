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
    
    public static var healthPotionActivated = false
    
    public var enemyList = [Enemy]()
    
    private var currentEnemyIndex = 0

    let rows: Int = 6
    let cols: Int = 6
    
    var grid : Grid!
    
    //UI Elements
    let background = SKSpriteNode(imageNamed: "grid_background")
    let healthBar = SKSpriteNode(imageNamed: "health_bar")
    let healthBarAmount = SKSpriteNode(imageNamed: "health_bar_amount")
    let goldCounterIcon = SKSpriteNode(imageNamed: "coin_icon")
    let goldCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    let enemyHealthBar = SKSpriteNode(imageNamed: "enemy_health_bar")
    let enemyHealthBarAmount = SKSpriteNode(imageNamed: "enemy_health_bar_amount")
    
    let potionButton = SKSpriteNode(imageNamed: "healing_tile_4")
    
    var chosenOffenseTile : Int = 0
    var chosenDefenseTile : Int = 0
    var chosenHealingTile : Int = 0
    
    var chosenTiles = [SKTexture]()
    
    var enemySprite = SKSpriteNode()
    
    public var playerStats: Player!
    public var enemyStats: Enemy!
    
    override func didMove(to view: SKView) {
        
        playerStats = CharacterSelection.selectedCharacter
        
        setupUI()
        setupCharacters()
        
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
            playerStats.revertToBaseValues()
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
        
        if (playerStats.health > 0){
            healthBarAmount.xScale = CGFloat(playerStats.health)/CGFloat(playerStats.maxHealth)
        } else if (playerStats.health <= 0){
            healthBarAmount.xScale = CGFloat(playerStats.health)/CGFloat(playerStats.maxHealth)
            GameScene.gameStarted = false
            print("Game over!")
        }
        
        if (enemyStats.health > 0){
            enemyHealthBarAmount.xScale = CGFloat(enemyStats.health)/CGFloat(enemyStats.maxHealth)
        } else if (enemyStats.health <= 0){
            enemyHealthBarAmount.xScale = CGFloat(enemyStats.health)/CGFloat(enemyStats.maxHealth)
            GameScene.gameStarted = false
            print ("You win!")
            
            enemySprite.removeFromParent()
            enemyList.remove(at: currentEnemyIndex)
            
            if (enemyList.count > 0){
                generateEnemies()
                GameScene.turns = 3
            } else {
                print("All enemies defeated!")
            }
        }
        
        goldCounterLabel.text = String(GameScene.gold)
    }
    
    func setupUI(){
        
        background.size.width = CGFloat(frame.size.width)
        background.size.height = CGFloat(frame.size.height)
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = 0
        addChild(background)
        
        healthBar.position = CGPoint(x: frame.size.width / 3.3, y: frame.size.height/2)
        healthBar.zPosition = 4
        addChild(healthBar)
        
        healthBarAmount.zPosition = 3
        healthBarAmount.xScale = CGFloat(playerStats.health) / CGFloat(playerStats.maxHealth)
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
        
        potionButton.zPosition = 3
        potionButton.position = CGPoint(x: healthBar.position.x * 3.07, y: goldCounterIcon.position.y - 50)
        addChild(potionButton)
    }
    
    func setupCharacters(){
        
        let playerSprite = SKSpriteNode(imageNamed: "spr_\(CharacterSelection.selectedCharacter.name)_idle_0")
        
        var playerSprites: [SKTexture] = []
        
        playerSprite.position = CGPoint(x: frame.size.width/5, y: frame.size.height - 150)
        playerSprite.zPosition = 5
        
        if (CharacterSelection.selectedCharacter.animationFrame > 1){
            for counter in 1...CharacterSelection.selectedCharacter.animationFrame {
                playerSprites.append(SKTexture(imageNamed: "spr_\(CharacterSelection.selectedCharacter.name)_idle_\(counter)"))
            }
            let playerSpriteAnimation = SKAction.animate(with: playerSprites, timePerFrame: 0.2)
            playerSprite.run(SKAction.repeatForever(playerSpriteAnimation))
        }
        
        addChild(playerSprite)
        
        
        enemyList = [Enemy]()
        enemyList.append(Enemies.byr)
        enemyList.append(Enemies.khyr)
        enemyList.append(Enemies.putulu)
        enemyList.append(Enemies.vair)
        
        generateEnemies()
        
        enemyHealthBar.position = CGPoint(x: frame.size.width/2, y: frame.size.height - 20)
        enemyHealthBar.zPosition = 4
        addChild(enemyHealthBar)
        
        enemyHealthBarAmount.zPosition = 3
        enemyHealthBarAmount.xScale = CGFloat(enemyStats.health) / CGFloat(enemyStats.maxHealth)
        enemyHealthBarAmount.position = CGPoint(x: frame.size.width/4.3, y: frame.size.height - 20)
        enemyHealthBarAmount.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(enemyHealthBarAmount)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if potionButton.contains(touch.location(in: self)){
                GameScene.healthPotionActivated = true
            }
        }
    }
    
    func playerTurnEnded(){
        for tile in GameScene.pairedTiles{
            let pairedTile = GameScene.tiles[Int(tile.name!)!]
            
            if (pairedTile.tileType == TileType.offense){
                switch pairedTile.effectId {
                case 0:
                    playerStats.increaseAttackStat(increase: 10)
                case 1:
                    playerStats.increaseAttackStat(increase: 20)
                case 2:
                    playerStats.increaseAttackStat(increase: 30)
                case 3:
                    playerStats.increaseAttackStat(increase: 40)
                default:
                    playerStats.increaseAttackStat(increase: 10)
                }
            }
            else if(pairedTile.tileType == TileType.defense){
                switch pairedTile.effectId {
                case 0:
                    playerStats.increaseDefenseStat(increase: 10)
                case 1:
                    playerStats.increaseDefenseStat(increase: 20)
                case 2:
                    playerStats.increaseDefenseStat(increase: 30)
                case 3:
                    playerStats.increaseDefenseStat(increase: 40)
                default:
                    playerStats.increaseDefenseStat(increase: 10)
                }
            }
            else if (pairedTile.tileType == TileType.healing){
                switch pairedTile.effectId {
                case 0:
                    playerStats.increaseHealth(increase: 10)
                case 1:
                    playerStats.increaseHealth(increase: 20)
                case 2:
                    playerStats.increaseHealth(increase: 30)
                case 3:
                    playerStats.increaseHealth(increase: 40)
                default:
                    playerStats.increaseHealth(increase: 10)
                }
            }
        }
    
        print("Player Attack Stat: \(playerStats.attackStat)")
        print("Player Defense Stat: \(playerStats.defenseStat)")
        
        enemyStats.health -= (playerStats.attackStat - (playerStats.attackStat * (enemyStats.defenseStat/100)))

        
        GameScene.turns = 3
        GameScene.pairedTiles = [SKNode]()
        GameScene.tiles = [Tile]()
        
        GameScene.chosenNode1 = nil
        GameScene.chosenNode2 = nil
    }
    
    func beginEnemyTurn(){
        playerStats.health -= (enemyStats.attackStat - (enemyStats.attackStat * (playerStats.defenseStat/100)))

    }
    
    func generateTiles(){
        var x = 1
        var counter = 0

        for _ in 0...2{
            chosenOffenseTile = Int(arc4random_uniform(UInt32(Tiles.offenseTiles.count)))
            chosenDefenseTile = Int(arc4random_uniform(UInt32(Tiles.defenseTiles.count)))
            chosenHealingTile = Int(arc4random_uniform(UInt32(Tiles.healingTiles.count)))
            
            chosenTiles.append(Tiles.offenseTiles[chosenOffenseTile])
            chosenTiles.append(Tiles.defenseTiles[chosenDefenseTile])
            
            if (GameScene.healthPotionActivated){
                chosenTiles.append(Tiles.healingTiles[chosenHealingTile])
            }
        }
        
        GameScene.healthPotionActivated = false

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
    
    func generateEnemies(){
    
        currentEnemyIndex = Int(arc4random_uniform(UInt32(enemyList.count)))
        
        enemyStats = enemyList[currentEnemyIndex]
        enemySprite = SKSpriteNode(imageNamed: "spr_\(enemyStats.enemyName)_idle_0")
        
        var enemyAnimationTextures = [SKTexture]()
        for counter in 1...enemyStats.animationFrames {
           enemyAnimationTextures.append(SKTexture(imageNamed: "spr_\(enemyStats.enemyName)_idle_\(counter)"))
        }
        
        let enemySpriteAnimation = SKAction.animate(with: enemyAnimationTextures, timePerFrame: 0.2)
        enemySprite.run(SKAction.repeatForever(enemySpriteAnimation))

        enemySprite.position = CGPoint(x: frame.size.width - 50, y: frame.size.height - 150)
        enemySprite.zPosition = 5
        
        addChild(enemySprite)

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
