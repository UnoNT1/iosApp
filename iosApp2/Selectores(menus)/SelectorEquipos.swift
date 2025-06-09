//
//  SelectorEquipos.swift
//  iosApp2
//
//  Created by federico on 03/06/2025.
//

import Foundation
import SwiftUI

struct SelectorEquipoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData // To get 'empresaConfig'
    
    @StateObject var equiposViewModel = EquiposViewModel() // Own instance of the ViewModel
    @State private var filtroBusqueda: String = "" // For searching/filtering equipment
    // Recibe el filtro inicial como un Binding
    @Binding var filtroInicial: String

    // Closure to pass the selected equipment back to the parent view
    var onEquipoSeleccionado: (Equipos) -> Void

    // Computed property to filter the list of teams based on the search text
    var equiposFiltrados: [Equipos] {
        if filtroBusqueda.isEmpty {
            return equiposViewModel.equipos // Use the @Published 'equipos' from your ViewModel
        } else {
            return equiposViewModel.equipos.filter {
                $0.zzTitular?.localizedCaseInsensitiveContains(filtroBusqueda) ?? false
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Buscar equipo", text: $filtroBusqueda)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if equiposViewModel.isLoading {
                    ProgressView("Cargando equipos...")
                } else if let errorMessage = equiposViewModel.errorMessage {
                    Text("Error al cargar equipos: \(filtroBusqueda)") .foregroundColor(.red).padding()
                } else if equiposViewModel.equipos.isEmpty {
                    Text("No hay equipos disponibles.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(equiposFiltrados) { equipo in
                        Button(action: {
                            onEquipoSeleccionado(equipo) // Pass the selected equipment
                            dismiss() // Close the sheet
                        }) {
                            VStack{
                                Text(equipo.zzDir ?? "")
                                Text(equipo.zzUnico ?? "")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Seleccionar Equipo")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                self.filtroBusqueda = filtroInicial
                // You might pass an empty string or a generic term for 'palabra' if you want all equipments initially
                equiposViewModel.cargarEquipos(
                    empresa: configData.empresaConfig,
                    estado: "1",
                    palabra: filtroBusqueda
                )
            }
        }
    }
}
