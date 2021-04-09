//
//  FriendRequestViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 17/2/2564 BE.
//

import UIKit


class FriendRequestViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var sendFriendRequestButton: UIButton!
    @IBOutlet weak var titleTextField2: UITextField!
    @IBOutlet weak var friendRequestTable: UITableView!
    
    var img: [String] = []
    var username: [String] = []
    var key_array: [String] = []
    var keyCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupHeaderLabel()
        setupTitle()
        usernameTextField.delegate = self
        let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        friendRequestTable.register(nib, forCellReuseIdentifier: "FriendTableViewCell")
        friendRequestTable.delegate = self
        friendRequestTable.dataSource = self
        friendRequestTable.allowsSelection = false
        friendRequestTable.tableFooterView = UIView()
        sendFriendRequestButton.setTitle("Send friend request", for: .normal)
        sendFriendRequestButton.addTarget(self, action: #selector(sendFriendRequest), for: .touchUpInside)
        
        setupTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        username.removeAll()
        img.removeAll()
    }
    
    func setupHeaderLabel (){
        let title = "Add Friend"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-SemiBold",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
    func setupTitle(){
        titleTextField.text = "Type the username you want to add"
        titleTextField.isUserInteractionEnabled = false
        titleTextField.borderStyle = .none
        titleTextField.font = UIFont(name: "MavenPro-Regular", size: 15)
        
        titleTextField2.text = "People who added you"
        titleTextField2.isUserInteractionEnabled = false
        titleTextField2.borderStyle = .none
        titleTextField2.font = UIFont(name: "MavenPro-Regular", size: 15)
    }
    
    func setupTableView(){
        var count = 0
        DatabaseManager.shared.getFriendsKey(status:"request") { (keys) in
            self.keyCount = keys.count
            for key in keys{
                DatabaseManager.shared.getUsernameImg(key: key) { (datas) in
                    for data in datas{
                        self.username += [data.key]
                        self.img += [data.value]
                    }
                    self.key_array += [key]
                    count += 1
                    if(count == keys.count){
                        self.friendRequestTable.reloadData()}
                }
            }
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        view.endEditing(true)
        usernameTextField.resignFirstResponder()
        return true
    }
    
    
    @objc func sendFriendRequest(){
        if let username = usernameTextField.text, !username.isEmpty{
            DatabaseManager.shared.findUserId(username: username) { (key) in
                if(!key.isEmpty){
                    let alert = UIAlertController(title: "Success", message: "Friend added", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    DatabaseManager.shared.addFriends(key: key, mystatus: "pending", friendstatus: "request")
                }
                else{
                    let alert = UIAlertController(title: "Failed", message: "Username not found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            usernameTextField.text = nil
        }
        else{
            let alert = UIAlertController(title: "Failed", message: "Please enter username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}


extension FriendRequestViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension FriendRequestViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(username.count == keyCount && username.count != 0){
            return username.count
        }
        else{return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        
        if(username.count == keyCount && username.count != 0){
            cell.nameTextField.text = username[indexPath.row]
            cell.key = key_array[indexPath.row]
            if(img[indexPath.row] != nil){
                cell.setPhoto(url: img[indexPath.row])
            }
            cell.noButton.isHidden = false
            cell.yesButton.isHidden = false
        }
        else{
            cell.nameTextField.text = "No one added you right now"
            cell.noButton.isHidden = true
            cell.yesButton.isHidden = true
        }
        return cell
    }
}
