//
//  AltaClienteView.swift
//  iosApp2
//
//  Created by federico on 26/03/2025.
//

import Foundation
import SwiftUI

//lista de iva
enum Iva: String, CaseIterable, Identifiable {
    case opcion1 = "Cons Final"
    case opcion2 = "Exento"
    case opcion3 = "No Inscripto"
    case opcion4 = "Resp Inscripto"
    case opcion5 = "IVA NO Responsable"
    case opcion6 = "Monotributo"

    var id: String { self.rawValue }
}
//lista precios
enum Precios: String, CaseIterable, Identifiable{
    case opcion1 = "Lista 1"
    case opcion2 = "Lista 2"
    case opcion3 = "Lista 3"
    case opcion4 = "Lista 4"
    case opcion5 = "Lista 5"
    case opcion6 = "Lista 6"
    
    var id: String { self.rawValue }
}

struct AltaClienteView: View {
    @EnvironmentObject var configData: ConfigData
    @Environment(\.dismiss) var dismiss
    @State var nombre: String = ""
    @State var direccion: String = ""
    @State var telefono: String = ""
    @State var mail: String = ""
    @State var contacto: String = ""
    @State var cuit: String = ""
    @State var horario: String = ""
    //seleccion de los items iva
    @State private var seleccion: Iva = .opcion1
    //seleccion lista precios
    @State private var seleccionPrecios: Precios = .opcion1
    @State private var selectedIva: String?
    //mostrar alerta una vez que se agrego el cliente
    @State private var showingAlert = false
    @State private var titleAlert: String = ""
    @State private var messageAlert: String = ""
    var body: some View {
            ScrollView{
                VStack(alignment:.leading) {
                    HStack{
                        BackButton()
                        Text("Alta Cliente").font(.title).fontWeight(.bold)
                        Spacer()
                    }.frame(maxWidth: .infinity).background(.blue).foregroundColor(.white)
                    Spacer()
                    VStack(alignment: .leading ){
                        Text("Nombre")
                        TextField("Nombre", text:$nombre).textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Direccion")
                        TextField("Direccion", text: $direccion).textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Telefono")
                        TextField("Telefono", text: $telefono).keyboardType(.numberPad).textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Mail")
                        TextField("Mail", text: $mail).textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Contacto")
                        TextField("Contacto", text: $contacto).textFieldStyle(RoundedBorderTextFieldStyle())
                    }.frame(alignment: .leading).padding(.horizontal)
                    //lista de items IVA
                    HStack{
                        Text("Iva")
                        Picker("Iva", selection: $seleccion) {
                            ForEach(Iva.allCases) { opcion in
                                Text(opcion.rawValue).tag(opcion).font(.footnote)
                            }
                        }
                    }.padding()
                    HStack{
                        Text("CUIT")
                        TextField("00-00000000-0", text: $cuit).textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding(.horizontal)
                    Text("Horario").padding(.horizontal)
                    TextField("Horario", text: $horario).padding(.horizontal).textFieldStyle(RoundedBorderTextFieldStyle())
                    //lista precios
                    HStack{
                        Text("Lista")
                        Picker("Lista", selection: $seleccionPrecios) {
                            ForEach(Precios.allCases) { opcion in
                                Text(opcion.rawValue).tag(opcion).font(.footnote)
                            }
                        }
                    }.padding()
                    HStack{
                        CircularButton(word: "Iva Normal", selectedWord:$selectedIva)
                        CircularButton(word: "Iva Especial", selectedWord:$selectedIva)
                    }.padding(.horizontal)
                    Button(action: {
                        if nombre != "" && selectedIva != "" && cuit != ""{
                            agregarCliente(nombre: nombre, dir: direccion, te: telefono, mail: mail, contacto: contacto, cuit: cuit, horario: horario, latitud: "0", longitud: "0", iva: seleccion.rawValue, lpr: seleccionPrecios.rawValue, usuario: configData.usuarioConfig, tipo_iva: selectedIva ?? "Iva Normal", completion: { result in print(result)
                            })
                            titleAlert = "Exito"
                            messageAlert = "Cliente Cargado Correctamente"
                            showingAlert = true
                        }else{
                            titleAlert = "Error"
                            messageAlert = "Ingresa valores en los campos correspondientes"
                            showingAlert = true
                        }
                    }) {
                        Image("btnagregar1").resizable().scaledToFill().frame(width: 100, height: 58)
                    }.padding()
                    Spacer()
                }.frame(maxWidth: .infinity) //modificador vista VStack
            }.frame(maxWidth: .infinity)
            .background(Image("fondoc0").resizable().scaledToFill().edgesIgnoringSafeArea(.all))//modificadores vista ScrollView
        //mostrar alerta una vez cargado el cliente
        .alert(isPresented: $showingAlert){
            Alert(title: Text(titleAlert), message: Text(messageAlert), dismissButton: .default(Text("OK")) {
                if titleAlert == "Exito"{
                    dismiss()
                } else{}
            })
        }
    }
}
