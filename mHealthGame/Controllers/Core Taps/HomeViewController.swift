//
//  ViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 15/11/2563 BE.
//
import FirebaseAuth
import UIKit
import EventKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let monster_name = ["Yellow", "Blue","Green","Pink","Purple","Brown"]
    var monster_type: [Int] = []
    var action: [Int] = []
    var ready = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        handleNotAuthenticated()
        
        
        for _ in 1...monster_name.count {
            monster_type += [Int.random(in: 1...6)]
            //action += [Int.random(in: 1...4)]
        }
        sentNotification(offsetHour: 0)
        randAction { (randAction) in
            self.action = randAction
            self.ready = true
            self.tableView.reloadData()
        }
    }

    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        setupHeaderLabel()
        
        let nib = UINib(nibName: "PrototypeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PrototypeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleNotAuthenticated()
    }
    
    private func sentNotification(offsetHour: Int){
        
        var available = true
        
        fetchPreferenceTime { (hour, minute) in
            let date = Date()
            let calendar = Calendar.current
            let hour = hour + offsetHour
            let newDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)
            
            // fetch events
            let eventstore = EKEventStore()
            eventstore.requestAccess(to: .event) { (granted, err) in
                if granted{
                    EventManager.shared.getTodayEvent(completion: { (events) in
                        for event in events{
                            if(newDate! >= event.startDate && newDate! <= event.endDate && !event.isAllDay){available = false}
                        }
                        
                        if(!available){//print("time slot is occupied")
                            self.sentNotification(offsetHour: 1)
                        }
                        else{//print("time slot is free, notification sent at: \(newDate!)")
                            self.setNotification(offsetHour: offsetHour)
                        }
                    })
                }
                else{ print("access event is denied")}
            }
            
        }
    }
    
    private func fetchPreferenceTime(completion: @escaping(Int, Int) -> Void){
        DatabaseManager.shared.getNotificationPreference { (time) in
            if(!time.isEmpty){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let date = dateFormatter.date(from: time)
                
                dateFormatter.dateFormat = "HH"
                let hour = Int(dateFormatter.string(from: date!))
                
                dateFormatter.dateFormat = "mm"
                let minute = Int(dateFormatter.string(from: date!))
                
                completion(hour!, minute!)
            }
            else{completion(17,0)}
        }
    }
    
    private func setNotification(offsetHour: Int){
        var title = ""
        var body = ""
        NotificationManager.shared.requestAuth { (granted) in
            if granted{
                NotificationManager.shared.hasNotificationFired { (fired) in
                    if(!fired){
                        DatabaseManager.shared.getProgressData(progress_str: "monster_defeat", numOfDays: 1) { (progressArr) in
                            for progress in progressArr {
                                let lastPlay = self.checkTimeStamp(interval: TimeInterval(progress.timestamp/1000))
                                if(lastPlay >= 3){
                                    title = "Hey, how are you"
                                    body = "You haven't founght defeat monster for the past few days, let's fight them and climb the leaderbaord"
                                }else{
                                     title =  "Hey, how's your day?"
                                     body = "It's time for your  daily exericise"
                                }
                                var dateCompoents = DateComponents()
                                dateCompoents.hour = 17 + offsetHour
                                NotificationManager.shared.sendNotification(dateComponents: dateCompoents, title: title, body: body)
                            }
                        }
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
    
    
    // find ceiling of  in arr[l..h]
    private func findCeil(arr: [Int], r: Int, l: Int, h: Int) -> Int{
        var mid: Int
        var ll = l
        var hh = h
        
        repeat{
            mid = (ll + hh) / 2
            if(r > arr[mid]) { ll = mid + 1}
            else{ hh = mid}
        }while(ll < hh)
        if(arr[ll] >= r){return ll}
        else{return 0}
    }
    
    private func myRand(arr: [Int], freq:[Int], n: Int) -> Int {
        //create and fill prefix array
        var prefix = [Int].init(repeating: 0, count: n)
        prefix[0] = freq[0]
        for i in 1..<n {
            prefix[i] = prefix[i - 1] + freq[i]
        }
        // prefix n - 1 is the sum of all frequencies.
        // generate a random number with value from 1 to the sum
        let rand = Int.random(in: 1...prefix[n - 1])
        let index = findCeil(arr: prefix, r: rand, l: 0, h: n - 1)
        return arr[index]
    }
        
    private func randAction(completion: @escaping(([Int]) -> Void)){
        let arr = [1,2,3,4] // punch, slash, squat, run
        var freq: [Int] = []
        var action: [Int] = []
        let n = arr.count
        DatabaseManager.shared.getAllFrequency { [self] (actionFrequency) in
            freq = [actionFrequency.punch, actionFrequency.slash,actionFrequency.squat,actionFrequency.run]
            for _ in 1...monster_name.count {
                let rand = myRand(arr: arr, freq: freq, n: n)
                action += [rand]
            }
            print("action: \(arr)")
            print("freq  : \(freq)")
            print("result: \(action)")
            completion(action)
        }
    }
    
    
    func checkTimeStamp(interval : TimeInterval) -> Int{
        
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return 1  }
        else if calendar.isDateInToday(date) { return 0 }
        else if calendar.isDateInTomorrow(date) { return 1 }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return -day }
            else { return day }
        }
    }
    
    
}

extension HomeViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(action[indexPath.row] != 4){
            if let vc = storyboard?.instantiateViewController(identifier: "MapViewController") as? FightArenaViewController{
                vc.monster_img = "Funny_Monsters_\(monster_type[indexPath.row])"
                vc.action = action[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            if let vc = storyboard?.instantiateViewController(identifier: "RunGameViewController") as? RunGameViewController{
                vc.monster_img = "monster_\(monster_type[indexPath.row])"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!ready){return 1}
        else{return monster_name.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeTableViewCell", for: indexPath) as! PrototypeTableViewCell
        
        let index = indexPath.row
        
        if(!ready){cell.label.text = "calculating..."}
        else{
            cell.label.text = monster_name[monster_type[indexPath.row] - 1]
            
            cell.photoView.image = UIImage(named: "monster_\(monster_type[indexPath.row])")
            if(action[index] == 1){
                cell.photoView2.image = UIImage(named: "punch")
            }
            else if(action[index] == 2){cell.photoView2.image = UIImage(named: "doublesword")}
            else if(action[index] == 3){cell.photoView2.image = UIImage(named: "squats")}
            else{ cell.photoView2.image = UIImage(named: "run")}
        }
        return cell
    }
}

