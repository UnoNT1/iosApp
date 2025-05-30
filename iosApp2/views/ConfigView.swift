//
//  ConfigView.swift
//  iosApp2
//
//  Created by federico on 20/03/2025.
//

import Foundation
import SwiftUI
import Combine

//clase para q estas variables sean accesibles para todas las vistas
class ConfigData: ObservableObject {
    @Published var menuValue: String = "OS"
    @Published var usuarioConfig: String = "Demo"
    @Published var empresaConfig: String = "Demo"
    @Published var ipConfig: String = "https://www.unont.com.ar/yavoy/sistemas/dato5/android/"
}

struct ConfigView: View{
    @State private var terminalConfig = "GENERICA"
    @EnvironmentObject var configData: ConfigData //intancia de clase para obtener las variables
    @Environment(\.dismiss) var dismiss
    var body: some View{
        NavigationView {
            VStack(alignment: .leading){
                Text("Ingrese IP").multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                SecureField("Ip",text: $configData.ipConfig).padding()
                Text("Usuario").multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                TextField("Usuario", text: $configData.usuarioConfig).padding()
                HStack{
                    Text("Terminal")
                    Spacer()
                    Text("Empresa").multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                HStack{
                    TextField("Terminal", text: $terminalConfig)
                    Spacer()
                    TextField("Empresa", text: $configData.empresaConfig)
                }
                Text("Menu")
                TextField("Menu", text: $configData.menuValue).padding()
                Button(action:{
                    dismiss()
                })
                {
                    Text("Ingresar").padding()
                }.border(.orange)
                
                Spacer()
            }.textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            
                .navigationTitle("Configuración")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cerrar") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
