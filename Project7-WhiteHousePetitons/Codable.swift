//
//  Codable.swift
//  project7
//
//  Created by 李沐軒 on 2019/3/17.
//  Copyright © 2019 李沐軒. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}


