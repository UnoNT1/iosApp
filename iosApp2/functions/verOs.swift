//
//  verOs.swift
//  iosApp2
//
//  Created by federico on 29/04/2025.
//

import Foundation


import Foundation

struct VerOs: Codable {
    let pTit: String?
    let pFec: String?
    let pCon: String?
    let pMot: String?
    let pCta: String?
    let pReg: String?
    let pR00: String?
    let pUrl: String?
    let pTel: String?
    let pMail: String?
    let pUno: String?
    let pUsu: String?
    let pNen: String?
    let pSer: String?
    let pObs: String?
    let pOpe: String?
    let pEst: String?

    // Puedes agregar un init si necesitas inicializar con valores predeterminados
    // init() {
    //     pTit = ""
    //     pFec = ""
    //     // ... y así sucesivamente
    // }
}

func obtenerDetallesVerOs(registro: String, empresa: String, completion: @escaping (Result<[VerOs], Error>) -> Void) {
    guard let url = URL(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/veros.php") else {
        print("Error: URL inválida.")
        completion(.failure(NSError(domain: "AppError", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let postString = "registro=\(registro)&empresa=\(empresa)"
    print("Datos POST enviados: registro=\(registro), empresa=\(empresa)")
    request.httpBody = postString.data(using: .utf8)

    URLSession.shared.dataTask(with: request) { data, response, error in
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
            print("Respuesta JSON recibida: \(String(data: data, encoding: .utf8) ?? "No se pudieron decodificar los datos")")
            do {
                let decoder = JSONDecoder()
                let detallesVerOs = try decoder.decode([VerOs].self, from: data)
                completion(.success(detallesVerOs))
            } catch {
                print("Error al decodificar el JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        } else {
            print("No se recibieron datos del servidor.")
            completion(.failure(NSError(domain: "AppError", code: -3, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos del servidor"])))
        }
    }.resume()
}

