//
//  SettingsViewModel.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/25.
//

import UIKit

enum SettingsSections: Int, CaseIterable {
    case name
    case profession
    case age
    case bio
    case gender
    case club
//    case ageRange
    
    var discription: String {
        switch self {
        case .name: return "Name"
        case .profession: return "Profession"
        case .age: return "age"
        case .bio: return "Bio"
        case .gender: return "man or female"
        case .club: return "favorite or being club"
//        case .ageRange: return "Seeking Age Range"
        }
    }
}

struct SettingsViewModel {
    
    private let user: User
    let sections: SettingsSections
    
    let placeholderText: String
    var value: String?
    
    var shouldHideInputTextField: Bool {
        return sections == .gender || sections == .club
    }
    
    var shouldHideGenderPicker: Bool {
        return sections != .gender
    }
    
    var shouldHideClubPicker: Bool {
        return sections != .club
    }
    
//    var shouldHideSlider: Bool {
//        return sections != .ageRange
//    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge)
    }
    
    func minAgeLabelText(forValue value: Float) -> String {
        return "Min \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String {
        return "Max \(Int(value))"
    }
    
    
    init(user: User, sections: SettingsSections) {
        self.user = user
        self.sections = sections
        
        placeholderText = "Enter \(sections.discription.lowercased())"
        
        switch sections {
        
        case .name:
            value = user.name
        case .profession:
            value = user.profession
        case .age:
            value = "\(user.age)"
        case .bio:
            value = user.bio
        case .gender:
            value = user.gender
        case .club:
            value = user.club
//        case .ageRange:
//            break
        }
    }
    
}
