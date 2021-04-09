//
//  LoginViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 15/11/2563 BE.
//

import UIKit

class LoginViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        header.backgroundColor = .red
        // let backgroundImageView = UIImageView(image: UIImage (named: "gradient"))
        // header.addSubView(backgroundImageView)
        return header
    }()
    private let usernameEmail: UITextField = {
        let field = UITextField()
        let placeHolderAttr = NSAttributedString(string: "Email Address or Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let recoveryButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Forgot Password? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black])
        button.setAttributedTitle(attributedText, for: UIControl.State.normal)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.65)])
        
        let attributedSubText = NSMutableAttributedString(string: "Create Account", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(attributedSubText)
        
        button.setAttributedTitle(attributedText, for: UIControl.State.normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        recoveryButton.addTarget(self, action: #selector(didTapRecoveryPasswordButton), for: .touchUpInside)
        usernameEmail.delegate = self
        password.delegate = self
        addSubViews()
        view.backgroundColor = UIColor.systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // assign frames
        headerView.frame = CGRect(
            x:0,
            y:0.0,
            width: view.width,
            height: view.height/3.0
        )
        
        usernameEmail.frame = CGRect(
            x:25,
            y:headerView.bot + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        password.frame = CGRect(
            x:25,
            y:usernameEmail.bot + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        loginButton.frame = CGRect(
            x:25,
            y:password.bot + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        createAccountButton.frame = CGRect(
            x:25,
            y:loginButton.bot + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        recoveryButton.frame = CGRect(
            x:25,
            y:createAccountButton.bot + 210,
            width: view.width - 50,
            height: 52.0
        )
        
        //configureHeaderView()
    }
    private func configureHeaderView(){
        guard headerView.subviews.count == 1 else {
            return
        }
        
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        backgroundView.frame = headerView.bounds
        /*
        //Add logo
        let imageView = UIImageView(image: UIImage(named: "text"))
        headerView.contentMode = .scaleAspectFit
        imageView.frame = CGReact(x: headerview.width/4.0, y: view.safeAreaInserts.top, width: headerView.width,
        height: hearderView.height - view.safeAreaInserts.top
        )
        */
    }
    
    private func addSubViews(){
        view.addSubview(usernameEmail)
        view.addSubview(password)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(recoveryButton)
    }
    
    @objc private func didTapLoginButton() {
        password.resignFirstResponder()
        usernameEmail.resignFirstResponder()
        
        guard let usernameEmail = usernameEmail.text, !usernameEmail.isEmpty,
              let password = password.text, !password.isEmpty else{
                let alert = UIAlertController(title: "Empty Password",message: "Please Enter Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dissmiss",style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
        }
        
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"), usernameEmail.contains((".")){
            // email
            email = usernameEmail
        }
        else {
            // username
            username = usernameEmail
        }
        //login func
        AuthManager.shared.loginUser(username: username, email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                     //user logged in
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    // error
                    let alert = UIAlertController(title: "Login Error",message: "Wrong Email or Password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dissmiss",style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapCreateAccountButton() {
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func didTapRecoveryPasswordButton(){
        let vc = PasswordRecoverViewController()
        vc.modalPresentationStyle = .fullScreen // user can't swipe it away
        self.present(vc, animated: true, completion: nil)
    }
}



extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmail {
            password.becomeFirstResponder() // keyboard pop-up
        }
        else if textField == password {
            view.endEditing(true)
            password.resignFirstResponder()
           // usernameEmail.becomeFirstResponder()
        }
        return true
    }
}
