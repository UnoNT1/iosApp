//
//  AgendaView.swift
//  iosApp2
//
//  Created by federico on 06/03/2025.
//

import SwiftUI

class FechasConsultas: ObservableObject{
    @Published var desdeFechaString: String = ""
    @Published var hastaFechaString: String = ""
    
    //inicializar variables para q tengan la fecha actual
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaActual = Date()
        let fechaActualString = dateFormatter.string(from: fechaActual)
        
        if desdeFechaString == "" {
            self.desdeFechaString = fechaActualString
        }
        if hastaFechaString == "" {
            self.hastaFechaString = fechaActualString
        }
    }
}

struct AgendaView: View {
    @EnvironmentObject var fechasConsultas : FechasConsultas
    @State private var desdeFecha = Date()
    @State private var hastaFecha = Date()
    @Environment(\.dismiss) var dismiss
    @Binding var nombreModulo: String

    var body: some View {
        VStack{
            HStack{
                BackButton()
                Spacer()
            }
            Text("Elija el rango entre dos fechas para buscar en las consultas segun el modulo que este posicionado").font(.title3).foregroundStyle(Color.blue).padding()
            Text(nombreModulo)
            DatePicker("", selection: $desdeFecha, displayedComponents: .date).padding().foregroundStyle(.blue)
            Text("DESDE: \(fechasConsultas.desdeFechaString)").foregroundStyle(.blue)
            DatePicker("", selection: $hastaFecha, displayedComponents: .date).padding().foregroundStyle(.blue)
            Text("HASTA: \(fechasConsultas.hastaFechaString)").foregroundStyle(.blue)
            
            Button(action: {
                fechasConsultas.desdeFechaString = formatearFecha(desdeFecha)
                fechasConsultas.hastaFechaString = formatearFecha(hastaFecha)
                dismiss()
                          
                    }) {
                        Text("Guardar")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                       .padding()
            Spacer()
        }
        .navigationTitle("Rango de Fechas para consulta").navigationBarTitleDisplayMode(.inline).font(.system(size: 20))
        .navigationBarBackButtonHidden(true)
    }
}

// Función auxiliar para formatear fechas, convirtiendolas en string.
    func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"// Estilo de Fechas
        return formatter.string(from: fecha)
    }


func stringADate(_ fechaString: String) -> Date {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd"
       return formatter.date(from: fechaString) ?? Date()
   }
