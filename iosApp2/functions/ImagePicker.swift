//
//  ImagePicker.swift
//  iosApp2
//
//  Created by federico on 23/05/2025.
//

import Foundation
import SwiftUI
import UIKit // Necesario para UIImagePickerController
import MobileCoreServices // Importar para kUTTypeImage (aunque no lo usamos directamente aquí, es bueno saberlo)

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Binding var originalImageFileName: String? // ¡Aquí está el cambio!
    @Environment(\.dismiss) var dismiss // Para cerrar la hoja después de seleccionar/tomar foto

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No se necesita actualizar nada para este caso
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

       
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                 if let image = info[.originalImage] as? UIImage {
                     parent.selectedImage = image

                     // Obtener el nombre del archivo original si es de la galería
                     if parent.sourceType == .photoLibrary, let imageUrl = info[.imageURL] as? URL {
                         parent.originalImageFileName = imageUrl.lastPathComponent // "IMG_1234.JPG"
                     } else {
                         // Si es de la cámara, o no se pudo obtener un URL (ej. Live Photos),
                         // el ViewModel se encargará de determinar la extensión.
                         // Aquí solo necesitamos indicar que no hay un nombre de archivo original explícito de la galería.
                         parent.originalImageFileName = nil
                     }
                 }
                 parent.dismiss()
             }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
