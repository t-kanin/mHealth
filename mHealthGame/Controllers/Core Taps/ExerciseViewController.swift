//
//  ExerciseViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 24/11/2563 BE.
//

import UIKit
import CoreMotion
import HealthKit

class ExerciseViewController: UIViewController{
    
    @IBOutlet weak var xAccel: UITextField!
    @IBOutlet weak var yAccel: UITextField!
    @IBOutlet weak var zAccel: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var numberStairClimbTextField: UITextField!
    
    
    private var motion = CMMotionManager()
    private var motionActivityManager  = CMMotionActivityManager()
    private var healthManager = HealthManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderLabel()
        activityManager()
        myAccel()
        
        healthManager.requestAuthorization { success in
            if success {
                self.healthManager.getTodayFlightsClimb { result in
                    if let myresult = result {
                        // update UI
                        self.updateFlightClimbUI(collection: myresult)
                    }
                }
            }
            else {
                print("Auth not success")
            }
        }
    }
    
    private func updateFlightClimbUI( collection: HKStatisticsCollection){
        let startDate = Calendar.current.startOfDay(for: Date())
        var cc = Double(0)
        collection.enumerateStatistics(from: startDate, to: Date()) { (statistics, value) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            if count != nil {
                cc = count!
            }
            print("FlightClimbs: \(count)")
            DispatchQueue.main.async {
                self.numberStairClimbTextField.text = "FlightClimbs: \(cc)"
            }
            
        }
    }
    
    // TODO: - move these func to the models
    
    // MARK: - GET USER ACTIVITY
    func activityManager(){
        if(CMMotionActivityManager.isActivityAvailable()){ //check if the device authorisation for the motion tracking
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                if(motion?.stationary == true){
                    self.textField.text = "User is stationary"
                }
                else if(motion?.walking == true){
                    self.textField.text = "User is walking"
                }
                else if(motion?.running == true){
                    self.textField.text = "User is running"
                }
                else{
                    self.textField.text = "User activity is unknown"
                }
                //print(motion as Any)
                
            }
        }
    }
    
    // MARK: - GET ACCELEROMETER DATA FROM THE USER
    func myAccel() {
        motion.accelerometerUpdateInterval = 0.5
        motion.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let trueData = data {
                self.view.reloadInputViews()
                let x = trueData.acceleration.x
                let y = trueData.acceleration.y
                let z = trueData.acceleration.z
                
                self.xAccel.text = "x: \(Double(x).rounded(toPlaces: 3))"
                self.yAccel.text = "y: \(Double(y).rounded(toPlaces: 3))"
                self.zAccel.text = "z: \(Double(z).rounded(toPlaces: 3))"
                
            }
        }
    }
    
    func setupHeaderLabel (){
        let title = "User Activity"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"Didot",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
}

extension Double {
    // Round the double to decimal places value
    func rounded(toPlaces places:Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded()/divisor
    }
}
