//
//  StoryScene.swift
//  MemoryGame
//
//  Created by Metis on 19/05/2019.
//  Copyright © 2019 Metis. All rights reserved.
//

import SpriteKit

class StoryScene: SKScene {
    
    var slides = [SKTexture]()
    
    var slideViewer = SKSpriteNode(imageNamed: "slide 1")
    
    var currentSlide = 0
    
    var tapObject = SKSpriteNode()
    var tapAnimation = SKAction()
    
    override func didMove(to view: SKView) {
        slides.append(SKTexture(imageNamed: "slide 1"))
        slides.append(SKTexture(imageNamed: "slide 2"))
        slides.append(SKTexture(imageNamed: "slide 3"))
        slides.append(SKTexture(imageNamed: "slide 4"))
        slides.append(SKTexture(imageNamed: "slide 5"))
        slides.append(SKTexture(imageNamed: "slide 6"))
    
        slideViewer.position = CGPoint(x: frame.midX, y: frame.midY)
        slideViewer.xScale = 1.5
        slideViewer.yScale = 1.5
        slideViewer.texture = slides[currentSlide]
        
        addChild(slideViewer)
        
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
            if (currentSlide < slides.count) {
                slideViewer.texture = slides[currentSlide]
                currentSlide = currentSlide + 1
            } else {
                let scene = CharacterSelection(size: (view?.bounds.size)!)
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(scene, transition: transition)
            }
            
            let position = touch.location(in:self)
            tapObject.position = position
            tapObject.run(tapAnimation)
            
        }
    }
}
