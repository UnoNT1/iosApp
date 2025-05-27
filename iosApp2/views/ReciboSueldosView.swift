//
//  ReciboSueldosView.swift
//  iosApp2
//
//  Created by federico on 07/03/2025.
//

import SwiftUI

struct ReciboSueldosView: View {
    @State private var importeComprobante:Int = 0
    @State private var detalleComprobante: String = ""
    @State private var operacionComprobante: String = ""
    @State private var fechaSeleccionada : String = ""
    @State private var nroComprSeleccionado: String = ""
    @State public var recibos: [Recibos] = []
    @State private var isLoading = true
    @State private var error: Error?
    @Environment(\.dismiss) var dismiss
    @State private var isShowingAltaRecibo = false
    @EnvironmentObject var fechasConsultas : FechasConsultas
    @State private var isShowingAgenda = false
    @State var nombreModulo: String = "Recibos"
    
    var body: some View {
            VStack {
                HStack {
                    BackButton()
                    Spacer()
                    Text("Recibos").font(.title).padding()
                    Spacer()
                    Button(action: {
                        isShowingAgenda = true
                    }){
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Button(action:{
                        isShowingAltaRecibo = true
                    }){
                        Image("nuevo_64")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }.padding()
                }
                
                //if para ver si hay errores
                if isLoading {
                    ProgressView("Cargando recibos...")
                } else if let error = error {
                    Text("Error al cargar los recibos: \(error.localizedDescription)")
                        .foregroundColor(.red)
                }else {
                    List(recibos) { recibo in
                        VStack(alignment: .leading) {
                            HStack{
                                if let numero = recibo.nro_re00 {
                                    Text("N: \(String(numero))").foregroundStyle(.blue)
                                } else {
                                    Text("N: No disponible")
                                }
                                Spacer()
                                if let monto = recibo.apl_re00 {
                                    Text("$\(String(monto))").foregroundStyle(.red)
                                } else {
                                    Text("No disponible")
                                }
                            }
                            Text(recibo.tit_re00 ?? "Título no disponible")
                                .font(.headline)
                            if let fecha = recibo.fec_re00 {
                                Text("Fecha: \(fecha)")
                            } else {
                                Text("Fecha: No disponible")
                            }
                            
                            Text("Teléfono: \(recibo.tel_re00 ?? "Teléfono no disponible")")
                            
                            if let urlString = recibo.url_re00, let url = URL(string: urlString) {
                                Link("Ver Recibo", destination: url)
                            } else {
                                Text("Recibo: No disponible")
                            }
                        }
                    }
                    
                }
            }.frame(maxWidth: .infinity).background(Image("fondoc0").resizable().scaledToFill().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .sheet(isPresented: $isShowingAltaRecibo){
                    AltaReciboView(importe:$importeComprobante , detalleSeleccionado: $detalleComprobante, operacionSeleccionada: $operacionComprobante, fechRe: $fechaSeleccionada, nroComprobante: $nroComprSeleccionado)
                }
        
            .sheet(isPresented: $isShowingAgenda){
                AgendaView(nombreModulo: $nombreModulo)
                
            }//mostrar la vista agenda, que es para elegir fecha
        //esto se ejecuta primero al cargar la vista antes que todo lo demas.
            .onChange(of: fechasConsultas.desdeFechaString){ _ in
                cargarRecibos()
            }
            .onChange(of: fechasConsultas.hastaFechaString){ _ in
                cargarRecibos()
            }
            .onAppear {
               cargarRecibos()
            }
    }
    
    func cargarRecibos(){
        obtenerRecibos(desdeFecha: fechasConsultas.desdeFechaString, hastaFecha:fechasConsultas.hastaFechaString ) { recibos, error in
            DispatchQueue.main.async {
                isLoading = false
                if let recibos = recibos {
                    self.recibos = recibos
                } else if let error = error {
                    print("ERROR DETALALDO: \(error)")
                    self.error = error
                }
            }
        }
    }
        
}
