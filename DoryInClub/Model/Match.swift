//
//  Match.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/01.
//

import UIKit

struct Match {
    let name: String
    let profileImageUrl: String
    let uid: String
//    let isTouch: Bool
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
//        self.isTouch = dictionary["isTouch"] as? Bool ?? false

    }
}
