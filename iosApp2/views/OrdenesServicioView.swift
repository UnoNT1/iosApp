//
//  OrdenesServicioView.swift
//  iosApp2
//
//  Created by federico on 11/04/2025.
//

import Foundation
import SwiftUI

struct OrdenesServicioView: View {
    @State private var os: [OrdenesServicios] = []
    @State private var error: Error?
    @EnvironmentObject var configData: ConfigData
    @Environment(\.dismiss) var dismiss
    
    @State private var estadoSeleccionado: String = "Pendiente" // Valor por defecto
    let estados = ["En_Proceso", "Conforme", "Observada", "Terminada_OK", "OS Futura", "OS Anulada", "Facturada", "Presupuesto", "Pendiente", "Todos"]
    
    @State private var servicioSeleccionado: String = "Todos" // Valor por defecto
    let servicios = ["Reparaciones", "Mantenimiento", "Instalaciones", "Reclamo", "Ingeniero", "Fact.Masiva", "Todos"]
    //variable que maneja si el array de la api esta vacio
    @State private var noSeEncontraronRegistros: Bool = false
    @State private var isShowingVerOsView = false
    @State var selectedOSNumero: String?
    @State private var mostrandoNuevaOSView = false
    
    var body: some View {
        VStack{
            HStack{
                BackButton()
                Text("Ord. de Servicios").font(.title)
                Button(action:{
                    mostrandoNuevaOSView = true
                }){
                    Image("nuevo_64").resizable().scaledToFill().frame(width: 50, height: 50)
                    
                }
            }
            HStack {
                HStack{
                    Text("Estado")
                    // Menú desplegable para "Estado"
                    Picker("Estado", selection: $estadoSeleccionado) {
                        ForEach(estados, id: \.self) { estado in
                            Text(estado)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.trailing)
                }
                Text("Tipo")
                // Menú desplegable para "Servicio"
                Picker("Servicio", selection: $servicioSeleccionado) {
                    ForEach(servicios, id: \.self) { servicio in
                        Text(servicio)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(.horizontal)
            
            Button(action: {
                cargarOS()
            }){
                Text("Buscar").padding()
            }.background(Color.gray).foregroundStyle(Color.white).cornerRadius(8)
            
            
            if noSeEncontraronRegistros {
                Text("No se encontraron órdenes de servicio con los criterios seleccionados.")
                    .foregroundColor(.gray)
                    .padding()
            }else{
                Text("Cant: \(os.count)").padding().background(Color.blue).foregroundStyle(Color.white).cornerRadius(8)
                List(os, id: \.osNro) { orden in
                    Button(action: {
                        selectedOSNumero = orden.osNro ?? ""
                        print("Se seleccionó la OS con número: \(selectedOSNumero ?? "nullo")") // Imprime el valor
                        isShowingVerOsView = true
                    }) {
                        
                        VStack(alignment: .leading) {
                            HStack{
                                Text("\(orden.osNro ?? "N/A")").background(Color.blue)
                                Text("\(orden.osFecha ?? "N/A")").foregroundStyle(.gray)
                            }
                            HStack(alignment: .top){
                                Text("\(orden.osTitular ?? "N/A")").font(.title3).foregroundStyle(.blue)
                            }
                            HStack(alignment: .top){
                                Text("\(orden.osNombre ?? "N/A")").foregroundStyle(.red).font(.footnote)
                            }
                            HStack(alignment: .top){
                                Text("\(orden.osMotivo ?? "N/A")").font(.title3)
                            }
                        }.frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.cyan).opacity(0.3)]), startPoint: .bottom, endPoint: .top)
                            )
                            .cornerRadius(8)
                            .padding()
                    }.buttonStyle(PlainButtonStyle()) // Para que la celda de la lista sea interactiva
                }.listStyle(.plain)
            }
        }.frame(maxWidth: .infinity)
            .fullScreenCover(isPresented: $isShowingVerOsView ){
                VerOsView(numeroOS: $selectedOSNumero){
                    cargarOS()
                }

            }
            .fullScreenCover(isPresented: $mostrandoNuevaOSView) {
                NuevaOS()
            }
        .onAppear(){
            cargarOS()
        }
    }
  
    func cargarOS() {
            noSeEncontraronRegistros = false // Resetear el estado al iniciar la carga
            obtenerOrdenServicio(empresa: configData.empresaConfig, servicio: servicioSeleccionado, estado: estadoSeleccionado) { ordenes, error in
                DispatchQueue.main.async {
                    if let ordenes = ordenes {
                        self.os = ordenes
                        self.noSeEncontraronRegistros = ordenes.isEmpty // Actualizar el estado si el array está vacío
                    } else if let error = error {
                        self.error = error
                        // Aquí podrías mostrar un mensaje de error más específico al usuario
                        print("Error al obtener órdenes de servicio: \(error.localizedDescription)")
                        self.noSeEncontraronRegistros = true
                    }
                }
            }
        }
}

