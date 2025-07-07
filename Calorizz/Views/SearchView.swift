//
//  SearchView.swift
//  Calorizz
//
//  Created by Foundation-019 on 26/06/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = FoodViewModel()
    @State private var selectedFoods: [FoodItem] = []
    @AppStorage("username") private var name = ""
    @State private var searchBar: String = ""
    @State private var showCamera = false
    @State private var image: UIImage?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack (spacing: 0) {
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            HStack {
                                NavigationLink(destination: CategoryView()){
                                    Image(systemName: "arrow.backward")
                                        .foregroundStyle(.primary)
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
                                    foodCardView(food: food, onAdd: {
                                        addFood(food)
                                    })
                                }
                            }
                            .padding(.top)
                            .shadow(color: colorScheme == .dark ? Color.white.opacity(1) : Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
                        }
                        Spacer(minLength: 80)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 20)
                    .background(Color(.systemBackground))
                    .shadow(radius: 5)
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
        }
    }
    private func addFood(_ food: FoodItem) {
        if !selectedFoods.contains(where: { $0.name == food.name }) {
            selectedFoods.append(food)
        }
    }
}

#Preview {
    CategoryView()
}
