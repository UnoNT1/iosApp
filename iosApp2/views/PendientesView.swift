//
//  PendientesView.swift
//  iosApp2
//
//  Created by federico on 04/06/2025.
//

import SwiftUI

struct PendientesView: View {
    // Instancia del ViewModel. @StateObject la crea y la mantiene viva.
    @StateObject private var viewModel = PendientesViewModel()
    @Environment(\.dismiss) var dismiss

    // Parámetros que la vista padre le pasará a esta vista
    let nombreUsuario: String
    let empresaUsuario: String
    let usuarioApp: String
    // Nuevo closure para pasar los datos seleccionados a la vista padre
    var onVisitaSelected: (String?, String?, String?, String?, String?, String?, String?, String?, String?) -> Void // dir, titular, motivo, telefono, equipos
    var body: some View {
        VStack(alignment: .leading){
                HStack{
                    BackButton()
                    Text("Visitas Pendientes").font(.title2).padding(.horizontal)
                    Spacer()
                }.frame(maxWidth: .infinity).background(.blue)
                if viewModel.isLoading {
                    ProgressView("Cargando visitas...")
                        .padding()
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    Button("Reintentar") {
                        viewModel.loadVisitas(nombre: nombreUsuario, empresa: empresaUsuario, usuario: usuarioApp)
                    }
                    .padding()
                } else if viewModel.visitas.isEmpty {
                    Text("No hay visitas pendientes para mostrar.")
                        .foregroundColor(.gray)
                        .padding()
                    Button("Recargar") {
                        viewModel.loadVisitas(nombre: nombreUsuario, empresa: empresaUsuario, usuario: usuarioApp)
                    }
                    .padding()
                } else {
                    List(viewModel.visitas) { orden in // Usamos tu estructura VisitasPendientes aquí
                        // Tu contenido de celda existente
                        Button(action: {
                            // Cuando se selecciona una orden, llama al closure
                            onVisitaSelected(
                                orden.peDir,
                                orden.peTitular,
                                orden.peCta,
                                orden.peMotivo,
                                orden.peTre,   // Teléfono (peTre)
                                orden.peNre,
                                orden.peFirma,
                                orden.peEst,
                                orden.peNombre
                            )
                            print("Valores enviados a la vista padre:")
                            print("Dirección: \(orden.peDir ?? "N/A")")
                            print("Titular: \(orden.peTitular ?? "N/A")")
                            print("Motivo: \(orden.peMotivo ?? "N/A")")
                            print("Teléfono: \(orden.peTre ?? "N/A")")
                            print("Equipos: \(orden.peFirma ?? "N/A")")
                            print("Persona: \(orden.peNre ?? "N/A")")
                            print("Tipo: \(orden.peTre ?? "")")
                            // selectedVisita = orden
                        }) {
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    Text("\(orden.peNro ?? "N/A")")
                                        .background(Color.blue)
                                    Spacer()
                                    // Fecha y el círculo de estado
                                    HStack(spacing: 5) {
                                        Text("\(orden.peFecha ?? "N/A")")
                                            .foregroundStyle(.gray)

                                        Circle()
                                            .fill(estadoColor(for: orden.peEst))
                                            .frame(width: 10, height: 10)
                                            .overlay(
                                                Circle()
                                                    .stroke(orden.peEst == "1" ? Color.gray : Color.clear, lineWidth: 1)
                                            )
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(alignment: .top) {
                                    Text("\(orden.peTitular ?? "N/A")")
                                        .font(.title3)
                                        .foregroundStyle(.blue)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(alignment: .top) {
                                    Text("\(orden.peNombre ?? "N/A")") // El detalle de la OS
                                        .foregroundStyle(.red)
                                        .font(.footnote)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                HStack(alignment: .top) {
                                    Text("\(orden.peMotivo ?? "N/A")")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(.systemGray6), Color(.cyan).opacity(0.3)]), startPoint: .bottom, endPoint: .top)
                            )
                        }
                    }
                }
        }.frame(maxWidth: .infinity)
        .onAppear {
            // Cuando la vista aparece, carga las visitas
            viewModel.loadVisitas(nombre: nombreUsuario, empresa: empresaUsuario, usuario: usuarioApp)
        }
    }

    // Función auxiliar para determinar el color del círculo
    private func estadoColor(for estado: String?) -> Color {
        guard let estadoNum = Int(estado ?? "") else { return .clear } // Convierte a Int para la comparación numérica

        switch estadoNum {
        case 9: return .red // Pendiente
        case 2: return .green // Conforme
        case 1: return .white // En proceso
        default: return .clear
        }
    }
}
