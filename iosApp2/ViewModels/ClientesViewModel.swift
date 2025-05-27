//
//  ClientesViewModel.swift
//  iosApp2
//
//  Created by federico on 08/05/2025.
//

import Foundation

// ViewModel para cargar los clientes (separa la lógica de la vista)
class ClientesViewModel: ObservableObject {
    @Published var clientesOriginales: [Clientes] = [] // Lista original de clientes
    @Published var clientesFiltrados: [Clientes] = [] // Lista filtrada para mostrar
    
    @Published var isLoading = true
    @Published var error: Error?
    
    @Published var searchText: String = "" {
            didSet {
                filtrarClientes() // Filtrar cada vez que cambia el texto de búsqueda
            }
        }
    func cargarClientes(empresa: String) {
            isLoading = true
            obtenerClientes(empresa: empresa) { fetchedClientes, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let fetchedClientes = fetchedClientes {
                        self.clientesOriginales = fetchedClientes
                        self.clientesFiltrados = fetchedClientes // Inicialmente mostrar todos
                    } else if let error = error {
                        self.error = error
                        print("Error al cargar clientes en ViewModel: \(error)")
                    }
                }
            }
        }

        func filtrarClientes() {
            if searchText.isEmpty {
                clientesFiltrados = clientesOriginales
            } else {
                clientesFiltrados = clientesOriginales.filter {
                    $0.ord_cl00.localizedCaseInsensitiveContains(searchText) ||
                    $0.cta_cl00.localizedCaseInsensitiveContains(searchText) // También buscar por cuenta
                }
            }
        }
    }
