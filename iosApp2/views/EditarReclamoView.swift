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
//vista de los reclamos o mantenimiento que estan pendientes y pueden ser tomados por alguien
struct EditarReclamoView: View {
    @State private var error: Error?
    @Environment(\.dismiss) var dismiss
    // 1. Define tu enum para los ítems del menú
    enum OpcionReclamo: String, CaseIterable, Identifiable {
        case tomarReclamo = "Tomar Reclamo"
        case transferirReclamo = "Transferir Reclamo"
        case suspenderReclamo = "Suspender Reclamo"
        
        var id: Self { self } // Conforme a Identifiable
    }
    @State private var opcionSeleccionada: OpcionReclamo = .tomarReclamo //variable q guarda el valor seleccionado del enum
    //enum para seleccionar la demora del reclamos
    enum DemoraReclamo: String, CaseIterable, Identifiable{
        case quince = "15 minutos"
        case mediaHora = "30 minutos"
        case cuarentaYcinco = "45 minutos"
        case unaHora = "1 Hora"
        case masDeUnaHora = "Mas de 1 Hora"
        
        var id: Self { self } // Conforme a Identifiable
    }
    @State private var demoraSeleccionada: DemoraReclamo = .quince
    let reclamo: Reclamos
    @State var detalles: DetalleReclamo?
    // Estado para controlar si la tarea está marcada (true) o no (false)
    @State private var reclamoPendiente: Bool = true
    @State private var isShowingVerOs: Bool = false
    @State private var nroReclamo: String? = ""
    @EnvironmentObject var configData: ConfigData
    
    //state que almacena el tmpOs, que solo necesitamos el numero de operacion de la tarea
    @State var tmpOs: [TmpOS] = []
    @State private var reg00: String = ""
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                HStack{
                    Text("\(detalles?.pUsu ?? "")")
                    Text("\(detalles?.pCel ?? "")").padding(.horizontal).foregroundStyle(Color.red).border(.gray, width: 2).cornerRadius(10)
                }.padding(.bottom, 10)
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
                    Text("Tarea pendiente").foregroundStyle(Color.blue)
                    // 3. El Toggle personalizado
                    Toggle(isOn: $reclamoPendiente) {
                        // El 'label' del Toggle está vacío porque el texto ya lo pusimos al lado.
                        // Podrías poner aquí un Text("") o dejarlo así.
                    }
                    .toggleStyle(.customCheckbox) // <-- ¡Este es el truco para que parezca una casilla!
                    Spacer()
                    Text("Hora")
                    Text("\(detalles?.pFec ?? "") \(detalles?.pHor ?? "")").padding().border(Color.black, width: 2).cornerRadius(10)
                }.onTapGesture {
                    reclamoPendiente.toggle()
                }
                
                Text("Motivo").foregroundStyle(Color.blue)
                Text("\(detalles?.pMot ?? "")").font(.title3).padding(.vertical, 30).padding(.horizontal, 3).border(Color.red, width: 3)
                
                //menu desplegable de trasnferir reclamo, tomarlo, etc
                HStack{
                    Text("Accion")
                    Picker("", selection: $opcionSeleccionada) {
                        ForEach(OpcionReclamo.allCases) { opcion in
                            Text(opcion.rawValue)
                                .tag(opcion) // Asigna el valor del enum como tag
                        }
                    }
                    .pickerStyle(.menu) // Esto lo convierte en un menú desplegable
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)
                }
                HStack{
                    Text("Demora")
                    Picker("", selection: $demoraSeleccionada){
                        ForEach(DemoraReclamo.allCases){ opcion in
                            Text(opcion.rawValue).tag(opcion)
                        }
                    }
                    .pickerStyle(.menu) // Esto lo convierte en un menú desplegable
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)
                    
                }
                HStack{
                    Text("Usuario")
                    Text(configData.usuarioConfig)
                }
                
                Spacer()
                
                HStack(alignment: .center){
                    Button(action:{
                        yaVoy(nroOS: nroReclamo ?? "", est_tarea:"Pendiente" , obs_reclamo: "", usu_tarea: configData.usuarioConfig, dem_reclamo: demoraSeleccionada.rawValue, r00_reclamo:detalles?.pReg ?? "", cta_reclamo: detalles?.pCta ?? "", tit_reclamo: detalles?.pTit ?? "", empresa: configData.empresaConfig){ result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    print("Orden de servicio \(nroReclamo) tomado exitosamente!")
                                    dismiss() // Regresa a la vista anterior
                                case .failure(let error):
                                    print("Error al tomar el reclamo \(nroReclamo): \(error)")
                                    // Muestra un mensaje de error al usuario
                                }
                            }
                        }
                        }){
                        VStack{
                            Image("yavoy").resizable().scaledToFill().frame(width: 40, height: 40)
                            Text("Ya Voy").font(.footnote).foregroundStyle(.orange)
                        }.padding(.vertical, 10).padding(.horizontal, 20).background(.orange.opacity(0.5)).border(.orange, width: 2).cornerRadius(4)
                    }.padding(.horizontal)
                    
                    //boton para editar el reclamo
                    Button(action:{
                        isShowingVerOs = true
                    }){
                        VStack{
                            Image("os_48").resizable().scaledToFill().frame(width: 40, height: 40)
                            Text("Editar").font(.footnote).foregroundStyle(.blue)
                        }.padding(.vertical, 10).padding(.horizontal, 20).background(.blue.opacity(0.5)).border(.orange, width: 2).cornerRadius(4)
                    }.padding(.horizontal)
                }.frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity)
        .fullScreenCover(isPresented: $isShowingVerOs){
            VerOsView(numeroOS: $nroReclamo )
        }
        
        .onAppear(){
            detalleReclamo(registro: reclamo.pHora ?? "0"){ detallesArray, error in
                if let detallesArray = detallesArray, let detalle = detallesArray.first {
                    self.detalles = detalle // Asignar el primer elemento del array
                    self.nroReclamo = detalle.pReg
                } else if let error = error {
                    print("Error al cargar detalles: \(error)")
                }
            }
        }
        //onAPPEAR para cargar el numero de operacion de la tarea
        .onAppear(){
            obtenerDetallesTMPOS(nroOS: nroReclamo ?? "") {  result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("ok")
                    case .failure(let err):
                        error = err
                        print("Error al obtener detalles del reclamo \(nroReclamo): \(err.localizedDescription)")
                    }
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


//casilla para indicar si es tarea pendiente o no
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle() // Toggles the state
        } label: {
            HStack {
                // The label (if any) provided to the Toggle
                // In your case, you're providing an empty label, which is fine.
                configuration.label
                
                // The visual representation of the checkbox
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(configuration.isOn ? .accentColor : .gray)
            }
        }
        // Important: Use .buttonStyle(PlainButtonStyle()) to remove default button styling
        // and allow the image to be the primary visual.
        .buttonStyle(PlainButtonStyle())
    }
}

extension ToggleStyle where Self == CheckboxToggleStyle {
    static var customCheckbox: CheckboxToggleStyle {
        CheckboxToggleStyle()
    }
}
