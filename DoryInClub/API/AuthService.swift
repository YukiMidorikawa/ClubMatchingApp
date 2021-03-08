//
//  AuthService.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/24.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func logUserIn(withEmail email: String,
                          password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials,
                             completion: @escaping((Error?) -> Void)) {
        
        Service.uploadImage(image: credentials.profileImage) { (imageUrl) in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("エラー\(error)")
                    return
                }
                guard let uid = result?.user.uid else { return }
                let data = ["email": credentials.email,
                            "fullName": credentials.fullName,
                            "imageURLs": [imageUrl],
                            "uid": uid,
                            "age": 18] as [String : Any]
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}
