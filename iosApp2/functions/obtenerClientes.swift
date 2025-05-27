//
//  obtenerClientes.swift
//  iosApp2
//
//  Created by federico on 26/03/2025.
//

import Foundation

struct Clientes:Identifiable, Codable, Equatable{
    let id: UUID = UUID()
    var cta_cl00: String
    var con_cl00: String
    var ord_cl00: String
    var dir_cl00: String
    var tel_cl00: String
    var net_cl00: String
    var iva_cl00: String
    var hor_cl00: String
    var civ_cl00: String
    
}

func obtenerClientes(empresa:String, completion: @escaping ([Clientes]?, Error?) -> Void) {
    let urlString = "\(urlApi)clientes.php?empresa=\(empresa)"
    
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
            
            guard let data = data else { // Desempaqueta 'data' de forma segura
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "Datos no encontrados", code: -1, userInfo: nil))
                }
                return
            }
            
            do {
                let resultados = try JSONDecoder().decode([Clientes].self, from: data)
                DispatchQueue.main.async {
                    completion(resultados, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
