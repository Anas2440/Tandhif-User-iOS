//
//  Common Delegates.swift
//  Goferjek
//
//  Created by Trioangle on 03/12/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation

///  Use :-   Welcome ViewController Navigation Protocol
protocol WelcomeNavigationProtocol {
    
    /// Note :- Use this Method Navigate current ViewController to Login ViewController
    func navigateToLoginVC()
    
    /// Note :  Use this Method current ViewController to Login ViewController
    func navigateToRegisterVC()
    
    /// Note :  Use this Method current ViewController to Social ViewController
    func navigateToSocailSignUp()
}
