//
//  CategoryView.swift
//  Calorizz
//
//  Created by Foundation-023 on 26/06/25.
//

import SwiftUI
//firman ganteng

struct FoodItem: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let calories: Int
}

func foodCardView(food: FoodItem) -> some View {
    HStack(spacing: 16) {
        Image(food.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)

        VStack(alignment: .leading, spacing: 4) {
            Text(food.name)
                .font(.headline)
            Text("\(food.calories) Kkal")
                .font(.subheadline)
                .foregroundColor(.shadedGreen)
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
    .background(Color.white)
    .cornerRadius(15)
    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    .padding(.horizontal)
}


struct KategoriItem: View {
    let title: String
    let imageName: String
    let backgroundColor: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .padding()
        .frame(width: 100)
        .background(backgroundColor)
        .cornerRadius(20)
    }
}

struct KategoriView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Categories")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    KategoriItem(title: "Nasi", imageName: "foodImage", backgroundColor: .customOrange)
                    KategoriItem(title: "Ayam", imageName: "foodImage", backgroundColor: .customYellow)
                    KategoriItem(title: "Ikan", imageName: "foodImage", backgroundColor: .customGreen)
                    KategoriItem(title: "Daging", imageName: "foodImage", backgroundColor: .customOrange)
                    KategoriItem(title: "Sayur", imageName: "foodImage", backgroundColor: .customYellow)
                    KategoriItem(title: "Buah", imageName: "foodImage", backgroundColor: .customGreen)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal)
    }
}

struct CategoryView: View {
    @AppStorage("username") private var name = ""
    @State private var searchBar: String = ""
    @State private var showCamera = false
    @State private var image: UIImage?
    
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
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                    .padding(.bottom, 16)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            HStack {
                                NavigationLink(destination: SearchView()) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Search", text: $searchBar)
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
                            ImagePicker(selectedImage: $image).padding()
                        }
                        .padding(.horizontal)
                        
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 16) {
                                KategoriView()
                                
                                VStack(spacing: 12) {
                                    foodCardView(food: FoodItem(imageName: "c", name: "Nasi Kuning Komplit", calories: 550))
                                    foodCardView(food: FoodItem(imageName: "sate_ayam", name: "Sate Ayam", calories: 300))
                                    foodCardView(food: FoodItem(imageName: "gado_gado", name: "Gado-Gado", calories: 400))
                                }
                                .padding(.top)
                                Spacer(minLength: 80)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 20)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .shadow(radius: 5)
                }
                
                HStack {
                    Text("5 Item")
                        .font(.body)
                    Spacer()
                    //                Button(action: {}) {
                    NavigationLink(destination: listView()) {
                        
                        Text("Calculate")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.shadedGreen)
                            .cornerRadius(10)
                    }
                }
                //                }
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 30)
                .padding(.horizontal)
                .background(.white)
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CategoryView()
}
