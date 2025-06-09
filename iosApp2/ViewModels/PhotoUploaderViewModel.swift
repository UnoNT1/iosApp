//
//  PhotoUploaderViewModel.swift
//  iosApp2
//
//  Created by federico on 23/05/2025.
//

import Foundation
import UIKit // Necesario para UIImage y Data de imágenes
import SwiftUI


enum ImageUploadError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case serverError(Int, String?)
    case noData
    case invalidResponse
    case serializationError(Error)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "La URL de la API es inválida."
        case .requestFailed(let error): return "Fallo en la petición: \(error.localizedDescription)"
        case .serverError(let statusCode, let message): return "Error del servidor (\(statusCode)): \(message ?? "Desconocido")"
        case .noData: return "No se recibieron datos del servidor."
        case .invalidResponse: return "Respuesta inválida del servidor."
        case .serializationError(let error): return "Error al procesar la respuesta: \(error.localizedDescription)"
        case .unknownError: return "Ocurrió un error desconocido."
        }
    }
}

func uploadImageToAPI(
    image: UIImage,
    operacion: String,
    nombre: String,
    detalle: String,
    tipo: String,
    empresa: String,
    completion: @escaping (Result<Data, ImageUploadError>) -> Void
) {
    // ⚠️ ATENCIÓN: Reemplaza esta URL con la URL REAL de tu API para subir imágenes
    guard let url = URL(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/foto.php") else {
        completion(.failure(.invalidURL))
        return
    }
    
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        completion(.failure(.serializationError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se pudo convertir la imagen a Data."]))))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    
    func appendTextField(name: String, value: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    appendTextField(name: "operacion", value: operacion)
    appendTextField(name: "nombre", value: nombre)
    appendTextField(name: "detalle", value: detalle)
    appendTextField(name: "tipo", value: tipo)
    appendTextField(name: "empresa", value: empresa)
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"foto\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n".data(using: .utf8)!)
    
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error en la petición: \(error.localizedDescription)")
            completion(.failure(.requestFailed(error)))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Respuesta inválida del servidor.")
            completion(.failure(.invalidResponse))
            return
        }
        
        guard let data = data else {
            print("No se recibieron datos del servidor.")
            completion(.failure(.noData))
            return
        }
        
        if (200...299).contains(httpResponse.statusCode) {
            print("Imagen subida exitosamente. Código de estado: \(httpResponse.statusCode)")
            completion(.success(data))
        } else {
            let errorMessage = String(data: data, encoding: .utf8)
            print("Error del servidor: \(httpResponse.statusCode), Mensaje: \(errorMessage ?? "Sin mensaje")")
            completion(.failure(.serverError(httpResponse.statusCode, errorMessage)))
        }
    }
    task.resume()
}
