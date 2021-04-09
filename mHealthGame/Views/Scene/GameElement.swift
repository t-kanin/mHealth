import SpriteKit

struct PhysicsCategory {
    static let player: UInt32 = 0x1 << 0
    static let monster: UInt32 = 0x1 << 1
}

extension GameScene {
    
    func createGameOverLogo() {
        let logoImg = SKSpriteNode(imageNamed: "gameover")
        logoImg.size = CGSize(width: 272, height: 200)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.maxY * 0.7)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createWinLogo(){
        let logoImg = SKSpriteNode(imageNamed: "youwin2")
        logoImg.size = CGSize(width: 272, height: 100)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.maxY * 0.7)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    
}
