//
//  listView.swift
//  calories
//
//  Created by Foundation-019 on 25/06/25.
//

import SwiftUI

struct ListView: View {
    
    @State private var quantities: [UUID: Int] = [:]
    @State private var showConfirm = false
    @State private var pendingDelete: FoodItem?
    @ObservedObject var selectionModel: FoodSelectionModel
    
    var totalCalories: Int {
        selectionModel.selectedFoods.reduce(0) { sum, food in
            let qty = quantities[food.id] ?? 0
            return sum + food.calories * qty
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.shadedOrange,.shadedYellow], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            
            VStack{
                ScrollView {
                    VStack(alignment: .trailing, spacing: 10) {
                        ForEach(selectionModel.selectedFoods) { food in
                            let qty = quantities[food.id] ?? 1
                            
                            MakananItemView(
                                imageName: food.imageName,
                                title: food.name,
                                calories: "\(food.calories) kkal",
                                portion: food.portion,
                                quantity: qty,
                                onMinus: {
                                    if qty > 1 {
                                        quantities[food.id, default: 1] -= 1
                                    } else {
                                        pendingDelete = food
                                        showConfirm = true
                                    }
                                },
                                onPlus: {
                                    quantities[food.id, default: 1] += 1
                                }
                            )
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Text("Total:")
                        .font(.title2.bold())
                        .foregroundColor(.shadedGreen)
                    
                    Text("\(totalCalories) kkal")
                        .font(.title2.bold())
                        .foregroundColor(.shadedGreen)
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
            }
            .navigationTitle("Daftar Makanan")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CategoryView(selectionModel: selectionModel)) {
                        Text("Selesai")
                            .foregroundStyle(.blue)
                            .font(.title3)
                    }
                }
            }
            
            .alert("Hapus item?", isPresented: $showConfirm) {
                Button("Ya", role: .destructive) {
                    if let food = pendingDelete {
                        delete(food)
                    }
                }
                Button("Batal", role: .cancel) { }
            } message: {
                if let food = pendingDelete {
                    Text("Apakah yakin ingin menghapus \"\(food.name)\" dari list makanan?")
                }
            }
            
            .onAppear {
                for food in selectionModel.selectedFoods {
                    if quantities[food.id] == nil {
                        quantities[food.id] = 1
                    }
                }
            }
            
        }
    }
    
    func delete(_ food: FoodItem) {
        quantities.removeValue(forKey: food.id)
        // Untuk menghapus dari list, karena selectedFoods bersifat let,
        // kita harus mengubahnya jadi @State dulu. Jadi:
        // Ubah var selectedFoods → @State var selectedFoods
        selectionModel.selectedFoods.removeAll { $0.id == food.id }
    }
}

struct MakananItemView: View {
    let imageName: String
    let title: String
    let calories: String
    let portion: String
    let quantity: Int
    let onMinus: () -> Void
    let onPlus: () -> Void
    
    
    var body: some View {
        HStack (spacing: 20) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .clipped()
                .cornerRadius(12)
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                
                Text(calories)
                    .foregroundStyle(.shadedGreen)
                    .font(.subheadline)
                
                Text(portion)
                    .foregroundStyle(.green)
                    .font(.subheadline)
                
            }
            
            Spacer()
            
            HStack(spacing: 1) {
                Button(action: onMinus) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.orange)
                        .padding(13)
                }
                
                Text("\(quantity)")
                    .font(.body)
                    .frame(width: 20)
                    .foregroundColor(.black)
                
                Button(action: onPlus) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .padding(.horizontal)
                }
            }
            .frame(width: 90)
        }
        .padding()
        .background(Color(.shadedYellow))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview {
    ListView(selectionModel: FoodSelectionModel())
}

