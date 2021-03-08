//
//  MessageViewModel.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/02/13.
//

import UIKit

struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : .systemPink
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white

    }
    
    var rightAncherActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAncherActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil }
        guard  let profileImageUrl = user.imageURLs.first else { return nil }
        return URL(string: profileImageUrl)
    }

    
    init(message: Message) {
        self.message = message
    }
    
}
