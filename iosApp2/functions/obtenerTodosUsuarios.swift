//
//  obtenerTodosUsuarios.swift
//  iosApp2
//
//  Created by federico on 24/02/2025.
//

import Foundation

struct RespuestaUsuarios: Codable {
    let usuarios: [String]
    let empresas: [String]
}

struct UsuariosYEmpresas {
    let usuarios: [String]
    let empresas: [String]
}

func obtenerTodosUsuarios(username: String, password: String, completion: @escaping (UsuariosYEmpresas?, Error?) -> Void) {
    let urlString = "\(urlApi)usuarios.php?username=\(username)&password=\(password)"

    guard let url = URL(string: urlString) else {
        print("Error en la URL")
        return
    }

    DispatchQueue.global().async {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "Error de datos", code: 1, userInfo: nil))
                }
                return
            }

            do {
                let respuesta = try JSONDecoder().decode(RespuestaUsuarios.self, from: data)
                DispatchQueue.main.async {
                    let usuariosYEmpresas = UsuariosYEmpresas(usuarios: respuesta.usuarios, empresas: respuesta.empresas)
                    completion(usuariosYEmpresas, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}

