//
//  ListaEquiposView.swift
//  iosApp2
//
//  Created by federico on 09/05/2025.
//

import Foundation
import SwiftUI

//vista que muestra la lista de equipos
struct ListaEquiposNombreView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData
    @State private var empresaBusqueda: String = ""
    @State private var nombreClienteBusqueda: String = ""
    @StateObject var viewModel: ListaEquiposNombreViewModel
    let onEquipoSeleccionado: (String) -> Void // Nuevo closure para comunicar la selección

    init(empresa: String, nombreCliente: String, onEquipoSeleccionado: @escaping (String) -> Void) {
        _viewModel = StateObject(wrappedValue: ListaEquiposNombreViewModel(empresa: empresa, nombreCliente: nombreCliente))
        self.onEquipoSeleccionado = onEquipoSeleccionado
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Cargando equipos...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error al cargar equipos: \(errorMessage)")
                        .foregroundColor(.red)
                } else if viewModel.equipos.isEmpty {
                    Text("No se encontraron equipos para los criterios proporcionados.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.equipos) { equipo in
                            Button(action: {
                                if let nombreEquipo = equipo.equ_as00 {
                                    onEquipoSeleccionado(nombreEquipo) // Llama al closure con el nombre
                                    dismiss() // Cierra la vista después de la selección
                                }
                            }){
                                VStack(alignment: .leading) {
                                    Text(equipo.tit_as00 ?? "Título no disponible")
                                        .font(.headline)
                                    Text("Cuenta: \(equipo.cta_as00 ?? 0)")
                                    Text("Equipo: \(equipo.equ_as00 ?? "N/A")")
                                    Text("Activo: \(equipo.act_as00 ?? "N/A")")
                                    Text("Tipo: \(equipo.abr_as00 ?? "N/A")")
                                    Text("EOP: \(equipo.eop_as00 ?? 0)")
                                    Text("Estado: \(equipo.est_as00 ?? 0)")
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }.navigationTitle("Lista de Equipos")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Atrás") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                print("Empresa a buscar: \(viewModel.empresa)")
                print("Nombre del cliente a buscar: \(viewModel.nombreCliente)")
            }
        }
    }
}
