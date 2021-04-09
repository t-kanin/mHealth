import SpriteKit

class CountdownLabel: SKLabelNode {
    var endTime:Date!
    var start = false
    func update(){
        let timeLeftInt = Int(timeLeft())
        text = String(timeLeftInt)
        
    }
    
    func startWithDuration(duration: TimeInterval){
        let currTime = Date()
        endTime = currTime.addingTimeInterval(duration)
    }
    
    func timeLeft() -> TimeInterval {
        let currTime = Date()
        let remainingSecond = endTime.timeIntervalSince(currTime)
        return max(remainingSecond,0)
    }

    func hasFinished() -> Bool {
        if(timeLeft() == 0){
            return true
        }
        else {
            return false
        }
    }
    func startTimer(){
        start = true
    }
    
    func stopTimer(){
        start = false
    }
    
    func didStarttimer() -> Bool{
        return start
    }
    
}
