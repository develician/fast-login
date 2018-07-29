//
//  ViewController.swift
//  FastLogin
//
//  Created by killi8n on 2018. 7. 29..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    var disposeBag: DisposeBag = DisposeBag()
    
    var authService: AuthServiceType?
    var sceneSwitcher: SceneSwitcherType?
    
    let usernameField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("로그인", for: .normal)
        return btn
    }()
    
    let joinButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("회원가입", for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        self.title = "LOGIN"
        self.usernameField.becomeFirstResponder()
        
        let viewComponents = [usernameField, passwordField, loginButton, joinButton]
        viewComponents.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        usernameField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.frame.size.width * 0.7)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        passwordField.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.frame.size.width * 0.7)
            make.top.equalTo(usernameField.snp.bottom).offset(16)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.frame.size.width * 0.7)
            make.top.equalTo(passwordField.snp.bottom).offset(24)
        }
        
        joinButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.frame.size.width * 0.7)
            make.top.equalTo(loginButton.snp.bottom).offset(16)
        }
        
        
        
        bind()
        
        
    }

    private func setComponentsEnabled(_ isEnabled: Bool) {
        self.usernameField.isEnabled = isEnabled
        self.passwordField.isEnabled = isEnabled
        self.loginButton.isEnabled = isEnabled
        self.joinButton.isEnabled = isEnabled
    }
  
}

extension LoginViewController {
    func bind() {
        joinButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
            self?.navigationController?.pushViewController(JoinViewController(), animated: true)
        }).disposed(by: disposeBag)

        loginButton.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in
            self?.setComponentsEnabled(false)
            self?.usernameField.backgroundColor = nil
            self?.passwordField.backgroundColor = nil
            guard let username = self?.usernameField.text else {return}
            guard let password = self?.passwordField.text else {return}
            
            self?.authService?.login(username: username, password: password, completion: { [weak self] (result) in
                self?.setComponentsEnabled(true)
                switch result {
                case .success:
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(true, forKey: "logged")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    guard let window = appDelegate.window else {return}
                    let sceneSwitcher = SceneSwitcher(window: window)
                    sceneSwitcher.profileView = ProfileView(userService: UserService.shared, sceneSwitcher: sceneSwitcher)
                    sceneSwitcher.presentProfile()
                case .failure(.wrongUsername):
                    self?.usernameField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                    self?.usernameField.becomeFirstResponder()
                case .failure(.wrongPassword):
                    self?.passwordField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
                    self?.passwordField.becomeFirstResponder()
                }
            })
        }).disposed(by: disposeBag)
    }
}

struct LoginView {
    let authService: AuthServiceType
    let sceneSwitcher: SceneSwitcherType
    
    func initiateViewController() -> UIViewController? {
        let loginViewController = LoginViewController()
        loginViewController.authService = self.authService
        
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

}
