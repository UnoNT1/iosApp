//
//  UploadPhotoView.swift
//  iosApp2
//
//  Created by federico on 23/05/2025.
//

import Foundation
import SwiftUI

struct UploadPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData
    @StateObject private var viewModel = PhotoUploaderViewModel()

    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    @State private var operacion: String
    @State private var baseNombreFoto: String
    @State private var originalImageFileName: String?

    private let sufijoNombreFotoAPI = "_O"

    @State private var detalleFoto: String = "Foto de prueba"
    @State private var tipoFoto: String = ""
    @State private var empresaId: String = "1"

    // CAMBIO 2: El inicializador ahora recibe el 'operacion'
    init(operacionDesdeNuevaOs: String) {
        // Asignamos el valor recibido al @State operacion
        _operacion = State(initialValue: operacionDesdeNuevaOs)
        
        // Ahora, baseNombreFoto se construye usando la operacion que llegó
        _baseNombreFoto = State(initialValue: "\(operacionDesdeNuevaOs)\(sufijoNombreFotoAPI)")
        
        _originalImageFileName = State(initialValue: nil)
        _viewModel = StateObject(wrappedValue: PhotoUploaderViewModel())
        // El 'empresaId' puedes seguirlo inicializando aquí o dejar que el Binding de NuevaOsView lo pase.
        // Si siempre es "1", puedes dejarlo así. Si viene de configData, es mejor pasarlo como binding.
        // Por ahora, asumimos que 'empresa' en uploadPhoto viene de configData.empresaConfig
    }

    var body: some View {
        NavigationView { // <-- El .onChange debe ir aquí o en el VStack/Form
            Form {
                Section("Datos de la Foto") {
                    Text("Operación: \(operacion)")
                    Text("Nombre Base: \(baseNombreFoto)")
                    Text("Nombre de Archivo Final: \(viewModel.finalImageName.isEmpty ? "Pendiente" : viewModel.finalImageName)")

                    HStack {
                        Text("Tipo de Archivo Detectado:")
                        Spacer()
                        Text(viewModel.imageType.isEmpty ? "No Seleccionado" : viewModel.imageType.uppercased())
                            .foregroundColor(.secondary)
                    }

                    TextField("Detalle", text: $detalleFoto)
                    // ... (Aquí iría tu Picker si decides mantener un control manual para 'tipo' del PHP)
                }

                Section("Seleccionar/Tomar Foto") {
                    HStack {
                        Spacer()
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }

                    Button("Tomar Foto (Cámara)") {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            sourceType = .camera
                            originalImageFileName = nil
                            showingImagePicker = true
                        } else {
                            viewModel.uploadMessage = "La cámara no está disponible en este dispositivo o simulador."
                            viewModel.showAlert = true
                        }
                    }
                    .disabled(viewModel.isUploading)

                    Button("Seleccionar de Galería") {
                        sourceType = .photoLibrary
                        showingImagePicker = true
                    }
                    .disabled(viewModel.isUploading)
                }

                Section {
                    Button(action: {
                        // Actualizamos tipoFoto con la extensión antes de subir
                        tipoFoto = viewModel.imageType

                        viewModel.uploadPhoto(
                            operacion: operacion,
                            baseNombre: baseNombreFoto,
                            detalle: detalleFoto,
                            tipo: tipoFoto, // Este es el valor que se envía a PHP
                            empresa: configData.empresaConfig,
                            originalImageFileName: originalImageFileName
                        )
                    }) {
                        if viewModel.isUploading {
                            ProgressView("Subiendo...")
                        } else {
                            Text("Subir Foto")
                        }
                    }
                    .disabled(viewModel.selectedImage == nil || viewModel.isUploading)
                }
            } // Fin de la Form
            .navigationTitle("Subir Foto")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(sourceType: sourceType, selectedImage: $viewModel.selectedImage, originalImageFileName: $originalImageFileName)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.uploadMessage ?? "Error"),
                    dismissButton: .default(Text("OK")) {
                        viewModel.showAlert = false
                    }
                )
            }
            // ¡¡ESTE ES EL CAMBIO!! El .onChange se aplica al NavigationView (o al contenido principal de la vista)
            .onChange(of: viewModel.imageType) { newType in
                self.tipoFoto = newType // Esto mantendrá tipoFoto sincronizado
            }
        } // Fin de la NavigationView
    }
}
