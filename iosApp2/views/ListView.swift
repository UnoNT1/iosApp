//
//  ListView.swift
//  iosApp2
//
//  Created by federico on 26/02/2025.
//

import SwiftUI

//Donde se almacena los usuarios con sus respectivas empresas
struct UsuarioEmpresa: Identifiable {
    let id = UUID()
    let usuario: String
    let empresa: String
}

//Lista de usuarios con sus respectivas empresas
struct ListView: View {
    @State private var usuariosEmpresas: [UsuarioEmpresa] = []
    @State private var filtro: String = ""
    let username: String
    let password: String

    var usuariosEmpresasFiltrados: [UsuarioEmpresa] {
        if filtro.isEmpty {
            return usuariosEmpresas
        } else {
            return usuariosEmpresas.filter { $0.usuario.localizedCaseInsensitiveContains(filtro) }
        }
    }

    var body: some View {
        VStack {
            TextField("Filtrar usuarios", text: $filtro)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if usuariosEmpresasFiltrados.isEmpty && !filtro.isEmpty {
                Text("No se encontraron usuarios")
            } else if !usuariosEmpresas.isEmpty {
                List(usuariosEmpresasFiltrados) { usuarioEmpresa in
                    HStack {
                        Text(usuarioEmpresa.usuario)
                        Spacer()
                        Text(usuarioEmpresa.empresa)
                    }
                }
            } else {
                Text("Cargando usuarios...")
            }
        }
        .navigationTitle("Usuarios")
        .onAppear {
            cargarUsuarios()
        }
    }

    func cargarUsuarios() {
        obtenerTodosUsuarios(username: username, password: password) { usuariosYEmpresas, error in
            if let error = error {
                print("Error al obtener usuarios: \(error)")
                return
            }
            if let usuariosYEmpresas = usuariosYEmpresas {
                var paresUsuarioEmpresa: [UsuarioEmpresa] = []
                for (index, usuario) in usuariosYEmpresas.usuarios.enumerated() {
                    if index < usuariosYEmpresas.empresas.count {
                        let empresa = usuariosYEmpresas.empresas[index]
                        paresUsuarioEmpresa.append(UsuarioEmpresa(usuario: usuario, empresa: empresa))
                    }
                }
                self.usuariosEmpresas = paresUsuarioEmpresa
            }
        }
    }
}
