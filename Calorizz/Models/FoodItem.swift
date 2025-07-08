//
//  FoodItem.swift
//  Calorizz
//
//  Created by Foundation-023 on 01/07/25.
//

import Foundation

struct FoodItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let calories: Int
    let category: String
    let portion: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case calories
        case category
        case portion
    }
}
