//
//  borrarOS.swift
//  iosApp2
//
//  Created by federico on 08/05/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

func borrarOS(nroOS: String, empresa: String, usuario: String, completion: @escaping (Result<Void, APIError>) -> Void) {
    guard let url = URL(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/borrar_os.php") else {
        completion(.failure(.invalidURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let postData = "nro_os=\(nroOS)&empresa=\(empresa)&usuario=\(usuario)"
    request.httpBody = postData.data(using: .utf8)

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(.invalidResponse))
            return
        }

        // La API PHP parece no devolver un JSON en caso de éxito,
        // por lo que asumimos que si la respuesta es exitosa (código 2xx),
        // la operación se realizó correctamente.
        completion(.success(()))

        // Si la API devolviera algún dato en caso de éxito o error específico
        // en el body de la respuesta, podrías decodificarlo aquí para
        // proporcionar información más detallada en la completion handler.
        // Por ejemplo:
        /*
        if let data = data {
            let responseString = String(decoding: data, as: UTF8.self)
            print("Respuesta del servidor: \(responseString)")
            // Podrías verificar el 'responseString' para determinar el éxito o un error específico.
        }
        */
    }.resume()
}
