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

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Cargando reclamos...")
            } else if let error = error {
                Text("Error al cargar los reclamos: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else{
                List(reclamos) { reclamo in
                    NavigationLink(destination: EditarReclamoView(reclamo: reclamo)) { //Redirige a la vista de detalle
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading){
                                Text("\(reclamo.pTitular ?? "No disponible")")
                                    .font(.headline)
                                Text("Detalle: \(reclamo.pDetalle ?? "No disponible")")
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true) // Permite expansión vertical
                                Text("Registro: \(reclamo.pRegistro ?? "No disponible")")
                                Text("Estado: \(reclamo.pEstado ?? "No disponible")")
                            }.padding().frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 1.0, green: 0.8, blue: 0.0), // Naranja claro (arriba)
                                            Color.red
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(10) // Redondea las esquinas
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 2) // Agrega un borde rojo
                                )
                            HStack{
                                Text("\(reclamo.pFecha ?? "No disponible")")
                                Text(reclamo.pHora ?? "")
                                Text(reclamo.pOrigen ?? "No disponible").padding().background(Color.green)
                            }
                        }.frame(maxWidth: .infinity)
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
