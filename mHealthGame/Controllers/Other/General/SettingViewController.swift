//
//  ProgressViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 3/12/2563 BE.
//

import UIKit

class SettingViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI(){
        setupTitleLabel()
        setupProfilePic()
    }
    
}

