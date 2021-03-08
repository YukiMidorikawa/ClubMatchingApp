//
//  CardViewModel.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/22.
//

import UIKit

class CardViewModel {
    
    let user: User
    let imageURLs: [String]
    let userInfoText: NSAttributedString
    let clubInfoText: NSAttributedString
    private var imageIndex = 0
    var index: Int { return imageIndex}
    
    var imageUrl: URL?
    
    init(user: User) {
        self.user = user
        
        let nameAttributedText = NSAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white])
        
        let ageAttributedText = NSAttributedString(string: " \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white])
        
        let clubAttributedText = NSAttributedString(string: " \(user.club)", attributes: [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.systemPink])
        
        let combination = NSMutableAttributedString()
        
        combination.append(nameAttributedText)
        combination.append(ageAttributedText)
        
        self.userInfoText = combination
        self.clubInfoText = clubAttributedText
        
//        self.imageUrl = URL(string: user.profileImageUrl)
        self.imageURLs = user.imageURLs
        self.imageUrl = URL(string: self.imageURLs[0])
    }
    
    func showNextPhoto() {
        guard imageIndex < imageURLs.count - 1 else { return }
        imageIndex += 1
        imageUrl = URL(string: imageURLs[imageIndex])
        print("次へ")
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        imageUrl = URL(string: imageURLs[imageIndex])
        print("前へ")
    }
    
    
}
