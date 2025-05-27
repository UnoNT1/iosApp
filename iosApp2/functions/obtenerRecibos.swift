//
//  obtenerRecibos.swift
//  iosApp2
//
//  Created by federico on 07/03/2025.
//

import Foundation

struct Recibos: Identifiable ,Codable{
    let id: UUID? = UUID()
    let nro_re00: Int?
    var cta_re00: Int?
    var tit_re00 : String?
    var fec_re00 : String?
    var apl_re00: Int?
    var tel_re00: String?
    var url_re00: String?
}


func obtenerRecibos(desdeFecha: String, hastaFecha: String, completion: @escaping ([Recibos]?, Error?) -> Void) {
    let urlString = "\(urlApi)recibos.php?username=dato&password=200492&desde=\(desdeFecha)&hasta=\(hastaFecha)"
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
                let resultados = try JSONDecoder().decode([Recibos].self, from: data)
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
