//
//  yavoy.swift
//  iosApp2
//
//  Created by federico on 12/06/2025.
//

import Foundation
//funcion cundo tocas en el icono de yavoy en un reclamo
func yaVoy(nroOS: String, est_tarea: String, obs_reclamo:String, usu_tarea: String, dem_reclamo: String, r00_reclamo: String, cta_reclamo:String, tit_reclamo:String, empresa: String, completion: @escaping (Result<Void, APIError>) -> Void) {
    guard let url = URL(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/editar_reclamo.php") else {
        completion(.failure(.invalidURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let postData = "nro_os=\(nroOS)&est_tarea=\(est_tarea)&tar_tarea=\(obs_reclamo)&usu_tarea=\(usu_tarea)&dem_tarea=\(dem_reclamo)&r00_tarea=\(r00_reclamo)&cta_tarea=\(cta_reclamo)&tit_tarea=\(tit_reclamo)&emp_tarea=\(empresa)"
    
    //imprimir los valores que se van a enviar
    print("--------------------------------------------------")
    print("Enviando a editar_reclamo.php:")
    print("Datos a enviar (httpBody): \(postData)")
    print("--------------------------------------------------")
    
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
