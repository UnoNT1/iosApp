//
//  UploadPhotoView.swift
//  iosApp2
//
//  Created by federico on 23/05/2025.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit

struct UploadPhotoView: View {
    @EnvironmentObject var configData: ConfigData
    @State private var selectedUIImage: UIImage? // La imagen seleccionada/tomada
        @State private var showingImagePicker = false
        @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
        @State private var showingAlert = false
        @State private var alertTitle: String = ""
        @State private var alertMessage: String = ""

    // Nuevo estado para controlar la ActionSheet
       @State private var showingSourceSelectionActionSheet = false

       // Parámetros para la API
       @State private var operacion: String = "2025"
       @State private var nombre: String = ""
       @State private var detalle: String = ""
       @State private var tipo: String = ""
        let tipoIma: String = ""

       var body: some View {
           NavigationView {
               Form {
                   Section("Datos de la Imagen") {
                       if let uiImage = selectedUIImage {
                           Image(uiImage: uiImage)
                               .resizable()
                               .scaledToFit()
                               .frame(maxWidth: .infinity, maxHeight: 200)
                               .cornerRadius(10)
                               .padding(.vertical)
                       } else {
                           Text("Selecciona una imagen")
                               .foregroundColor(.gray)
                               .frame(maxWidth: .infinity, maxHeight: 150)
                               .background(Color.gray.opacity(0.1))
                               .cornerRadius(10)
                               .padding(.vertical)
                       }

                       Button("Seleccionar Imagen") {
                           // Activa el estado para mostrar la ActionSheet de SwiftUI
                           showingSourceSelectionActionSheet = true
                       }
                   }

                   Section("Parámetros de la API") {
                       TextField("Operación", text: $operacion)
                       TextField("Nombre", text: $nombre)
                       TextField("Detalle", text: $detalle)
                       TextField("Tipo", text: $tipo)
                       TextField("Empresa", text: $configData.empresaConfig)
                   }

                   Section {
                       Button("Subir Imagen a la API") {
                           uploadImage()
                       }
                       .disabled(selectedUIImage == nil || nombre.isEmpty || detalle.isEmpty || tipo.isEmpty)
                   }
               }
               .navigationTitle("Subir Imagen")
               // Modificador para la hoja de selección de imagen (ImagePicker)
               .sheet(isPresented: $showingImagePicker) {
                   ImagePicker(selectedImage: $selectedUIImage, sourceType: sourceType)
               }
               // Modificador para la ActionSheet de selección de fuente (Galería/Cámara)
               .actionSheet(isPresented: $showingSourceSelectionActionSheet) {
                   ActionSheet(title: Text("Seleccionar Imagen"), message: nil, buttons: [
                       .default(Text("Galería de Fotos")) {
                           self.sourceType = .photoLibrary
                           self.showingImagePicker = true
                       },
                       // Solo muestra la opción de cámara si está disponible
                       .default(Text("Cámara")) {
                           if UIImagePickerController.isSourceTypeAvailable(.camera) {
                               self.sourceType = .camera
                               self.showingImagePicker = true
                           } else {
                               // Si la cámara no está disponible, puedes mostrar una alerta
                               self.showAlert(title: "Error", message: "Cámara no disponible en este dispositivo.")
                           }
                       },
                       .cancel()
                   ])
               }
               .alert(isPresented: $showingAlert) {
                   Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
               }
           }
       }


       func uploadImage() {
           guard let imageToUpload = selectedUIImage else {
               self.showAlert(title: "Error", message: "Por favor, selecciona o toma una imagen primero.")
               return
           }

           guard !nombre.isEmpty, !detalle.isEmpty, !tipo.isEmpty else {
               self.showAlert(title: "Error", message: "Todos los campos de la API son obligatorios.")
               return
           }

           uploadImageToAPI(
               image: imageToUpload,
               operacion: operacion,
               nombre: nombre,
               detalle: detalle,
               tipo: tipoIma,
               empresa: configData.empresaConfig
           ) { result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let data):
                       self.showAlert(title: "Éxito", message: "Imagen subida correctamente.")
                       if let responseString = String(data: data, encoding: .utf8) {
                           print("Respuesta de la API: \(responseString)")
                       }
                       self.selectedUIImage = nil
                       self.nombre = ""
                       self.detalle = ""

                   case .failure(let error):
                       self.showAlert(title: "Error al subir", message: error.localizedDescription)
                       print("Error al subir imagen: \(error.localizedDescription)")
                   }
               }
           }
       }

       func showAlert(title: String, message: String) {
           self.alertTitle = title
           self.alertMessage = message
           self.showingAlert = true
       }
   }
