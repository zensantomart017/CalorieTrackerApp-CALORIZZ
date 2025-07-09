import SwiftUI

func foodCardView(food: FoodItem, isAdded: Bool,onAdd: @escaping () -> Void) -> some View {
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
                .foregroundStyle(.primary)
            
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
    .background(isAdded ? Color.orange.opacity(0.2) : Color(.shadedYellow))
    .background(isAdded ? Color.customYellow
        .opacity(0.2) : Color(.systemBackground))
    .cornerRadius(15)
    .overlay(
        RoundedRectangle(cornerRadius: 15)
            .stroke(isAdded ? Color.orange : Color.gray.opacity(0.2), lineWidth: 1)
    )
    .padding(.horizontal)
    .overlay(
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
            .padding(.horizontal)
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
    @Environment(\.colorScheme) var colorScheme
    let categoryOrder = ["Nasi", "Lauk", "Sayur", "Buah", "Umbi", "Sambal", "Makanan Olahan", "Camilan", "Hidangan Penutup", "Lainnya"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [.shadedOrange,.shadedYellow], startPoint: .topTrailing, endPoint: .bottomLeading)
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
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 16)
                    
                    Text("Cek kalori makananmu dulu yuk!")
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        
                        HStack(spacing: 12) {
                            HStack {
                                NavigationLink(destination: SearchView(selectionModel: selectionModel)) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    TextField("Cari menu", text: $searchBar)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }}
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(Color(.shadedYellow))
                            .cornerRadius(20)
                            
                            Button {
                                showCamera = true
                            } label: {
                                Image(systemName: "viewfinder.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .foregroundStyle(.orange)
                                //                                    .padding(10)
                                //                                Text("Scan")
                            }
                            //                            .padding()
                            //                            .background(Color.orange)
                            //                            .cornerRadius(20)
                            //                            .foregroundStyle(.white)
                        }
                        .sheet(isPresented: $showCamera) {
                            ImagePicker(selectedImage: $image)
                        }
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
                            .padding(.top)
                            .padding(.bottom, 100)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 20)
                    //                    .background(Color(.systemBackground))
                    //                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    //                    .ignoresSafeArea(edges: .bottom)
                    //                    .shadow(color: colorScheme == .dark ? Color.white.opacity(1) : Color.black.opacity(0.1), radius: 1, x: 0, y: 0)
                }
                
                HStack {
                    Group {
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
                    
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                    .padding(.horizontal)
                    .background(Color(.systemBackground))
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.loadAllFoods()
            }
        }
    }
}

#Preview {
    CategoryView(selectionModel: FoodSelectionModel())
}
