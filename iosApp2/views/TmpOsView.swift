//
//  TmpOsView.swift
//  iosApp2
//
//  Created by federico on 29/04/2025.
//

import Foundation
import SwiftUI

//vista que la pasandole como arguemnto un numeroOS nos carga los detalles de la Orden de servicio correspondiente
struct TmpOsView: View{
    @State var tmpOs: [TmpOS] = []
    @Binding var nroOS: String?
    @State private var error: Error?
    var body: some View{
        VStack{
            if let error = error {
                
            } else if tmpOs.isEmpty {
                Text("Cargando datos...")
            } else {
                List {
                    ForEach(tmpOs, id: \.tmpId) { tmpItem in
                        VStack(alignment: .leading) {
                            HStack{
                                Text("Equipo")
                                Text("\(tmpItem.tmpUno ?? "")").frame(maxWidth: .infinity).background(Color.yellow).padding(1).border(Color.gray).cornerRadius(8)
                            }.padding(.horizontal)
                            Text("\(tmpItem.tmpNombre ?? "N/A")").frame(maxWidth: .infinity).padding(.horizontal).background(Color.white).border(Color.gray).cornerRadius(8)
                            Text("\(tmpItem.tmpDetalle ?? "N/A")").padding(.horizontal)
                            HStack{
                                Text("\(tmpItem.tmpId ?? "")").padding()
                                Text("Cant \(tmpItem.tmpCantidad ?? "")").padding()
                            }
                        }.frame(maxWidth: .infinity).background(Color.green)
                    }
                }.listStyle(.plain)
                    .background(Color.clear)
            }
        }.frame(maxWidth: .infinity)
        .onAppear(){
            obtenerDetallesTMPOS(nroOS: nroOS ?? "") {  result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detalles):
                        tmpOs = detalles // Tomamos el primer (y probablemente único) resultado
                    case .failure(let err):
                        error = err
                        print("Error al obtener detalles de la OS \(nroOS): \(err.localizedDescription)")
                    }
                }
            }
        }
    }
}
