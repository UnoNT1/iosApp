//
//  obtenerImputados.swift
//  iosApp2
//
//  Created by federico on 13/03/2025.
//

import Foundation

struct Comprobante: Codable, Identifiable{
    let id: UUID = UUID()
    let id_re90 : String
    let nro_re90: String
    let det_re90: String
    let fin_re90: String
    let imp_re90: Int
    let ope_re90:String
    // Otros campos de tu comprobante
}

func obtenerComprobantes(completion: @escaping ([Comprobante]?, Error?) -> Void) {
    guard let url = URL(string: "\(urlApi)obtener_comprobantes.php") else {
        completion(nil, NSError(domain: "App", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"]))
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }

        guard let data = data else {
            completion(nil, NSError(domain: "App", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos"]))
            return
        }

        do {
            let decoder = JSONDecoder()
            let comprobantes = try decoder.decode([Comprobante].self, from: data)
            completion(comprobantes, nil)
        } catch {
            completion(nil, error)
        }
    }.resume()
}
