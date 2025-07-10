//
//  WelcomeView.swift
//  Calorizz
//
//  Created by Foundation-023 on 09/07/25.
//

import SwiftUI

func foodCardView(food: FoodItem, isAdded: Bool, onAdd: @escaping () -> Void) -> some View {
    HStack(alignment: .center, spacing: 16) {
        if let uiImage = UIImage(named: food.imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
        } else {
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text(food.name)
                .font(.headline)
                .foregroundStyle(.black)

            Text("\(food.calories) Kkal")
                .font(.subheadline)
                .foregroundColor(.green)

            Text("\(food.portion)")
                .font(.subheadline)
                .foregroundColor(.green)
        }

        Spacer()

        Button {
            onAdd()
        } label: {
            Image(systemName: isAdded ? "checkmark.circle.fill" : "plus.circle.fill")
                .font(.title)
                .foregroundColor(.orange)
        }
        .buttonStyle(PlainButtonStyle())
    }
    .padding(15)
    .background(isAdded ? Color.orange.opacity(0.2) : Color(.cardcolor))
    .cornerRadius(15)
    .overlay(
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
    )
    .padding(.horizontal, 20)
}

class FoodSelectionModel: ObservableObject {
    @Published var selectedFoods: [FoodItem] = []
}

struct CategoryView: View {
    @AppStorage("username") private var name = ""
    @StateObject private var viewModel = FoodViewModel()
    @ObservedObject var selectionModel: FoodSelectionModel
    @State private var selectedCategory: String = "Nasi"
    @State private var searchBar: String = ""
    @State private var showCamera: Bool = false
    @State private var image: UIImage?
    @State private var navigateToListView = false
    @Environment(\.colorScheme) var colorScheme

    let categoryOrder = ["Nasi", "Lauk", "Sayur", "Buah", "Umbi", "Sambal", "Makanan olahan", "Camilan", "Hidangan Penutup", "Lainnya"]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [.gradasi1, .gradasi2, .gradasi3,.gradasi3, .gradasi4,.gradasi4], startPoint: .topTrailing, endPoint: .bottomLeading)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Text("Hi, \(name)👋🏻")
                            .font(.largeTitle.bold())
                            .foregroundColor(.orange)
                        Spacer()
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 16)

                    Text("Cek kalori makananmu dulu yuk!")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            HStack {
                                NavigationLink(destination: SearchView(selectionModel: selectionModel)) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Cari menu", text: $searchBar)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 25)
                            .frame(height: 50)
                            .background(Color(.cardcolor))
                            .cornerRadius(20)

                            Button {
                                showCamera = true
                            } label: {
                                Image(systemName: "camera.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.orange)
                            }
                        }
                        .sheet(isPresented: $showCamera) {
                            ImagePicker(selectedImage: $image)
                        }
                        .onChange(of: image) { newImage in
                            if let img = newImage {
                                detectAndNavigate(from: img)
                            }
                        }
                        .padding(.horizontal, 20)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(categoryOrder.filter { viewModel.uniqueCategories.contains($0) }, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                        print("📂 Kategori dipilih: \(category)")
                                    }) {
                                        KategoriItem(
                                            title: category,
                                            imageName: imageNameForCategory(category),
                                            backgroundColor: colorForCategory(category),
                                            isSelected: selectedCategory == category
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }

                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.foods(for: selectedCategory)) { food in
                                    foodCardView(
                                        food: food,
                                        isAdded: selectionModel.selectedFoods.contains(where: { $0.name == food.name })
                                    ) {
                                        if let index = selectionModel.selectedFoods.firstIndex(where: { $0.name == food.name }) {
                                            selectionModel.selectedFoods.remove(at: index)
                                            print("🗑️ Dihapus dari pilihan: \(food.name)")
                                        } else {
                                            selectionModel.selectedFoods.append(food)
                                            print("✅ Ditambahkan ke pilihan: \(food.name)")
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 100)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 20)
                }

                if !selectionModel.selectedFoods.isEmpty {
                    HStack {
                        
                        Spacer()
                        
                        NavigationLink(destination: ListView(selectionModel: selectionModel)) {
                            HStack {
                                Text("\(selectionModel.selectedFoods.count) item terpilih")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(30)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }

                NavigationLink(
                    destination: ListView(selectionModel: selectionModel),
                    isActive: $navigateToListView
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.loadAllFoods()
                print("📦 Data makanan dimuat.")
            }
        }
    }

    private func detectAndNavigate(from image: UIImage) {
        print("📷 [1] Fungsi detectAndNavigate dipanggil.")
        DetectionManager.shared.detectLabels(from: image) { labels in
            print("🔍 [2] Label terdeteksi: \(labels)")
            DispatchQueue.main.async {
                let matched = viewModel.matchDetectedLabels(labels)
                for (food, _) in matched {
                    if !selectionModel.selectedFoods.contains(where: { $0.id == food.id }) {
                        selectionModel.selectedFoods.append(food)
                        print("🍽️ Otomatis ditambahkan: \(food.name)")
                    }
                }
                if !matched.isEmpty {
                    navigateToListView = true
                    print("➡️ Navigasi ke ListView karena hasil deteksi ditemukan.")
                } else {
                    print("⚠️ Tidak ada kecocokan ditemukan.")
                }
            }
        }
    }

    private func imageNameForCategory(_ category: String) -> String {
        switch category {
        case "Nasi": return "nasi"
        case "Lauk": return "lauk"
        case "Sayur": return "sayur"
        case "Buah": return "buah"
        case "Umbi": return "umbi"
        case "Sambal": return "sambal"
        case "Makanan olahan": return "makananolahan"
        case "Camilan": return "camilan"
        case "Hidangan Penutup": return "hidanganPenutup"
        case "Lainnya": return "lainnya"
        default: return "photo"
        }
    }

    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Nasi": return .tintedOrange
        case "Lauk": return .shadedYellow
        case "Sayur": return .customGreen
        case "Buah": return .tintedOrange
        case "Umbi": return .shadedYellow
        case "Sambal": return .customGreen
        case "Makanan olahan": return .tintedOrange
        case "Camilan": return .shadedYellow
        case "Hidangan Penutup": return .customGreen
        default: return .tintedOrange
        }
    }
}

#Preview {
    CategoryView(selectionModel: FoodSelectionModel())
}
