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
                LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                VStack (spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 160, height: 160)
                        
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
                        Text("Username")
                            .font(.headline)
                        
                        TextField("Your username", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                        
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
                .onAppear() {
                    if !name.isEmpty {
                        isReturningUser = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            navigate = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
