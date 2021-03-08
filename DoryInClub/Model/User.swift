//
//  User.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/22.
//

import UIKit

struct User {
    var name: String
    var age: Int
    let email: String
    let uid: String
    var imageURLs: [String]
    
    var gender: String
    var profession: String
    var minSeekingAge: Int
    var maxSeekingAge: Int
    var bio: String
    var club: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.imageURLs = dictionary["imageURLs"] as? [String] ?? [String]()
        self.uid = dictionary["uid"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.profession = dictionary["profession"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? 18
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? 60
        self.bio = dictionary["bio"] as? String ?? ""
        self.club = dictionary["club"] as? String ?? ""
    }
}
