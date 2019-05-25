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
    
    override func didMove(to view: SKView) {
        slides.append(SKTexture(imageNamed: "slide 1"))
        slides.append(SKTexture(imageNamed: "slide 2"))
        slides.append(SKTexture(imageNamed: "slide 3"))
        slides.append(SKTexture(imageNamed: "slide 4"))
        slides.append(SKTexture(imageNamed: "slide 5"))
        slides.append(SKTexture(imageNamed: "slide 6"))
    
        slideViewer.position = CGPoint(x: frame.midX, y: frame.midY)
        slideViewer.xScale = 1.4
        slideViewer.yScale = 1.4
        slideViewer.texture = slides[currentSlide]
        
        addChild(slideViewer)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            if (currentSlide < slides.count) {
                slideViewer.texture = slides[currentSlide]
                currentSlide = currentSlide + 1
            } else {
                let scene = GameScene(size: (view?.bounds.size)!)
                let transition = SKTransition.flipVertical(withDuration: 1.0)
                scene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(scene, transition: transition)
            }
            
        }
    }
}
