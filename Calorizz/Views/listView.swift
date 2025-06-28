//
//  listView.swift
//  calories
//
//  Created by Foundation-019 on 25/06/25.
//

import SwiftUI

struct listView: View {
    var body: some View {
        NavigationStack{
            VStack{
                HStack(spacing: 16) {
                    NavigationLink(destination: CategoryView()) {
                        Label("", systemImage: "chevron.left")
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                    
                    Button{
                    }label:{
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
                        MakananItemView(imageName: "ayambetutu", title: "Ayam Betutu", calories: "20 kkal")
                        MakananItemView(imageName: "sayurasem", title: "Sayur Asem", calories: "20 kkal")
                        MakananItemView(imageName: "jahirgoreng", title: "Ikan Jahir Goreng", calories: "20 kkal")
                        MakananItemView(imageName: "nasi", title: "Nasi Putih", calories: "20 kkal")
                        MakananItemView(imageName: "sayurasem", title: "Sayur Asem", calories: "20 kkal")
                        MakananItemView(imageName: "sayurasem", title: "Sayur Asem", calories: "20 kkal")
                    }
                }
                
                HStack(){
                    Text("Total : ")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("kkal")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationBarBackButtonHidden(true)
        }
    }
    
    struct MakananItemView: View {
        let imageName: String
        let title: String
        let calories: String
        
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
                
                HStack(spacing : 1){
                    Button{
                    } label:{
                        Label("", systemImage: "minus.circle.fill")
                            .foregroundStyle(.orange)
                            .padding(2)
                    }
                    
                    Text("1")
                        .font(.body)
                        .frame(width: 20)
                    
                    Button{
                    } label:{
                        Label("", systemImage: "plus.circle.fill")
                            .foregroundStyle(.orange)
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
    listView()
}
