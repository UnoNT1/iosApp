//
//  EquiposView.swift
//  iosApp2
//
//  Created by federico on 27/05/2025.
//

import Foundation
import SwiftUI

//estado = 2 es observado
//estado = 1 operativo
//estado = 3 parado
//estado = 0 muestra todos

struct EquiposView:View {
    @StateObject private var viewModel = EquiposViewModel() // Instancia del ViewModel
    // Tus parámetros de búsqueda
    @EnvironmentObject var configData: ConfigData
       // estadoParam ahora se inicializa desde ButtonState.blanco
       @State private var estadoParam: String = String(ButtonState.blanco.rawValue) // <-- IMPORTANTE: inicializar con el valor en string
       @State private var palabraParam: String = ""
       // Nuevo @State para el estado del botón. Su valor inicial coincide con estadoParam
       @State private var currentButtonState: ButtonState = .blanco
    
       var body: some View {
               VStack {
                   HStack{
                       BackButton()
                       Text("Lista Equipos").padding(.horizontal).font(.title)
                   }.frame(maxWidth: .infinity).background(Color.blue).foregroundStyle(.white)
                   
                   // *** ¡Aquí va el botón de estado cambiante! ***
                   Button(action: {
                       // 1. Cambia el estado interno del botón
                       currentButtonState = currentButtonState.next
                       // 2. Actualiza estadoParam con el nuevo valor numérico en String
                       estadoParam = String(currentButtonState.rawValue)
                       print("estadoParam actualizado a: \(estadoParam)")
                       
                       // Opcional: Llama a cargarEquipos inmediatamente si quieres que cambie al toque
                       // viewModel.cargarEquipos(empresa: empresaParam, estado: estadoParam, palabra: palabraParam)
                   }) {
                       Text("Estado del Equipo") // Muestra el número del estado
                           .font(.title3)
                           .fontWeight(.bold)
                           .foregroundColor(currentButtonState.color == .white ? .black : .white)
                           .padding(.vertical, 4)
                           .padding(.horizontal, 10)
                           .background(currentButtonState.color)
                           .cornerRadius(10)
                           .shadow(radius: 3)
                   }
                   .padding(.vertical) // Espacio para el botón
                   
                   TextField("Palabra", text: $palabraParam)
                       .textFieldStyle(.roundedBorder)
                       .padding(.horizontal)
                   
                   Button("Buscar Equipos") {
                       // Cuando presionas este botón, usará el valor actual de estadoParam
                       viewModel.cargarEquipos(empresa: configData.empresaConfig, estado: estadoParam, palabra: palabraParam)
                   }
                   .padding()
                   
                   // Indicador de carga
                   if viewModel.isLoading {
                       ProgressView("Cargando equipos...")
                       Spacer()
                   }
                   // Mensaje de error
                   else if let errorMessage = viewModel.errorMessage {
                       Text("Error: Valor no encontrado")
                           .foregroundColor(.red)
                           .padding()
                       Spacer()
                   }
                   // Lista de equipos
                   else {
                       List(viewModel.equipos) { equipo in
                           VStack(alignment: .leading) {
                               HStack{
                                   Text("\(equipo.zzNro ?? "N/D")").padding().background(Color.blue).cornerRadius(10).foregroundColor(.white)
                                   Spacer()
                                   Text("\(equipo.zzUnico ?? "N/D")").padding().background(Color.red).cornerRadius(10).foregroundColor(.white)
                               }
                               Text("\(equipo.zzNombre ?? "N/D")")
                                   .font(.headline)
                               Text("Titular: \(equipo.zzTitular ?? "N/D")")
                               Text("Dirección: \(equipo.zzDir ?? "N/D")")
                               HStack{
                                   Text("Equipo: \(equipo.zzTipo ?? "N/D")")
                                   Spacer()
                                   Text("Cta: \(equipo.zzCta ?? "N/D")")
                               }
                           }
                           .padding(.vertical, 4)
                           .background(cellBackgroundColor(forEopStatus: equipo.zzEop))
                           .cornerRadius(8) // Opcional: redondear también el fondo de la celda
                           .padding(.horizontal, 4) // Pequeño padding para que se vea el redondeo en la lista
                       }
                       .listStyle(.plain)
                   }
               
               }
               .onAppear {
                   // Carga inicial al aparecer la vista, usando el estado inicial del botón
                   viewModel.cargarEquipos(empresa: configData.empresaConfig, estado: estadoParam, palabra: palabraParam)
               }
       }
   }



// --- Función para determinar el color de fondo de la celda ---
   func cellBackgroundColor(forEopStatus eop: String?) -> Color {
       switch eop {
       case "1": // Estado 1: Verde (menos opaco)
           return Color.green.opacity(0.4) // Un verde más claro
       case "2": // Estado 2: Amarillo
           return Color.yellow.opacity(0.4) // Un naranja más claro
       case "3": // Estado 3: Rojo
           return Color.red.opacity(0.4) // Un rojo más claro
       case "0": // Estado 0: Blanco (o gris claro para que se note el cambio)
           return Color.gray.opacity(0.1) // Un gris muy claro
       default: // Cualquier otro caso o "N/D"
           return Color.clear // Sin fondo si no hay un estado definido
       }
   }
   // --- Fin de la función de color ---
