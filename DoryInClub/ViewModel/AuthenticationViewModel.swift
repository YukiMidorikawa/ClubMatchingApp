//
//  AuthenticationViewModel.swift
//  DoryInClub
//
//  Created by 緑川裕紀 on 2021/01/24.
//

import Foundation

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
            password?.isEmpty == false
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var fullName: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
            fullName?.isEmpty == false &&
            password?.isEmpty == false
    }
    
}
