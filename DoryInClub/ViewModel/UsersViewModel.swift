//
//  UsersViewModel.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/19.
//

import Foundation

struct UsersViewModel {
    
    // MARK: - Propaties
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        guard let profileImageUrl = conversation.user.imageURLs.first else { return nil }
        return URL(string: profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "hh:mm a"
        return dateFomatter.string(from: date)
    }
    
    // MARK: - Lifecycle
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }

}
