//
//  String+Extensions.swift
//  e-marketing-ios
//
//  Created by Betül Tarhan on 20.09.2026.
//

import Foundation

extension String {
    /// "sport-accessories" -> "Sport Accessories"
    var categoryDisplayName: String {
        split(separator: "-").map(\.capitalized).joined(separator: " ")
    }
}
