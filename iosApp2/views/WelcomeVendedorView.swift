//
//  WelcomeVendedorView.swift
//  iosApp2
//
//  Created by federico on 20/03/2025.
//

import Foundation
import SwiftUI

struct WelcomeVendedorView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData
    
    enum NavigationItem: String, CaseIterable, Identifiable {
        //case agenda = "Agenda"
        //case notasDePedido = "Notas de Pedido"
       // case entradaSalidas = "Entradas / Salidas"
        case clientes = "Clientes"
        case ordenesServicios = "Ordenes de Servicio"
        //case consultaCodigos = "Consulta Codigos"
        case emisionRecibos = "Emision de Recibos"
        //case actividadesNegocio = "Actividades en la Unidad de Negocio"
        
        var id: String { self.rawValue }
    }
    
    //variable donde se almacenara el item que seleccione el usuario
    @State private var selectedItem: NavigationItem? = nil
    @State private var mostrarTextField = false
    @State private var textoBusqueda = ""
    @State var nombreModulo: String = "MODULO GENERAL"
    @State private var isShowingMarcarIngreso = false
    
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
                Button {
                    dismiss() // Cierra la vista
                } label: {
                    Image("atras_64")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
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
            
            //redirigir a determinada vista segun el caso q seleccione el usuario
            .fullScreenCover(item: $selectedItem) { vista in
                switch vista {
                case .clientes:
                    ClientesView()
                case .ordenesServicios:
                    OrdenesServicioView()
                case .emisionRecibos:
                    ReciboSueldosView()
                }
            }
        }
    }
}
