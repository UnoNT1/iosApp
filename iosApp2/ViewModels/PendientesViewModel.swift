//
//  PendientesViewModel.swift
//  iosApp2
//
//  Created by federico on 05/06/2025.
//

import Foundation
import Combine // Importa Combine para el ObservableObject y @Published

class PendientesViewModel: ObservableObject {
    // @Published notificará a las vistas cada vez que 'visitas' cambie
    @Published var visitas: [VisitasPendientes] = []
    @Published var isLoading: Bool = false // Para mostrar un indicador de carga
    @Published var errorMessage: String? // Para mostrar errores

    func loadVisitas(nombre: String, empresa: String, usuario: String) {
        isLoading = true // Indica que la carga ha comenzado
        errorMessage = nil // Limpia cualquier error previo

        obtenerVisitasPendientes(nombre: nombre, empresa: empresa, usuario: usuario) { [weak self] (visitasCargadas, error) in
            // Asegúrate de que las actualizaciones de UI ocurran en el hilo principal
            DispatchQueue.main.async {
                self?.isLoading = false // La carga ha terminado

                if let error = error {
                    self?.errorMessage = "Error al cargar las visitas: \(error.localizedDescription)"
                    print("Error de carga: \(error.localizedDescription)")
                    self?.visitas = [] // Limpia las visitas en caso de error
                } else if let visitasCargadas = visitasCargadas {
                    self?.visitas = visitasCargadas
                    print("Visitas cargadas correctamente: \(visitasCargadas.count) elementos")
                } else {
                    self?.errorMessage = "No se recibieron datos de visitas."
                    self?.visitas = []
                }
            }
        }
    }
}
