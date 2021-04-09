import SpriteKit
import CoreMotion

class FightScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let player: UInt32 = 0x1 << 0
        static let monster: UInt32 = 0x1 << 1
    }
    
    var str = 1  // higher str means higher damage
    var dex = 1  // higher dex means higher attack accuracy
    var spd = 1 // higher spd means the time inveral between monster attack is larger
    
    let motionManager = CMMotionManager()
    let timer = CountdownLabel()
    let playerAttTimer = CountdownLabel()
    let monsterAttTimer = CountdownLabel()
    
    let soundWin = SKAction.playSoundFileNamed("youwin2.mp3", waitForCompletion: false)
    let soundLose = SKAction.playSoundFileNamed("gameover.mp3", waitForCompletion: false)
    let slash = SKAction.playSoundFileNamed("slash.mp3", waitForCompletion: false)
    let punch = SKAction.playSoundFileNamed("punch.mp3", waitForCompletion: false)
    
    var monster_img = ""
    var action = 0
    
    let player = SKSpriteNode(imageNamed: "hero")
    let background = SKSpriteNode(imageNamed: "bg")
    let attack = SKSpriteNode(imageNamed: "player_attack")
    var mon_attack = SKSpriteNode(imageNamed: "monster_slash")
    let action_text = SKLabelNode(fontNamed: "MavenPro-Regular")

    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    let timeBetweenMonsterAtt = 3
    
    let movePointsPerSec = CGFloat(120)
    
    var gameEnd = false
    
    var monsterHealth = 1.0
    var playerHealth = 1.0
    
    var angle = 0.0

    
    override func didMove(to view: SKView) {
        createScene()
        
        getStats()
        
        /*Adding nodes + text */
        addMonster()
        addPlayer()
        addPlayerAttack()
        addMonsterAttack()
        
        /*Run motion manager to detect movement and angle*/
        
        if(action == 1){
            isPunch()
            addText(text: "Monster is weak to punch")
            DatabaseManager.shared.increaseProgressData(progress: "number_punches")
            DatabaseManager.shared.increaseFrequency(progressFrequency: "punch")
        }
        else if(action == 2){
            isSlash()
            addText(text: "Monster is weak to slash")
            DatabaseManager.shared.increaseProgressData(progress: "number_slashes")
            DatabaseManager.shared.increaseFrequency(progressFrequency: "slash")
        }
        else{
            isSquat()
            addText(text: "Monster is weak to squat")
            DatabaseManager.shared.increaseProgressData(progress: "number_squat")
            DatabaseManager.shared.increaseFrequency(progressFrequency: "squat")
        }
        getAngle()
        
        DatabaseManager.shared.increaseProgressData(progress: "monster_defeat")
         
        /*time between each mponster attack */
        timer.startWithDuration(duration: TimeInterval(timeBetweenMonsterAtt))
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else{
            dt = 0
        }
        lastUpdateTime = currentTime
        
        if(!gameEnd){
            monsterAttack()
        }
        if(playerAttTimer.didStarttimer() == true){
            removePlayerAttack()
        }
        
        if(monsterAttTimer.didStarttimer() == true){
            removeMonsterAttack()
        }
    }
    
    func isPunch(){
        if(motionManager.isAccelerometerAvailable ){
            motionManager.accelerometerUpdateInterval = 1/5
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [self] (data, error) in
                if let trueData = data {
                    //&& angle < 3 && angle > -3
                    if(trueData.acceleration.x <= -0.5 && angle < 20 && angle > -20 ){
                        print("\(trueData.acceleration.x), \(trueData.acceleration.y), \(trueData.acceleration.z) , \(angle)")
                        
                        self.attack.zPosition = 5
                        self.playerAttTimer.startTimer()
                        self.playerAttTimer.startWithDuration(duration:1)
                        run(slash)
                        let dmg = 0.01 * Double(self.str)/2
                        let player_hit = Int.random(in: 1...100) * 10 * self.dex
                        let player_hit_100 = Double(player_hit) * 0.01
                        let monster_evade = Int.random(in: 1...100)
                        
                        if( Int(player_hit_100) <= monster_evade){
                            //print(" player attack miss, player hit chance: \(player_hit_100) and monster //evade chance: \(monster_evade) ")
                        }
                        else if(self.monsterHealth - dmg >= 0 ){
                            self.monsterHealth -= dmg
                        }
                        else{
                            self.monsterHealth = 0
                            self.gameWon()
                        }
                        self.updateHealthBar(nodeName: "monster_healthbar",health: CGFloat(self.monsterHealth))
                    }
                }
            }
        }
    }
    
    
    func isSlash(){
        if(motionManager.isAccelerometerAvailable ){
            motionManager.accelerometerUpdateInterval = 1/5
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [self] (data, error) in
                if let trueData = data {
                    if(trueData.acceleration.x > 2 && self.angle > 10 && self.angle < 60){
                        //print("\(trueData.acceleration.x), \(trueData.acceleration.y), \(trueData.acceleration.z), \(angle)")
                        self.attack.zPosition = 5
                        self.playerAttTimer.startTimer()
                        self.playerAttTimer.startWithDuration(duration:1)
                        run(slash)
                        let dmg = 0.01 * Double(self.str)/2
                        let player_hit = Int.random(in: 1...100) * 3 * self.dex
                        let player_hit_100 = Double(player_hit) * 0.01
                        let monster_evade = Int.random(in: 1...100)
                        
                        if( Int(player_hit_100) <= monster_evade){
                            //print(" player attack miss, player hit chance: \(player_hit_100) and monster //evade chance: \(monster_evade) ")
                        }
                        else if(self.monsterHealth - dmg >= 0 ){
                            self.monsterHealth -= dmg
                        }
                        else{
                            self.monsterHealth = 0
                            self.gameWon()
                        }
                        self.updateHealthBar(nodeName: "monster_healthbar",health: CGFloat(self.monsterHealth))
                    }
                }
            }
        }
    }
    
    func isSquat(){
        if(motionManager.isAccelerometerAvailable ){
            motionManager.accelerometerUpdateInterval = 1/5
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [self] (data, error) in
                if let trueData = data {
                    if(trueData.acceleration.y > 2 ){
                        //print("\(trueData.acceleration.x), \(trueData.acceleration.y), //\(trueData.acceleration.z), \(angle)")
                        self.attack.zPosition = 5
                        self.playerAttTimer.startTimer()
                        self.playerAttTimer.startWithDuration(duration:1)
                        run(slash)
                        let dmg = 0.01 * Double(self.str)/2
                        run(punch)
                        
                        let player_hit = Int.random(in: 1...100) * 3 * self.dex
                        let player_hit_100 = Double(player_hit) * 0.01
                        let monster_evade = Int.random(in: 1...100)
                        
                        if( Int(player_hit_100) <= monster_evade){
                            //print(" player attack miss, player hit chance: \(player_hit_100) and monster //evade chance: \(monster_evade) ")
                        }
                        else if(self.monsterHealth - dmg >= 0 ){
                            self.monsterHealth -= dmg
                        }
                        else{
                            self.monsterHealth = 0
                            self.gameWon()
                        }
                        self.updateHealthBar(nodeName: "monster_healthbar",health: CGFloat(self.monsterHealth))
                    }
                }
            }
        }
    }
    
    func getAngle(){
        if  motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] (motion, error) -> Void in
                if let attitude = motion?.attitude {
                    self?.angle = attitude.pitch * 180 / Double.pi
                    //print(self?.angle)
                }
            }
        }
    }
    
    private func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zero
        
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        background.anchorPoint = CGPoint.init(x:0, y:0)
        background.name = "background"
        background.position = CGPoint(x:CGFloat(0) * self.frame.width, y:0)
        background.size = (self.view?.bounds.size)!
        background.zPosition = -1
        self.addChild(background)
    }
    
    
    private func createHealthBar(pos: CGPoint, name: String, health: CGFloat, name_gray: String){
        let graybar  = SKSpriteNode(color: UIColor.gray, size: CGSize(width: size.width*0.8, height: 30))
        graybar.position = pos
        graybar.zPosition = 1
        graybar.name = name_gray
        addChild(graybar)
        
        let healthbar = SKSpriteNode(color: UIColor.red, size: CGSize(width: size.width*0.8, height: 30))
        healthbar.position = pos
        healthbar.name = name
        healthbar.zPosition  = 2
        healthbar.xScale = CGFloat(health)
        addChild(healthbar)
    }
    
    private func updateHealthBar(nodeName: String, health: CGFloat){
        let updateHealth = childNode(withName: nodeName) as! SKSpriteNode
        updateHealth.xScale = CGFloat(health)
    }
    
    private func addMonster(){
        let monster = SKSpriteNode(imageNamed: monster_img)
        monster.position = CGPoint(x:size.width/2, y: size.height*0.7)
        monster.physicsBody = SKPhysicsBody(circleOfRadius: monster.size.height/10)
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
        monster.physicsBody?.collisionBitMask = PhysicsCategory.player
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.player
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.affectedByGravity = false
        monster.size = CGSize(width: 200, height: 200)
        monster.name = "monster"
        addChild(monster)
        
        createHealthBar(pos: CGPoint(x:size.width/2, y: size.height*0.85),name: "monster_healthbar",health: CGFloat(monsterHealth), name_gray: "graybar_mon")
    }
    
    private func monsterAttack(){
        if(Float(timer.timeLeft()) == 0.0 ){
            run(punch)
            let player_evade = Int.random(in: 1...100) * self.spd
            let player_evade_100 = Double(player_evade) * 0.01
            let monster_hit = Int.random(in: 1...100)
            
            if( Int(player_evade_100) >= monster_hit){
                //print(" monster attack miss with evade chance: \(player_evade_100) and monster hit chance: //\(monster_hit) ")
            }
            else if(self.playerHealth - 0.05 >= 0 ){
                self.playerHealth -= 0.05
                self.mon_attack.zPosition = 5
                self.monsterAttTimer.startTimer()
                self.monsterAttTimer.startWithDuration(duration:1)
            }
            else{
                self.playerHealth = 0
            }
            self.updateHealthBar(nodeName: "player_healthbar",health: CGFloat(playerHealth))
            if(playerHealth == 0){gameLost()}
        }
        
        if(timer.hasFinished()){
            timer.startWithDuration(duration: TimeInterval(timeBetweenMonsterAtt))
        }
    }
    
    private func addPlayer(){
        player.position = CGPoint(x:size.width/2, y: size.height * 0.3)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height/10)
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.collisionBitMask = PhysicsCategory.monster
        player.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = false
        player.size = CGSize(width: 200, height: 200)
        addChild(player)
        
        createHealthBar(pos: CGPoint(x:size.width/2, y: size.height*0.15), name: "player_healthbar", health: CGFloat(playerHealth), name_gray: "graybar_player")
    }
    
    private func addPlayerAttack(){
        attack.position = CGPoint(x:size.width/2, y: size.height*0.7)
        attack.size = CGSize(width: 200, height: 200)
        attack.zPosition = -2
        addChild(attack)
    }
    
    private func addMonsterAttack(){
        mon_attack.position = CGPoint(x:size.width/2, y: size.height * 0.3)
        mon_attack.size = CGSize(width: 200, height: 200)
        mon_attack.zPosition = -2
        addChild(mon_attack)
    }
    
    private func removePlayerAttack(){
        if(playerAttTimer.hasFinished()){
            attack.zPosition = -3
            playerAttTimer.stopTimer()
        }
    }
    
    private func removeMonsterAttack(){
        if(monsterAttTimer.hasFinished()){
            mon_attack.zPosition = -3
            monsterAttTimer.stopTimer()
        }
    }
    
    private func  addText(text: String){
        action_text.text = text
        action_text.fontSize = 15
        action_text.fontColor = SKColor.red
        action_text.position = CGPoint(x: frame.midX, y: size.height * 0.93)
           
        addChild(action_text)
    }
    
    private func addProceedButton(){
        backgroundColor = SKColor.white
        let buttonTexture: SKTexture! = SKTexture(imageNamed: "button")
        let buttonTextureSelected: SKTexture! = SKTexture(imageNamed: "buttonSelected.png")
        let button = FTButtonNode(normalTexture: buttonTexture, selectedTexture: buttonTextureSelected, disabledTexture: buttonTexture)
        button.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(buttonTap))
        button.setButtonLabel(title: "Button", font: "MavenPro-Regular", fontSize: 12)
        button.position = CGPoint(x: self.frame.midX,y: size.height * 0.5)
        button.zPosition = 1
        button.name = "Button"
        self.addChild(button)
    }
    
    private func gameWon(){
        gameEnd = true
        run(soundWin)
        motionManager.stopAccelerometerUpdates()
        createWinLogo()
        removeNode()
        action_text.text = ""
    }
    
    private func gameLost(){
        gameEnd = true
        run(soundLose)
        motionManager.stopAccelerometerUpdates()
        createGameOverLogo()
        removeNode()
        action_text.text = ""
    }
    
    /*get stats from the database*/
    
    private func getStats(){
        
        DatabaseManager.shared.getStats(stats: "Strength") { result  in
            let myresult = result
            if(myresult !=  nil){
                self.str = myresult
            }
        }
        
        DatabaseManager.shared.getStats(stats:"Dexterity") { result in
            let myresult = result
            if(myresult != nil){
                self.dex = myresult
            }
        }
        
        DatabaseManager.shared.getStats(stats: "Speed") { result in
            let myresult = result
            if(myresult != nil){
                self.spd = myresult
            }
        }
        
    }
    
    /*refactor*/
    
    func createGameOverLogo() {
        let logoImg = SKSpriteNode(imageNamed: "gameover")
        logoImg.size = CGSize(width: 272, height: 200)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.height * 0.8)
        logoImg.setScale(0.5)
        logoImg.zPosition = 5
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createWinLogo(){
        let logoImg = SKSpriteNode(imageNamed: "youwin2")
        logoImg.size = CGSize(width: 272, height: 100)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func removeNode(){
        player.removeFromParent()
        self.childNode(withName: "monster")?.removeFromParent()
        self.childNode(withName: "monster_healthbar")?.removeFromParent()
        self.childNode(withName: "player_healthbar")?.removeFromParent()
        self.childNode(withName: "graybar_player")?.removeFromParent()
        self.childNode(withName: "graybar_mon")?.removeFromParent()
    }
    
    @objc func buttonTap() {
        print("Button pressed")
        let vc = FightArenaViewController()
        vc.gameEnd = true
        vc.performSegue(withIdentifier: "go", sender: vc)
    }
    
}

