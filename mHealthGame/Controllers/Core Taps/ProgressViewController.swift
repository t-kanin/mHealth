//
//  ProgressViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 26/2/2564 BE.
//

import UIKit
import FirebaseAuth

class ProgressViewController: UIViewController{
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var progressTableView: UITableView!
    
    var pickerSelectedItem = 0
    
    let title_arr:[String] = ["Monster defeat today", "Number of today punches", "Number of today slashes", "Number of today squat", "Time running today"]
    
    let summary_arr:[String] = ["monster defeated","punched throw","slashed","squat","minutes run"]
    var summary_arr_Int: [Int] = []
    let img_arr:[String] = ["Funny_Monsters_1","punch","doublesword","squats","run"]
    
    var ready = false
    
    override func viewDidLoad() {
        setupHeaderLabel()
        handleNotAuthenticated()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ready = false
        summary_arr_Int.removeAll()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let nib = UINib(nibName: "ProgressTableViewCell", bundle: nil)
        progressTableView.register(nib, forCellReuseIdentifier: "ProgressTableViewCell")
        progressTableView.delegate = self
        progressTableView.dataSource = self
        
        progressTableView.tableFooterView = UIView()
        
        DatabaseManager.shared.getArrayOfProcessData { (data) in
            self.summary_arr_Int = data
            self.ready = true
            DispatchQueue.main.async {
                self.progressTableView.reloadData()
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
    
    func setupHeaderLabel (){
        let title = "Summary"
        let attributedText = NSMutableAttributedString(string: title,attributes:
                            [NSAttributedString.Key.font: UIFont.init(name:"MavenPro-SemiBold",size: 28)!,NSAttributedString.Key.foregroundColor: UIColor.black])
        headerLabel.attributedText = attributedText
    }
    
}


extension ProgressViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "MonsterGraphViewController") as? GraphViewController{
            self.navigationController?.pushViewController(vc, animated: true)
            vc.title = "Summary"
            if(indexPath.row == 0){vc.chartLabel = "Enemy Defeated"
                vc.progress_str = "monster_defeat"
            }
            if(indexPath.row == 1){vc.chartLabel = "Number of punches"
                vc.progress_str = "number_punches"
            }
            if(indexPath.row == 2){vc.chartLabel = "Number of slashes"
                vc.progress_str = "number_slashes"
            }
            if(indexPath.row == 3){vc.chartLabel = "Number of squat done"
                vc.progress_str = "number_squat"
            }
            if(indexPath.row == 4){vc.chartLabel = "Running time (minutes)"
                vc.progress_str = "time_running"
            }
        }
    }
    
}

extension ProgressViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressTableViewCell", for: indexPath) as! ProgressTableViewCell
        cell.titleLabel.text = title_arr[indexPath.row]
        if(ready){
            cell.setText(data: summary_arr_Int[indexPath.row],textBack: summary_arr[indexPath.row])
        }
        else{ cell.todayLabel.text = "retreving data..."}
        cell.photoImage.image = UIImage(named: img_arr[indexPath.row] )
        return cell
    }
}

