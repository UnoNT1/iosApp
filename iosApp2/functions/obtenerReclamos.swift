//
//  obtenerReclamos.swift
//  iosApp2
//
//  Created by federico on 06/03/2025.
//

import Foundation

//funcion para obtener todos los reclamos de la tabla lpb_ag00
//{"a1":"Reclamo\r\nPersona encerrada en el ascensor.\r\n","pDetalle":"Reclamo\r\nPersona encerrada en el ascensor.\r\n","pOrigen":"SMS","pFecha":"7\/4-15:43 Z:1","pRegistro":"42070","pTitular":"ARAOZ 1815","pEstado":"8","pHora":"49290"}

struct Reclamos: Codable, Identifiable{
    let id: UUID? = UUID()
    var a1: String?
    var pDetalle: String?
    var pOrigen: String?
    var pFecha: String?
    var pRegistro: String?
    var pTitular: String?
    var pEstado: String?
    var pHora: String?
    
}

func obtenerReclamos(empresa: String, desdeFecha: String, hastaFecha: String, completion: @escaping ([Reclamos]?, Error?) -> Void) {
    // 1. Construcción de la URL
    // Codifica los componentes de la URL para evitar problemas con caracteres especiales (ej. espacios)
    var components = URLComponents(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/principal.php")
    components?.queryItems = [
        URLQueryItem(name: "cuenta", value: empresa),
        URLQueryItem(name: "empresa", value: empresa),
        URLQueryItem(name: "palabra", value: "0"),
        URLQueryItem(name: "estado", value: "0"),
        URLQueryItem(name: "w_desde", value: desdeFecha),
        URLQueryItem(name: "w_hasta", value: hastaFecha),
        URLQueryItem(name: "cliente", value: "0"),
        URLQueryItem(name: "cambio_a", value: "0"),
        URLQueryItem(name: "w_desde_pe", value: "0"),
        URLQueryItem(name: "w_hasta_pe", value: "0")
    ]
    
    guard let url = components?.url else { // Usamos components?.url para la URL codificada
        // Asegúrate de que el completion se llame en el hilo principal
        DispatchQueue.main.async {
            completion(nil, NSError(domain: "URLConstructionError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error al construir la URL."]))
        }
        print("Error al construir la URL para reclamos.")
        return
    }
    
    print("Fetching URL: \(url.absoluteString)") // Útil para depurar la URL exacta

    // 2. Ejecución de la tarea de red
    // No es necesario DispatchQueue.global().async aquí, URLSession ya trabaja en un hilo de fondo.
    URLSession.shared.dataTask(with: url) { data, response, error in
        // Todas las llamadas al completion deben ser en el hilo principal
        DispatchQueue.main.async {
            if let error = error {
                print("Error de red: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("No se recibieron datos de la API.")
                completion(nil, NSError(domain: "NoDataError", code: 204, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos de la API."]))
                return
            }
            
            // Opcional: Imprimir el JSON crudo para depuración
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON crudo recibido:\n\(jsonString)")
            } else {
                print("No se pudo convertir los datos a una cadena de texto (JSON crudo).")
            }

            do {
                let decoder = JSONDecoder()
                // Si la API devuelve fechas en un formato específico, puedes configurarlo aquí.
                // Por ejemplo, si pFecha fuera un Date en tu struct y la API lo envía como "YYYY-MM-DD"
                // decoder.dateDecodingStrategy = .iso8601 // O .formatted(formatter)

                let resultados = try decoder.decode([Reclamos].self, from: data)
                
                // Las líneas comentadas para limpiar cadenas:
                // Estas operaciones de reemplazo son más adecuadas para la presentación en la UI
                // o después de que se haya confirmado que la decodificación es exitosa.
                // Además, si los caracteres especiales son parte de la codificación UTF-8,
                // Swift los maneja automáticamente. Si son escapes de JSON, JSONDecoder
                // también los maneja. Solo si son caracteres basura literal en el JSON,
                // necesitarías este tipo de limpieza.
                /*
                for i in 0..<resultados.count {
                    resultados[i].a1 = resultados[i].a1?.replacingOccurrences(of: "\r\n", with: "").replacingOccurrences(of: "\\u00ed", with: "í").replacingOccurrences(of: "\\u00f3", with: "ó").replacingOccurrences(of: "\\u00c3\\u00ad", with: "í").replacingOccurrences(of: "\\u00c3\\u00b3", with: "ó")
                    resultados[i].pDetalle = resultados[i].pDetalle?.replacingOccurrences(of: "\r\n", with: "").replacingOccurrences(of: "\\u00ed", with: "í").replacingOccurrences(of: "\\u00f3", with: "ó").replacingOccurrences(of: "\\u00c3\\u00ad", with: "í").replacingOccurrences(of: "\\u00c3\\u00b3", with: "ó")
                }
                */

                //print("Decodificación exitosa. Se encontraron \(resultados.count) reclamos.")
                completion(resultados, nil)

            } catch let decodingError as DecodingError {
                // Manejo más específico de errores de decodificación
                print("🚫 Error de decodificación:")
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("  Tipo no coincide: \(type) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("  Valor no encontrado: \(type) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("  Clave no encontrada: \(key.stringValue) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("  Datos corruptos: \(context.debugDescription)")
                @unknown default:
                    print("  Error de decodificación desconocido: \(decodingError.localizedDescription)")
                }
                completion(nil, decodingError) // Pasa el error de decodificación más específico
            } catch {
                // Cualquier otro tipo de error
                print("Error general al decodificar: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }.resume() // Inicia la tarea de red
}
