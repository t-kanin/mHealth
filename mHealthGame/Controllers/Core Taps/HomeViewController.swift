//
//  ViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 15/11/2563 BE.
//
import FirebaseAuth
import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var dailyMissionTextField: UITextField!
    @IBOutlet weak var mission_1: UITextField!
    @IBOutlet weak var mission_2: UITextField!
    @IBOutlet weak var mission_3: UITextField!
    @IBOutlet weak var mission_4: UITextField!
    @IBOutlet weak var mission_5: UITextField!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        setupHeaderLabel()
        setupTitleLabel()
        mission_1.text = "1. Reach 5500 step counts"
        mission_2.text = "2. Flight climb 4 floors"
        mission_3.text = "3. Defeat 2 enemies"
        mission_4.text = "4. 10 minutes run "
        mission_5.text = "5. minutes walk"
        handleNotAuthenticated()
    }
    
    private func  handleNotAuthenticated(){
        // check auth status
        // nill == absence of value
        if Auth.auth().currentUser == nil {
            // show log in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen // user can't swipe it away
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
}

