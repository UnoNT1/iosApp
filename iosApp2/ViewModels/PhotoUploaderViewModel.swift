//
//  PhotoUploaderViewModel.swift
//  iosApp2
//
//  Created by federico on 23/05/2025.
//

import Foundation
import UIKit // Necesario para UIImage y Data de imágenes


class PhotoUploaderViewModel: ObservableObject {
    // MARK: - Propiedades Publicadas (@Published)

    @Published var selectedImage: UIImage?
    @Published var isUploading: Bool = false
    @Published var uploadMessage: String?
    @Published var showAlert: Bool = false

    @Published var finalImageName: String = "" // Guardará el nombre final con .png para la UI
    @Published var imageType: String = ""      // Guardará "png" para la UI

    // ¡¡¡IMPORTANTE: Reemplaza esta URL con la ruta REAL y COMPLETA de tu script PHP!!!
    let uploadURL = URL(string: "https://www.unont.com.ar/yavoy/sistemas/dato5/android/foto.php")!

    // MARK: - Función de Subida de Foto

    func uploadPhoto(operacion: String, baseNombre: String, detalle: String, tipo: String, empresa: String, originalImageFileName: String?) {
        guard let imageToUpload = selectedImage else {
            uploadMessage = "No se ha seleccionado ninguna imagen para subir."
            showAlert = true
            return
        }

        isUploading = true
        uploadMessage = nil

        // Siempre convertimos la imagen a PNG Data, ya que PHP añadirá .png
        guard let finalImageData = imageToUpload.pngData() else {
            uploadMessage = "Error al convertir la imagen a formato PNG."
            showAlert = true
            isUploading = false
            return
        }

        // El nombre de archivo que se mostrará en la UI y el tipo final (siempre png)
        let fullFileNameForUI = "\(baseNombre).png"
        self.finalImageName = fullFileNameForUI // Para mostrar en la UI
        self.imageType = "png"                   // Para mostrar en la UI

        let base64Image = finalImageData.base64EncodedString()

        // Construir los parámetros de la solicitud POST
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "operacion", value: operacion),
            URLQueryItem(name: "foto", value: base64Image),
            // ¡¡¡CAMBIO CLAVE AQUÍ!!!
            // Enviamos SOLO el baseNombre, sin ninguna extensión, porque PHP añadirá ".png"
            URLQueryItem(name: "nombre", value: baseNombre),
            URLQueryItem(name: "detalle", value: detalle),
            URLQueryItem(name: "tipo", value: tipo),
            URLQueryItem(name: "empresa", value: empresa)
        ]

        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.isUploading = false
                if let error = error {
                    self.uploadMessage = "Error de conexión: \(error.localizedDescription)"
                    self.showAlert = true
                    print("🚫 Error de conexión al subir foto: \(error)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        self.uploadMessage = "Error del servidor: Código \(httpResponse.statusCode)"
                        self.showAlert = true
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("🚨 Respuesta de error del servidor: \(responseString)")
                        }
                        return
                    }
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("✅ Respuesta de la API (raw): \(responseString)")
                    if responseString.contains("Subió imagen Correctamente") {
                        self.uploadMessage = "¡Imagen subida correctamente!"
                    } else {
                        self.uploadMessage = "Error al subir imagen: \(responseString)"
                    }
                } else {
                    self.uploadMessage = "No se recibió respuesta válida del servidor."
                }
                self.showAlert = true
            }
        }.resume()
    }
}
