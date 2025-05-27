//
//  ComprobantesImputadosView.swift
//  iosApp2
//
//  Created by federico on 13/03/2025.
//

import SwiftUI

struct ComprobantesImputadosView: View {
    @Environment(\.dismiss) var dismiss // es para volver a la vista anterior
    @Binding var importe: Int // Recibe el Binding para el importe
    @Binding var detalleSeleccionado: String
    @State private var comprobantes: [Comprobante] = []
    @State private var comprobanteSeleccionado: Comprobante? = nil // Para almacenar el comprobante seleccionado
    @State private var importeSeleccionado: Int = 0
    @Binding var operacionSeleccionada: String
    @Binding var fechaRe: String // recibe binding para fecha_re90
    @Binding var nroComprobante: String
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Cargando comprobantes...")
                } else if let error = error {
                    Text("Error al cargar comprobantes: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    List(comprobantes) { comprobante in
                        Button {
                            // Acción al tocar el botón
                            comprobanteSeleccionado = comprobante
                            nroComprobante = comprobante.nro_re90
                            importeSeleccionado = comprobante.imp_re90 //almacena el total del comprobante seleccionado
                            fechaRe = comprobante.fin_re90
                            detalleSeleccionado = comprobante.det_re90
                            operacionSeleccionada = comprobante.ope_re90
                            importe = comprobante.imp_re90 // Actualiza el Binding de importe
                            print("Comprobante seleccionado: \(comprobante)")
                        } label: {
                                HStack {
                                    Text("Comprobante ID: \(comprobante.id_re90)")
                                    Text("Detalle: \(comprobante.det_re90)")
                                    Text("Total: $\(comprobante.imp_re90)")
                                    Text("Fecha: \(comprobante.fin_re90)")
                                }
                                .padding(.vertical, 8) // Ajusta el padding según necesites
                            }
                            .buttonStyle(PlainButtonStyle()) // Elimina el estilo por defecto del botón
                        }
                }
                
                HStack {
                    Text("Importe seleccionado: $\(importeSeleccionado)")
                        .padding()
                    Button("Guardar") {
                        // Aquí puedes guardar el valor de importeSeleccionado y otros datos
                        print("Guardando importe: \(importeSeleccionado)")
                        // También puedes acceder a comprobanteSeleccionado para obtener más detalles
                        if let seleccionado = comprobanteSeleccionado {
                            print("Detalle del comprobante: \(seleccionado.det_re90)")
                            // Guardar los datos aquí (por ejemplo, en una base de datos)
                        }
                        dismiss() // Vuelve a la vista anterior
                    }
                    .padding()
                }
                
                
            }
            .navigationTitle("Comprobantes")
            .onAppear {
                fetchComprobantes()
            }
        }
    }
    
    func fetchComprobantes() {
        isLoading = true
        obtenerComprobantes { fetchedComprobantes, fetchError in
            DispatchQueue.main.async {
                isLoading = false
                if let fetchError = fetchError {
                    self.error = fetchError
                    print(fetchError)
                } else if let fetchedComprobantes = fetchedComprobantes {
                    self.comprobantes = fetchedComprobantes
                }
            }
        }
    }
}
