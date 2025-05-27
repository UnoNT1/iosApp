//
//  obtenerOS.swift
//  iosApp2
//
//  Created by federico on 11/04/2025.
//

import Foundation


struct OrdenesServicios: Codable{
    var osNombre: String?
    var osTitular: String?
    var osMotivo: String?
    var osFecha: String?
    var osNro: String?
    var osMonto: String?
    var osOper: String?
    var osEst: String?
    var osCta: String?
    var osLat: String?
    var osLong: String?
    var osFirma: String?
}


func obtenerOrdenServicio(empresa: String, servicio: String? = nil, estado: String? = nil, completion: @escaping ([OrdenesServicios]?, Error?) -> Void) {
    guard !empresa.isEmpty else {
        print("El parámetro 'empresa' es obligatorio.")
        completion(nil, NSError(domain: "Parámetro inválido", code: -2, userInfo: [NSLocalizedDescriptionKey: "El parámetro 'empresa' es obligatorio."]))
        return
    }

    var components = URLComponents(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/os.php")

    components?.queryItems = [URLQueryItem(name: "empresa", value: empresa)]

    if let servicio = servicio, !servicio.isEmpty {
        components?.queryItems?.append(URLQueryItem(name: "tipo", value: servicio))
    }

    if let estado = estado, !estado.isEmpty {
        components?.queryItems?.append(URLQueryItem(name: "estado", value: estado))
    }

    guard let url = components?.url else {
        print("Error al construir la URL")
        completion(nil, NSError(domain: "Error de URL", code: -3, userInfo: [NSLocalizedDescriptionKey: "Error al construir la URL."]))
        return
    }

    print("URL a solicitar: \(url)") // Para depuración

    DispatchQueue.global().async {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "Datos no encontrados", code: -1, userInfo: nil))
                }
                return
            }

            do {
                let resultados = try JSONDecoder().decode([OrdenesServicios].self, from: data)
                DispatchQueue.main.async {
                    if resultados.isEmpty {
                        completion([], nil) // Devolvemos un array vacío para indicar "no se encontraron registros"
                    } else {
                        completion(resultados, nil)
                    }
                }
            } catch {
                print("Error detallado: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
