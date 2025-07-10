//
//  ListView.swift
//  calories
//
//  Created by Foundation-019 on 25/06/25.
//

import SwiftUI

func portionMultiplied(portion: String, quantity: Int) -> String {
    let trimmed = portion.trimmingCharacters(in: .whitespaces)
    let components = trimmed.split(separator: " ", maxSplits: 1).map { String($0) }

    if components.count == 2, let baseAmount = Double(components[0]) {
        let unit = components[1]
        let total = baseAmount * Double(quantity)
        
        // Format hasil agar tidak muncul ".0" jika angka bulat
        let formattedTotal: String
        if total.truncatingRemainder(dividingBy: 1) == 0 {
            formattedTotal = String(Int(total)) // misalnya "3" bukan "3.0"
        } else {
            formattedTotal = String(format: "%.1f", total) // misalnya "2.5"
        }

        return "\(formattedTotal) \(unit)"
    } else {
        // Gagal parsing → kembalikan original
        return portion
    }
}



struct ListView: View {
    
    @State private var showConfirm = false
    @State private var pendingDelete: FoodItem?
    @ObservedObject var selectionModel: FoodSelectionModel
    
    var totalCalories: Int {
        selectionModel.selectedFoods.reduce(0) { sum, food in
            let qty = selectionModel.quantities[food.id] ?? 0
            return sum + food.calories * qty
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.gradasi1, .gradasi2, .gradasi3, .gradasi3, .gradasi4, .gradasi4], startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(alignment: .trailing, spacing: 10) {
                        ForEach(selectionModel.selectedFoods) { food in
                            let qty = selectionModel.quantities[food.id] ?? 1
                            
                            MakananItemView(
                                imageName: food.imageName,
                                title: food.name,
                                calories: "\(food.calories * qty ) kkal",
                                portion: portionMultiplied(portion: food.portion, quantity: qty),
                                quantity: qty,
                                onMinus: {
                                    if qty > 1 {
                                        selectionModel.quantities[food.id, default: 1] -= 1
                                    } else {
                                        pendingDelete = food
                                        showConfirm = true
                                    }
                                },
                                onPlus: {
                                    selectionModel.quantities[food.id, default: 1] += 1
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
                    NavigationLink(destination: CategoryView(selectionModel: FoodSelectionModel())) {
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
                    if selectionModel.quantities[food.id] == nil {
                        selectionModel.quantities[food.id] = 1
                    }
                }
            }
        }
    }
    
    func delete(_ food: FoodItem) {
        selectionModel.quantities.removeValue(forKey: food.id)
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
            if let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipped()
                    .cornerRadius(12)
            } else {
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
            }
            
            
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
                    .foregroundStyle(.shadedGreen)
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
        .background(Color(.cardcolor))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview {
    ListView(selectionModel: FoodSelectionModel())
}

