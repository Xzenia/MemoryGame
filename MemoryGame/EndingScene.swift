import SpriteKit

class EndingScene: SKScene{
    
    var slideViewer = SKSpriteNode(imageNamed: "winscreen")
    
    var tapObject = SKSpriteNode()
    var tapAnimation = SKAction()
    
    override func didMove(to view: SKView) {
        slideViewer.position = CGPoint(x: frame.midX, y: frame.midY)
        slideViewer.xScale = 1.5
        slideViewer.yScale = 1.5
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
            let scene = MainMenuScene(size: (view?.bounds.size)!)
            let transition = SKTransition.flipVertical(withDuration: 1.0)
            
            GameViewController.currentLevel = 0
            
            scene.scaleMode = SKSceneScaleMode.aspectFill
            view?.presentScene(scene, transition: transition)
        
            let position = touch.location(in:self)
            tapObject.position = position
            tapObject.run(tapAnimation)
        }
    }
}
