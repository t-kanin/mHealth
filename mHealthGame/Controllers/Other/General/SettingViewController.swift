//
//  ProgressViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 3/12/2563 BE.
//
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import UIKit

class SettingViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var image: UIImage? = nil  
    var url : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uid = AuthManager.shared.getUID()
        var url : String?
        Database.database().reference().child("users").child(uid!).child("downloadURL").observeSingleEvent(of: .value, with: { (snapshot) in
            if let actualUrl = snapshot.value as? String{
                self.profilePic.sd_setImage(with: URL(string: actualUrl), placeholderImage: UIImage(systemName: "photo"), options:.continueInBackground, completed: nil)
            }
        })
    }
    
    private func setupUI(){
        setupTitleLabel()
        setupProfilePic()
        setupLogoutButton() 
    }
    
    @objc private func didTapLogout(){
        
        AuthManager.shared.logout(){ success in
            if success {
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen // user can't swipe it away
                self.present(loginVC, animated: true, completion: nil)
            }
            else {
                print("Sign oute failed")
            }
        }
    }
}
