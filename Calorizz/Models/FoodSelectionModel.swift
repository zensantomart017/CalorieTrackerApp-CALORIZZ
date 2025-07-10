//
//  FoodSelectionModel.swift
//  Calorizz
//
//  Created by Foundation-023 on 10/07/25.
//

import Foundation
import SwiftUI

class FoodSelectionModel: ObservableObject {
    @Published var selectedFoods: [FoodItem] = []
    @Published var quantities: [UUID: Int] = [:]
}
