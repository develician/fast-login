//
//  AuthService.swift
//  FastLogin
//
//  Created by killi8n on 2018. 7. 29..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import Alamofire
import CodableAlamofire
import RxSwift
import RxCocoa

enum LoginResult {
    case success
    case failure(LoginError)
}

enum LoginError {
    case wrongUsername
    case wrongPassword
}

protocol AuthServiceType {
    func login(username: String?, password: String?, completion: @escaping (LoginResult) -> Void)
}

final class AuthService: AuthServiceType {
    
    func login(username: String?, password: String?, completion: @escaping (LoginResult) -> Void) {
        guard let username = username else {
            return completion(.failure(.wrongUsername))
        }
        
        guard let password = password else {
            return completion(.failure(.wrongPassword))
        }
        
        let parameters: [String : Any] = [
            "username": username,
            "password": password
        ]
        guard let url = API.login.url else {
            return
        }
        Alamofire.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodableObject(keyPath: "form") { (response: DataResponse<LoginResponse>) in
            let credential = response.value.map { ($0.username, $0.password) }
            
            switch credential {
            case ("fast", "campus")?:
                completion(.success)
            case ("fast", _)?:
                completion(.failure(.wrongPassword))
            default:
                completion(.failure(.wrongUsername))
            }
        }
    }
    
    static let shared = AuthService()
}

private struct LoginResponse: Decodable {
    let username: String
    let password: String
}
