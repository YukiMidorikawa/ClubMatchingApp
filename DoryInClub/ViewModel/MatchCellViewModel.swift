//
//  MatchCellViewModel.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/01.
//

import UIKit

struct MatchCellViewModel {
    
    let nameText: String
    let profileImageUrl: URL?
    let uid: String
    
    init(match: Match) {
        nameText = match.name
        profileImageUrl = URL(string: match.profileImageUrl)
        uid = match.uid
    }
}
