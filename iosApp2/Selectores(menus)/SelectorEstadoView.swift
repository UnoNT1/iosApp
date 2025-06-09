//
//  SelectorEstadoView.swift
//  iosApp2
//
//  Created by federico on 30/05/2025.
//

import Foundation
import SwiftUI

// Define tu enum de Estados de OS
enum EstadoOS: String, CaseIterable, Identifiable {
    case enProceso = "EP"
    case conforme = "CONF"
    case terminadaOK = "T"
    case observada = "OB"
    case pendiente = "PEND"
    // Agrega aquí todos los estados posibles que tu API o lógica maneje

    var id: String { self.rawValue } // Necesario para usarlo en List o ForEach
    
    // Opcional: una representación más amigable para la UI
    var displayText: String {
        switch self {
        case .enProceso: return "En Proceso"
        case .conforme: return "Conforme"
        case .terminadaOK: return "Terminada OK"
        case .observada: return "Observada"
        case .pendiente: return "Pendiente"
        }
    }
}

struct SelectorEstadoView: View {
    @Environment(\.dismiss) var dismiss
    
    // Closure para devolver el estado seleccionado
    var onEstadoSeleccionado: ((EstadoOS) -> Void)

    var body: some View {
        NavigationView {
            List(EstadoOS.allCases) { estado in // Usamos .allCases del enum
                Button(action: {
                    onEstadoSeleccionado(estado) // Devuelve el estado seleccionado
                    dismiss() // Cierra el modal
                }) {
                    Text(estado.displayText) // Muestra el texto amigable
                }
            }
            .navigationTitle("Seleccionar Estado")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
