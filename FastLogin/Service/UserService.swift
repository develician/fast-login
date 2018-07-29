//
//  UserService.swift
//  FastLogin
//
//  Created by killi8n on 2018. 7. 29..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import Alamofire
import CodableAlamofire


protocol UserServiceType {
    func currentUser(username: String?, completion: @escaping (Result<String>) -> Void)
}

final class UserService: UserServiceType {
    
    static let shared = UserService()
    
    func currentUser(username: String?, completion: @escaping (Result<String>) -> Void) {
        guard let username = username else {return}
        guard let url = API.profile(username: username).url else {return}
        Alamofire.request(url, method: .get)
            .validate()
            .responseDecodableObject(keyPath: "args") { (response: DataResponse<CurrentUserResponse>) in
                let result = response.result.map {
                    $0.username
                    
                }
                completion(result)
        }
    }
    
    
}

private struct CurrentUserResponse: Decodable {
    let username: String
}
