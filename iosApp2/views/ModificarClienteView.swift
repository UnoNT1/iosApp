//
//  ModificarClienteView.swift
//  iosApp2
//
//  Created by federico on 27/03/2025.
//

import Foundation
import SwiftUI

struct ModificarClienteView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData
    @Binding var cliente: Clientes // Recibe el cliente a modificar
    @State private var mensajeError = ""
    @State private var mostrarError = false
    @State private var observacion = ""
    @State private var seleccion: Iva
    //esto hace q muestre el iva asociado al cliente
    init(cliente: Binding<Clientes>) {
        _cliente = cliente
        _seleccion = State(initialValue: Iva(rawValue: cliente.wrappedValue.civ_cl00) ?? .opcion1)
    }
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    BackButton()
                    Text("Modificar Cliente").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                TextField("Nombre", text: $cliente.ord_cl00).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Dirección", text: $cliente.dir_cl00).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Teléfono", text: $cliente.tel_cl00).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Email", text: $cliente.net_cl00).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Contacto", text: $cliente.con_cl00).textFieldStyle(RoundedBorderTextFieldStyle())
                HStack{
                    Text("Iva")
                    Picker("Iva", selection: $seleccion) {
                        ForEach(Iva.allCases) { opcion in
                            Text(opcion.rawValue).tag(opcion).font(.footnote)
                        }
                    }
                }
                TextField("Cuit", text: $cliente.iva_cl00).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Horario", text: $cliente.hor_cl00).textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Observaciones",text: $observacion).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if let index = Iva.allCases.firstIndex(of: seleccion) {
                        let indiceIVA = index + 1 // El índice comienza desde 1
                        modificarCliente(nombre:cliente.ord_cl00 , dir: cliente.dir_cl00, te: cliente.tel_cl00, mail: cliente.net_cl00, contacto: cliente.con_cl00, cuit: cliente.iva_cl00, horario: cliente.hor_cl00,iva: String(indiceIVA),cuenta: cliente.cta_cl00, completion:{result in print(result)} )
                    }
                    dismiss()
                }) {
                    Image("grabar_32").resizable().scaledToFill().frame(width: 80, height: 90)
                }
            }.frame(maxWidth: .infinity).padding()
        }.frame(maxWidth: .infinity).background(Image("fonfoc1").resizable().scaledToFill().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        
            .alert(isPresented: $mostrarError) {
                Alert(title: Text("Error"), message: Text(mensajeError), dismissButton: .default(Text("OK")))
            }
    }
}
