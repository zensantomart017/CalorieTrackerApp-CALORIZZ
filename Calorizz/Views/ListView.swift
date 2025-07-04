//
//  listView.swift
//  calories
//
//  Created by Foundation-019 on 25/06/25.
//

import SwiftUI

struct ListView: View {
    var selectedFoods: [FoodItem]
        
        var totalCalories: Int {
            selectedFoods.reduce(0) { $0 + $1.calories }
        }
    var body: some View {
        NavigationStack{
            VStack{
                HStack(spacing: 16) {
                    NavigationLink(destination: CategoryView()) {
                        Label("", systemImage: "chevron.left")
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: CategoryView()){
                        Label("", systemImage: "plus")
                            .foregroundStyle(.shadedGreen)
                            .font(.system(size: 25))
                    }
                    .font(.headline)
                    .padding(.horizontal)
                }
                .padding(10)
                
                ScrollView {
                    VStack(alignment: .trailing, spacing: 10) {
                        ForEach(selectedFoods) { food in
                            MakananItemView(
                                imageName: imageName(for: food.name), title: food.name, calories: "\(food.calories) kkal")
                        }
                    }
                }
                
                HStack(){
                    Text("Total : ")
                        .font(.headline)
                    
                                    
                    Text("\(totalCalories) kkal")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    Spacer()
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func imageName(for name: String) -> String {
        switch name {
        case "Ayam Betutu": return "ayambetutu"
        case "Sayur Asem": return "sayurasem"
        case "Ikan Jahir Goreng": return "jahirgoreng"
        case "Nasi Putih": return "nasi"
        default: return "photo"
        }
    }
    
    struct MakananItemView: View {
        let imageName: String
        let title: String
        let calories: String
        
        var body: some View {
            HStack (spacing: 20) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipped()
                    .cornerRadius(12)
                
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .layoutPriority(1)
                    
                    
                    Text(calories)
                        .foregroundStyle(.shadedGreen)
                        .font(.subheadline)
                }
                
                Spacer()
                
                HStack(spacing : 1){
                    Button{
                    } label:{
                        Label("", systemImage: "minus.circle.fill")
                            .foregroundStyle(.orange)
                            .padding(2)
                    }
                    
                    Text("1")
                        .font(.body)
                        .frame(width: 20)
                    
                    Button{
                    } label:{
                        Label("", systemImage: "plus.circle.fill")
                            .foregroundStyle(.orange)
                            .padding(.horizontal)
                    }
                }
                .frame(width: 90)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ListView(selectedFoods: [])
}
