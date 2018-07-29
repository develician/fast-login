//
//  JoinCategory.swift
//  FastLogin
//
//  Created by killi8n on 2018. 7. 29..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit
import RxDataSources

struct JoinCategory {
    var name: String
}

extension JoinCategory: IdentifiableType, Equatable {
    static func ==(lhs: JoinCategory, rhs: JoinCategory) -> Bool {
        return lhs.name == rhs.name
    }
    
    var identity: String {
        return name
    }
}
