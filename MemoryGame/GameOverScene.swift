//
//  GameOverScene.swift
//  MemoryGame
//
//  Created by Metis on 09/05/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let gameOverMessage = SKLabelNode(fontNamed: "Eight Bit Dragon")
    let matchesCounterLabel = SKLabelNode(fontNamed: "Eight Bit Dragon")
    
    let playButton = SKSpriteNode(imageNamed: "spr_play_0")
    
    var tapObject = SKSpriteNode()
    var tapAnimation = SKAction()
    
    override func didMove(to view: SKView) {
        
        gameOverMessage.fontSize = 20
        gameOverMessage.text = "You Died!"
        gameOverMessage.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 + 200)
        addChild(gameOverMessage)
        
        matchesCounterLabel.fontSize = 16
        matchesCounterLabel.text = "Matches: \(GameScene.matches)"
        matchesCounterLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 + 100)
        addChild(matchesCounterLabel)

        playButton.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 - 200)
        addChild(playButton)
        
        var tapAnimationTextures = [SKTexture]()
        
        for counter in 0...7{
            tapAnimationTextures.append(SKTexture(imageNamed: "tap_effect_\(counter)"))
        }
        
        tapObject.zPosition = 10
        tapAnimation = SKAction.animate(with: tapAnimationTextures, timePerFrame: 0.05)
        
        addChild(tapObject)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if playButton.contains(touch.location(in: self)){
                let characterSelectionScene = CharacterSelection(size: (view?.bounds.size)!)
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                characterSelectionScene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(characterSelectionScene, transition: transition)
            }
            
            let position = touch.location(in:self)
            tapObject.position = position
            tapObject.run(tapAnimation)
        }
    }

    
}
