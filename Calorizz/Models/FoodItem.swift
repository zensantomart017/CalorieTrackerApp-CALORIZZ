//
//  FoodItem.swift
//  Calorizz
//
//  Created by Foundation-023 on 01/07/25.
//

import Foundation

struct FoodItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let calories: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case calories
    }
}
