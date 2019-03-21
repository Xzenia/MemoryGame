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
        
        SKColor.black.setStroke()
        bezierPath.lineWidth = 1.0
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
                    
                    if (GameScene.chosenNode1 == nil){
                        GameScene.chosenNode1 = node
                    } else {
                        GameScene.chosenNode2 = node
                    }
                }

                if (GameScene.chosenNode1 != nil && GameScene.chosenNode2 != nil){
                    if (GameScene.chosenNode1 == GameScene.chosenNode2){
                        print("Selected the same node!")
                        changeTilesToDefault()
                        setSelectedNodesToNil()
                    } else if (GameScene.tiles[Int(GameScene.chosenNode1.name!)!].tile == GameScene.tiles[Int(GameScene.chosenNode2.name!)!].tile){
                        print("Both tiles are similar!")
                        GameScene.pairedTiles.append(GameScene.chosenNode1)
                        setSelectedNodesToNil()
                        
                        GameScene.turns -= 1
                        
                        GameScene.gold += 1
                        
                        self.run(SKAction.playSoundFileNamed(Sounds.correctMatch, waitForCompletion: false))
                    
                        print("Turns: \(GameScene.turns)")
                    } else {
                        print("Both tiles are not similar!")
                        
                        self.run(SKAction.playSoundFileNamed(Sounds.wrongMatch, waitForCompletion: false))
                        
                        let wait = SKAction.wait(forDuration: 0.5)
                        let run = SKAction.run {
                            self.changeTilesToDefault()
                            self.setSelectedNodesToNil()
                            GameScene.turns -= 1                            

                            print("Turns: \(GameScene.turns)")
                        }
                        self.run(SKAction.sequence([wait, run]))
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
    
    func setSelectedNodesToNil(){
        GameScene.chosenNode1 = nil
        GameScene.chosenNode2 = nil
    }
    
    func changeTilesToDefault(){
        let action = SKAction.setTexture(GameScene.defaultTile)
        GameScene.chosenNode1.run(action)
        GameScene.chosenNode2.run(action)
    }
}
