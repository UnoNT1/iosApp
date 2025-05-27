//
//  agregarCliente.swift
//  iosApp2
//
//  Created by federico on 27/03/2025.
//

import Foundation


func agregarCliente(
    nombre: String, dir: String, te: String, mail: String, contacto: String, cuit: String, horario: String, latitud: String, longitud: String, iva: String, lpr: String, usuario: String, tipo_iva: String,
    completion: @escaping (Result<String, Error>) -> Void
) {
    let url: String = "https://www.unont.com.ar/yavoy/sistemas/dato5/android/alta_cliente.php"
    guard let urlObj = URL(string: url) else {
        completion(.failure(NSError(domain: "App", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
        return
    }

    var request = URLRequest(url: urlObj)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let postString = "nombre=\(nombre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&dir=\(dir.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&te=\(te.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&mail=\(mail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&contacto=\(contacto.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&cuit=\(cuit.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&horario=\(horario.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&latitud=\(latitud.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&longitud=\(longitud.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&iva=\(iva.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&lpr=\(lpr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&usuario=\(usuario.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
    "&tipo_iva=\(tipo_iva.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    print("Datos a enviar: \(postString)")
    request.httpBody = postString.data(using: .utf8)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "App", code: -1, userInfo: [NSLocalizedDescriptionKey: "Respuesta del servidor inválida"])))
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let statusCode = httpResponse.statusCode
            completion(.failure(NSError(domain: "App", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Error en la respuesta del servidor con código: \(statusCode)"])))
            return
        }

        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            completion(.success(responseString))
        }
    }
    task.resume()
}
