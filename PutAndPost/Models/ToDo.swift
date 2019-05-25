//
//  ToDo.swift
//  PutAndPost
//
//  Created by Michael Stoffer on 5/25/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

struct Todo: Codable {
    var title: String
    var identifier: String
    
    init(title: String, identifier: String = UUID().uuidString) {
        self.title = title
        self.identifier = identifier
    }
}
