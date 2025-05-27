//
//  modificarCliente.swift
//  iosApp2
//
//  Created by federico on 27/03/2025.
//

import Foundation

func modificarCliente(nombre: String, dir: String, te: String, mail: String, contacto: String, cuit: String, horario: String, iva: String, cuenta: String, completion: @escaping (Result<Data, Error>) -> Void) {

    let parametros: [String: String] = [
        "nombre": nombre,
        "dir": dir,
        "te": te,
        "mail": mail,
        "contacto": contacto,
        "cuit": cuit,
        "horario": horario,
        "iva": iva,
        "id_cliente": cuenta
    ]
    let url: String = "\(urlApi)modificar_cliente.php"
    guard let urlObj = URL(string: url) else {
        completion(.failure(NSError(domain: "App", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
        return
    }

    var request = URLRequest(url: urlObj)
    request.httpMethod = "PUT" // Usa PUT para actualizaciones
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let parametrosString = parametros.map { "\($0)=\($1)" }.joined(separator: "&")

    print("Datos a Enviar: \(parametrosString)")
    request.httpBody = parametrosString.data(using: .utf8)

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos de la API"])))
            return
        }

        completion(.success(data))
    }.resume()
}
