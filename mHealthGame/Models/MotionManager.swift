//
//  MotionManager.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 28/1/2564 BE.
//

import CoreMotion

public class MotionManager{
    let motionActivityManager = CMMotionActivityManager()
    let motionManger = CMMotionManager()
    var station = false
    var run = false
    
    // MARK: - GET USER ACTIVITY
    func activityManager(){
        if(CMMotionActivityManager.isActivityAvailable()){ //check if the device authorisation for the motion tracking
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                if(motion?.stationary == true){
                    //self.textField.text = "User is stationary"
                }
                else if(motion?.walking == true){
                    //self.textField.text = "User is walking"
                }
                else if(motion?.running == true){
                    //self.textField.text = "User is running"
                }
                else{
                    //self.textField.text = "User activity is unknown"
                }
            }
        }
    }
    
    func isPunch() -> Bool{
        var punch = false
        if(motionManger.isAccelerometerAvailable){
            motionManger.accelerometerUpdateInterval = 1/5
            motionManger.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let trueData = data {
                    print(trueData.acceleration.x)
                    if(trueData.acceleration.x <= -1){
                        punch = true
                        print(punch)
                    }
                }
            }
        }
        return punch 
    }
    
    
    func isRunning() -> Bool {
        if(CMMotionActivityManager.isActivityAvailable()){
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                if(motion?.running == true){
                    self.run = true
                }
                else{
                    self.run = false
                }
            }
        }
        return run
    }
    
    func isStationary() -> Bool{
        if(CMMotionActivityManager.isActivityAvailable()){
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                if(motion?.stationary == true){
                    self.station = true
                }
                else{
                    self.station = false
                }
            }
        }
        return station
    }
    
}
