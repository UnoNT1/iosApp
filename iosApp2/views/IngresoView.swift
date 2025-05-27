//
//  IngresoView.swift
//  iosApp2
//
//  Created by federico on 09/05/2025.
//

import Foundation
import SwiftUI

struct IngresoView:View {
    @State private var clienteSeleccionado: Clientes?
    @State private var mostrandoSelectorCliente = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData
    @State private var tipoIngreso: TipoDeIngreso = .mantenimiento
    enum TipoDeIngreso: String, CaseIterable, Identifiable {
        case mantenimiento = "Mantenimiento"
        case reclamo = "Reclamo"
        case ingeniero = "Ingeniero"
        case fact_masiva = "Fact.Masiva"
        case reparaciones = "Reparaciones"
        case instalaciones = "Instalaciones"
        case todos = "Todos"
        
        var id: Self { self }
    }
    
    @State private var empresaBuscar = ""
    @State private var nombreClienteBuscar = ""
    @State private var mostrarListaEquipos = false
    @State private var nombreEquipoSeleccionado: String = ""
    @State private var mostrarAlertaClienteNoSeleccionado = false
    @State private var motivoVisita: String = ""
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    BackButton()
                    Text("Marca De Ingreso")
                }
                Text("Esta por marcar el ingreso a una ubicacion que le permitira mantener identificado a la cuenta para realizar las distintas tareas").font(.footnote).padding()
                Section() {
                    HStack {
                        Text("Lugar")
                        Text(clienteSeleccionado?.ord_cl00 ?? "No seleccionado").background(Color.gray.opacity(0.2))
                            .cornerRadius(8).foregroundColor(.secondary)
                        Text(clienteSeleccionado?.cta_cl00 ?? "").background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }.padding(3)
                    
                    HStack{
                        Text("Direccion:")
                        Text(clienteSeleccionado?.dir_cl00 ?? "").font(.footnote)
                    }.padding(3)
                    HStack{
                        Text("Equipo: \(nombreEquipoSeleccionado) ")
                        Button("Lista Equip."){
                            if clienteSeleccionado != nil {
                                mostrarListaEquipos = true
                            } else {
                                mostrarAlertaClienteNoSeleccionado = true // Muestra la alerta si no hay cliente
                            }
                        }
                    }.padding(.bottom)
                    HStack{
                        Button(action:{
                            mostrandoSelectorCliente = true
                        }){
                            VStack{
                                Image(systemName: "person.2").resizable().scaledToFill().frame(width: 40, height: 40)
                                Text("Cuentas").foregroundStyle(.blue)
                            }
                        }.padding()
                        Button(action:{
                            
                        }){
                            VStack{
                                Image("pend_64").resizable().scaledToFill().frame(width: 70, height: 40)
                                Text("Visitas").foregroundStyle(.blue)
                            }
                        }
                    }
                    Text("Motivo de la Visita:")
                    TextField("", text: $motivoVisita).padding().background(Color.green).textFieldStyle(.roundedBorder)
                    
                    HStack{
                        Text("Tipo")
                        Picker("Seleccionar Tipo", selection: $tipoIngreso) { // Usamos la variable de estado
                            ForEach(TipoDeIngreso.allCases) { tipo in
                                Text(tipo.rawValue).tag(tipo)
                            }
                        }
                        .pickerStyle(.menu) // Aplica el estilo de menú desplegable
                        
                    }
                    Button(action:{
                        
                    }){
                        Image("ingreso1").resizable().scaledToFill().frame(width: 100, height: 70)
                    }
                }
                Spacer()
            }
        }.frame(maxWidth: .infinity)
        .sheet(isPresented: $mostrandoSelectorCliente) {
            SelectorClienteView(onClienteSeleccionado: { cliente in
                clienteSeleccionado = cliente
                mostrandoSelectorCliente = false
            })
        }
        .alert(isPresented: $mostrarAlertaClienteNoSeleccionado) { // Presenta la alerta
            Alert(
                title: Text("Seleccionar Cliente"),
                message: Text("Por favor, seleccione un cliente antes de elegir un equipo."),
                dismissButton: .default(Text("Entendido"))
            )
        }
        }
}
