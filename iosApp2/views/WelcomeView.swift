//
//  WelcomeView.swift
//  iosApp2
//
//  Created by federico on 26/02/2025.
//

import SwiftUI

// Vista de bienvenida, una vez que las credenciales del usuario son validas
struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData
    
    enum NavigationItem: String, CaseIterable, Identifiable {
        //case agenda = "Agenda"
        //case notasDePedido = "Notas de Pedido"
       // case entradaSalidas = "Entradas / Salidas"
        //case cuentas = "Cuentas"
        case equipos = "Equipos"
        case ordenesServicios = "Ordenes de Servicio"
        //case consultaCodigos = "Consulta Codigos"
       // case emisionRecibos = "Emision de Recibos"
        //case actividadesNegocio = "Actividades en la Unidad de Negocio"
        
        var id: String { self.rawValue }
    }
    
    //variable donde se almacenara el item que seleccione el usuario
    @State private var selectedItem: NavigationItem? = nil
    @State private var mostrarTextField = false
    @State private var textoBusqueda = ""
    @State var nombreModulo: String = "MODULO GENERAL"
    @State private var isShowingMarcarIngreso = false
    @State private var isShowingCuentas = false
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Text("\(configData.usuarioConfig)")
                    Button(action:{
                        isShowingMarcarIngreso = true
                        
                    }){
                        Image("ingreso_32").resizable().scaledToFill().frame(width: 40, height: 40)
                    }
                }
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
                    }.padding(.horizontal)
                    Button(action:{
                        isShowingCuentas = true
                    }){
                        Image("vi_32").resizable().scaledToFill().frame(width: 48, height: 48)
                    }.padding(.horizontal)
                    Button(action:{
                        selectedItem = .ordenesServicios
                    }){
                        Text(configData.menuValue)
                    }.padding(.horizontal)
                }
                
            }
            //menu tres puntitos
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                        // boton para activar el buscador
                        Button(action:{
                            mostrarTextField.toggle()
                        }){
                            Image("doc").resizable().scaledToFill().frame(width: 30, height: 30)
                        }
                        
                        if mostrarTextField {
                            TextField("Buscar...", text: $textoBusqueda)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }
                    NavigationLink(destination: AgendaView(nombreModulo: $nombreModulo)) {
                        Image(systemName: "calendar").resizable().frame(width: 30, height: 30).padding() // Icono de calendario
                        }
                        
                        Menu() {
                            ForEach(NavigationItem.allCases) { item in
                                Button(item.rawValue) {
                                    selectedItem = item
                                    
                                }
                            }
                        }label:{Image(systemName: "ellipsis").resizable().scaledToFill().frame(width: 30)}
                }
            }.fullScreenCover(isPresented: $isShowingMarcarIngreso){
                IngresoView()
            }
            .fullScreenCover(isPresented: $isShowingCuentas){
                ClientesView()
            }
            
            //redirigir a determinada vista segun el caso q seleccione el usuario
            .fullScreenCover(item: $selectedItem) { vista in
                switch vista {
                case .equipos:
                    EquiposView()
                case .ordenesServicios:
                    OrdenesServicioView()
              /*  case .emisionRecibos:
                    ReciboSueldosView()*/
                }
            }
        }
    }
}

