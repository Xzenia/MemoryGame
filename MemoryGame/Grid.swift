//
//  Grid.swift
//  Test Project
//
//  Created by Metis on 19/02/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class Grid:SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var blockSize:CGFloat!
    
    public static var chosenPairs = [SKNode]()
    
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
        
        SKColor.gray.setStroke()
        bezierPath.lineWidth = 5.0
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
            
            if node != self {
                if (!GameScene.pairedTiles.contains(node) && GameScene.turns > 0 && GameScene.gameStarted){
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
                        
                        let action = SKAction.setTexture(GameScene.defaultTile)
                        Grid.chosenPairs[0].run(action)
                        
                        Grid.chosenPairs.removeAll()
                        
                    } else if (GameScene.tiles[Int(Grid.chosenPairs[0].name!)!].tile == GameScene.tiles[Int(Grid.chosenPairs[1].name!)!].tile){
                        print("Both tiles are similar!")
                        GameScene.pairedTiles.append(Grid.chosenPairs[0])
                        Grid.chosenPairs.removeAll()
                        
                        GameScene.turns -= 1
                        
                        GameScene.matches += 1
                    
                        print("Turns: \(GameScene.turns)")
                    } else {
                        print("Both tiles are not similar!")
                        
                        GameScene.turns -= 1
                        print("Turns: \(GameScene.turns)")
                        
                        Grid.chosenPairs.removeAll()
                    }
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
