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
        database.child("users").child(uid).setValue(["username":username , "downloadURL": " "]) { error, _ in
            if error == nil {
                completion(true)
                return
            }
            else {
                completion(false)
                return
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
}
