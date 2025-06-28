//
//  SearchView.swift
//  Calorizz
//
//  Created by Foundation-019 on 26/06/25.
//

import SwiftUI

struct foodItem: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let calories: Int
}

func foodCardView(food: foodItem) -> some View {
    HStack(alignment: .center, spacing: 16) {
        Image(food.imageName)
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
            print("Add \(food.name) tapped!")
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.title)
                .foregroundColor(.orange)
        }
        .buttonStyle(PlainButtonStyle())
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(15)
    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    .padding(.horizontal)
}

struct SearchView: View {
    @AppStorage("username") private var name = ""
    @State private var searchBar: String = ""
    @State private var showCamera = false
    @State private var image: UIImage?
    
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
                                
                                TextField("Search", text: $searchBar)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
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
                                VStack(spacing: 12) {
                                    foodCardView(food: foodItem(imageName: "c", name: "Nasi Kuning Komplit", calories: 550))
                                    
                                    foodCardView(food: foodItem(imageName: "sate_ayam", name: "Sate Ayam", calories: 300))
                                    
                                    foodCardView(food: foodItem(imageName: "gado_gado", name: "Gado-Gado", calories: 400))
                                    
                                    foodCardView(food: foodItem(imageName: "gado_gado", name: "Gado-Gado", calories: 400))
                                    
                                    foodCardView(food: foodItem(imageName: "gado_gado", name: "Gado-Gado", calories: 400))
                                }
                                .padding(.top)
                                Spacer(minLength: 80)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 20)
                    .background(Color(.systemBackground))
                    .shadow(radius: 5)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CategoryView()
}
