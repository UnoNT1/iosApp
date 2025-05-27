//
//  EquiposViewModel.swift
//  iosApp2
//
//  Created by federico on 27/05/2025.
//

import Foundation
import SwiftUI

class EquiposViewModel: ObservableObject {
    @Published var equipos: [Equipos] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // La lógica de red ahora reside directamente aquí
    func cargarEquipos(empresa: String, estado: String, palabra: String) {
        isLoading = true
        errorMessage = nil // Limpia cualquier error anterior

        // 1. Construcción de la URL (misma lógica que antes)
        var components = URLComponents(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/zz.php")
        components?.queryItems = [
            URLQueryItem(name: "empresa", value: empresa),
            URLQueryItem(name: "estado", value: estado),
            URLQueryItem(name: "palabra", value: palabra)
        ]

        guard let url = components?.url else {
            DispatchQueue.main.async { // Siempre vuelve al hilo principal para actualizaciones de UI/Published
                self.errorMessage = "Error al construir la URL para equipos."
                self.isLoading = false
            }
            print("Error: URL inválida para obtener equipos.")
            return
        }

        print("Solicitando URL de equipos: \(url.absoluteString)")

        // 2. Realiza la solicitud de red (misma lógica que antes)
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Asegura que todas las actualizaciones de @Published ocurran en el hilo principal
            DispatchQueue.main.async {
                guard let self = self else { return } // Captura self débilmente para evitar ciclos de retención

                self.isLoading = false // Ya no está cargando, independientemente del resultado

                // Manejo de errores de red
                if let error = error {
                    print("Error de red al obtener equipos: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }

                // Asegúrate de que haya datos
                guard let data = data else {
                    print("No se recibieron datos de la API para equipos.")
                    self.errorMessage = "No se recibieron datos de la API para equipos."
                    return
                }

                // Opcional: Imprimir el JSON crudo para depuración. ¡Muy útil!
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON crudo recibido para equipos:\n\(jsonString)")
                } else {
                    print("No se pudo convertir los datos a una cadena de texto (JSON crudo de equipos).")
                }

                // Intenta decodificar los datos
                do {
                    let equipos = try JSONDecoder().decode([Equipos].self, from: data)
                    print("Decodificación exitosa. Se encontraron \(equipos.count) equipos.")
                    self.equipos = equipos // Actualiza la propiedad @Published
                } catch let decodingError as DecodingError {
                    // Manejo específico de errores de decodificación
                    print("🚫 Error de decodificación al obtener equipos:")
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        self.errorMessage = "Tipo no coincide: \(type) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)"
                    case .valueNotFound(let type, let context):
                        self.errorMessage = "Valor no encontrado: \(type) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)"
                    case .keyNotFound(let key, let context):
                        self.errorMessage = "Clave no encontrada: \(key.stringValue) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)"
                    case .dataCorrupted(let context):
                        self.errorMessage = "Datos corruptos: \(context.debugDescription)"
                    @unknown default:
                        self.errorMessage = "Error de decodificación desconocido: \(decodingError.localizedDescription)"
                    }
                    print(self.errorMessage!) // Imprime el error detallado en consola también
                } catch {
                    // Cualquier otro error inesperado
                    print("Error general al decodificar equipos: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
}
