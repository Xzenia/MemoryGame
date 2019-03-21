//
//  MainMenuScene.swift
//  MemoryGame
//
//  Created by Metis on 13/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene{

    let PlayButton = SKSpriteNode(imageNamed: "MainMenu_PlayButton")
    
    override func didMove(to view: SKView) {
        PlayButton.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        PlayButton.xScale = 0.5
        PlayButton.yScale = 0.5
        addChild(PlayButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if PlayButton.contains(touch.location(in: self)){
                let characterSelectionScene = CharacterSelection(size: (view?.bounds.size)!)
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                characterSelectionScene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(characterSelectionScene, transition: transition)

            }
        }
    }
}
