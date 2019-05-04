import SpriteKit

class GameScene: SKScene {
    
    public static var tiles = [Tile]()
    
    public static var pairedTiles = [SKNode]()
    
    public static var chosenNode1 : SKNode!
    public static var chosenNode2 : SKNode!
    
    public static var defaultTile : SKTexture! = SKTexture(imageNamed: "tile_0")
    
    public static var turns = 3
    
    public static var matches = 0
    
    public static var gameStarted = false
    
    public static var healthPotionActivated = false
    
    public var enemyList = [Enemy]()
    
    let rows: Int = 5
    let cols: Int = 5
    
    var grid : Grid!
    
    var enemyDeathAnimationTextures = [SKTexture]()
    
    //UI Elements
    let healthBar = SKSpriteNode(imageNamed: "health_bar")
    let healthBarAmount = SKSpriteNode(imageNamed: "health_bar_amount")
    let goldCounterIcon = SKSpriteNode(imageNamed: "spr_matches_0")
    let goldCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    let enemyHealthBar = SKSpriteNode(imageNamed: "enemy_health_bar")
    let enemyHealthBarAmount = SKSpriteNode(imageNamed: "enemy_health_bar_amount")
    
    let potionButton = SKSpriteNode(imageNamed: "spr_potion_0")
    
    let damageCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    var playerSprite = SKSpriteNode()
    
    var enemySprite = SKSpriteNode()
    
    public var playerStats: Player!
    public var enemyStats: Enemy!
    
    var tapObject = SKSpriteNode(imageNamed: "tap_effect_0")
    var tapAnimation = SKAction()

    let playerController = PlayerController()
    
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
        
        GameScene.matches = 0

    }
    
    override func update(_ currentTime: TimeInterval) {
        if (GameScene.turns <= 0){
            
            playerTurnEnded()
            playerStats.revertToBaseValues()
            
            GameScene.chosenNode1 = nil
            GameScene.chosenNode2 = nil
            
            GameScene.gameStarted = false
            
            self.setupGrid()
            
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

        goldCounterLabel.text = String(GameScene.matches)
    }
    
    func setupUI(){
        
        var background_lower = SKSpriteNode()
        var background_upper = SKSpriteNode()
        
        if (GameViewController.currentLevel == 0){
            background_lower = SKSpriteNode(imageNamed: "darkForest_bottom")
            background_upper = SKSpriteNode(imageNamed: "darkForest_top")
        }
        else if (GameViewController.currentLevel == 1){
            background_lower = SKSpriteNode(imageNamed: "crystalCave_bottom")
            background_upper = SKSpriteNode(imageNamed: "crystalCave_top")
        }
        else if (GameViewController.currentLevel == 2){
            background_lower = SKSpriteNode(imageNamed: "darkForest_bottom")
            background_upper = SKSpriteNode(imageNamed: "darkForest_top")
        }
        else {
            background_lower = SKSpriteNode(imageNamed: "darkForest_bottom")
            background_upper = SKSpriteNode(imageNamed: "darkForest_top")
        }
        
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
        
        healthBar.position = CGPoint(x: frame.size.width / 3, y: frame.size.height/2)
        healthBar.zPosition = 4
        addChild(healthBar)
        
        healthBarAmount.zPosition = 3
        healthBarAmount.xScale = CGFloat(playerStats.health) / CGFloat(playerStats.maxHealth)
        healthBarAmount.position = CGPoint(x: frame.size.width / 15, y: frame.size.height/2)
        healthBarAmount.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(healthBarAmount)
        
        goldCounterIcon.zPosition = 3
        goldCounterIcon.position = CGPoint(x: frame.size.width/2 + 115, y: frame.size.height/2)
        addChild(goldCounterIcon)
        
        goldCounterLabel.zPosition = 3
        goldCounterLabel.position = CGPoint (x: frame.size.width/2 + 153, y: goldCounterIcon.position.y - 15)
        goldCounterLabel.fontSize = 26
        goldCounterLabel.text = String(GameScene.matches)
        goldCounterLabel.fontColor = UIColor.black
        addChild(goldCounterLabel)
        
        potionButton.zPosition = 3
        potionButton.position = CGPoint(x: frame.size.width/2 + 150, y: frame.size.height/2 - 50)
        addChild(potionButton)
        
        var tapAnimationTextures = [SKTexture]()

        for counter in 0...7{
            tapAnimationTextures.append(SKTexture(imageNamed: "tap_effect_\(counter)"))
        }
        tapObject.zPosition = 10
        tapAnimation = SKAction.animate(with: tapAnimationTextures, timePerFrame: 0.05)
        
        addChild(tapObject)
        
        damageCounterLabel.fontSize = 12
        damageCounterLabel.zPosition = 10
        
        print("Current Level: \(GameViewController.currentLevel)")
    }
    
    func setupCharacters(){
        playerSprite = SKSpriteNode(imageNamed: "spr_\(CharacterSelection.selectedCharacter.name)_idle_0")
        
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
            
            if (pairedTile.tileType == TileType.Item){
                switch pairedTile.effectId {
                case 1:
                    playerStats.increaseHealth(increase: 10)
                case 2:
                    playerStats.increaseHealth(increase: 20)
                case 3:
                    playerStats.increaseHealth(increase: 30)
                case 4:
                    playerStats.increaseHealth(increase: 40)
                default:
                    playerStats.increaseHealth(increase: 10)
                }
            }
            else if (pairedTile.tileType == TileType.Move){
                let move = playerController.generateMove(pairedTile: pairedTile)
                print("Move name: \(move.name)")
                playerStats.increaseAttackStat(increase: move.attack)
                playerStats.increaseDefenseStat(increase: move.defense)
            }
        }
        
        print("Player Attack Stat: \(playerStats.attackStat)")
        print("Player Defense Stat: \(playerStats.defenseStat)")
        
        let damage = (playerStats.attackStat - (playerStats.attackStat * (enemyStats.defenseStat/100)))
        enemyStats.health -= damage
        
        damageCounterLabel.text = "\(damage)"
        damageCounterLabel.position = enemySprite.position
        addChild(damageCounterLabel)
        
        let wait = SKAction.wait(forDuration: 3)
        let run = SKAction.run {
            self.damageCounterLabel.removeFromParent()
            if (self.enemyStats.health <= 0){
                GameScene.gameStarted = false
                print ("You win!")
                
                let enemyDeathSpriteAnimation = SKAction.animate (with: self.enemyDeathAnimationTextures, timePerFrame: 0.4)
                
                self.enemySprite.run(enemyDeathSpriteAnimation, completion: {
                    self.enemySprite.removeFromParent()
                    self.enemyList.remove(at: 0)
                    
                    if (self.enemyList.count > 0){
                        self.generateEnemies()
                    } else {
                        let levelCompletionScene = LevelCompletionScene(size: (self.view?.bounds.size)!)
                        let transition = SKTransition.flipVertical(withDuration: 1.0)
                        levelCompletionScene.scaleMode = SKSceneScaleMode.aspectFill
                        self.view?.presentScene(levelCompletionScene, transition: transition)
                    }
                })
            }
        
        }
        self.run(SKAction.sequence([wait, run, SKAction.run{self.beginEnemyTurn()}]))
        
        GameScene.pairedTiles = [SKNode]()
        GameScene.tiles = [Tile]()
    }
    
    func beginEnemyTurn(){
        
        let damage = (enemyStats.attackStat - (enemyStats.attackStat * (playerStats.defenseStat/100)))
        playerStats.health -= damage
        damageCounterLabel.text = "\(damage)"
        damageCounterLabel.position = playerSprite.position
        addChild(damageCounterLabel)
        let wait = SKAction.wait(forDuration: 2)
        let run = SKAction.run {
            self.damageCounterLabel.removeFromParent()
        }
        self.run(SKAction.sequence([wait, run]))
        
    }
    
    func generateTiles(){
        var x = 1
        var counter = 0
        
        var chosenTiles = [Tile]()
        var characterTileArray = [SKTexture]()
        
        switch CharacterSelection.selectedCharacter.name {
        case "Shou":
            characterTileArray = Tiles.shouTiles
        case "Emily":
            characterTileArray = Tiles.emilyTiles
        case "Rikko":
            characterTileArray = Tiles.rikkouTiles
        default:
            print("GenerateTiles() switch case defaulted!")
            characterTileArray = Tiles.shouTiles
        }
    
        for counter in 1...4{
            
            let chosenHealingTile = Int(arc4random_uniform(UInt32(Tiles.healingTiles.count - 1))) + 1
            
            let moveTile = Tile(row: 0, col: 0, id: 0, effectId: counter, character: CharacterSelection.selectedCharacter.name, tile: characterTileArray[counter - 1], tileType: TileType.Move)
            let healingTile  = Tile(row: 0, col: 0, id: 0, effectId: chosenHealingTile, character: "", tile: Tiles.healingTiles[chosenHealingTile], tileType: TileType.Item)
            
            chosenTiles.append(moveTile)
            
            if (GameScene.healthPotionActivated){
                chosenTiles.append(healingTile)
            }
        }
        
        GameScene.healthPotionActivated = false
        
        while x <= rows {
            var y = 0
            while y < cols {
                let randomNum = Int(arc4random_uniform(UInt32(chosenTiles.count)))
                
                chosenTiles[randomNum].row = x - 1
                chosenTiles[randomNum].col = y
                chosenTiles[randomNum].id = counter
                GameScene.tiles.append(chosenTiles[randomNum])
                
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
 }
