//
//  EditarReclamoView.swift
//  iosApp2
//
//  Created by federico on 09/04/2025.
//

import Foundation
import SwiftUI

struct DetalleReclamo: Codable, Identifiable {
    // Para Identifiable. Usaremos pReg como ID si es único.
    var id: String { pReg ?? UUID().uuidString }

    // Todas las propiedades como String? por si la API las devuelve nulas o ausentes
    let pTit: String?
    let pFec: String?
    let pEst: String?
    let pCon: String?
    let pOper: String?
    let pCta: String?
    let pMot: String?
    let pUno: String?
    let pReg: String? // Este campo parece un buen candidato para 'id'
    let pUsu: String?
    let pR00: String?
    let pUrl: String?
    let pTel: String?
    let pCel: String?
    let pPer: String?
    let pHor: String?
    let pDir: String?
    let pTec: String?

    // Si los nombres de las propiedades coinciden exactamente con las claves JSON,
    // no necesitas un CodingKeys.
}


struct EditarReclamoView: View {
    let reclamo: Reclamos
    @State var detalles: DetalleReclamo?

    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("\(detalles?.pUsu ?? "")")
                  Text("\(detalles?.pCel ?? "")").padding().foregroundStyle(Color.red).cornerRadius(10)
            }.padding(.bottom)
            HStack{
                Text("Persona").foregroundStyle(Color.blue)
                VStack{ Text(detalles?.pPer ?? "")
                    Rectangle()
                        .frame(height: 1) // Altura del subrayado
                        .foregroundColor(.black) // Color del subrayado
                        .frame(maxWidth: .infinity) // Ancho máximo
                }
            }.padding(.bottom)
            HStack{
                Text("Equipo").foregroundStyle(Color.blue)
                
                VStack{
                    Text("\(detalles?.pUno ?? "")")
                    Rectangle()
                        .frame(height: 1) // Altura del subrayado
                        .foregroundColor(.black) // Color del subrayado
                        .frame(maxWidth: .infinity) // Ancho máximo
                }
            }.padding(.bottom)
            HStack{
                Text("Titular").foregroundStyle(Color.blue)
                VStack{
                    Text("\(detalles?.pTit ?? "")")
                    Rectangle()
                        .frame(height: 1) // Altura del subrayado
                        .foregroundColor(.black) // Color del subrayado
                        .frame(maxWidth: .infinity) // Ancho máximo
                }
            }.padding(.bottom)
            HStack{
                Text("Domicilio").foregroundStyle(Color.blue)
                VStack{
                    Text("\(detalles?.pDir ?? "")")
                    Rectangle()
                        .frame(height: 1) // Altura del subrayado
                        .foregroundColor(.black) // Color del subrayado
                        .frame(maxWidth: .infinity) // Ancho máximo
                }
            }.padding(.bottom)
            HStack{
                Text("\(detalles?.pEst ?? "")").foregroundStyle(Color.blue)
                Spacer()
                Text("Hora \(detalles?.pFec ?? "")").padding().border(Color.black, width: 2).cornerRadius(10)
            }
            Text("Motivo").foregroundStyle(Color.blue)
            Text("\(detalles?.pMot ?? "")").font(.title3).padding().border(Color.red, width: 2)
            Spacer()
        }
        .onAppear(){
            detalleReclamo(registro: reclamo.pHora ?? "0"){ detallesArray, error in
                if let detallesArray = detallesArray, let detalle = detallesArray.first {
                    self.detalles = detalle // Asignar el primer elemento del array
                } else if let error = error {
                    print("Error al cargar detalles: \(error)")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .navigationTitle("At.reclamo \(reclamo.pRegistro ?? "")")
    }
}

//funcion para visualizar los detalles del reclamos


func detalleReclamo(registro: String, completion: @escaping ([DetalleReclamo]?, Error?) -> Void) {
    let urlString = "https://www.unont.com.ar/yavoy/sistemas/dato5/android/regos.php" // Asumo esta es la URL base
    guard let url = URL(string: urlString) else {
        DispatchQueue.main.async {
            completion(nil, NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida."]))
        }
        print("Error: URL inválida para regos.php")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST" // Especificamos el método POST
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Tipo de contenido para parámetros POST

    // Codifica el parámetro 'registro' para la solicitud POST
    let postString = "registro=\(registro.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    request.httpBody = postString.data(using: .utf8)

    print("Solicitando URL (POST) para registros: \(url.absoluteString) con body: \(postString)") // Para depuración

    URLSession.shared.dataTask(with: request) { data, response, error in
        DispatchQueue.main.async { // Aseguramos que el completion se ejecute en el hilo principal
            if let error = error {
                print("Error de red al obtener registros: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                print("No se recibieron datos de la API para registros.")
                completion(nil, NSError(domain: "NoDataError", code: 204, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos de la API para registros."]))
                return
            }

            // Opcional: Imprimir el JSON crudo para depuración. ¡Muy útil!
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON crudo recibido para registros:\n\(jsonString)")
            } else {
                print("No se pudo convertir los datos a una cadena de texto (JSON crudo de registros).")
            }

            do {
                let registros = try JSONDecoder().decode([DetalleReclamo].self, from: data)
                print("Decodificación exitosa. Se encontraron \(registros.count) registros.")
                completion(registros, nil)
            } catch let decodingError as DecodingError {
                print("🚫 Error de decodificación al obtener registros:")
                // Manejo detallado de errores de decodificación
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("  Tipo no coincide: \(type) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("  Valor no encontrado: \(type) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("  Clave no encontrada: \(key.stringValue) en \(context.codingPath.map { $0.stringValue }.joined(separator: ".")) – \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("  Datos corruptos: \(context.debugDescription)")
                @unknown default:
                    print("  Error de decodificación desconocido: \(decodingError.localizedDescription)")
                }
                completion(nil, decodingError)
            } catch {
                print("Error general al decodificar registros: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }.resume()
}
