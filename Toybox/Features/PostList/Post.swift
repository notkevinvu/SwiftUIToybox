//
//  File.swift
//  
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation

struct Post: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
