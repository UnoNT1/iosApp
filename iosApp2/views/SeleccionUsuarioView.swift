//
//  SeleccionUsuarioView.swift
//  iosApp2
//
//  Created by federico on 07/03/2025.
//

import SwiftUI




//vista que muestra los usuarios para darle alta de recibos
struct SeleccionUsuarioView: View {
    @EnvironmentObject var fechasConsultas: FechasConsultas
    @Binding var datosUsuario: DatosUsuario
    //array que almacenara los usuarios
    @State private var users: [Recibos] = [] //@State para que la vista se actualice
    @Binding var selectedUser: String?
    
    let dateFormatter = DateFormatter()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var configData: ConfigData
    
    @State private var error: Error? // Donde se va a guardar el error si es q hay
    var body: some View {
        NavigationView {
            
            List(users) { user in
                Button(action: {
                    selectedUser = user.tit_re00
                    datosUsuario.titular = user.tit_re00 ?? ""
                    datosUsuario.celular = user.tel_re00 ?? ""
                    datosUsuario.cuenta = String(user.cta_re00 ?? 0)
                    datosUsuario.fecha = dateFormatter.string(from: Date())
                    datosUsuario.empresa = configData.empresaConfig
                    datosUsuario.usuario = configData.usuarioConfig
                    datosUsuario.sucursal = "20"
                    dismiss()
                }) {
                    Text(user.tit_re00 ?? "Usuario no disponible") //Text para mostrar el nombre del usuario
                }
            }
            .navigationTitle("Seleccionar Usuario")
        }
        //funcion que se ejecutaantes de que se muestre la vista
        .onAppear {
            obtenerRecibos(desdeFecha: fechasConsultas.desdeFechaString, hastaFecha:fechasConsultas.hastaFechaString ){ recibos, error in
                DispatchQueue.main.async {
                    if let recibos = recibos {
                        self.users = recibos
                    } else if let error = error {
                        print("ERROR DETALALDO: \(error)")
                        self.error = error
                    }
                }
            }
        }
    }
}


//este struct guarda los valores del equipo que el usuario selecciono para dar alta de recibo
struct DatosUsuario {
    var titular: String = ""
    var cuenta: String = ""
    var usuario: String = ""
    var empresa: String = ""
    var sucursal: String = ""
    var celular: String = ""
    var fecha: String = ""
}
