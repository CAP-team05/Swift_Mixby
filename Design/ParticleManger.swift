import SpriteKit

class RainFall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        
        // 백그라운드 스레드에서 SKEmitterNode 로드
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let emitterNode = SKEmitterNode(fileNamed: "RainFall.sks") else {
                print("Failed to load RainFall.sks")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.addChild(emitterNode)
                emitterNode.particlePositionRange.dx = UIScreen.main.bounds.width
            }
        }
    }
}

class SnowFall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        
        // 백그라운드 스레드에서 SKEmitterNode 로드
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let emitterNode = SKEmitterNode(fileNamed: "SnowFall.sks") else {
                print("Failed to load RainFall.sks")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.addChild(emitterNode)
                emitterNode.particlePositionRange.dx = UIScreen.main.bounds.width
            }
        }
    }
}
