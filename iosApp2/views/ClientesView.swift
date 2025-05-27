//
//  ClientesView.swift
//  iosApp2
//
//  Created by federico on 26/03/2025.
//

import Foundation
import SwiftUI

struct ClientesView:View {
    @EnvironmentObject var configData: ConfigData
    @State public var clientes: [Clientes] = []
    @State private var isLoading = true
    @State private var error: Error?
    @State private var filtro: String = ""
    @State var isAltaCliente = false
    @Environment(\.dismiss) var dismiss
    //para filtrar los clientes
    var clientesFiltrados: [Clientes] {
        if filtro.isEmpty {
            return clientes
        } else {
            return clientes.filter { $0.ord_cl00.localizedCaseInsensitiveContains(filtro) }
        }
    }
    //mostrar el cliente q selecciono el usuario
    @State private var clienteSeleccionado: Clientes?
    @FocusState private var keyboardBack: Bool
    
    //donde empieza la vista
    var body: some View {
            VStack{
                Text("Clientes").font(.title).padding()
                HStack{
                    BackButton()
                    Spacer()
                    TextField("Filtrar clientes", text: $filtro)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($keyboardBack)
                    Spacer()
                    Button{
                        isAltaCliente = true
                    }label: {
                        Image("vi_48").resizable().scaledToFit().frame(width: 38, height: 38)
                    }.padding()
                }
                if isLoading {
                    ProgressView("Cargando clientes...")
                } else if let error = error {
                    Text("Error al cargar los clientes: \(error.localizedDescription)")
                        .foregroundColor(.red)
                }else {
                    if clientesFiltrados.isEmpty && !filtro.isEmpty {
                        Text("No se encontraron clientes")
                    } else if !clientesFiltrados.isEmpty {
                        List(clientesFiltrados) { cliente in
                                
                                VStack(alignment: .leading) {
                                    HStack{
                                        if cliente.cta_cl00 != "" {
                                            Text("N: \(cliente.cta_cl00)").foregroundStyle(.blue)
                                        } else {
                                            Text("N: No disponible")
                                        }
                                        Spacer()
                                        if cliente.ord_cl00 != ""{
                                            Text("\(cliente.ord_cl00)").foregroundStyle(.red.opacity(0.7))
                                        } else {
                                            Text("No disponible")
                                        }
                                    }
                                    Text("\(cliente.dir_cl00)").font(.body)
                                    Text("\(cliente.tel_cl00)").font(.body)
                                    Text("\(cliente.net_cl00)").font(.footnote)
                                }.onTapGesture {
                                    clienteSeleccionado = cliente // Guarda el cliente seleccionado
                                }
                        }.listRowBackground(Color.clear)
                            .listStyle(.plain)
                            .safeAreaInset(edge: .bottom) { // Agrega espacio al final de la lista
                                Spacer().frame(height: 100) // Ajusta la altura según sea necesario
                            }
                    }else{
                        Text("Cargando clientes...")
                    }
                }
                
            }.background(
                Image("fondoc0").resizable().scaledToFill().edgesIgnoringSafeArea(.all)
            )
            .onTapGesture {
                keyboardBack = false
            }
        
                .sheet(isPresented: $isAltaCliente){
                    AltaClienteView()
                }
            
            //muestra esta vista cuando el usuario presiona alguno de los clientes
                .sheet(item: $clienteSeleccionado) { cliente in
                    if let index = clientes.firstIndex(where: { $0.id == cliente.id }) {
                        ModificarClienteView(cliente: $clientes[index])
                    } else {
                        EmptyView()
                    }
                }
            
            //se ejecuta antes que cargue la vista
            .onAppear {
                obtenerClientes(empresa: configData.empresaConfig) { clientes, error in
                    DispatchQueue.main.async {
                        isLoading = false
                        if let clientes = clientes {
                            self.clientes = clientes
                        } else if let error = error {
                            print("ERROR DETALALDO: \(error)")
                            self.error = error
                        }
                    }
                }
            }
        }
}
