//
//  API.swift
//  FastLogin
//
//  Created by killi8n on 2018. 7. 29..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit

enum API {
    case login
    case profile(username: String)
}

extension API {
    var baseURL: String {
        return "https://httpbin.org"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/post"
        case let .profile(username):
            return "/get?username=\(username)"
        }
    }
    
    var url: URL? {
        return URL(string: "\(self.baseURL)\(self.path)")
    }
}

