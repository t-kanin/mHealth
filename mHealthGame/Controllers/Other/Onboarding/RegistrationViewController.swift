//
//  RegistrationViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 15/11/2563 BE.
//

import UIKit

class RegistrationViewController: UIViewController {

    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let username: UITextField = {
        let field = UITextField()
        let placeHolderAttr = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        field.attributedPlaceholder = placeHolderAttr
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        field.layer.cornerRadius = 3
        field.clipsToBounds = true
        
        field.attributedPlaceholder = placeHolderAttr
        field.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        
        return field
    }()
    
    private let email: UITextField = {
        let field = UITextField()
        let placeHolderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        field.attributedPlaceholder = placeHolderAttr
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        field.layer.cornerRadius = 3
        field.clipsToBounds = true
        
        field.attributedPlaceholder = placeHolderAttr
        field.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        
        return field
    }()
    
    private let password: UITextField = {
        let field = UITextField()
        let placeHolderAttr = NSAttributedString(string: "Password (8+ Characters)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        field.isSecureTextEntry = true
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no

        field.layer.cornerRadius = 3
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        field.clipsToBounds = true
        field.attributedPlaceholder = placeHolderAttr
        field.textColor = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1)
        
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        username.delegate = self
        email.delegate = self
        password.delegate = self
        view.addSubview(username)
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(registerButton)
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        username.frame = CGRect(x: 20, y: view.safeAreaInsets.top+50, width: view.width-40, height: 52)
        email.frame = CGRect(x: 20, y: username.bot+10, width: view.width-40, height: 52)
        password.frame = CGRect(x: 20, y: email.bot+10, width: view.width-40, height: 52)
        registerButton.frame = CGRect(x: 20, y: password.bot+10, width: view.width-40, height: 52)
    }
    
    @objc private func didTapRegister(){
        email.resignFirstResponder()
        username.resignFirstResponder()
        password.resignFirstResponder()
        
        guard let email = email.text, !email.isEmpty,
        let password = password.text, !password.isEmpty, password.count >= 8,
        let username = username.text, !username.isEmpty else {return}
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) {
            registered in
            DispatchQueue.main.async {
                if registered {
                    /*
                    let vc = HomeViewController()
                    vc.modalPresentationStyle = .fullScreen // user can't swipe it away
                    self.present(vc, animated: true, completion: nil)
                     */
                }
                else {
                    //failed
                }
            }
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username {
            email.becomeFirstResponder()
        }
        else if textField == email{
            password.becomeFirstResponder()
        }
        else{
            didTapRegister()
        }
        return true
    }
}
