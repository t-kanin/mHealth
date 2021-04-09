//
//  FriendViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 17/2/2564 BE.
//

import UIKit


class FriendViewController: UIViewController{

    @IBOutlet weak var friendRequestButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var friendListTableView: UITableView!
    
    var img: [String] = []
    var username: [String] = []
    var key_array: [String] = []
    var keyCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderLabel()
        friendRequestButton.setTitle("add friend", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nib = UINib(nibName: "FriendLsitTableViewCell", bundle: nil)
        friendListTableView.register(nib, forCellReuseIdentifier: "FriendLsitTableViewCell")
        friendListTableView.delegate = self
        friendListTableView.dataSource = self
        friendListTableView.allowsSelection = false
        
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    func setupHeaderLabel (){
        let title = "Friend List"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-SemiBold",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
    func setupTableView(){
        print("set up table view")
        
        username.removeAll()
        img.removeAll()
        key_array.removeAll()
        
        var count = 0
        DatabaseManager.shared.getFriendsKey(status:"accept") { (keys) in
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
                        self.friendListTableView.reloadData()}
                }
            }
        }
        friendListTableView.tableFooterView = UIView()
    }
    
}

extension FriendViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension FriendViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(username.count == keyCount && username.count != 0){
            return username.count
        }
        else{return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendLsitTableViewCell", for: indexPath) as! FriendLsitTableViewCell
        
        if(username.count != 0){
            cell.nameTextField.text = username[indexPath.row]
            if(img[indexPath.row] != nil){
                cell.setPhoto(url: img[indexPath.row])
            }
        }
        else{
            cell.nameTextField.text = "Empty Contacts"
        }
        return cell
    }
}



