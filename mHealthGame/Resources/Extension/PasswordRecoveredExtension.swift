//
//  PasswordRecoveredExtension.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 5/12/2563 BE.
//

import UIKit

extension PasswordRecoverViewController {
    
    func setupTitleLabel (){
        let title = "Forgot Password"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"Didot",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
    func setupRecoveryButton(){
        recoveryButton.setTitle("RESET MY PASSWORD", for: UIControl.State.normal)
        recoveryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        recoveryButton.backgroundColor = UIColor.black
        recoveryButton.layer.cornerRadius = 5
        recoveryButton.clipsToBounds = true
        recoveryButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    
    func setupEmailTextField(){
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        emailContainerView.layer.cornerRadius = 3
        emailContainerView.clipsToBounds = true
        
        emailTextField.borderStyle = .none
        let placeHolderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        emailTextField.attributedPlaceholder = placeHolderAttr
        emailTextField.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
    }
}
