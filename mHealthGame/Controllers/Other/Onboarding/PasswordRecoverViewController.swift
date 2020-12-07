//
//  PasswordRecoverViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 5/12/2563 BE.
//

import UIKit

class PasswordRecoverViewController: UIViewController{
    
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var recoveryButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI(){
        setupTitleLabel()
        setupEmailTextField()
        setupRecoveryButton()
    }
    
}
