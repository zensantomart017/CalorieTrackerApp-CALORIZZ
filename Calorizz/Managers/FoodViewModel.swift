////
////  FoodViewModel.swift
////  Calorizz
////
////  Created by Foundation-023 on 01/07/25.
////
//
//import Foundation
//
//class FoodViewModel: ObservableObject {
//    @Published var items: [FoodItem] = []
//    
//    func loadAllFoods() {
//        guard let url = Bundle.main.url(forResource: "food", withExtension: "json") else { return }
//        
//        do {
//            let data = try Data(contentsOf: url)
//            let decoded = try JSONDecoder().decode([FoodItem].self, from: data)
//            
//            DispatchQueue.main.async {
//                self.items = decoded
//            }
//        } catch {
//            print("Error decoding: \(error)")
//        }
//    }
//    
//    func fetchFoods(for query: String) {
//        guard let url = Bundle.main.url(forResource: "food", withExtension: "json") else { return }
//        do {
//            let data = try Data(contentsOf: url)
//            let response = try JSONDecoder().decode([FoodItem].self, from: data)
//            
//            let filtered = response.filter { $0.name.lowercased().contains(query.lowercased()) }
//            
//            DispatchQueue.main.async {
//                self.items = filtered
//            }
//        } catch {
//            print("Error decoding: \(error)")
//        }
//    }
//        
//        func foods(for category: String) -> [FoodItem] {
//            items.filter { $0.category == category }
//        }
//        
//        var uniqueCategories: [String]{
//            Set(items.map { $0.category }).sorted()
//        }
//}


import Foundation

class FoodViewModel: ObservableObject {
    @Published var items: [FoodItem] = []
    
    func loadAllFoods() {
        guard let url = Bundle.main.url(forResource: "food", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([FoodItem].self, from: data)
            
            DispatchQueue.main.async {
                self.items = decoded
            }
        } catch {
            print("Error decoding: \(error)")
        }
    }
    
    func fetchFoods(for query: String) {
        guard let url = Bundle.main.url(forResource: "food", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode([FoodItem].self, from: data)
            
            let filtered = response.filter { $0.name.lowercased().contains(query.lowercased()) }
            
            DispatchQueue.main.async {
                self.items = filtered
            }
        } catch {
            print("Error decoding: \(error)")
        }
    }
        
        func foods(for category: String) -> [FoodItem] {
            items.filter { $0.category == category }
        }
        
        var uniqueCategories: [String]{
            Set(items.map { $0.category }).sorted()
        }
    
    func matchDetectedLabels(_ labels: [String]) -> [(FoodItem, Int)] {
        var countMap: [String: Int] = [:]
        labels.forEach { countMap[$0, default: 0] += 1 }

        return countMap.compactMap { (label, count) in
            if let match = items.first(where: { $0.name.lowercased() == label.lowercased() }) {
                return (match, count)
            }
            return nil
        }
    }

}
