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
            VStack (spacing: 20) {
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.green)
                    .padding()
                
                if isReturningUser {
                    Text("Welcome back, \(name)!")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                } else {
                    Label {
                        Text("Username")
                    } icon: {
                        Image(systemName: "person")
                    }
                    
                    TextField("Your username", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                    
                    Button {
                        if !name.isEmpty {
                            navigate = true
                        }
                    } label: {
                        Label("Next", systemImage: "arrow.right")
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .background(.blue)
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

#Preview {
    WelcomeView()
}
