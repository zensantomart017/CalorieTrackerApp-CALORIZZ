//
//  SearchView.swift
//  Calorizz
//
//  Created by Foundation-019 on 26/06/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FoodViewModel()
    @ObservedObject var selectionModel: FoodSelectionModel
    @AppStorage("username") private var name = ""
    @State private var searchBar: String = ""
    @State private var showCamera = false
    @State private var image: UIImage?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack (spacing: 0) {
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            HStack {
                                Button(action: {
                                  
                                    dismiss()
                                }) {
                                    Image(systemName: "arrow.backward")
                                }

                                HStack {
                                    TextField("Cari Menu", text: $searchBar)
                                        .foregroundColor(.gray)
                                    
                                    Button {
                                        if !searchBar.isEmpty {
                                            viewModel.fetchFoods(for: searchBar)
                                        }
                                    } label: {
                                        Image(systemName: "magnifyingglass")
                                            .font(.title2)
                                    }
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(20)
                        }
                        .sheet(isPresented: $showCamera) {
                            ImagePicker(selectedImage: $image).padding()
                        }
                        .padding(.horizontal)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 16){
                                ForEach(viewModel.items) { food in
                                    foodCardView(
                                        food: food,
                                        isAdded: selectionModel.selectedFoods.contains(where: { $0.id == food.id }),
                                        onAdd: {
                                            if let index = selectionModel.selectedFoods.firstIndex(where: { $0.id == food.id }) {
                                                selectionModel.selectedFoods.remove(at: index) // ← hapus jika sudah ada
                                            } else {
                                                selectionModel.selectedFoods.append(food) // ← tambahkan jika belum ada
                                            }
                                        }
                                    )
                                }


                            }
                            .padding(.top)
//                            .shadow(color: colorScheme == .dark ? Color.white.opacity(1) : Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                        }
                        Spacer(minLength: 80)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 20)
                    .background(Color(.systemBackground))
                   // .shadow(radius: 5)
                }
                
                HStack {
                    Text("\(selectionModel.selectedFoods.count) Item")
                        .font(.body)
                    Spacer()
                    NavigationLink(destination: ListView(selectionModel: selectionModel)) {
                        Text("Hitung")
                            .font(.headline)
                            .foregroundColor(Color(.systemBackground))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.shadedGreen)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 30)
                .padding(.horizontal)
                .background(Color(.systemBackground))
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    private func addFood(_ food: FoodItem) {
        if !selectionModel.selectedFoods.contains(where: { $0.name == food.name }) {
            selectionModel.selectedFoods.append(food)
        }
    }
}

#Preview {
    SearchView(selectionModel: FoodSelectionModel())
}
