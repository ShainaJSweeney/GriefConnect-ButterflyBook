//
//  UserDatabaseModel.swift
//  GriefConnect
//
//  Created by Shaina Sweeney on 9/25/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseAPI{
    static let shared = DatabaseAPI()
    private let database = Database.database(url: "https://griefconnect-49d76-default-rtdb.firebaseio.com/").reference()
}

struct User {
    let username: String
    
    var checkedEmail: String{
        var checkedEmail = username.replacingOccurrences(of: ".", with: "-")
        checkedEmail = checkedEmail.replacingOccurrences(of: "@", with: "-")
        return checkedEmail
    }
    
    public func printUser() -> String{
        return username
    }
}

extension DatabaseAPI{
    
    public func checkIfEmailExists(with email: String, completion: @escaping (Bool) -> Void){
        var checkedEmail = email.replacingOccurrences(of: ".", with: "-")
        checkedEmail = checkedEmail.replacingOccurrences(of: "@", with: "-")
        database.child(checkedEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
            
        })
    }
    
    
    
    public func postNewUser(with user: User, completion: @escaping (Bool) -> Void){
        database.child(user.checkedEmail).setValue(
            ["email": user.username], withCompletionBlock: { error, _ in
                guard error == nil else{
                    print("write database failed")
                    completion(false)
                    return
                }
                
                self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                    if var users = snapshot.value as? [[String: String]] {
                        let newElement = [
                            "email": user.checkedEmail
                        ]
                        users.append(newElement)
                        self.database.child("users").setValue(newElement, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    } else {
                        let newCollection : [String: String] = [
                            "email": user.checkedEmail
                        ]
                        self.database.child("users").setValue(newCollection, withCompletionBlock: {error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    }
                    
                    
                })
            }
        )
    }
}

