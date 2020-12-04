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
    }
    
    func myAccel() {
        motion.accelerometerUpdateInterval = 0.5
        
    }
}
