//
//  WelcomeView.swift
//  iosApp2
//
//  Created by federico on 26/02/2025.
//

import SwiftUI

// Vista de bienvenida, una vez que las credenciales del usuario son validas
struct WelcomeView: View {
    var username: String
    var password: String
    
    enum NavigationItem: String, CaseIterable, Identifiable {
        case usuarios = "Usuarios"
        //case pagos = "Pagos"
        //case empresas = "Empresas"
        
        var id: String { self.rawValue }
    }
    
    @State private var selectedItem: NavigationItem? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hola, \(username)!")
                    .font(.largeTitle)
                    .padding()
                
                Text("Bienvenido a la aplicación.")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .navigationTitle("Bienvenido")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Opciones") {
                        ForEach(NavigationItem.allCases) { item in
                            Button(item.rawValue) {
                                selectedItem = item
                            
                            }
                        }
                    }
                }
            }
            .navigationDestination(item: $selectedItem) { item in
                switch item {
                case .usuarios:
                    ListView(username: username, password: password)
                    
              //  case .pagos:
                //    EmptyView()
                    
                //case .empresas:
                  //  EmptyView()
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}
