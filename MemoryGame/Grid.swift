import SpriteKit

class Grid:SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var blockSize:CGFloat!
    
    public static var chosenPairs = [SKNode]()
    public static var pairedTiles = [SKNode]() //Keeps track of all pairs of tiles 
    
    convenience init?(blockSize:CGFloat,rows:Int,cols:Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
        self.isUserInteractionEnabled = true
    }
    
    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        
        if (CharacterSelection.selectedCharacter.name == CharacterSelection.shou.name){
            SKColor.yellow.setStroke()
        }
        else if (CharacterSelection.selectedCharacter.name == CharacterSelection.rikko.name){
            SKColor.red.setStroke()
        }
        else {
            SKColor.blue.setStroke()
        }

        bezierPath.lineWidth = 2.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let colSize = (blockSize * CGFloat(cols))
        let rowSize = (blockSize * CGFloat(rows))
        let x = CGFloat(col) * blockSize - colSize / 2.0 + offset
        let y = CGFloat(rows - row - 1) * blockSize - rowSize / 2.0 + offset
        return CGPoint(x:x, y:y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let node = atPoint(position)
            let setToDefaultTile = SKAction.setTexture(GameScene.defaultTile)

            if node != self {
                if (!Grid.pairedTiles.contains(node) && GameScene.turns > 0 && GameScene.gameStarted){
                    let tileTexture = GameScene.tiles[Int(node.name!)!].tile
                    let action = SKAction.setTexture(tileTexture)
                    node.run(action)
                    
                    if (Grid.chosenPairs.count == 1){
                        Grid.chosenPairs.append(node)
                    } else if (Grid.chosenPairs.count == 0){
                        Grid.chosenPairs.append(node)
                    }
                }
                
                if (Grid.chosenPairs.count > 1){
                    
                    if (Grid.chosenPairs[0] == Grid.chosenPairs[1]){
                        print("Selected the same node!")
                        Grid.chosenPairs[0].run(setToDefaultTile)

                    } else if (GameScene.tiles[Int(Grid.chosenPairs[0].name!)!].tile == GameScene.tiles[Int(Grid.chosenPairs[1].name!)!].tile){
                        print("Both tiles are similar!")
                        GameScene.pairedTiles.append(Grid.chosenPairs[0])
                        
                        Grid.pairedTiles.append(Grid.chosenPairs[0])
                        Grid.pairedTiles.append(Grid.chosenPairs[1])
                        
                        GameScene.turns -= 1
                        GameScene.matches += 1
                    
                        print("Turns: \(GameScene.turns)")

                    } else {
                        print("Both tiles are not similar!")
                        
                        GameScene.turns -= 1
                        print("Turns: \(GameScene.turns)")
                        
                        let chosenNode1 = Grid.chosenPairs[0]
                        let chosenNode2 = Grid.chosenPairs[1]
                        
                        let wait = SKAction.wait(forDuration: 0.5)
                        let run = SKAction.run {
                            chosenNode1.run(setToDefaultTile)
                            chosenNode2.run(setToDefaultTile)

                        }
                        self.run(SKAction.sequence([wait, run]))
                    }
                    
                    Grid.chosenPairs.removeAll()
                }
                
            } else {
                let x = size.width / 2 + position.x
                let y = size.height / 2 - position.y
                let row = Int(floor(x / blockSize))
                let col = Int(floor(y / blockSize))
                print("\(row) \(col)")
            }
        }
    }
}
