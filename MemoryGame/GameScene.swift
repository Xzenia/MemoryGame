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
    
    let rows: Int = 5
    let cols: Int = 5
    
    var grid : Grid!
    
    var enemyDeathAnimationTextures = [SKTexture]()
    
    //UI Elements
    let background_lower = SKSpriteNode(imageNamed: "crystalCave_bottom")
    let background_upper = SKSpriteNode(imageNamed: "crystalCave_top")
    let healthBar = SKSpriteNode(imageNamed: "health_bar")
    let healthBarAmount = SKSpriteNode(imageNamed: "health_bar_amount")
    let goldCounterIcon = SKSpriteNode(imageNamed: "coin_icon")
    let goldCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    let enemyHealthBar = SKSpriteNode(imageNamed: "enemy_health_bar")
    let enemyHealthBarAmount = SKSpriteNode(imageNamed: "enemy_health_bar_amount")
    
    let potionButton = SKSpriteNode(imageNamed: "spr_potion_0")
    
    var enemySprite = SKSpriteNode()
    
    public var playerStats: Player!
    public var enemyStats: Enemy!
    
    var tapObject = SKSpriteNode(imageNamed: "tap_effect_0")
    var tapAnimation = SKAction()
    
    override func didMove(to view: SKView) {
        
        playerStats = CharacterSelection.selectedCharacter
        
        setupUI()
        setupCharacters()
        
        grid = Grid(blockSize: 40.0, rows:rows, cols:cols)!
        grid.position = CGPoint (x:frame.midX, y:frame.midY/2)
        grid.zPosition = 3
        
        setupGrid()
        addChild(grid)
        
        GameScene.chosenNode1 = nil
        GameScene.chosenNode2 = nil
        
        print("Turns: \(GameScene.turns)")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (GameScene.turns <= 0){
            playerTurnEnded()
            beginEnemyTurn()
            playerStats.revertToBaseValues()
            
            GameScene.pairedTiles = [SKNode]()
            GameScene.tiles = [Tile]()
            
            GameScene.chosenNode1 = nil
            GameScene.chosenNode2 = nil
            
            GameScene.gameStarted = false
            
            setupGrid()
            
            GameScene.turns = 3
        }
        
        if (playerStats.health > 0){
            healthBarAmount.xScale = CGFloat(playerStats.health)/CGFloat(playerStats.maxHealth)
        } else if (playerStats.health <= 0){
            healthBarAmount.xScale = 0/CGFloat(playerStats.maxHealth)
            GameScene.gameStarted = false
            print("Game over!")
        }
        
        if (enemyStats.health > 0){
            enemyHealthBarAmount.xScale = CGFloat(enemyStats.health)/CGFloat(enemyStats.maxHealth)
        } else if (enemyStats.health <= 0){
            enemyHealthBarAmount.xScale = 0/CGFloat(enemyStats.maxHealth)
        }
        
        goldCounterLabel.text = String(GameScene.gold)
    }
    
    func setupUI(){
        background_lower.size.width = CGFloat(frame.size.width)
        background_lower.size.height = CGFloat(frame.size.height)
        background_lower.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background_lower.zPosition = 0
        addChild(background_lower)
        
        background_upper.size.width = CGFloat(frame.size.width)
        background_upper.size.height = CGFloat(frame.size.height)
        background_upper.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background_upper.zPosition = 0
        addChild(background_upper)
        
        healthBar.position = CGPoint(x: frame.size.width / 3.3, y: frame.size.height/2)
        healthBar.zPosition = 4
        addChild(healthBar)
        
        healthBarAmount.zPosition = 3
        healthBarAmount.xScale = CGFloat(playerStats.health) / CGFloat(playerStats.maxHealth)
        healthBarAmount.position = CGPoint(x: frame.size.width / 25, y: frame.size.height/2)
        healthBarAmount.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(healthBarAmount)
        
        goldCounterIcon.zPosition = 3
        goldCounterIcon.position = CGPoint(x: frame.size.width/2 + 130, y: frame.size.height/2)
        addChild(goldCounterIcon)
        
        goldCounterLabel.zPosition = 3
        goldCounterLabel.position = CGPoint (x: frame.size.width/2 + 160, y: goldCounterIcon.position.y - 15)
        
        goldCounterLabel.text = String(GameScene.gold)
        goldCounterLabel.fontColor = UIColor.black
        addChild(goldCounterLabel)
        
        potionButton.zPosition = 3
        potionButton.position = CGPoint(x: healthBar.position.x * 2.98, y: goldCounterIcon.position.y - 50)
        addChild(potionButton)
        
        var tapAnimationTextures = [SKTexture]()
        
        for counter in 0...7{
            tapAnimationTextures.append(SKTexture(imageNamed: "tap_effect_\(counter)"))
        }
        tapObject.zPosition = 10
        tapAnimation = SKAction.animate(with: tapAnimationTextures, timePerFrame: 0.05)
        
        addChild(tapObject)
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
        
        initializeEnemies()
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
    
    func setupGrid(){
        generateTiles()
        generateGridContents(revealTiles: true)
        
        let wait = SKAction.wait(forDuration: 5)
        let run = SKAction.run {
            self.grid.removeAllChildren()
            self.generateGridContents(revealTiles: false)
            GameScene.gameStarted = true
        }
        self.run(SKAction.sequence([wait, run]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if potionButton.contains(touch.location(in: self)){
                GameScene.healthPotionActivated = true
            }
            let position = touch.location(in:self)
            tapObject.position = position
            tapObject.run(tapAnimation)
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
                
            else if (pairedTile.tileType == TileType.defense){
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
        
        if (enemyStats.health <= 0){
            GameScene.gameStarted = false
            print ("You win!")
            
            let enemyDeathSpriteAnimation = SKAction.animate (with: enemyDeathAnimationTextures, timePerFrame: 0.4)
            
            enemySprite.run(enemyDeathSpriteAnimation, completion: {
                self.enemySprite.removeFromParent()
                self.enemyList.remove(at: 0)
                
                if (self.enemyList.count > 0){
                    self.generateEnemies()
                } else {
                    print("All enemies defeated!")
                }
            })
        }
    }
    
    func beginEnemyTurn(){
        playerStats.health -= (enemyStats.attackStat - (enemyStats.attackStat * (playerStats.defenseStat/100)))
    }
    
    func generateTiles(){
        var x = 1
        var counter = 0
        
        var chosenTiles = [Tile]()

        for _ in 0...2{
            
            let chosenOffenseTile = Int(arc4random_uniform(UInt32(Tiles.offenseTiles.count - 1)))
            let chosenDefenseTile = Int(arc4random_uniform(UInt32(Tiles.defenseTiles.count - 1)))
            let chosenHealingTile = Int(arc4random_uniform(UInt32(Tiles.healingTiles.count - 1)))
            
            let offenseTile = Tile(row: 0, col: 0, id: 0, effectId: chosenOffenseTile, tileType: TileType.offense, tile: Tiles.offenseTiles[chosenOffenseTile])
            
            let defenseTile = Tile(row: 0, col: 0, id: 0, effectId: chosenDefenseTile, tileType: TileType.defense, tile: Tiles.defenseTiles[chosenDefenseTile])
            
            let healingTile = Tile(row: 0, col: 0, id: 0, effectId: chosenHealingTile, tileType: TileType.healing, tile: Tiles.healingTiles[chosenHealingTile])
            
            chosenTiles.append(offenseTile)
            chosenTiles.append(defenseTile)
            
            if (GameScene.healthPotionActivated){
                chosenTiles.append(healingTile)
            }
        }
        
        GameScene.healthPotionActivated = false
        
        while x <= rows {
            var y = 0
            while y < cols {
                let randomNum = Int(arc4random_uniform(UInt32(chosenTiles.count)))
            
                let tile = Tile(row: x-1, col: y, id: counter, effectId: chosenTiles[randomNum].effectId, tileType: chosenTiles[randomNum].tileType, tile: chosenTiles[randomNum].tile)
                
                GameScene.tiles.append(tile)
                
                counter = counter + 1
                y = y + 1
            }
            x = x + 1
        }
    }
    
    func initializeEnemies(){
        var tempList = [Enemy]()
        
        tempList.append(Enemies.byr)
        tempList.append(Enemies.khyr)
        tempList.append(Enemies.putulu)
        tempList.append(Enemies.vair)
        
        tempList.append(Enemies.duwende)
        tempList.append(Enemies.kapre)
        tempList.append(Enemies.manananggal)
        tempList.append(Enemies.tikbalang)
        
        tempList.append(Enemies.kyub)
        tempList.append(Enemies.kown)
        
        tempList.shuffle()
        
        let numberOfEnemies = Int(arc4random_uniform(8)) + 2
        
        for i in 0...numberOfEnemies - 1 {
            enemyList.append(tempList[Int(i)])
        }
        
        print("Number of Enemies: \(numberOfEnemies)")
        
        enemyList = sortList(_list: enemyList)
    }
    
    func generateEnemies(){
        enemyStats = enemyList[0]
        enemySprite = SKSpriteNode(imageNamed: "spr_\(enemyStats.enemyName)_idle_0")
        
        var enemyIdleAnimationTextures = [SKTexture]()
        
        for counter in 1...enemyStats.idleAnimationFrames {
            enemyIdleAnimationTextures.append(SKTexture(imageNamed: "spr_\(enemyStats.enemyName)_idle_\(counter)"))
        }
        
        enemyDeathAnimationTextures = [SKTexture]()
        
        for counter in 0...enemyStats.deathAnimationFrames {
            enemyDeathAnimationTextures.append(SKTexture(imageNamed: "spr_\(enemyStats.enemyName)_die_\(counter)"))
        }
        
        let enemyIdleSpriteAnimation = SKAction.animate(with: enemyIdleAnimationTextures, timePerFrame: 0.2)
        enemySprite.run(SKAction.repeatForever(enemyIdleSpriteAnimation))
        
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
}
