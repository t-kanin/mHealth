//
//  AuthManager.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 20/11/2563 BE.
//
import FirebaseAuth

public class AuthManager {
    static let shared = AuthManager()
    // MARK: - PUBLIC
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void){
        DatabaseManager.shared.canCreatNewUser(with: email, username: username) { canCreate in
            if canCreate{
                /*create account*/
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else{
                        //Firebase auth could not create account
                        completion(false)
                        return
                    }
                    // insert into database
                    
                    guard let userid = Auth.auth().currentUser?.uid else {
                        completion(false)
                        return
                    }
                    DatabaseManager.shared.insertNewUSer(with: email, username: username, uid: userid) {insert in
                        if insert{
                            completion(true)
                            return
                        }
                        else{
                            // failed to insert to database
                            completion(false)
                            return
                        }
                    }
                }
            }
            else{
                //creation failed
                completion(false)
            }
        }
    }
    

    public func loginUser (username: String?, email: String?, password: String, completion: @escaping(Bool) -> Void){
        if let email = email {
            // email login
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else{
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
            //username login
            //TODO: add username login ?
            
        }
    }
    
    public func logout (completion: @escaping(Bool) -> Void){
        do{
            try Auth.auth().signOut()
            completion(true)
        }
        catch{
            print("failed to sign out")
            completion(false)
        }
    }
    
    public func getUID()->String?{
        let userId = Auth.auth().currentUser?.uid
        return userId
    }
}
