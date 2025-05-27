//
//  NuevaOS.swift
//  iosApp2
//
//  Created by federico on 08/05/2025.
//

import Foundation
import SwiftUI

struct NuevaOS: View {
    @Environment(\.dismiss) var dismiss
    @State private var numeroOperacionActual: String = "" // O como sea que la obtengas

    @State private var receptorNombre: String = ""
    @State private var receptorCuenta: String = ""
    @State private var motivo: String = ""
    @State private var fecha: Date = Date()
    @State private var numeroOS: String = ""
    @State private var monto: String = ""
    @State private var operador: String = ""
    @State private var estado: String = "Pendiente"
    @State private var latitud: String = ""
    @State private var longitud: String = ""
    @State private var firma: String = ""
    @EnvironmentObject var configData: ConfigData
    @State private var equipoSeleccionado : String = ""
    @State private var mostrandoHojaClientes = false // Controla la presentación de la hoja
    @StateObject var clientesViewModel = ClientesViewModel() // Usamos un ViewModel para cargar los clientes
    @State private var estadoSeleccionado: String = "Pendiente" // Estado por defecto
    @State private var tipoServicioSeleccionado: String = "Reparación" // Tipo por defecto
    let estadosPosibles = ["Pendiente", "En Proceso", "Conforme", "Observada", "Terminada OK"]
    let tiposServicioPosibles = ["Reparación", "Mantenimiento", "Instalación", "Reclamo", "Ingeniero", "Fact.Masiva", "Todos"]
    @State private var mostrarFotoView = false

    init() {
        _numeroOperacionActual = State(initialValue: String(generarNumeroAleatorio()))
        // Puedes cargarla de la base de datos o generarla de alguna otra manera aquí
    }
    
    var body: some View {
           NavigationView {
               Form {
                   Section() {
                       HStack{
                           Text("Nueva OS \(numeroOperacionActual)").font(.title)
                           Spacer()
                           Button(action:{
                               mostrarFotoView = true
                           }){
                               Image(systemName: "camera.circle.fill").resizable().scaledToFill().frame(width: 40, height: 40)
                           }
                       }
                       HStack {
                           Text("Nombre:")
                           TextField("Nombre del Receptor", text: $receptorNombre)
                       }
                       HStack {
                           Text("Cuenta:")
                           TextField("Número de Cuenta", text: $receptorCuenta)
                               .keyboardType(.numberPad)
                       }
                       Button("Seleccionar Cliente") {
                           mostrandoHojaClientes = true // Presenta la hoja al tocar el botón
                       }
                   }
                   HStack{
                       Text("Responsable")
                       TextField("", text: $configData.usuarioConfig).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).foregroundColor(.green)
                       Text("Equipo")
                       TextField("", text: $equipoSeleccionado)
                   }
                   

                   Section(header: Text("Detalles de la Orden de Servicio")) {
                       HStack{
                           // Menú desplegable para el Tipo de Servicio
                           Menu {
                               ForEach(tiposServicioPosibles, id: \.self) { tipo in
                                   Button(tipo) {
                                       tipoServicioSeleccionado = tipo
                                   }
                               }
                           } label: {
                               HStack {
                                   Text("Tipo:")
                                   Spacer()
                                   Text(tipoServicioSeleccionado)
                                       .foregroundColor(.secondary)
                               }
                           }
                           
                           // Menú desplegable para el Estado
                           Menu {
                               ForEach(estadosPosibles, id: \.self) { estado in
                                   Button(estado) {
                                       estadoSeleccionado = estado
                                   }
                               }
                           } label: {
                               HStack {
                                   Text("Estado:")
                                   Spacer()
                                   Text(estadoSeleccionado)
                                       .foregroundColor(.secondary)
                               }
                           }
                       }
                       HStack{
                           Text("Motivo")
                           // Picker para seleccionar la fecha (opcional, si quieres permitir cambiarla)
                           DatePicker("", selection: $fecha, displayedComponents: .date)
                       }
                       TextField("Motivo",text: $motivo).foregroundStyle(Color.black) .textFieldStyle(RoundedBorderTextFieldStyle()).background(Color.green).padding()
                   }

                   Button("Guardar Nueva OS") {
                       dismiss()
                   }
               }
               .toolbar {
                   ToolbarItem(placement: .navigationBarLeading) {
                       Button("Cancelar") {
                           dismiss()
                       }
                   }
               }.sheet(isPresented: $mostrandoHojaClientes) {
                   HojaSeleccionarClienteView(clientesViewModel: clientesViewModel) { clienteSeleccionado in
                       receptorNombre = clienteSeleccionado.ord_cl00
                       receptorCuenta = clienteSeleccionado.cta_cl00
                       mostrandoHojaClientes = false // Cierra la hoja después de seleccionar
                   }
               }
               .sheet(isPresented: $mostrarFotoView ){
                   UploadPhotoView(operacionDesdeNuevaOs: numeroOperacionActual)
               }
               
               .onAppear {
                   clientesViewModel.cargarClientes(empresa: configData.empresaConfig)
               }
           }
       }
}
