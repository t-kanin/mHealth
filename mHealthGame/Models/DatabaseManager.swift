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
        database.child("users").child(uid).setValue(["username":username]) { error, _ in
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
    
}
