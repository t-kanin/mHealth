//
//  ExerciseViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 24/11/2563 BE.
//

import UIKit
import CoreMotion
import HealthKit

class ProfileViewController: UIViewController{

    var averageStepCount: Double?
    var averageDistanceTravel: Double?
    var averageFlightClimbed: Double?
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var numberStairClimbTextField: UITextField!
    @IBOutlet weak var distanceTravelTextField: UITextField!
    
    @IBOutlet weak var strengthTextField: UITextField!
    @IBOutlet weak var speedTextField: UITextField!
    @IBOutlet weak var dexterityTextField: UITextField!

    @IBOutlet weak var progressButton: UIButton!
    
    private var healthManager = HealthManager()
    private var databaseManager = DatabaseManager()

    var playerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderLabel()
        addImageView()
        setLevelUpButton()
        setupTextField()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        averageStepCount = 0.0
        averageDistanceTravel = 0.0
        averageFlightClimbed = 0.0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        healthManager.requestAuthorization { success in
            if success {
                self.retrieveHealthData()
            }
            else {
                print("Auth health not success")
            }
        }
        
        retrieveStsts()
    }
    
    
    func retrieveStsts(){
        databaseManager.getStats(stats: "Strength") { stat in
            if let str = stat as? Int {
                self.strengthTextField.text = "Strength: \(str)"
            }
        }
        databaseManager.getStats(stats: "Speed") { stat in
            if let spd = stat as? Int {
                self.speedTextField.text = "Speed: \(spd)"
            }
        }
        databaseManager.getStats(stats: "Dexterity") { stat in
            if let dex = stat as? Int {
                self.dexterityTextField.text = "Dexterity: \(dex)"
            }
        }
    }
    
    func retrieveHealthData(){
        self.healthManager.totalWeeklyStepCount { stepcount in
            if(stepcount != nil ){
                self.getStepCount(averageStepCount: stepcount!)
            }
        }
        
        self.healthManager.totalWeeklyDistanceTravel { (distancetravel) in
            if(distancetravel != nil){
                self.getDistanceTravel(averageDistanceTravel: distancetravel!)
            }
        }
        
        self.healthManager.totalWeeklyFlightClimb { (flightclimb) in
            if(flightclimb != nil){
                self.getStairClimb(averageStairClimb: flightclimb!)
            }
        }
    }

    func getStepCount(averageStepCount: Double){
        var cc: Int?
        DatabaseManager.shared.getStepcount(uid: AuthManager.shared.getUID()!) { result in
            DatabaseManager.shared.getUpdateStatus(updateStatus: "updateStepcount") { success in
                if success {
                    let stepcount = result
                    if(stepcount != nil){
                        if(stepcount >= averageStepCount){cc =  Int(0.2 * averageStepCount)}
                        else if(stepcount >= 0.75 * averageStepCount){cc = Int(0.25 * averageStepCount) } // 100
                        else{ cc = Int(averageStepCount) } // 600
                        self.textField.text = "Stepcount: \(cc!) required"
                    }
                    
                    self.healthManager.calculateStepDouble { result in
                        let tdStepCount = result
                        if(tdStepCount != nil && cc != nil && stepcount != nil ){
                            if(Int(tdStepCount!) >= (cc! + Int(stepcount))){
                                //print("tdStepcount: (\(tdStepCount!) cc: \(cc! + Int(stepcount))")
                                self.databaseManager.increaseStats(stats: "Dexterity")
                                self.databaseManager.setStatUpdate(uid: AuthManager.shared.getUID()!, status: false, updateStats: "updateStepcount")
                                DispatchQueue.main.async{
                                    self.textField.text = "Dexterity has increased by one !!"
                                }
                            }
                        }
                    }
                }
                else{
                    self.textField.text = "press X to progress"
                }
            }
        }
    }
    
    func getDistanceTravel( averageDistanceTravel: Double){
        var cc: Int?
        DatabaseManager.shared.getDistancetravel(uid: AuthManager.shared.getUID()!) { result in
            
            DatabaseManager.shared.getUpdateStatus(updateStatus: "updateDistancetravel") { success in
                if success {
                    let distancetravel = Double(result)
                    
                    if(distancetravel != nil){
                        if(distancetravel >= averageDistanceTravel){cc = Int( 0.2 * averageDistanceTravel)}
                        else if(distancetravel >= 0.75 * averageDistanceTravel){ cc = Int(0.25 * averageDistanceTravel)}
                        else{ cc = Int(0.5 * averageDistanceTravel) }
                        
                        self.distanceTravelTextField.text = "distancetravel: \(cc!)  meters required"
                    }
                    
                    
                    self.healthManager.getDistanceTravelDouble { result in
                        let tdDistanceTravel = result
                        if(tdDistanceTravel != nil && cc != nil && distancetravel != nil ){
                            if(tdDistanceTravel! >= (cc! + Int(distancetravel))){
                                //print("tdDistanceTravel: (\(tdDistanceTravel!) cc: \(cc! + distancetravel)")
                                self.databaseManager.increaseStats(stats: "Speed")
                                self.databaseManager.setStatUpdate(uid: AuthManager.shared.getUID()!, status: false, updateStats: "updateDistancetravel")
                                DispatchQueue.main.async{
                                    self.distanceTravelTextField.text = "Speed has increased by one !!"
                                }
                            }
                        }
                    }
                }
                else {
                    self.distanceTravelTextField.text = "press X to progress"
                }
            }
        }
    }
    
    
    func getStairClimb(averageStairClimb: Double){
        var cc: Int?
        DatabaseManager.shared.getStairclimb(uid: AuthManager.shared.getUID()!) { result in
            
            DatabaseManager.shared.getUpdateStatus(updateStatus: "updateStairclimb") { success in
                if success {
                    let  stairclimb = result
                    if(stairclimb != nil){
                        if(stairclimb >= 0.75 * averageStairClimb){cc = Int(0.25 * averageStairClimb)}
                        else if(stairclimb >= 0.5 * averageStairClimb){cc = Int(0.5 * averageStairClimb)}
                        else{cc = 2}
                        if(cc == 0){cc = 2}
                        self.numberStairClimbTextField.text = "Stairclimb: \(cc!) required"
                    }
                    
                    self.healthManager.getTodayFlightsClimbDouble { result in
                        let tdStairclimb = result
                        if(tdStairclimb != nil && cc != nil && stairclimb != nil){
                            //print("tdStairclimb: (\(tdStairclimb!) cc: \(cc! + Int(stairclimb))")
                            if(Int(tdStairclimb!) >= (cc! + Int(stairclimb))){
                                self.databaseManager.increaseStats(stats: "Strength")
                                self.databaseManager.setStatUpdate(uid: AuthManager.shared.getUID()!, status: false, updateStats: "updateStairclimb")
                                DispatchQueue.main.async{
                                    self.numberStairClimbTextField.text = "Strength has increased by one !!"
                                }
                            }
                        }
                    }
                }
                else {
                    
                    self.numberStairClimbTextField.text = "press X to progress"
                }
            }
        }
    }
    
    func setupHeaderLabel (){
        let title = "Profile"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-SemiBold",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
    func setupTextField(){
        textField.borderStyle = .none
        distanceTravelTextField.borderStyle = .none
        numberStairClimbTextField.borderStyle = .none
        textField.font = UIFont(name: "MavenPro-Regular", size: 15)
        distanceTravelTextField.font = UIFont(name: "MavenPro-Regular", size: 15)
        numberStairClimbTextField.font = UIFont(name: "MavenPro-Regular", size: 15)
        
        strengthTextField.borderStyle = .none
        speedTextField.borderStyle = .none
        dexterityTextField.borderStyle = .none
        strengthTextField.font = UIFont(name: "MavenPro-Regular", size: 15)
        speedTextField.font = UIFont(name: "MavenPro-Regular", size: 15)
        dexterityTextField.font = UIFont(name: "MavenPro-Regular", size: 15)
    }
    
    func addImageView(){
        playerImage = UIImageView(frame: CGRect(x: UIScreen.main.bounds.size.width/2 - 75, y: 160, width: 150, height: 150))
        playerImage.image = UIImage(named: "hero")
        playerImage.layer.borderColor = UIColor.black.cgColor
        playerImage.layer.borderWidth = 2
        
        view.addSubview(playerImage)
    }
    
    func setLevelUpButton(){
        let startLevelUp = UIButton(type: .custom)
        startLevelUp.frame = CGRect(x: view.bounds.maxX * 0.7, y: view.bounds.maxY * 0.7, width: 50, height: 50)
        startLevelUp.setTitle("X", for: .normal)
        startLevelUp.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startLevelUp.clipsToBounds = true
        startLevelUp.setTitleColor(.white, for: .normal)
        startLevelUp.layer.cornerRadius = 0.5 * startLevelUp.bounds.size.width
        startLevelUp.backgroundColor = UIColor.black
        startLevelUp.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        view.addSubview(startLevelUp)
        
    }
    
    @objc func buttonPress(){
        let auth = AuthManager()
        let userid = auth.getUID()!
        
        DatabaseManager.shared.updateStepcount(uid: userid){ success in
 
        }
        
        DatabaseManager.shared.updateStairClimb(uid: userid) { (success) in

        }
        
        DatabaseManager.shared.updateDistanceTravel(uid: userid) { (success) in

        }
        
        DatabaseManager.shared.setStatUpdate(uid: userid, status: true, updateStats: "updateStepcount")
        DatabaseManager.shared.setStatUpdate(uid: userid, status: true, updateStats: "updateDistancetravel")
        DatabaseManager.shared.setStatUpdate(uid: userid, status: true, updateStats: "updateStairclimb")
        
        retrieveHealthData()
        
    }
}

extension Double {
    // Round the double to decimal places value
    func rounded(toPlaces places:Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded()/divisor
    }
}
