//
//  HojaSeleccionarCliente.swift
//  iosApp2
//
//  Created by federico on 08/05/2025.
//

import Foundation
import SwiftUI

struct HojaSeleccionarClienteView: View {
    @ObservedObject var clientesViewModel: ClientesViewModel
    let onClienteSeleccionado: (Clientes) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                TextField("Buscar cliente...", text: $clientesViewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if clientesViewModel.isLoading {
                    ProgressView("Cargando clientes...")
                } else if let error = clientesViewModel.error {
                    Text("Error al cargar clientes: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                } else if clientesViewModel.clientesFiltrados.isEmpty && !clientesViewModel.searchText.isEmpty {
                    Text("No se encontraron clientes")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(clientesViewModel.clientesFiltrados) { cliente in
                        Button(action: {
                            onClienteSeleccionado(cliente)
                        }) {
                            VStack(alignment: .leading) {
                                Text("\(cliente.ord_cl00) (\(cliente.cta_cl00))")
                                    .font(.headline)
                                // Puedes mostrar más detalles del cliente si lo deseas
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Seleccionar Cliente")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
