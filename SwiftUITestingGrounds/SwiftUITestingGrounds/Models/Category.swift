//
//  Category.swift
//  SwiftUITestingGrounds
//
//  Created by Kevin Vu on 2/20/25.
//

import Foundation

struct Category: Identifiable, Codable {
    let id: UUID
    let parentEventId: UUID
    var name: String
    
    public init(
        id: UUID = UUID(),
        parentEventId: UUID,
        name: String
    ) {
        self.id = id
        self.parentEventId = parentEventId
        self.name = name
    }
}

// MARK: - Hashable
/// Overriding the default hashable and equatable conformances so that
/// we only check for name equivalence
extension Category: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name.lowercased())
    }
}

// MARK: - Equatable
extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        (lhs.name.lowercased() == rhs.name.lowercased())
    }
}

// MARK: - Sample data
extension Category {
    static func sampleCategories() -> [Category] {
        [
            .init(parentEventId: UUID(), name: "Food"),
            .init(parentEventId: UUID(), name: "Drinks"),
            .init(parentEventId: UUID(), name: "Transportation"),
            .init(parentEventId: UUID(), name: "Miscellaneous"),
            .init(parentEventId: UUID(), name: "Clothing"),
            .init(parentEventId: UUID(), name: "Home"),
        ]
    }
}
