//
//  NuevaOs.swift
//  iosApp2
//
//  Created by federico on 10/06/2025.
//

import Foundation


// Estructura para los parámetros que enviaremos a la API
struct IngresoData: Encodable {
    let titular: String
    let motivo: String
    let unico: String // O el tipo de dato que corresponda en PHP
    let operacion: String // PHP lo convierte a float, enviar como String es seguro
    let nroos: String // PHP lo convierte a Int, enviar como String es seguro
    let obs: String
    let usuario: String
    let cuenta: String // PHP lo convierte a Int, enviar como String es seguro
    let detalle: String
    let accion: String
    let estado: String
    let empresa: String
    let fecha: String // Formato "YYYY-MM-DD"
    let hora: String  // Formato "HH:MM"
}

// Estructura para la respuesta de la API
struct ApiResponse: Decodable {
    let logstatus: String // "0" para éxito, "1" para error
}


func registrarIngreso(data: IngresoData, completion: @escaping (Bool, Error?) -> Void) {
    // Reemplaza con la URL real de tu script PHP
    let apiUrlString = "https://www.unont.com.ar/yavoy/sistemas/dato5/android/addos.php" // Asumiendo el nombre del script

    guard let url = URL(string: apiUrlString) else {
        completion(false, NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL de la API inválida."]))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    // Construir el cuerpo de la solicitud POST
    // Los scripts PHP con $_POST esperan formato x-www-form-urlencoded
    var components = URLComponents()
    components.queryItems = [
        URLQueryItem(name: "titular", value: data.titular),
        URLQueryItem(name: "motivo", value: data.motivo),
        URLQueryItem(name: "unico", value: data.unico),
        URLQueryItem(name: "operacion", value: data.operacion),
        URLQueryItem(name: "nroos", value: data.nroos),
        URLQueryItem(name: "obs", value: data.obs),
        URLQueryItem(name: "usuario", value: data.usuario),
        URLQueryItem(name: "cuenta", value: data.cuenta),
        URLQueryItem(name: "detalle", value: data.detalle),
        URLQueryItem(name: "accion", value: data.accion),
        URLQueryItem(name: "estado", value: data.estado),
        URLQueryItem(name: "empresa", value: data.empresa),
        URLQueryItem(name: "fecha", value: data.fecha),
        URLQueryItem(name: "hora", value: data.hora)
    ]
    
    // Convertir los query items en el formato x-www-form-urlencoded
    // El '?' al principio es importante, pero lo quitamos para solo tener la cadena
    if let postBody = components.query?.data(using: .utf8) {
        request.httpBody = postBody
    } else {
        completion(false, NSError(domain: "EncodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se pudo codificar el cuerpo de la solicitud."]))
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error de red al registrar ingreso: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion(false, error)
            }
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("Respuesta no HTTP.")
            DispatchQueue.main.async {
                completion(false, NSError(domain: "InvalidResponse", code: 2, userInfo: [NSLocalizedDescriptionKey: "Respuesta de servidor inválida."]))
            }
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let statusCode = httpResponse.statusCode
            print("Error de servidor HTTP: \(statusCode)")
            if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                print("Respuesta del servidor: \(responseString)")
            }
            DispatchQueue.main.async {
                completion(false, NSError(domain: "HTTPError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Error HTTP: \(statusCode)"]))
            }
            return
        }

        guard let data = data else {
            print("No se recibieron datos en la respuesta.")
            DispatchQueue.main.async {
                completion(false, NSError(domain: "NoData", code: 3, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos del servidor."]))
            }
            return
        }

        // --- DEBUG: Imprimir la respuesta cruda del servidor ---
        if let rawResponse = String(data: data, encoding: .utf8) {
            print("Respuesta cruda de la API: \(rawResponse)")
        }
        // --- FIN DEBUG ---

        do {
            let apiResponses = try JSONDecoder().decode([ApiResponse].self, from: data)
            if let firstResponse = apiResponses.first {
                let success = (firstResponse.logstatus == "0")
                if success {
                    print("Ingreso registrado con éxito (logstatus: 0).")
                } else {
                    print("Fallo al registrar ingreso (logstatus: 1).")
                }
                DispatchQueue.main.async {
                    completion(success, nil)
                }
            } else {
                print("Respuesta de la API vacía o mal formada.")
                DispatchQueue.main.async {
                    completion(false, NSError(domain: "APIResponseError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Respuesta de la API vacía o mal formada."]))
                }
            }
        } catch {
            print("Error al decodificar la respuesta JSON: \(error.localizedDescription)")
            // --- DEBUG: Más detalles sobre el error de decodificación ---
            if let decodingError = error as? DecodingError {
                print("Detalles del error de decodificación: \(decodingError)")
            }
            // --- FIN DEBUG ---
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
    }.resume()
}
