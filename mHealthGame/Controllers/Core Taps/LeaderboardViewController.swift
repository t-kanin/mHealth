//
//  ProgressViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 3/12/2563 BE.
//

import UIKit
import FirebaseAuth

class LeaderboardViewController: UIViewController{
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    var keyCount = 0
    
    var user_array: [DatabaseManager.userInfo]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderLabel()
        rankLabel.text = "#"
        usernameLabel.text = "Username"
        scoreLabel.text = "Score"
        handleNotAuthenticated()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let nib = UINib(nibName: "LeaderboardTableViewCell", bundle: nil)
        leaderboardTableView.register(nib, forCellReuseIdentifier: "LeaderboardTableViewCell")
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        leaderboardTableView.allowsSelection = false
        leaderboardTableView.tableFooterView = UIView()
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    func setupHeaderLabel (){
        let title = "Leaderboard"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-SemiBold",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
    func setupTableView(){
        
        user_array.removeAll()
        
        var count = 0
        
        DatabaseManager.shared.getUsernameImgScore(key: AuthManager.shared.getUID()!) { (data) in
            var user = DatabaseManager.userInfo()
            user.username = data.username
            user.img = data.img
            user.score = data.score
            self.user_array += [user]
            self.user_array.sort{$1.score < $0.score}
            self.leaderboardTableView.reloadData()
        }
        
        DatabaseManager.shared.getFriendsKey(status:"accept") { (keys) in
            self.keyCount = keys.count
            for key in keys{
                DatabaseManager.shared.getUsernameImgScore(key: key) { data in
                    var user = DatabaseManager.userInfo()
                    user.username = data.username
                    user.img = data.img
                    user.score = data.score
                    self.user_array += [user]
                    count += 1
                    if(count == keys.count){
                        self.user_array.sort{$1.score < $0.score}
                        self.leaderboardTableView.reloadData()
                    }
                }
            }
        }
        
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

extension LeaderboardViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension LeaderboardViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(user_array.count != 0){
            return user_array.count
        }
        else{return 1 }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardTableViewCell", for: indexPath) as! LeaderboardTableViewCell
        
        
        if(user_array.count != 0){
            cell.usernameLabel.text = user_array[indexPath.row].username
            let strg = user_array[indexPath.row].score
            cell.scoreLabel.text = String(strg)
            cell.rankLabel.text = String(indexPath.row + 1)
            if(user_array[indexPath.row].img != nil){
                cell.setPhoto(url: user_array[indexPath.row].img)
            }
        }
        else{
            cell.usernameLabel.text = "Empty Contacts"
        }
        return cell
    }
}
