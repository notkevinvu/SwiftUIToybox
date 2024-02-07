//
//  File.swift
//  
//
//  Created by Kevin Vu on 2/6/24.
//

import Foundation

public struct Post: Identifiable, Codable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let body: String
}
