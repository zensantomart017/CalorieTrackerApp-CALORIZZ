//
//  WelcomeView.swift
//  Calorizz
//
//  Created by Foundation-023 on 26/06/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var navigate = false
    @AppStorage("username") private var name = ""
    @State private var isReturningUser = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.shadedOrange,.customOrange, .customYellow], startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                VStack (spacing: 20) {
                    ZStack {
                        
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 160, height: 170)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 80)
                    
                    if isReturningUser {
                        Text("Welcome back, \(name)!")
                            .font(.title)
                            .bold()
                            .padding(.bottom)
                    } else {
                        Text("Calorizz")
                            .font(.title)
                            .italic(true)
                            .bold(true)
                            .foregroundStyle(.shadedGreen)
                        
                        TextField("Your username", text: $name)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.white.opacity(0.30))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 32)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)

                        
                        Button {
                            if !name.isEmpty {
                                navigate = true
                            }
                        } label: {
                            Text("Next")
                                .fontWeight(.semibold)
                                .frame(maxWidth: 100)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .font(.headline)
                        .disabled(name.isEmpty)
                    }
                    
                    NavigationLink("", destination: CategoryView(), isActive: $navigate).hidden()
                }
                .padding()
//                .onAppear() {
//                    if !name.isEmpty {
//                        isReturningUser = true
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            navigate = true
//                        }
//                    }
//                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
