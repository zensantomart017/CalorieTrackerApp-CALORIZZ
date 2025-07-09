//
//  KategoriItem.swift
//  Calorizz
//
//  Created by Foundation-006 on 09/07/25.
//

import SwiftUI

struct KategoriItem: View {
    let title: String
    let imageName: String
    let backgroundColor: Color
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
                )
                .shadow(radius: isSelected ? 8 : 2)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .padding()
        .frame(width: 100)
        .background(backgroundColor.opacity(isSelected ? 1.0 : 0.5))
        .cornerRadius(20)
    }
}

