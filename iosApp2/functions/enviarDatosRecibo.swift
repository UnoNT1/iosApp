//
//  enviarDatosRecibo.swift
//  iosApp2
//
//  Created by federico on 17/03/2025.
//

import Foundation

func enviarDatosRecibo(titular: String, operacion: String, cuenta: String, usuario: String, total: String, empresa: String, imputado: String, sucursal: String, celular: String) {
    guard let url = URL(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/addre.php") else {
        print("URL inválida")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    // Crear la cadena de parámetros
    let postString = "titular=\(titular.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&operacion=\(operacion.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&cuenta=\(cuenta.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&usuario=\(usuario.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&total=\(total.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&empresa=\(empresa.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&imputado=\(imputado.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&sucursal=\(sucursal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&celular=\(celular.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

    request.httpBody = postString.data(using: .utf8)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error al enviar la solicitud: \(error)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Error en la respuesta del servidor")
            return
        }

        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Respuesta del servidor(enviarDatosRecibo): \(responseString)")
        }
    }
    task.resume()
}


func enviarDatosComprobante(
    operacion: String,
    detalle: String,
    total: String,
    pago: String,
    fec_re90: String,
    nro_re90: String,
    emp_re90: String,
    completion: @escaping (Result<String, Error>) -> Void
) {
    let url: String = "https://www.unont.com.ar/yavoy/sistemas/dato5/android/addtmpre.php"
    guard let urlObj = URL(string: url) else {
        completion(.failure(NSError(domain: "App", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
        return
    }

    var request = URLRequest(url: urlObj)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let postString = "operacion=\(operacion.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&detalle=\(detalle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&total=\(total.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&pago=\(pago.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&fec_re90=\(fec_re90.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&nro_re90=\(nro_re90.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" +
                     "&emp_re90=\(emp_re90.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Demo")"

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
