//
//  SelectorClientesView.swift
//  iosApp2
//
//  Created by federico on 09/05/2025.
//

import Foundation
import SwiftUI


// Vista para seleccionar un cliente (similar a ClientesView pero simplificada para la selección)
struct SelectorClienteView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData
    @State private var clientes: [Clientes] = []
    @State private var isLoading = true
    @State private var error: Error?
    @State private var filtro: String = ""
    var onClienteSeleccionado: (Clientes) -> Void

    var clientesFiltrados: [Clientes] {
        if filtro.isEmpty {
            return clientes
        } else {
            return clientes.filter { $0.ord_cl00.localizedCaseInsensitiveContains(filtro) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Buscar cliente...", text: $filtro)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if isLoading {
                    ProgressView("Cargando clientes...")
                } else if let error = error {
                    Text("Error al cargar clientes: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                } else if clientesFiltrados.isEmpty && !filtro.isEmpty {
                    Text("No se encontraron clientes")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(clientesFiltrados) { cliente in
                        Button(action: {
                            onClienteSeleccionado(cliente)
                        }) {
                            Text("\(cliente.ord_cl00) (\(cliente.cta_cl00))")
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Seleccionar Ascensor")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                obtenerClientes(empresa: configData.empresaConfig) { fetchedClientes, error in
                    DispatchQueue.main.async {
                        isLoading = false
                        if let fetchedClientes = fetchedClientes {
                            clientes = fetchedClientes
                        } else if let error = error {
                            self.error = error
                            print("Error al cargar clientes en SelectorClienteView: \(error)")
                        }
                    }
                }
            }
        }
    }
}
