//
//  VerOsView.swift
//  iosApp2
//
//  Created by federico on 29/04/2025.
//

//vista para ver la Orden de servicio mas detallada con sus respectivas tareas y/o motivos que lo sacamos de tmpOsView
import Foundation
import SwiftUI

struct VerOsView: View {
    @Binding var numeroOS: String?
    @State private var verOs: VerOs?
    @State private var error: Error?
    @EnvironmentObject var configData: ConfigData
    @Environment(\.dismiss) var dismiss
    // Closure para notificar a la vista anterior que se borró la OS
        var onOSBorrada: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                BackButton()
                Text("OS_\(numeroOS ?? "N/A")")
                    .font(.title2).padding()
                Spacer()
            }.frame(maxWidth: .infinity).background(.blue).foregroundStyle(.white)
            if let detalle = verOs {
                VStack{
                    HStack{
                        Text("Títular: \(detalle.pTit ?? "")").padding().border(Color.orange).cornerRadius(8)
                        Text("Cuenta: \(detalle.pCta ?? "N/A")").padding().border(Color.orange).cornerRadius(8)
                    }
                    HStack{
                        Text("Tipo \(detalle.pSer ?? "N/A")").padding().background(Color.white)
                        Text("Estado: \(detalle.pEst ?? "N/A")").padding()
                    }
                    HStack{
                        Text("Motivo \(detalle.pNen ?? "")")
                        Text("\(detalle.pFec ?? "")").padding(1).background(Color.white).cornerRadius(9).foregroundStyle(.blue)
                        Spacer()
                    }
                    
                    //motivo
                    VStack(alignment: .leading){
                        TmpOsView(nroOS: $numeroOS)
                        /*
                         HStack{
                         Text("Equipo").padding(1)
                         Text("\(detalle.pUno ?? "")").foregroundStyle(Color.yellow).padding(1).frame(maxWidth: .infinity).border(Color.gray).cornerRadius(8)
                         }
                         Text("\(detalle.pUsu ?? "")").frame(maxWidth: .infinity).padding(1).background(.white).foregroundColor(.black).cornerRadius(8)
                         Text("\(detalle.pObs ?? "")").padding(1)*/
                         }.frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity).padding()
                } else if let error = error {
                    Text("Error al cargar los detalles: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    Text("Cargando detalles...")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                //botones
                HStack{
                    Button(action:{
                        
                    }){
                        Image(systemName:"record.circle.fill").resizable().scaledToFill().frame(width: 50, height: 30)
                        Text("Grabar")
                    }.padding()
                    
                    Button(action:{
                        borrarOS(nroOS: numeroOS ?? "", empresa: configData.empresaConfig, usuario: configData.usuarioConfig) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    print("Orden de servicio \(numeroOS) borrada exitosamente.")
                                    onOSBorrada?() // Llama al closure para recargar la lista en la vista anterior
                                    dismiss() // Regresa a la vista OrdenesServicioView
                                case .failure(let error):
                                    print("Error al borrar la orden de servicio \(numeroOS): \(error)")
                                    // Muestra un mensaje de error al usuario
                                }
                            }
                        }
                    }){
                        Image(systemName: "trash").resizable().scaledToFill().frame(width: 50,height: 30).foregroundStyle(.blue)
                        Text("Borrar")
                    }.padding()
                }.frame(maxWidth: .infinity).padding()
                
            }
                .frame(maxWidth: .infinity)
                .background(Image("fondoc0").resizable().scaledToFill().edgesIgnoringSafeArea(.all))
                .onAppear {
                    cargarDetallesOS()
                }
        }
        
        func cargarDetallesOS() {
            print("Cargando detalles para la OS número (en VerOsView): \(numeroOS ?? "nulo")")
            obtenerDetallesVerOs(registro: numeroOS ?? "N/A", empresa: configData.empresaConfig) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detalles):
                        verOs = detalles.first // Tomamos el primer (y probablemente único) resultado
                    case .failure(let err):
                        error = err
                        print("Error al obtener detalles de la OS \(numeroOS): \(err.localizedDescription)")
                    }
                }
            }
        }
    }
