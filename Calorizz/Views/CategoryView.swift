//
//  CategoryView.swift
//  Calorizz
//
//  Created by Foundation-023 on 26/06/25.
//

import SwiftUI

func foodCardView(food: FoodItem, isAdded: Bool,onAdd: @escaping () -> Void) -> some View {
    HStack(alignment: .center, spacing: 16) {
        Image("photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
        
        VStack(alignment: .leading, spacing: 4) {
            Text(food.name)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text("\(food.calories) Kkal")
                .font(.subheadline)
                .foregroundColor(.green)
        }
        
        Spacer()
        
        Button {
            onAdd()
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .foregroundColor(.orange)
        }
        .buttonStyle(PlainButtonStyle())
    }
    .padding()
    .background(isAdded ? Color.orange.opacity(0.2) : Color(.systemBackground)) // <- Warna berubah
    .cornerRadius(15)
    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    .padding(.horizontal)
}

struct CategoryView: View {
    @AppStorage("username") private var name = ""
    @StateObject private var viewModel = FoodViewModel()
    @State private var selectedFoods: [FoodItem] = []
    @State private var selectedCategory: String = "Nasi"
    @State private var searchBar: String = ""
    @State private var showCamera: Bool = false
    @State private var image: UIImage?
    @Environment(\.colorScheme) var colorScheme
    let categoryOrder = ["Nasi", "Lauk", "Sayur", "Buah", "Umbi", "Sambal", "Makanan Olahan", "Camilan", "Hidangan Penutup", "Lainnya"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Hi, \(name)👋🏻")
                            .font(.title.bold())
                            .foregroundColor(.orange)
                        Spacer()
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                    .padding(.bottom, 16)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            HStack {
                                NavigationLink(destination: SearchView(selectedFoods: $selectedFoods)) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Cari menu", text: $searchBar)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }}
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                            
                            Button {
                                showCamera = true
                            } label: {
                                Image(systemName: "camera.viewfinder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.gray)
                                    .padding(10)
                                
                                
                            }
                        }
                        .sheet(isPresented: $showCamera) {
                            ImagePicker(selectedImage: $image)
                        }
                        .padding(.horizontal)
                        
                        Text("Kategori")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(categoryOrder.filter { viewModel.uniqueCategories.contains($0) }, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        Text(category)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                            .background(selectedCategory == category ? Color.orange : Color.gray.opacity(0.1))
                                            .foregroundColor(.primary)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.foods(for: selectedCategory)) { food in
                                    foodCardView(food: food, isAdded: selectedFoods.contains(where: { $0.name == food.name })) {
                                        if let index = selectedFoods.firstIndex(where: { $0.name == food.name }) {
                                                selectedFoods.remove(at: index)
                                            } else {
                                                selectedFoods.append(food)
                                            }
                                        }
                                    }
                                

                            }
                            .padding(.top)
                            .padding(.bottom, 100)
                            .shadow(color: colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 20)
                    .background(Color(.systemBackground))
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .shadow(color: colorScheme == .dark ? Color.white.opacity(1) : Color.black.opacity(1), radius: 5, x: 0, y: 4)
                }
                
                HStack {
                    Text("\(selectedFoods.count) Item")
                        .font(.body)
                    Spacer()
                    NavigationLink(destination: ListView(selectedFoods: selectedFoods)) {
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
            .onAppear {
                viewModel.loadAllFoods()
            }
        }
    }
}

#Preview {
    CategoryView()
}
