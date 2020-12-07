//
//  ViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 15/11/2563 BE.
//
import FirebaseAuth
import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        setupHeaderLabel()
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
    
    func setupHeaderLabel (){
        let title = "Home"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"Didot",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
}

