//
//  CharacterSelection.swift
//  MemoryGame
//
//  Created by Metis on 20/03/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class CharacterSelection: SKScene {
    
    public static let shou = Player(_name: "Shou", _baseAttackStat: 10, _baseDefenseStat: 8, _maxHealth: 100, _animationFrame: 8, _attackAnimationFrame: 21)
    public static let rikko = Player(_name: "Rikko", _baseAttackStat: 8, _baseDefenseStat: 10, _maxHealth: 100, _animationFrame: 10, _attackAnimationFrame: 8)
    public static let emily = Player(_name: "Emily", _baseAttackStat: 15, _baseDefenseStat: 5, _maxHealth: 120, _animationFrame: 10, _attackAnimationFrame: 9)
    
    public static var selectedCharacter = CharacterSelection.shou
    
    let shouSprite = SKSpriteNode(imageNamed: "spr_\(CharacterSelection.shou.name)_idle_0")
    let rikkoSprite = SKSpriteNode(imageNamed: "spr_\(CharacterSelection.rikko.name)_idle_0")
    let emilySprite = SKSpriteNode(imageNamed: "spr_\(CharacterSelection.emily.name)_idle_0")
    
    override func didMove(to view: SKView) {
        shouSprite.position = CGPoint(x: frame.size.width/5, y: frame.size.height/2)
        shouSprite.zPosition = 3
        shouSprite.xScale = 1.5
        shouSprite.yScale = 1.5
        addChild(shouSprite)
        
        rikkoSprite.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        rikkoSprite.zPosition = 3
        rikkoSprite.xScale = 1.5
        rikkoSprite.yScale = 1.5
        addChild(rikkoSprite)
        
        emilySprite.position = CGPoint(x: frame.size.width/1.3, y: frame.size.height/2)
        emilySprite.zPosition = 3
        emilySprite.xScale = 1.5
        emilySprite.yScale = 1.5
        addChild(emilySprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if shouSprite.contains(touch.location(in: self)){
                CharacterSelection.selectedCharacter = CharacterSelection.shou
                goToStoryScene()
            }
            else if (rikkoSprite.contains(touch.location(in: self))){
                CharacterSelection.selectedCharacter = CharacterSelection.rikko
                goToStoryScene()
            }
            else if (emilySprite.contains(touch.location(in: self))){
                CharacterSelection.selectedCharacter = CharacterSelection.emily
                goToStoryScene()
            }
        }
    }
    
    func goToStoryScene(){
        let scene = StoryScene(size: (view?.bounds.size)!)
        let transition = SKTransition.flipVertical(withDuration: 1.0)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        view?.presentScene(scene, transition: transition)
    }

}
