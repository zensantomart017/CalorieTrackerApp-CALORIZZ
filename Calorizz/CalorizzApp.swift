//
//  CalorizzApp.swift
//  Calorizz
//
//  Created by Foundation-023 on 25/06/25.
//

import SwiftUI

@main
struct CalorizzApp: App {
    let persistenceController = PersistenceController.shared
    @State private var selectedFoods: [FoodItem] = []


    var body: some Scene {
        
        WindowGroup {
            WelcomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
