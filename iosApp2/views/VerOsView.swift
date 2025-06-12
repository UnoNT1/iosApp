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
    // Nuevo estado para controlar la visibilidad del SelectorClienteView
    @State private var showingClientSelector = false
    //Nuevo estado para guardar el cliente seleccionado
    @State private var selectedClient: Clientes? // Asegúrate de que 'Cliente' esté definido
    // *** ¡Nueva variable de estado para el texto del titular que se muestra en la UI! ***
    @State private var uiTitularText: String = "Sin titular"
    // --- ¡Nuevas variables de estado para el selector de estado! ---
    @State private var showingEstadoSelector = false // Para controlar la visibilidad del modal de estado
    @State private var uiEstado: String = ""
    @State private var uiObservacion: String = ""
    @State private var nombreEquipoSeleccionado: String = "Seleccionar equipo" // El nombre del equipo actualmente seleccionado
    @State private var isShowingEquipoSelector = false
    @State private var titularParaFiltroEquipos: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                BackButton()
                Text("OS_\(numeroOS ?? "N/A")")
                    .font(.title2).padding()
                Spacer()
                Button(action:{
                    isShowingEquipoSelector = true
                }){
                    Image("e").resizable().scaledToFill().frame(width: 30, height: 30)
                }.padding(.horizontal)
                
            }.frame(maxWidth: .infinity).background(.blue).foregroundStyle(.white)
            if let detalle = verOs {
                VStack{
                    HStack{
                        Text("Títular:\(uiTitularText) ").padding().border(Color.orange).cornerRadius(8)
                        Text("Cuenta: \(detalle.pCta ?? "N/A")").padding().border(Color.orange).cornerRadius(8)
                        Button(action:{
                            showingClientSelector = true
                        }){
                            Image(systemName: "person").resizable().scaledToFill().frame(width: 25, height: 25)
                        }
                    }
                    HStack{
                        VStack(alignment: .leading){
                            Text("Responsable")
                            Text("\(detalle.pUsu ?? "")").frame(maxWidth: .infinity).background(Color.green)
                        }.padding(.horizontal)
                        VStack(alignment: .leading){
                            Text("Equipo")
                            Text("\(nombreEquipoSeleccionado ?? "")").frame(maxWidth: .infinity).background(Color.green)
                        }.padding(.horizontal)
                    }
                    HStack{
                        Text("Tipo \(detalle.pSer ?? "N/A")").padding().background(Color.white)
                        
                        Button(action: {
                            showingEstadoSelector = true
                        }){
                            HStack{
                                Text("Estado: \(uiEstado)").padding().background(Color.white)
                                Image(systemName: "chevron.down")
                            }.foregroundStyle(Color.black)
                        }
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
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Observacion")
                        TextField("", text: $uiObservacion).frame(maxWidth: .infinity).padding(.vertical).background(Color.green)
                        
                    }
                    
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
                }.padding(3)
                
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
                }.padding(3)
            }.frame(maxWidth: .infinity).padding()
            
        }.navigationBarHidden(true)
        .frame(maxWidth: .infinity)
        .background(Image("fondoc0").resizable().scaledToFill().edgesIgnoringSafeArea(.all))
        //Selector equipos
        .fullScreenCover(isPresented: $isShowingEquipoSelector) {
            SelectorEquipoView(filtroInicial: $uiTitularText) { selectedEquipo in
                self.nombreEquipoSeleccionado = selectedEquipo.zzUnico ?? "Seleccionar equipo"
            }
        }
            
            
            .onAppear {
                cargarDetallesOS{loadedOs in // Necesitamos un completion para cargarDetallesOS
                    self.verOs = loadedOs
                    self.uiTitularText = loadedOs?.pTit ?? "Sin Titular" // Inicializa la variable de UI
                    self.uiEstado = loadedOs?.pEst ?? "No disp"
                    self.uiObservacion = loadedOs?.pObs ?? ""
                    self.nombreEquipoSeleccionado = loadedOs?.pUno ?? "Sin equipos"
                }
            }
            .sheet(isPresented: $showingClientSelector){
                SelectorClienteView (onClienteSeleccionado: { cliente in
                    self.uiTitularText = cliente.ord_cl00
                    self.showingClientSelector = false
                })
            }
            .sheet(isPresented: $showingEstadoSelector) {
                SelectorEstadoView(onEstadoSeleccionado: { estado in
                    // Actualiza la variable de UI con el texto amigable del estado
                    self.uiEstado = estado.displayText
                    // Si necesitas el rawValue para enviar a la API, puedes guardar:
                    // self.selectedEstadoRawValue = estado.rawValue
                    self.showingEstadoSelector = false // Cierra la hoja modal
                })
            }
            // --------------------------------------------
        }
        
        func cargarDetallesOS(completion: @escaping (VerOs?) -> Void) {
            print("Cargando detalles para la OS número (en VerOsView): \(numeroOS ?? "nulo")")
            obtenerDetallesVerOs(registro: numeroOS ?? "N/A", empresa: configData.empresaConfig) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let detalles):
                        self.verOs = detalles.first // Asignamos el primer detalle a verOs
                        // --- ¡Aquí está el cambio clave! ---
                        // Una vez que verOs tiene datos, inicializa uiTitularText
                        if let loadedOs = self.verOs {
                            self.uiTitularText = loadedOs.pTit ?? "Sin Titular"
                            self.uiEstado = loadedOs.pEst ?? ""
                        } else {
                            self.uiTitularText = "Titular no disponible" // En caso de que detalles.first sea nil
                            self.uiEstado = "No disp."
                        }
                        // --- Fin del cambio ---
                        completion(self.verOs) // Pasamos el VerOs cargado al completion handler
                    case .failure(let err):
                        self.error = err
                        print("Error al obtener detalles de la OS \(numeroOS): \(err.localizedDescription)")
                        completion(nil) // En caso de error, pasamos nil al completion handler
                    }
                }
            }
        }
    }
