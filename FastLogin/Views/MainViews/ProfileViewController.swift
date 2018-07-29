//
//  ProfileViewController.swift
//  FastLogin
//
//  Created by killi8n on 2018. 7. 29..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    var disposeBag: DisposeBag = DisposeBag()
    
    var userService: UserServiceType?
    var sceneSwitcher: SceneSwitcherType?
    
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return indicator
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.semibold)
        return label
    }()
    
    let logoutButton: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("로그아웃", for: UIControlState.normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let viewComponents = [welcomeLabel, logoutButton]
        viewComponents.forEach {
            view.addSubview($0)
            $0.isHidden = true
        }
        
        
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX).offset(0)
            make.centerY.equalTo(view.snp.centerY).offset(0)
        }
        activityIndicator.startAnimating()
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX).offset(0)
            make.centerY.equalTo(view.snp.centerY).offset(0)
            make.width.equalTo(view.frame.size.width * 0.7)
            make.height.equalTo(48)
            
        }
        
        logoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(24)
            make.left.equalTo(view.snp.left).offset(24)
            make.right.equalTo(view.snp.right).offset(-24)

        }
        
        getProfile()
        bind()
    }


}

extension ProfileViewController {
    func getProfile() {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        self.userService?.currentUser(username: username, completion: { [weak self] (result) in
            self?.activityIndicator.stopAnimating()
            let viewComponents = [self?.welcomeLabel, self?.logoutButton]
            viewComponents.forEach { component in
                UIView.animate(withDuration: 0.5, animations: {
                    component?.isHidden = false
                })
            }
            switch result {
            case .success(username):
                self?.welcomeLabel.text = "Hi! \(username)"
            case .failure(let error):
                print(error.localizedDescription)
                self?.welcomeLabel.text = "Error!"
            default:
                break
            }
        })
    }
    
    func bind() {
        logoutButton.rx.tap.asObservable().subscribe(onNext: { _ in
            UserDefaults.standard.set(nil, forKey: "username")
            UserDefaults.standard.set(false, forKey: "logged")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            guard let window = appDelegate.window else {return}
            let sceneSwitcher = SceneSwitcher(window: window)
            sceneSwitcher.loginView = LoginView(authService: AuthService.shared, sceneSwitcher: sceneSwitcher)
            sceneSwitcher.presentLogin()
        }).disposed(by: disposeBag)
    }
}

struct ProfileView {
    let userService: UserServiceType
    let sceneSwitcher: SceneSwitcherType
    
    func initiateViewController() -> UIViewController? {
        let profileViewController = ProfileViewController()
        profileViewController.userService = self.userService
        
        let navigationController = UINavigationController(rootViewController: profileViewController)
        return navigationController
    }
}
