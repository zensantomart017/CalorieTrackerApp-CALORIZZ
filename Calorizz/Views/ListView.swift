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
   



    //@State var selectedFoods: [FoodItem]

    var totalCalories: Int {
        selectionModel.selectedFoods.reduce(0) { sum, food in
            let qty = quantities[food.id] ?? 0
            return sum + food.calories * qty
        }
    }

    var body: some View {
        NavigationStack{
            VStack{
                HStack(spacing: 16) {

                    NavigationLink(destination: CategoryView(selectionModel: FoodSelectionModel())) {
                        Label("", systemImage: "chevron.left")
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer(minLength: 0)

                    NavigationLink(destination: CategoryView(selectionModel: selectionModel)) {
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
                        ForEach(selectionModel.selectedFoods) { food in
                            if let qty = quantities[food.id] {
                                MakananItemView(
                                    imageName: imageName(for: food.name),
                                    title: food.name,
                                    calories: "\(food.calories) kkal",
                                    quantity: qty,
                                    onMinus: {
                                        if qty > 1 {
                                            quantities[food.id]! -= 1
                                        } else {
                                            pendingDelete = food
                                            showConfirm = true
                                        }
                                    },
                                    onPlus: {
                                        quantities[food.id, default: 0] += 1
                                    }
                                )
                            }
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

        }
        
        .onAppear {
            if quantities.isEmpty {
                for food in selectionModel.selectedFoods{
                    quantities[food.id] = 1 // Default 1 porsi saat tampil
                }
            }
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
    
    func delete(_ food: FoodItem) {
        quantities.removeValue(forKey: food.id)
        // Untuk menghapus dari list, karena selectedFoods bersifat let,
        // kita harus mengubahnya jadi @State dulu. Jadi:
        // Ubah var selectedFoods → @State var selectedFoods
        selectionModel.selectedFoods.removeAll { $0.id == food.id }
    }

    
    struct MakananItemView: View {
        let imageName: String
        let title: String
        let calories: String
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
                
                HStack(spacing: 1) {
                    Button(action: onMinus) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.orange)
                            .padding(13)
                    }

                    Text("\(quantity)")
                        .font(.body)
                        .frame(width: 20)

                    Button(action: onPlus) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.orange)
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
    ListView(selectionModel: FoodSelectionModel())
}

