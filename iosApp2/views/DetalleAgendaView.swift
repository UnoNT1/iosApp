//
//  DetalleAgendaView.swift
//  iosApp2
//
//  Created by federico on 04/06/2025.
//

import Foundation
import SwiftUI

struct DetalleAgendaView: View {
    let titular: String?
    let detalle: String?
    let fecha: String?
    let hora: String?
    let registro: String?
    let origen: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            HStack{
                BackButton()
                Text("Agenda").font(.title).padding(.horizontal)
                Spacer()
            }.background(.blue).foregroundStyle(Color.white)
            HStack{
                Text("Usuario")
                Text(titular ?? "").padding(.horizontal).padding(.vertical, 5).frame(maxWidth: .infinity).border(.gray, width: 2).cornerRadius(6)
            }.frame(maxWidth: .infinity).padding(.horizontal)
            HStack{
                Text("Registro")
                Text(registro ?? "").underline()
                
                Text("Origen")
                Text(origen ?? "").underline()
            }.padding(.horizontal)
            HStack{
                Text("Dia/Hora")
                Text(fecha ?? "").underline()
                Text(hora ?? "").underline()
            }.padding(.horizontal)
            VStack(alignment: .leading){
                Text("Detalle a agendar")
                Text(detalle ?? "").padding(.vertical, 30).frame(maxWidth: .infinity).background(.green.opacity(0.5)).border(.blue, width: 2).cornerRadius(6)
            }.padding(.horizontal)
            Spacer()
        }.frame(maxWidth: .infinity)
            .navigationBarHidden(true)//oculta la navegacion del navigation link
    }
}
