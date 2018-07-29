//
//  SceneSwitcher.swift
//  FastLogin
//
//  Created by killi8n on 2018. 7. 29..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit

protocol SceneSwitcherType {
    func presentLogin()
    func presentProfile()
}

final class SceneSwitcher: SceneSwitcherType {
    let window: UIWindow?
    var loginView: LoginView?
    var profileView: ProfileView?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func presentLogin() {
        self.window?.rootViewController = self.loginView?.initiateViewController()
    }
    
    func presentProfile() {
         self.window?.rootViewController = self.profileView?.initiateViewController()
    }
    
    
}
