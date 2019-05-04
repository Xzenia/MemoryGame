//
//  MainMenuScene.swift
//  MemoryGame
//
//  Created by Metis on 13/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene{

    let playButton = SKSpriteNode(imageNamed: "spr_play_0")
    let title = SKSpriteNode(imageNamed: "spr_title_0")
    
    var tapObject = SKSpriteNode(imageNamed: "tap_effect_0")
    var tapAnimation = SKAction()
    
    override func didMove(to view: SKView) {
        
        title.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 + 200)
        title.xScale = 1.5
        title.yScale = 1.5
        addChild(title)
        
        playButton.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
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
