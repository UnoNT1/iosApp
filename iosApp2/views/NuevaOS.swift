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
                   HStack {
                       Text("Nueva OS \(numeroOperacionActual)").font(.title3)
                       Spacer()
                       Button(action:{
                           mostrarFotoView = true
                       }){
                           Image(systemName: "camera.circle.fill").resizable().scaledToFill().frame(width: 40, height: 40)
                       }
                   }
                   
                   Section() {
                       HStack {
                           Text("Titular y Nro Cta").font(.footnote)
                           TextField("", text: $receptorNombre).frame(maxWidth: .infinity).background(.gray.opacity(0.2)).cornerRadius(8).foregroundStyle(.blue)
                           TextField("", text: $receptorCuenta).frame(width: 40).background(.gray.opacity(0.2)).cornerRadius(8).foregroundStyle(.blue)
                               .keyboardType(.numberPad)
                       }
                       
                       Button("Seleccionar Cliente") {
                           mostrandoHojaClientes = true
                       }
                   HStack { // Este HStack está directamente en el Form, no en una Section
                       Text("Responsable").font(.footnote)
                       TextField("", text: $configData.usuarioConfig).disabled(true).foregroundColor(.green).background(.gray.opacity(0.2)).cornerRadius(8)
                       Spacer()
                       Text("Equipo").font(.footnote)
                       TextField("", text: $equipoSeleccionado).background(.gray.opacity(0.2)).cornerRadius(8).foregroundStyle(.blue)
                   }
               }
                   
                   Section() {
                       HStack{
                           Menu {
                               ForEach(tiposServicioPosibles, id: \.self) { tipo in
                                   Button(tipo) {
                                       tipoServicioSeleccionado = tipo
                                   }
                               }
                           } label: {
                               HStack {
                                   Text("Tipo:")
                                   Text(tipoServicioSeleccionado)
                                       .foregroundColor(.secondary)
                               }
                           }
                           Spacer()
                           Menu {
                               ForEach(estadosPosibles, id: \.self) { estado in
                                   Button(estado) {
                                       estadoSeleccionado = estado
                                   }
                               }
                           } label: {
                               HStack {
                                   Text("Estado:")
                                   Text(estadoSeleccionado)
                                       .foregroundColor(.secondary)
                               }
                           }
                       }
                       HStack{
                           Text("Motivo")
                           DatePicker("", selection: $fecha, displayedComponents: .date)
                       }
                       // Aquí tu TextField del motivo con el fondo verde
                       ZStack {
                           RoundedRectangle(cornerRadius: 8)
                               .fill(Color.green)
                           TextField("Motivo", text: $motivo)
                               .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                               .foregroundStyle(Color.black)
                               .textFieldStyle(.plain)
                       }
                       .frame(height: 40)
                   }
                   
                   Button("Guardar Nueva OS") {
                       dismiss()
                   }
               }.listRowSpacing(0)
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
                   UploadPhotoView()
               }
               
               .onAppear {
                   clientesViewModel.cargarClientes(empresa: configData.empresaConfig)
               }
           }
       }
}
