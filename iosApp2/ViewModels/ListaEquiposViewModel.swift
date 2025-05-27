//
//  obtenerEquipos.swift
//  iosApp2
//
//  Created by federico on 12/05/2025.
//

import Foundation
import SwiftUI

//donde se alamcene el resultado de la api
/*struct Equipo: Identifiable, Codable {
    let id = UUID()
    let tit_as00: String?
    let cta_as00: Int?
    let equ_as00: String?
    let act_as00: String?
    let abr_as00: String?
    let eop_as00: Int?
    let est_as00: Int?
}

//aca comienxa el view model donde se modela como se va a manejar el resultado de la api
class ListaEquiposNombreViewModel: ObservableObject {
    @Published var equipos: [Equipo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var empresa: String
    var nombreCliente: String

    init(empresa: String, nombreCliente: String) {
        self.empresa = empresa
        self.nombreCliente = nombreCliente
        fetchEquipos()
    }

    func fetchEquipos() {
        isLoading = true
        errorMessage = nil
        equipos = []

        guard let url = URL(string: "\(urlApi)/listaEquipos.php?empresa=\(empresa)&nombreCliente=\(nombreCliente.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            errorMessage = "URL inválida"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Error de conexión: \(error.localizedDescription)"
                    print("Error de conexión: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.errorMessage = "Error en la respuesta del servidor"
                    print("Error en la respuesta del servidor: \(response as? HTTPURLResponse)")
                    return
                }

                if let data = data {
                    // Imprime la respuesta de la API como String para ver su contenido
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Respuesta de la API: \(responseString)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        self.equipos = try decoder.decode([Equipo].self, from: data)
                        print("Equipos decodificados: \(self.equipos)")
                    } catch {
                        self.errorMessage = "Error al decodificar el JSON: \(error.localizedDescription)"
                        print("Error al decodificar el JSON: \(error)")
                        print("Datos recibidos: \(String(data: data, encoding: .utf8) ?? "nil")")
                    }
                }
            }
        }.resume()
    }
}*/
