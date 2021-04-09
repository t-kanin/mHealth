//
//  DatabaseManager.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 20/11/2563 BE.
//
import FirebaseDatabase

public class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private var databaseHandle: DatabaseHandle?
    
    public struct userInfo{
        var username = ""
        var img = ""
        var score = 0
    }
    
    public struct progress{
        var timestamp: Int
        var count = 0
    }
    
    public struct actionFrequency{
        var punch: Int
        var slash: Int
        var squat: Int
        var run: Int
    }
    
    // MARK: - PUBLIC
    /// Check if username and email is available
    /// -Parameters
    public func canCreatNewUser(with email: String, username: String, completion:(Bool) -> Void){
        completion(true)
    }
    /// insert new user to database
    /// -Parameters
    ///     -completion; Async callback for result if database entry succeded 
    public func insertNewUSer(with email: String, username: String, uid: String, completion: @escaping (Bool) -> Void){
        database.child("users").child(uid).setValue(["username":username , "downloadURL": " ", "score": 0, "notification" :"17:00"]) { error, _ in
            if error == nil {
                self.database.child("users").child(uid).child("stats").setValue(["Strength": 1, "Speed": 1, "Dexterity": 1]){
                    error2,_ in
                    if(error2 == nil){
                        self.database.child("users").child(uid).child("healthkit").setValue(["updateStepcount": false,"updateStairclimb":false,"updateDistancetravel":false,"stepcount": 0, "stairclimb": 0, "distancetravel": 0])
                        self.database.child("users").child(uid).child("action_frequency").setValue(["punch": 1, "slash": 1, "squat": 1, "run": 1])
                        self.updateProgress(progress: "monster_defeat", firstTime: true)
                        self.updateProgress(progress: "number_punches", firstTime: true)
                        self.updateProgress(progress: "number_slashes", firstTime: true)
                        self.updateProgress(progress: "number_squat", firstTime: true)
                        self.updateRuntime(progress: "time_running", time: 0)
                        completion(true)
                        return
                    }
                    else{
                        completion(false)
                        return
                    }
                }
            }
            else {
                completion(false)
                return
            }
        }
    }
    // add to existing account
    public func createFrequency(){
        self.database.child("users").child(AuthManager.shared.getUID()!).child("action_frequency").setValue(["punch": 1, "slash": 1, "squat": 1, "run": 1])
    }
    
    public func getUsername(completion: @escaping(String) -> Void){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("username")
        ref.observeSingleEvent(of: .value){ snapshot in
            let name = snapshot.value as? String
            completion(name!)
        }
    }
    
    public func setNotificationPreference(time: String){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("notification")
        ref.setValue(time)
    }
    
    public func getNotificationPreference(completion: @escaping(String) -> Void){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("notification")
        ref.observeSingleEvent(of: .value) { (time) in
            if(time.value != nil){completion(time.value as! String)}
            else{completion("")}
        }
    }
    
    public func increaseScore(){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("score")
        ref.observeSingleEvent(of: .value){ score in
            var score = score.value as? Int
            score! += 10
            ref.setValue(score)
        }
    }

    
    public func updateProgress(progress: String, firstTime: Bool){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("summary").child(progress).childByAutoId()
        if(firstTime){ref.setValue(["timestamp": ServerValue.timestamp(),"count": 0])}
        else{
            ref.setValue(["timestamp": ServerValue.timestamp(),"count": 1])
        }
    }
    
    public func updateRuntime(progress: String, time: Int){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("summary").child(progress).childByAutoId()
        ref.setValue(["timestamp": ServerValue.timestamp(),"count": time])
    }
    
    public func increaseProgressData(progress: String){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("summary").child(progress).queryOrderedByKey().queryLimited(toLast: 1)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.children.allObjects as? [DataSnapshot] {
                for child in snap{
                    let firebaseTimeStamp = child.childSnapshot(forPath: "timestamp").value as? TimeInterval
                    let timeStamp = Date(timeIntervalSince1970: firebaseTimeStamp!/1000)
                    let calendar = Calendar.current
                    if(calendar.isDateInToday(timeStamp)){
                        let ref_count = self.database.child("users").child(AuthManager.shared.getUID()!).child("summary").child(progress).child(child.key).child("count")
                        ref_count.observeSingleEvent(of: .value) { (count) in
                            var data = count.value as? Int
                            data! += 1
                            ref_count.setValue(data)
                        }
                    }
                    else{self.updateProgress(progress: progress,firstTime:  false)}
                }
            }
        }
    }
    
    public func increaseProgressDataRun(progress: String, time: Int){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("summary").child(progress).queryOrderedByKey().queryLimited(toLast: 1)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.children.allObjects as? [DataSnapshot] {
                for child in snap{
                    let firebaseTimeStamp = child.childSnapshot(forPath: "timestamp").value as? TimeInterval
                    let timeStamp = Date(timeIntervalSince1970: firebaseTimeStamp!/1000)
                    let calendar = Calendar.current
                    if(calendar.isDateInToday(timeStamp)){
                        let ref_count = self.database.child("users").child(AuthManager.shared.getUID()!).child("summary").child(progress).child(child.key).child("count")
                        ref_count.observeSingleEvent(of: .value) { (count) in
                            var data = count.value as? Int
                            data! += time
                            ref_count.setValue(data)
                        }
                    }
                    else{self.updateRuntime(progress: progress, time: time)}
                }
            }
        }
    }
    
    public func getTodayProgressData(progress: String, completion: @escaping(Int) -> Void){
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("summary").child(progress).queryOrderedByKey().queryLimited(toLast: 1)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.children.allObjects as? [DataSnapshot] {
                for child in snap{
                    let firebaseTimeStamp =  child.childSnapshot(forPath: "timestamp").value as? TimeInterval
                    let timeStamp = Date(timeIntervalSince1970: firebaseTimeStamp!/1000)
                    let calendar = Calendar.current
                    if(calendar.isDateInToday(timeStamp)){
                        let data = child.childSnapshot(forPath: "count").value as! Int
                        completion(data)
                    }
                    else{//print("data is not for today")
                        completion(0)
                    }
                }
            }
        }
    }
    
    public func getProgressData(progress_str: String, numOfDays: Int, completion: @escaping([progress]) -> Void){
        var progressArr:[progress] = []
        var progressData = progress(timestamp: 0)
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("summary").child(progress_str).queryOrderedByKey().queryLimited(toLast: UInt(numOfDays) )
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let userdict = snap.value as? Dictionary<String, AnyObject>{
                        progressData.timestamp = userdict["timestamp"] as! Int
                        progressData.count = userdict["count"]! as! Int
                        progressArr.insert(progressData, at: 0)
                    }
                }
                completion(progressArr)
            }
        }
    }
    
    
    public func getArrayOfProcessData(completion: @escaping([Int]) -> Void){
        var data: [Int] = []
        getTodayProgressData(progress: "monster_defeat") { (monster_defeat) in
            data += [monster_defeat]
            self.getTodayProgressData(progress: "number_punches") { (punches) in
                data += [punches]
                self.getTodayProgressData(progress: "number_slashes") { (slashes) in
                    data += [slashes]
                    self.getTodayProgressData(progress: "number_squat") { (squat) in
                        data += [squat]
                        self.getTodayProgressData(progress: "time_running") { (time) in
                            data += [time]
                            completion(data)
                        }
                    }
                }
            }
        }
    }
    
    public func updateDownloadURL(url: String, uid: String){
        database.child("users").child(uid).updateChildValues(["downloadURL": url])
    }
    
    public func getDownloadURL(){
        let uid = AuthManager.shared.getUID()
        database.child("users").child(uid!).child("downloadURL").observeSingleEvent(of: .value, with: { (snapshot) in
            if let actualUrl = snapshot.value as? String{
                // do something like reload the page 
            }
        })
    }
    
    public func getFrequency(progressFrequency: String, completion: @escaping(Int) -> Void){
        let uid = AuthManager.shared.getUID()!
        database.child("users").child(uid).child("action_frequency").child(progressFrequency).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? Int{
                completion(data)
                return
            }
        }
    }
    
    public func getAllFrequency(completion: @escaping(actionFrequency) -> Void){
        let uid = AuthManager.shared.getUID()!
        var action_frequency = actionFrequency(punch: 0, slash: 0, squat: 0, run: 0)
        let ref = database.child("users").child(uid).child("action_frequency")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if(snap.key == "punch"){action_frequency.punch = snap.value as! Int }
                    if(snap.key == "run"){action_frequency.run = snap.value as! Int }
                    if(snap.key == "slash"){action_frequency.slash = snap.value as! Int }
                    if(snap.key == "squat"){action_frequency.squat = snap.value as! Int }
                }
                completion(action_frequency)
            }
        }
    }
    
    public func increaseFrequency(progressFrequency: String){
        getFrequency(progressFrequency: progressFrequency) { (frequency) in
            if var myFrequency = frequency as? Int{
                myFrequency += 1
                self.database.child("users").child(AuthManager.shared.getUID()!).child("action_frequency").updateChildValues([progressFrequency: myFrequency])
            }
        }
    }
    
    public func getStats(stats:String, completion: @escaping(Int) -> Void) {
        let uid = AuthManager.shared.getUID()
        database.child("users").child(uid!).child("stats").child(stats).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? Int{
                completion(data)
                return
            }
        }
    }
    
    public func increaseStats(stats: String){
        getStats(stats: stats) { stat in
            if var mystat = stat as? Int {
                mystat += 1
                self.database.child("users").child(AuthManager.shared.getUID()!).child("stats").updateChildValues([stats: mystat])
            }
        }
    }
    
    public func getUpdateStatus(updateStatus: String,completion: @escaping(Bool)-> Void){
        database.child("users").child(AuthManager.shared.getUID()!).child("healthkit").child(updateStatus).observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? Bool {
                completion(data)
                return
            }
        }
    }
    
    public func setStatUpdate(uid: String, status: Bool, updateStats: String){
        database.child("users").child(uid).child("healthkit").updateChildValues([updateStats: status])
    }
    
    public func updateStepcount(uid: String, completion: @escaping(Bool) -> Void){
        HealthManager.shared.calculateStepDouble { result in
            if let stepcount = result{
                self.database.child("users").child(uid).child("healthkit").updateChildValues(["stepcount": stepcount]){
                    error, _ in
                    if(error == nil){
                        completion(true)
                        return
                    }
                    else{
                        completion(false)
                        return
                    }
                }
            }
        }
    }
    
    public func updateDistanceTravel(uid: String, completion: @escaping(Bool) -> Void){
        HealthManager.shared.getDistanceTravelDouble{ result in
            if let distance = result{
                self.database.child("users").child(uid).child("healthkit").updateChildValues(["distancetravel": distance]){
                    error, _ in
                    if(error == nil){
                        completion(true)
                        return
                    }
                    else{
                        completion(false)
                        return
                    }
                }
            }
        }
    }
    
    public func updateStairClimb(uid: String, completion: @escaping(Bool) -> Void){
        var cc: Double?
        HealthManager.shared.getTodayFlightsClimbDouble { result in
            if(result == nil){
                cc = 0
            }
            else{
                if let stairclimb = result{
                    cc = stairclimb
                }
            }
            self.database.child("users").child(uid).child("healthkit").updateChildValues(["stairclimb": cc!]){
                error, _ in
                if(error == nil){
                    completion(true)
                    return
                }
                else{
                    completion(false)
                    return
                }
            }
        }
    }
    
    public func getStepcount(uid: String, completion: @escaping(Double)-> Void){
        database.child("users").child(uid).child("healthkit").child("stepcount").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? Double{
                completion(data)
                return
            }
        }
    }
    
   
    public func getDistancetravel(uid: String, completion: @escaping(Int)-> Void){
        database.child("users").child(uid).child("healthkit").child("distancetravel").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? Int{
                completion(data)
                return
            }
        }
    }
   
   
    public func getStairclimb(uid: String, completion: @escaping(Double)-> Void){
        database.child("users").child(uid).child("healthkit").child("stairclimb").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? Double{
                completion(data)
                return
            }
        }
    }
    
    /*friends system*/
    
    public func addFriends(key: String, mystatus: String, friendstatus: String){
        let userid = AuthManager.shared.getUID()
        let ref = database.child("users").child(userid!).child("friends")
        ref.child(key).setValue(mystatus)
        
        let friendRef = database.child("users").child(key).child("friends")
        friendRef.child(userid!).setValue(friendstatus)
    }
    
    public func getFriends(completion: @escaping(Dictionary<String, String>) -> Void){
        let ref = database.child("users")
        ref.observe(.value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let userdict = snap.value as? Dictionary<String, AnyObject>{
                        let username = userdict["username"]! as! String
                        let img = userdict["downloadURL"]! as! String
                        completion([username: img])
                    }
                }
            }
        }
    }
    
    public func getFriendsKey(status: String, completion: @escaping([String]) -> Void){
        var keys: [String] = []
        let ref = database.child("users").child(AuthManager.shared.getUID()!).child("friends")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if(snap.value as! String == status){keys += [snap.key]}
                }
                completion(keys)
            }
        }
    }

    public func getUsernameImg(key: String, completion: @escaping(Dictionary<String, String>) -> Void){
        let ref = database.child("users").child(key)
        var img = ""
        var username = ""
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if(snap.key == "downloadURL"){img = snap.value as! String }
                    if(snap.key == "username"){username = snap.value as! String }
                }
                completion([username: img])
            }
        }
    }
    
    public func getUsernameImgScore(key: String, completion: @escaping(userInfo) -> Void){
        var user = userInfo()
        let ref = database.child("users").child(key)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if(snap.key == "username"){user.username = snap.value as! String}
                    if(snap.key == "downloadURL"){user.img = snap.value as! String}
                    if(snap.key == "score") {user.score = snap.value as! Int}
                }
                completion(user)
            }
        }
    }
    
    public func leaderboard(completion: @escaping([userInfo]) -> Void){
        var user = userInfo()
        var user_array: [userInfo]  = []
        let ref = database.child("users").queryOrdered(byChild: "score")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let userdict = snap.value as? Dictionary<String, AnyObject>{
                        user.username = userdict["username"] as! String
                        user.img = userdict["downloadURL"] as! String
                        user.score = userdict["score"] as! Int
                    }
                    user_array.insert(user, at: 0)
                }
                
                completion(user_array)
            }
        }
    }
    
    public func findUserId(username: String, completion: @escaping(String) -> Void){
        let ref = database.child("users")
        var key: String?
        ref.observe(.value) { (snapshot) in
            var found = false
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let userdict = snap.value as? Dictionary<String, AnyObject>{
                        if(userdict["username"] as! String == username){
                            found = true
                            key = snap.key
                        }
                    }
                }
            }
            if(found){completion(key!)}
            else{completion("")}
        }
    }
    
    public func findUsernameFromKey(key: String, completion: @escaping(String)-> Void){
        let ref = database.child("users")
        ref.observe(.value){ snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let userdict = snap.value as? Dictionary<String, AnyObject>{
                        if(snap.key == key){ completion(userdict["username"] as! String)
                            return
                        }
                    }
                }
            }
        }
    }
    
    public func processFriendRequest(friendid: String,status: String){
        let userid = AuthManager.shared.getUID()!
        let friendRef = database.child("users").child(friendid)
        friendRef.child("friends").updateChildValues([userid:status])
        
        let ref = database.child("users").child(userid)
        ref.child("friends").updateChildValues([friendid:status])
    }
    
}
    
