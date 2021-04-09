import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{

    
    let player = SKSpriteNode(imageNamed: "head")
    var monster: SKSpriteNode?
    var monster_img = ""
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    let movePointsPerSec = CGFloat(30)
    var velocity = CGPoint(x: CGFloat(30), y: 0)
    
    let timer = CountdownLabel()

    var gameEnd: Bool = false
    
    let motionManager = MotionManager()
    
    let soundWin = SKAction.playSoundFileNamed("youwin2.mp3", waitForCompletion: false)
    let soundLose = SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        createScene()
        addPlayer()
        addMonster()
        addTimer()
        //DatabaseManager.shared.updateRuntime(progress: "time_running", time: 3)
        DatabaseManager.shared.increaseProgressDataRun(progress: "time_running", time: Int(180/60)) // test
        DatabaseManager.shared.increaseFrequency(progressFrequency: "run")
        DatabaseManager.shared.increaseScore()
     }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else{
            dt = 0
        }
        lastUpdateTime = currentTime
        
        timer.update()
        if(!motionManager.isRunning()){
            moveTowardsPlayer()
        }
        
        moveBackground()
        if(!gameEnd){
            checkWinCondition()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondbody = contact.bodyB
        
        if(firstBody.categoryBitMask == PhysicsCategory.monster && secondbody.categoryBitMask == PhysicsCategory.player && gameEnd == false) {
            createGameOverLogo()
            timer.removeAllActions()
            timer.removeFromParent()
            gameEnd = true
            run(soundLose)
            print("Game over player get eaten by the monster")
        }
    }
    
    private func checkWinCondition(){
        if(timer.hasFinished()){
            gameEnd = true
            createWinLogo()
            timer.removeAllActions()
            timer.removeFromParent()
            run(soundWin)
            print("player has successfully escape the monster")
        }
    }
    
    /* create scene and nodes*/
    private func addPlayer(){
        player.position = CGPoint(x: size.width*0.95, y: size.height/2)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.collisionBitMask = PhysicsCategory.monster
        player.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        player.physicsBody?.isDynamic = true
        addChild(player)
    }
    
    private func addMonster(){
        monster = SKSpriteNode(imageNamed: monster_img)
        monster?.position = CGPoint(x:size.width/20, y: size.height/2)
        monster?.physicsBody = SKPhysicsBody(rectangleOf: monster!.size)
        monster?.physicsBody?.categoryBitMask = PhysicsCategory.monster
        monster?.physicsBody?.collisionBitMask = PhysicsCategory.player
        monster?.physicsBody?.contactTestBitMask = PhysicsCategory.player
        monster?.physicsBody?.isDynamic = true
        addChild(monster!)
    }
    
    private func addTimer(){
        timer.position = CGPoint(x:self.frame.midX, y:self.frame.maxY * 0.7)
        timer.fontSize = 65
        addChild(timer)
        timer.startWithDuration(duration: 20)
    }
    private func createScene(){
        // define in game physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zero
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0...2
        {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            background.zPosition = -1
            self.addChild(background)
        }
    }
    
    /* movement func */
    private func moveBackground(){
        self.enumerateChildNodes(withName: "background") { (node, error) in
            node.position.x -= 2
            if(node.position.x < -(self.scene?.size.width)!){
                node.position.x += (self.scene?.size.width)! * 3
            }
        }
    }
    
    private func moveSprtie(sprite: SKSpriteNode, velocity: CGPoint){
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    func moveTowardsPlayer(){
        if(monster != nil){
            let offset = CGPoint(x: player.position.x - monster!.position.x, y: player.position.y - monster!.position.y)
            let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
            let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length))
            
            let velocity_mon = CGPoint(x: direction.x * movePointsPerSec, y: direction.y * movePointsPerSec)
            moveSprtie(sprite: monster!, velocity: velocity_mon)
        }
    }

    
    /* random func */
    func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
      return random() * (max - min) + min
    }

    
}
