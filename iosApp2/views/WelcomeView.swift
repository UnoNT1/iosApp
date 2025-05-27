//
//  WelcomeView.swift
//  iosApp2
//
//  Created by federico on 26/02/2025.
//

import SwiftUI

enum NavigationItem: String, CaseIterable, Identifiable {
    case usuarios = "Usuarios"
    case ordenesServicios = "Ordenes de Servicio"
    case equipos = "Equipos"
    case personas = "Personas"
    case permisos = "Permisos"
    case stockInsumos = "Stock Insumos"
    
    var id: String { self.rawValue }
}


// Vista de bienvenida, una vez que las credenciales del usuario son validas
struct WelcomeView: View {
    var username: String
    var password: String
    @EnvironmentObject var configData: ConfigData
    @State private var mostrarTextField = false
    @State private var textoBusqueda = ""
    @Environment(\.dismiss) var dismiss
    @State private var isShowingRecibosView = false
    @State private var isShowingCuentasView = false
    
    
    //variable donde se almacenara el item que seleccione el usuario
    @State private var selectedItem: NavigationItem? = nil
    @State var nombreModulo: String = "MODULO GENERAL"
    
    var body: some View {
        NavigationView{
            VStack {
                Text("\(configData.usuarioConfig)").padding()
                ReclamosView()
                Spacer()
                HStack{
                    Button {
                        dismiss() // Cierra la vista
                    } label: {
                        Image("atras_64")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                    //va hacia la vista ReciboSueldos
                    Button(action:{
                        isShowingRecibosView = true
                    }){
                        Image("re_48")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                    Button(action:{
                        isShowingCuentasView = true
                    }){
                        Image("vi_48")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                }
                
            }
            //menu tres puntitos
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // boton para activar el buscador
                    Button(action:{
                        mostrarTextField.toggle()
                    }){
                        Image("doc")
                    }
                    
                    if mostrarTextField {
                        TextField("Buscar...", text: $textoBusqueda)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    NavigationLink(destination: AgendaView(nombreModulo: $nombreModulo)) {
                        Image(systemName: "calendar").resizable().frame(width: 30, height: 30).padding()
                    }
                    
                    Menu() {
                        ForEach(NavigationItem.allCases) { item in
                            Button(item.rawValue) {
                                selectedItem = item
                                
                            }
                        }
                    }label:{Image(systemName: "ellipsis").resizable().scaledToFill().frame(width: 30)}
                }
            }
            
            .fullScreenCover(item: $selectedItem) { item in
                switch item {
                case .usuarios:
                    ListView(username: username, password: password)
                    
                case .ordenesServicios:
                    EmptyView()
                    
                case .equipos:
                    EmptyView()
                    
                case .personas:
                    EmptyView()
                    
                case .permisos:
                    EmptyView()
                    
                case .stockInsumos:
                    EmptyView()
                }
            }
            
            .fullScreenCover(isPresented:$isShowingRecibosView) {
                ReciboSueldosView()
            }
            .fullScreenCover(isPresented: $isShowingCuentasView){
                CuentasView()
            }
        }
    }
}

