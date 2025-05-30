//
//  tareasOs.swift
//  iosApp2
//
//  Created by federico on 29/04/2025.
//

import Foundation

struct TmpOS: Codable {
    let tmpNombre: String?
    let tmpCodigo: String?
    let tmpCantidad: String?
    let tmpDetalle: String?
    let tmpUno: String?
    let tmpTipo: String?
    let tmpPend: String?
    let tmpId: String?
}

func obtenerDetallesTMPOS(nroOS: String, completion: @escaping (Result<[TmpOS], Error>) -> Void) {
    guard let url = URL(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/tmp_os.php?nroos=\(nroOS)&accion=2") else {
        print("Error: URL inválida.")
        completion(.failure(NSError(domain: "AppError", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error en la petición: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Error en la respuesta del servidor: \(response as? HTTPURLResponse)")
            completion(.failure(NSError(domain: "AppError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Error en la respuesta del servidor"])))
            return
        }

        if let data = data {
            print("Datos JSON recibidos para OS \(nroOS): \(String(data: data, encoding: .utf8) ?? "No se pudieron decodificar los datos")")
            do {
                let decoder = JSONDecoder()
                let tmpOSArray = try decoder.decode([TmpOS].self, from: data)
                completion(.success(tmpOSArray))
            } catch {
                print("Error al decodificar el JSON para OS \(nroOS): \(error.localizedDescription)")
                completion(.failure(error))
            }
        } else {
            print("No se recibieron datos del servidor para la OS \(nroOS).")
            completion(.failure(NSError(domain: "AppError", code: -3, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos del servidor"])))
        }
    }.resume()
}
