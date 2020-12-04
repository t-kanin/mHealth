//
//  ExerciseViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 24/11/2563 BE.
//

import UIKit
import CoreMotion

class ExerciseViewController: UIViewController{
    
    @IBOutlet weak var xAccel: UITextField!
    @IBOutlet weak var yAccel: UITextField!
    @IBOutlet weak var zAccel: UITextField!
    
    var motion = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAccel()
    }
    
    func myAccel() {
        motion.accelerometerUpdateInterval = 0.5
        motion.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            print(data as Any)
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
}

extension Double {
    // Round the double to decimal places value
    func rounded(toPlaces places:Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded()/divisor
    }
}
