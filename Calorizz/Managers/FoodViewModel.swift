//
//  FoodViewModel.swift
//  Calorizz
//
//  Created by Foundation-023 on 01/07/25.
//

import Foundation

class FoodViewModel: ObservableObject {
    @Published var items: [FoodItem] = []
    
    func fetchFoods(for query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.api-ninjas.com/v1/nutrition?query=\(encodedQuery)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("SrSuDHdvhHjMmPYgoCpn5g==BaRph5zF6M0PJguQ", forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResp = response as? HTTPURLResponse {
                print("HTTP Status:", httpResp.statusCode)
            }
            
            if let error = error {
                print("Request error:", error)
                return
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([FoodItem].self, from: data)
                    DispatchQueue.main.async {
                        self.items = response
                    }
                } catch {
                    print("Error decoding: \(error)")
                }
            }
        }.resume()
    }
}
