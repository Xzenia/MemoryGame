import SpriteKit

class GameScene: SKScene {
    
    public static var tiles: [Tile]!
    
    public static var pairedTiles: [SKNode]!
    
    public static var defaultTile : SKTexture! = SKTexture(imageNamed: "tile_0")
    
    public static var turns = 3
    
    public static var matches = 0
    
    public static var gameStarted = false
    
    public static var healthPotionActivated = false
    
    public static var potionCount = 3
    
    public var enemyList: [Enemy]!
    
    let rows: Int = 5
    let cols: Int = 5
    
    var grid : Grid!
    
    var enemyDeathAnimationTextures = [SKTexture]()
    
    var playerAttackAnimation = SKAction()
    //UI Elements
    let healthBar = SKSpriteNode(imageNamed: "health_bar")
    let healthBarAmount = SKSpriteNode(imageNamed: "health_bar_amount")
    let goldCounterIcon = SKSpriteNode(imageNamed: "spr_matches_0")
    let goldCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    let enemyHealthBar = SKSpriteNode(imageNamed: "enemy_health_bar")
    let enemyHealthBarAmount = SKSpriteNode(imageNamed: "enemy_health_bar_amount")
    
    let potionCountLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    let potionButton = SKSpriteNode(imageNamed: "spr_potion_0")
    
    let damageCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    var playerSprite = SKSpriteNode()
    
    var enemySprite = SKSpriteNode()
    
    var playerStats: Player! = nil
    var enemyStats: Enemy! = nil
    
    var tapObject = SKSpriteNode(imageNamed:"tap_effect_0")
    var tapAnimation = SKAction()
    
    let attackNameFrame = SKSpriteNode(imageNamed: "Attack_Name_Frame")
    var attackNameLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    let playerController = PlayerController()
    //Sound
    let backgroundMusic = SKAudioNode(fileNamed: "Mus_ChaosTheory.mp3")
    let hurtSound = SKAction.playSoundFileNamed("Hurt.wav", waitForCompletion: false)
    let normalAttackSound = SKAction.playSoundFileNamed("SpellAttack.wav", waitForCompletion: false)
    let magicAttackSound = SKAction.playSoundFileNamed("MagicAttack.wav", waitForCompletion: false)
    let enemyAttackSound = SKAction.playSoundFileNamed("EnemyDamage.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        playerStats = CharacterSelection.selectedCharacter
        
        GameScene.tiles = [Tile]()
        GameScene.pairedTiles = [SKNode]()
        
        setupUI()
        setupCharacters()
        
        grid = Grid(blockSize: 50, rows:rows, cols:cols)!
        grid.position = CGPoint (x:frame.midX - 38, y:frame.midY/2)
        grid.zPosition = 3
        
        setupGrid()
        addChild(grid)
        
        Grid.chosenPairs.removeAll()
        
        GameScene.matches = 0
        GameScene.potionCount = 3
        
        scene?.scaleMode = SKSceneScaleMode.resizeFill
        
        addChild(backgroundMusic)
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
            background_lower = SKSpriteNode(imageNamed: "templeOfXartha_bottom")
            background_upper = SKSpriteNode(imageNamed: "templeOfXartha_top")
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
        
        healthBar.position = CGPoint(x: frame.size.width / 3.2, y: frame.size.height/2)
        healthBar.zPosition = 4
        addChild(healthBar)
        
        healthBarAmount.zPosition = 3
        healthBarAmount.xScale = CGFloat(playerStats.health) / CGFloat(playerStats.maxHealth)
        healthBarAmount.position = CGPoint(x: frame.size.width / 14, y: frame.size.height/2)
        healthBarAmount.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        addChild(healthBarAmount)
        
        goldCounterIcon.zPosition = 3
        goldCounterIcon.position = CGPoint(x: frame.size.width/1.25, y: frame.size.height/2)
        addChild(goldCounterIcon)
        
        goldCounterLabel.zPosition = 3
        goldCounterLabel.position = CGPoint (x: frame.size.width/1.10, y: frame.size.height/2.08)
        goldCounterLabel.fontSize = 26
        goldCounterLabel.text = String(GameScene.matches)
        goldCounterLabel.fontColor = UIColor.white
        addChild(goldCounterLabel)
        
        potionButton.zPosition = 3
        potionButton.position = CGPoint(x: frame.size.width/1.12, y: frame.size.height/2.5)
        addChild(potionButton)
        
        potionCountLabel.zPosition = 3
        potionCountLabel.position = CGPoint(x: potionButton.position.x - 20, y: potionButton.position.y + 20)
        potionCountLabel.text = "\(GameScene.potionCount)"
        potionCountLabel.fontSize = 18
        potionCountLabel.color = UIColor.white
        addChild(potionCountLabel)
        
        var tapAnimationTextures = [SKTexture]()
        
        for counter in 0...7{
            tapAnimationTextures.append(SKTexture(imageNamed: "tap_effect_\(counter)"))
        }
        tapObject.zPosition = 10
        tapAnimation = SKAction.animate(with: tapAnimationTextures, timePerFrame: 0.05)
        
        addChild(tapObject)
        
        damageCounterLabel.fontSize = 12
        damageCounterLabel.zPosition = 10
        damageCounterLabel.fontColor = UIColor.white
    }
    
    func setupCharacters(){
        playerSprite = SKSpriteNode(imageNamed: "spr_\(CharacterSelection.selectedCharacter.name)_idle_0")
        
        var playerSprites: [SKTexture] = []
        var playerAttackSprites = [SKTexture]()
        
        playerSprite.position = CGPoint(x: frame.size.width/5, y: frame.size.height/1.35)
        playerSprite.zPosition = 5
        
        for counter in 1...CharacterSelection.selectedCharacter.animationFrame {
            playerSprites.append(SKTexture(imageNamed: "spr_\(CharacterSelection.selectedCharacter.name)_idle_\(counter)"))
        }
        let playerSpriteAnimation = SKAction.animate(with: playerSprites, timePerFrame: 0.1)
        playerSprite.run(SKAction.repeatForever(playerSpriteAnimation))
        
        for counter in 0...CharacterSelection.selectedCharacter.attackAnimationFrame{
            playerAttackSprites.append(SKTexture(imageNamed: "spr_\(CharacterSelection.selectedCharacter.name)_Special_\(counter)"))
        }
        
        playerAttackAnimation = SKAction.animate(with: playerAttackSprites, timePerFrame: 0.1)
        
        addChild(playerSprite)
        
        initializeEnemies()
        generateEnemies()
        
        enemyHealthBar.position = CGPoint(x: frame.size.width/2.1, y: frame.size.height - 20)
        enemyHealthBar.zPosition = 4
        addChild(enemyHealthBar)
        
        enemyHealthBarAmount.zPosition = 3
        enemyHealthBarAmount.xScale = CGFloat(enemyStats.health) / CGFloat(enemyStats.maxHealth)
        enemyHealthBarAmount.position = CGPoint(x: enemyHealthBar.position.x/2.05, y: enemyHealthBar.position.y)
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
    
    override func update(_ currentTime: TimeInterval) {
        if (GameScene.turns <= 0){
            playerTurnEnded()
            playerStats.revertToBaseValues()
            
            Grid.chosenPairs.removeAll()
            
            GameScene.gameStarted = false
            
            self.setupGrid()
            
            GameScene.turns = 3
        }
        
        if (playerStats.health > 0){
            if (playerStats.health > playerStats.maxHealth){
                healthBarAmount.xScale = CGFloat(playerStats.maxHealth)/CGFloat(playerStats.maxHealth)
            } else {
                healthBarAmount.xScale = CGFloat(playerStats.health)/CGFloat(playerStats.maxHealth)
            }
        } else if (playerStats.health <= 0){
            healthBarAmount.xScale = 0/CGFloat(playerStats.maxHealth)
            GameScene.gameStarted = false
        }
        
        if (enemyStats.health > 0){
            enemyHealthBarAmount.xScale = CGFloat(enemyStats.health)/CGFloat(enemyStats.maxHealth)
        } else if (enemyStats.health <= 0){
            enemyHealthBarAmount.xScale = 0/CGFloat(enemyStats.maxHealth)
        }
        
        potionCountLabel.text = String(GameScene.potionCount)
        goldCounterLabel.text = String(GameScene.matches)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if potionButton.contains(touch.location(in: self)){
                if (!GameScene.healthPotionActivated && GameScene.potionCount > 0){
                    GameScene.healthPotionActivated = true
                    GameScene.potionCount = GameScene.potionCount - 1
                }
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
                    playerStats.increaseHealth(increase: 30)
                case 2:
                    playerStats.increaseHealth(increase: 20)
                case 3:
                    GameScene.potionCount = GameScene.potionCount + 1
                default:
                    playerStats.increaseHealth(increase: 50)
                }
            }
            else if (pairedTile.tileType == TileType.Move){
                let move = playerController.generateMove(pairedTile: pairedTile)
                playerStats.increaseAttackStat(increase: move.attack)
                playerStats.increaseDefenseStat(increase: move.defense)
            }
        }
        
        let damage = (playerStats.attackStat - (playerStats.attackStat * (enemyStats.defenseStat/100)))
        
        let wait = SKAction.wait(forDuration: 1.5)
        let run = SKAction.run {
            self.damageCounterLabel.removeFromParent()
            if (self.enemyStats.health <= 0){
                GameScene.gameStarted = false
                let enemyDeathSpriteAnimation = SKAction.animate (with: self.enemyDeathAnimationTextures, timePerFrame: 0.2)
                
                self.enemySprite.run(enemyDeathSpriteAnimation, completion: {
                    self.enemySprite.removeFromParent()
                    self.enemyList.remove(at: 0)
                    
                    if (self.enemyList.count > 0){
                        self.generateEnemies()
                    } else {
                        self.grid.removeAllChildren()
                        self.removeAllChildren()
                        
                        self.levelIsComplete()
                    }
                })
            }
            
        }
        
        let beginEnemyTurn = SKAction.run{
            if (self.enemyStats.health > 0){
                self.beginEnemyTurn()
            }
        }
        
        if (CharacterSelection.selectedCharacter.name == CharacterSelection.rikko.name){
            playerSprite.run(magicAttackSound)
        } else{
            playerSprite.run(normalAttackSound)
        }
        
        playerSprite.run(playerAttackAnimation, completion: {
            self.enemyStats.health -= damage
            
            self.damageCounterLabel.text = "\(damage)"
            self.damageCounterLabel.position = self.enemySprite.position
            self.addChild(self.damageCounterLabel)
            
            self.run(SKAction.sequence([wait, run, beginEnemyTurn]))
        })
        
        GameScene.pairedTiles = [SKNode]()
        Grid.pairedTiles = [SKNode]()
        GameScene.tiles = [Tile]()
    }
    
    func beginEnemyTurn(){
        
        let damage = (enemyStats.attackStat - (enemyStats.attackStat * (playerStats.defenseStat/100)))
        enemySprite.run(enemyAttackSound)
        
        playerStats.health -= damage
        damageCounterLabel.text = "\(damage)"
        damageCounterLabel.position = playerSprite.position
        addChild(damageCounterLabel)
        let wait = SKAction.wait(forDuration: 1.5)
        let run = SKAction.run {
            self.damageCounterLabel.removeFromParent()
            
            if (self.playerStats.health <= 0){
                self.enemyList.removeAll() //Removes any remaining monsters from a previous level if there is any.
                self.grid.removeAllChildren()
                self.removeAllChildren()
                
                let gameOverScene = GameOverScene(size: (self.view?.bounds.size)!)
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                gameOverScene.scaleMode = SKSceneScaleMode.aspectFill
                self.view?.presentScene(gameOverScene, transition: transition)
            }
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
            let chosenHealingTile = Int(arc4random_uniform(UInt32(Tiles.healingTiles.count)))
            
            let moveTile = Tile(row: 0, col: 0, id: 0, effectId: counter, character: CharacterSelection.selectedCharacter.name, tile: characterTileArray[counter - 1], tileType: TileType.Move)
            let healingTile  = Tile(row: 0, col: 0, id: 0, effectId: chosenHealingTile, character: "", tile: Tiles.healingTiles[chosenHealingTile], tileType: TileType.Item)
            
            chosenTiles.append(moveTile)
            
            if (GameScene.healthPotionActivated){
                chosenTiles.append(healingTile)
            }
        }
        
        if (arc4random_uniform(100) > 50){
            let potionPickupTile = Tile(row: 0, col: 0, id: 0, effectId: 3, character: "", tile: Tiles.potionPickupTile, tileType: TileType.Item)
            chosenTiles.append(potionPickupTile)
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
        enemyList = [Enemy]()
        
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
        tempList.append(Enemies.spyr)
        tempList.append(Enemies.prysm)
        tempList.append(Enemies.polymorph)
        tempList.append(Enemies.spark)
        tempList.append(Enemies.tsanak)
        
        tempList.shuffle()
        
        let numberOfEnemies = Int(arc4random_uniform(8)) + 3
        
        for i in 0...numberOfEnemies - 1 {
            enemyList.append(tempList[Int(i)])
        }
        
        enemyList = sortList(_list: enemyList)
    }
    
    func generateEnemies(){
        enemyStats = enemyList[0]
        
        if (enemyStats.health < 0){
            enemyStats.health = enemyStats.maxHealth
        }
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
        
        enemySprite.position = CGPoint(x: frame.size.width/1.2, y: frame.size.height/1.35)
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
                
                let tileIdNode = SKNode()
                tileIdNode.name = String(GameScene.tiles[counter].id)
                
                if (revealTiles){
                    tileSprite = SKSpriteNode(texture: GameScene.tiles[counter].tile)
                } else {
                    tileSprite = SKSpriteNode(texture: GameScene.defaultTile)
                }
                
                tileSprite.addChild(tileIdNode)
                tileSprite.setScale(1.3)
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
    
    func levelIsComplete(){
        let levelCompletionScene: SKScene!
        
        if (GameViewController.currentLevel < 2){
            levelCompletionScene = LevelCompletionScene(size: (self.view?.bounds.size)!)
        } else {
            levelCompletionScene = EndingScene(size: (self.view?.bounds.size)!)
        }
        
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        levelCompletionScene.scaleMode = SKSceneScaleMode.aspectFill
        self.view?.presentScene(levelCompletionScene, transition: transition)
    }
}
