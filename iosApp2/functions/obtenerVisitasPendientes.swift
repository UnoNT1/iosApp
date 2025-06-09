//
//  obtenerVisitasPendientes.swift
//  iosApp2
//
//  Created by federico on 05/06/2025.
//

import Foundation


struct VisitasPendientes: Identifiable, Codable, Equatable{
    let id: UUID = UUID()
    var peNombre: String? //nombre si es : reclamo, mantenimiento, etc
    var peUsu: String? //de donde se creo el reclamo, por ej SMS
    var peHora: String?
    var peDir: String?
    var peTitular: String?
    var peMotivo: String?
    var peFecha: String?
    var peNro: String? //nro de reclamo
    var peMonto: String?
    var peOper: String? //nro operacion
    var peEst: String? //estado, 9=pendiente
    var peSeg: String?
    var peCta: String?
    var peNre: String? //nombre de la perosna q creo la orden ej: Marcos congregado,Isaias, etc
    var peTre: String? //telefono
    var peFirma: String?
}



func obtenerVisitasPendientes(nombre: String ,empresa:String,usuario: String ,completion: @escaping ([VisitasPendientes]?, Error?) -> Void) {
    let urlString = "https://www.unont.com.ar/yavoy/sistemas/dato5/android/pendientes.php?nombre=\(nombre)&cuenta=&empresa=\(empresa)&usuario=\(usuario)"
    
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
                let resultados = try JSONDecoder().decode([VisitasPendientes].self, from: data)
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
