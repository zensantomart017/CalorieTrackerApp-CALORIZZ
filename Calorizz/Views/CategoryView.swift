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
            Image(systemName: "photo")
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
    .padding()
    .background(isAdded ? Color.orange.opacity(0.2) : Color(.cardcolor))
    .background(isAdded ? Color.customYellow.opacity(0.2) : Color(.systemBackground))
    .cornerRadius(15)
    .padding(.horizontal, 20)
    .overlay(
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
            .padding(.horizontal, 25)
    )
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

    let categoryOrder = ["Nasi", "Lauk", "Sayur", "Buah", "Umbi", "Sambal", "Makanan Olahan", "Camilan", "Hidangan Penutup", "Lainnya"]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [.gradasi1, .gradasi2, .gradasi3, .gradasi4], startPoint: .topTrailing, endPoint: .bottomLeading)
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
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    .padding(.bottom, 16)

                    Text("Cek kalori makananmu dulu yuk!")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)

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
                            print("🧪 onChange image terpanggil.")
                            if let img = newImage {
                                print("✅ Gambar dikirim ke fungsi deteksi.")
                                detectAndNavigate(from: img)
                            }
                        }
                        .padding(.horizontal, 25)

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
                                            .foregroundColor(.black)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 25)
                        }

                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.foods(for: selectedCategory)) { food in
                                    foodCardView(food: food, isAdded: selectionModel.selectedFoods.contains(where: { $0.name == food.name })) {
                                        if let index = selectionModel.selectedFoods.firstIndex(where: { $0.name == food.name }) {
                                            selectionModel.selectedFoods.remove(at: index)
                                        } else {
                                            selectionModel.selectedFoods.append(food)
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
                    .background(Color(.systemBackground))
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.loadAllFoods()
            }

            // ✅ Auto NavigationLink (triggered after detection)
            NavigationLink(
                destination: ListView(selectionModel: selectionModel),
                isActive: $navigateToListView
            ) {
                EmptyView()
            }
            .hidden()
        }
    }

    private func detectAndNavigate(from image: UIImage) {
        print("📷 [1] Fungsi detectAndNavigate dipanggil.")

        print("✅ [2] Berhasil konversi UIImage ke CGImage.")
        print("✅ [3] Model CoreML berhasil dimuat.")

        print("🚀 [4] Memulai deteksi via DetectionManager.")
        DetectionManager.shared.detectLabels(from: image) { labels in
            DispatchQueue.main.async {
                print("📥 [5] Callback deteksi dijalankan.")
                print("📊 [6] Label terdeteksi: \(labels)")

                let matched = viewModel.matchDetectedLabels(labels)
                print("📦 [7] Makanan yang cocok ditemukan: \(matched.map { $0.0.name })")

                for (food, _) in matched {
                    if !selectionModel.selectedFoods.contains(where: { $0.id == food.id }) {
                        selectionModel.selectedFoods.append(food)
                        print("✅ [8] Menambahkan makanan: \(food.name)")
                    } else {
                        print("ℹ️ [8] \(food.name) sudah ada di daftar.")
                    }
                }

                if !matched.isEmpty {
                    print("✅ [9] Navigasi otomatis ke ListView dimulai.")
                    navigateToListView = true
                } else {
                    print("⚠️ [9] Tidak ada makanan cocok. Navigasi dibatalkan.")
                }
            }
        }
    }
}

#Preview {
    CategoryView(selectionModel: FoodSelectionModel())
}
