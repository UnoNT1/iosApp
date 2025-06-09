//
//  ReclamosView.swift
//  iosApp2
//
//  Created by federico on 07/04/2025.
//

import Foundation
import SwiftUI

struct ReclamosView: View {
    @State private var reclamos: [Reclamos] = []
    @State private var error: Error?
    @State private var isLoading = true
    @EnvironmentObject var fechasConsultas: FechasConsultas
    @EnvironmentObject var configData: ConfigData
    @State private var isShowingVerOs: Bool = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Cargando reclamos...")
            } else if let error = error {
                Text("Error al cargar los reclamos: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else{
                List(reclamos) { reclamo in
                    //condicional para redirijir dependiendo si es mantenimiento o agenda o reclamo
                    if "\(reclamo.pOrigen ?? "")" == "Alta OS AG" {
                        NavigationLink(destination: DetalleAgendaView(titular: reclamo.pTitular ?? "", detalle: reclamo.pDetalle ?? "", fecha: reclamo.pFecha ?? "", hora: reclamo.pHora ?? "", registro: reclamo.pRegistro ?? "", origen: reclamo.pOrigen ?? "")) {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading){
                                    Text("\(reclamo.pTitular ?? "No disponible")")
                                        .font(.headline)
                                    Text("Detalle: \(reclamo.pDetalle ?? "No disponible")")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }.padding().frame(maxWidth: .infinity)
                                    .background(
                                        backgroundForReclamo(detalle: reclamo.pDetalle)
                                    )
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(borderColorForReclamo(detalle: reclamo.pDetalle), lineWidth: 2)
                                    )
                                HStack{
                                    Text("\(reclamo.pFecha ?? "No disponible")")
                                    Text(reclamo.pRegistro ?? "")
                                    Text(reclamo.pOrigen ?? "No disponible").padding().background(Color.green)
                                }
                            }.frame(maxWidth: .infinity)
                        }
                    }
                    else if ("\(reclamo.pDetalle ?? "")".contains("Mantenimiento") && reclamo.pEstado != "1" ){
                        NavigationLink(destination: VerOsView(numeroOS:Binding(get: { reclamo.pRegistro }, set: { _ in }))){
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading){
                                    Text("\(reclamo.pTitular ?? "No disponible")")
                                        .font(.headline)
                                    Text("Detalle: \(reclamo.pDetalle ?? "No disponible")")
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true) // Permite expansión vertical
                                }.padding().frame(maxWidth: .infinity)
                                    .background(
                                        backgroundForReclamo(detalle: reclamo.pDetalle)
                                    )
                                    .cornerRadius(10) // Redondea las esquinas
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(borderColorForReclamo(detalle: reclamo.pDetalle), lineWidth: 2) // Agrega un borde
                                    )
                                HStack{
                                    Text("\(reclamo.pFecha ?? "No disponible")")
                                    Text(reclamo.pRegistro ?? "")
                                    Text(reclamo.pOrigen ?? "No disponible").padding().background(Color.green)
                                }
                            }.frame(maxWidth: .infinity)
                        }
                    }
                    else{
                        NavigationLink(destination: EditarReclamoView(reclamo: reclamo)) { //Redirige a la vista de detalle
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading){
                                Text("\(reclamo.pTitular ?? "No disponible")")
                                    .font(.headline)
                                Text("Detalle: \(reclamo.pDetalle ?? "No disponible")")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true) // Permite expansión vertical
                            }.padding().frame(maxWidth: .infinity)
                                .background(
                                    backgroundForReclamo(detalle: reclamo.pDetalle)
                                )
                                .cornerRadius(10) // Redondea las esquinas
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(borderColorForReclamo(detalle: reclamo.pDetalle), lineWidth: 2) // Agrega un borde
                                )
                            HStack{
                                Text("\(reclamo.pFecha ?? "No disponible")")
                                Text(reclamo.pRegistro ?? "")
                                Text(reclamo.pOrigen ?? "No disponible").padding().background(Color.green)
                            }
                        }.frame(maxWidth: .infinity)
                    }
                }
                }//cierre llave lista
                .listStyle(.plain)
                
            }
        }.frame(maxWidth: .infinity)
            .onChange(of: fechasConsultas.desdeFechaString){ _ in
                cargarReclamos()
            }
            .onChange(of: fechasConsultas.hastaFechaString){ _ in
                cargarReclamos()
            }
            .onAppear {
                cargarReclamos()
            }
    }

    func cargarReclamos() {
        isLoading = true
        obtenerReclamos(empresa: configData.empresaConfig ,desdeFecha: fechasConsultas.desdeFechaString, hastaFecha: fechasConsultas.hastaFechaString) { reclamos, error in
            DispatchQueue.main.async {
                isLoading = false
                if let reclamos = reclamos {
                    self.reclamos = reclamos
                } else if let error = error {
                    self.error = error
                }
            }
        }
    }
}

// --- FUNCIÓN PARA DETERMINAR EL FONDO ---
    @ViewBuilder
    func backgroundForReclamo(detalle: String?) -> some View {
        let normalizedDetalle = detalle?.lowercased() ?? ""

        if normalizedDetalle.contains("persona encerrada") && normalizedDetalle.contains("reclamo") {
            // Naranja tirando a rojo
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.8, blue: 0.0), // Naranja claro (arriba)
                    Color.red // Rojo
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        } else if normalizedDetalle.contains("reclamo") {
            // Amarillo
            Color.yellow // Un solo color para el amarillo
        } else if normalizedDetalle.contains("mantenimiento") {
            // Celeste
            Color.blue.opacity(0.6) // Un azul suave
        } else {
            // Color por defecto si ninguna condición se cumple (ej. tu gradiente original o blanco)
            // Celeste
            Color.blue.opacity(0.6) // Un azul suave
        }
    }


// --- FUNCIÓN PARA DETERMINAR EL COLOR DEL BORDE ---
   func borderColorForReclamo(detalle: String?) -> Color {
       let normalizedDetalle = detalle?.lowercased() ?? ""
       
       if normalizedDetalle.contains("persona encerrada") && normalizedDetalle.contains("reclamo") {
           return Color.red // Borde rojo más oscuro
       } else if normalizedDetalle.contains("reclamo") {
           return Color.orange // Borde naranja para reclamos solo
       } else if normalizedDetalle.contains("mantenimiento") {
           return Color.blue // Borde azul para mantenimiento
       } else {
           return Color.blue // Borde por defecto
       }
   }
