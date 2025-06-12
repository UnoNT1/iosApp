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
    //variable para mostrar VisitasPendientesView
    @State private var isShowingMostrarPendientes: Bool = false
    // Estados para almacenar los valores recibidos de PendientesView
    @State private var selectedDir: String?
    @State private var selectedTitular: String?
    @State private var selectedCta: String?
    @State private var selectedMotivo: String? = ""
    @State private var selectedTel: String?
    @State private var selectedEquipo: String?
    @State private var selectedNre : String?
    @State private var selectedEst: String?
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                HStack{
                    BackButton()
                    Text("Marca De Ingreso").font(.title)
                }.frame(maxWidth:.infinity).background(Color.blue).foregroundStyle(Color.white)
                Text("Esta por marcar el ingreso a una ubicacion que le permitira mantener identificado a la cuenta para realizar las distintas tareas").font(.footnote).padding(10)
                Section() {
                    HStack {
                        Text("Lugar")
                        Text(selectedTitular ?? "No seleccionado").frame(maxWidth: .infinity).padding(.horizontal).background(Color.gray.opacity(0.2)).border(.gray, width: 0.5)
                            .cornerRadius(8).foregroundColor(.secondary)
                        Text(selectedCta ?? "").frame(maxWidth: 50).padding(.horizontal).background(Color.gray.opacity(0.2)).border(Color.gray, width: 0.5)
                            .cornerRadius(8)
                    }.padding(.horizontal)
                    
                    HStack{
                        Text("Direccion:")
                        Text(selectedDir ?? "").frame(maxWidth: .infinity).font(.footnote).padding(.horizontal).background(Color.gray.opacity(0.2)).border(Color.gray, width: 0.5).cornerRadius(8)
                    }.padding(.horizontal)
                    HStack{
                        Text("Equipo")
                        Text("\(nombreEquipoSeleccionado) ").frame(maxWidth: .infinity).padding(.horizontal).background(Color.gray.opacity(0.2)).border(.gray, width: 0.5).cornerRadius(8)
                        Button("Lista Equip."){
                            if selectedTitular != nil {
                                mostrarListaEquipos = true
                            } else {
                                mostrarAlertaClienteNoSeleccionado = true // Muestra la alerta si no hay cliente
                            }
                        }
                        
                    }.padding(.horizontal)
                    //condicional para mostrar la persona y numero de la visita pendiente
                    if selectedNre != nil || selectedTel != nil{
                        HStack{
                            Text(selectedNre ?? "").padding(.horizontal).background(.gray.opacity(0.2)).cornerRadius(8)
                            Text(selectedTel ?? "").padding(.horizontal).background(.gray.opacity(0.2)).cornerRadius(8)
                        }.frame(maxWidth: .infinity).padding(.horizontal)
                    } else{
                        
                    }
                    
                    HStack(alignment: .center){
                        Button(action:{
                            mostrandoSelectorCliente = true
                        }){
                            VStack(){
                                Image(systemName: "person.2").resizable().scaledToFill().frame(width: 40, height: 40)
                                Text("Cuentas").foregroundStyle(.blue)
                            }
                        }.padding()
                        Button(action:{
                            isShowingMostrarPendientes = true
                        }){
                            VStack{
                                Image("pend_64").resizable().scaledToFill().frame(width: 70, height: 40)
                                Text("Visitas").foregroundStyle(.blue)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                    Text("Motivo de la Visita:").padding(.horizontal)
                    ZStack{
                        TextEditor(text:Binding(
                            get: { selectedMotivo ?? "" }, // Si selectedMotivo es nil, usa ""
                            set: { selectedMotivo = $0 }   // Cuando el TextField cambia, actualiza selectedMotivo
                        ))
                            .border(.blue, width: 1)
                            .cornerRadius(4)
                            .frame(maxWidth: .infinity, minHeight: 80, maxHeight: 200) // Puedes controlar la altura aquí
                        
                    }.frame(maxWidth: .infinity).padding(.horizontal)
                    HStack{
                        Text("Tipo")
                        Picker("Seleccionar Tipo", selection: $tipoIngreso) { // Usamos la variable de estado
                            ForEach(TipoDeIngreso.allCases) { tipo in
                                Text(tipo.rawValue).tag(tipo)
                            }
                        }
                        .pickerStyle(.menu) // Aplica el estilo de menú desplegable
                        
                    }.padding(.horizontal)
                    HStack(alignment: .center){
                        Button(action:{
                            
                        }){
                            Image("ingreso1").resizable().scaledToFill().frame(width: 80, height: 60).padding(.horizontal)
                        }
                    }.frame(maxWidth: .infinity)
                }.padding(3)
            }.frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity)
        .sheet(isPresented: $mostrandoSelectorCliente) {
            SelectorClienteView(onClienteSeleccionado: { cliente in
                clienteSeleccionado = cliente
                self.selectedTitular = cliente.dir_cl00
                self.selectedCta = cliente.cta_cl00
                self.selectedDir = cliente.dir_cl00
                mostrandoSelectorCliente = false
            })
        }
        .sheet(isPresented: $isShowingMostrarPendientes){
            PendientesView(nombreUsuario: clienteSeleccionado?.dir_cl00 ?? "", empresaUsuario: configData.empresaConfig, usuarioApp: configData.usuarioConfig,// Aquí defines el closure que recibirá los datos
                           onVisitaSelected: { dir, titular,cta, motivo, telefono, persona , equipos, estado, tipoVisita in
                self.selectedDir = dir
                self.selectedTitular = titular
                self.selectedCta = cta
                self.selectedMotivo = motivo
                self.selectedTel = telefono
                self.selectedEquipo = equipos
                self.selectedNre = persona
                self.selectedEst = estado
                self.nombreEquipoSeleccionado = selectedEquipo ?? ""
               
                // Si no coincide, podrías dejar el actual o establecer un valor predeterminado.
                if let newTipo = TipoDeIngreso(rawValue: tipoVisita ?? "") {
                    self.tipoIngreso = newTipo
                } else {
                    // Opcional: Manejar casos donde el string no coincide con ningún tipo
                    print("Advertencia: El tipo de visita '\(tipoVisita)' no coincide con ningún TipoDeIngreso conocido.")
                    // Puedes decidir qué hacer aquí, por ejemplo, mantener el tipo actual
                    // o establecer uno por defecto como .mantenimiento
                    // self.tipoIngreso = .mantenimiento
                }
                
                isShowingMostrarPendientes = false // Opcional: cerrar la hoja si la presentaste como sheet
            }
            )
            .onAppear { // Añade este onAppear dentro del fullScreenCover
                   print("PendientesView FullScreenCover se presentó. Nombre de usuario para la carga: '\(selectedTitular ?? "NULO O VACÍO")'")
               }
            
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
