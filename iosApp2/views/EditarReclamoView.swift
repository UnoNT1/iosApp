//
//  EditarReclamoView.swift
//  iosApp2
//
//  Created by federico on 09/04/2025.
//

import Foundation
import SwiftUI

struct DetalleReclamo: Codable{
    var nom_cl12: String?
    var usu_cl12: String?
    var tre_cl12: String?
    var nre_cl12: String?
    var c01_cl12: String?
    var tit_cl12: String?
    var dom_cl12: String?
    var vto_cl12: String?
    var pen_cl12: String?
    var mot_cl12: String?
    
}


struct EditarReclamoView: View {
    let reclamo: Reclamos
    @State var detalles: DetalleReclamo?

    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("\(detalles?.nom_cl12 ?? "") \(detalles?.usu_cl12 ?? "")")
                Text("\(detalles?.tre_cl12 ?? "")").padding().foregroundStyle(Color.red).cornerRadius(10)
            }.padding(.bottom)
            HStack{
                Text("Persona").foregroundStyle(Color.blue)
                VStack{ Text(detalles?.nre_cl12 ?? "")
                    Rectangle()
                        .frame(height: 1) // Altura del subrayado
                        .foregroundColor(.black) // Color del subrayado
                        .frame(maxWidth: .infinity) // Ancho máximo
                }
            }.padding(.bottom)
            HStack{
                Text("Equipo").foregroundStyle(Color.blue)
                
                VStack{
                    Text("\(detalles?.c01_cl12 ?? "")")
                    Rectangle()
                        .frame(height: 1) // Altura del subrayado
                        .foregroundColor(.black) // Color del subrayado
                        .frame(maxWidth: .infinity) // Ancho máximo
                }
            }.padding(.bottom)
            HStack{
                Text("Titular").foregroundStyle(Color.blue)
                VStack{
                    Text("\(detalles?.tit_cl12 ?? "")")
                    Rectangle()
                        .frame(height: 1) // Altura del subrayado
                        .foregroundColor(.black) // Color del subrayado
                        .frame(maxWidth: .infinity) // Ancho máximo
                }
            }.padding(.bottom)
            HStack{
                Text("Domicilio").foregroundStyle(Color.blue)
                VStack{
                    Text("\(detalles?.dom_cl12 ?? "")")
                    Rectangle()
                        .frame(height: 1) // Altura del subrayado
                        .foregroundColor(.black) // Color del subrayado
                        .frame(maxWidth: .infinity) // Ancho máximo
                }
            }.padding(.bottom)
            HStack{
                Text("\(detalles?.pen_cl12 ?? "")").foregroundStyle(Color.blue)
                Spacer()
                Text("Hora \(reclamo.pFecha ?? "")").padding().border(Color.black, width: 2).cornerRadius(10)
            }
            Text("Motivo").foregroundStyle(Color.blue)
            Text("\(detalles?.mot_cl12 ?? "")").font(.title3).padding().border(Color.red, width: 2)
            Spacer()
        }
        .onAppear(){
            detalleReclamo(nroReclamo: reclamo.pRegistro ?? "0"){ detallesArray, error in
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

func detalleReclamo(nroReclamo: String, completion: @escaping ([DetalleReclamo]?, Error?) -> Void) {
    let urlString = "\(urlApi)editarReclamo.php?nro_reclamo=\(nroReclamo)"
    
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
                let resultados = try JSONDecoder().decode([DetalleReclamo].self, from: data)
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
