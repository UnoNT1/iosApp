//
//  AltaReciboView.swift
//  iosApp2
//
//  Created by federico on 07/03/2025.
//

import SwiftUI

//vista para dar alta recibos
struct AltaReciboView: View {
    @EnvironmentObject var configData: ConfigData
    
    @State private var datosUsuario = DatosUsuario()//variable que contiene los datos del equipo que selecciono el usuario
    @Binding var importe: Int // Recibe el valor del importe como Binding
    @Binding var detalleSeleccionado: String //recibe el detalle que el usuario selecciono
    @Binding var operacionSeleccionada: String
    // Genera un número entero aleatorio dentro del rango
    @State var numeroRandom = generarNumeroAleatorio()
    @Binding var fechRe: String
    @Binding var nroComprobante: String
    @State private var selectedUser: String?
    @State private var isShowingUserSelection = false
    @State private var imputado: Int = 0//campo imputar
    @State private var total: Int = 0 //campo total
    @State private var isShowingImputarView = false
    @State private var detalle: String = "" //campo detalle
    @State private var registros: [(detalle: String, importe: Int)] = []
    @State private var mostrarRegistro = false
    @Environment(\.dismiss) var dismiss // Para volver a la vista anterior
    @State private var showingAlert = false
    @State private var titleAlert: String = ""
    @State private var messageAlert: String = ""
    //para q el usuario pueda cerrar el teclado
    @FocusState private var keyboardBack: Bool
    @State private var clienteSeleccionado: Clientes?
    var body: some View {
        ScrollView{
            VStack {
                HStack{
                    BackButton()
                    Text("Alta Recibo").font(.title).fontWeight(.bold)
                    Spacer()
                }
                .frame(maxWidth: .infinity).background(.blue).foregroundColor(.white)
                HStack{
                    Text("Titular y nro cuenta").font(.footnote).frame(alignment: .leading).padding(.leading)
                    Spacer()
                }
                HStack{
                    if clienteSeleccionado != nil {
                        Text("Usuario seleccionado: \(clienteSeleccionado?.ord_cl00 ?? "")").border(Color.orange)
                    } else {
                        Text("Ningún usuario seleccionado")
                    }
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            isShowingUserSelection = true
                        }
                    Spacer()
                }.padding(.leading).padding(.bottom)
                HStack{
                    Text("Imputado")
                    TextField("Imputado", value: $importe, format: .number).padding().foregroundStyle(.green).border(.green).cornerRadius(10)
                        .keyboardType(.numberPad)
                        .disabled(true)
                    
                    Text("Total $")
                    TextField("Total",value:$total, format: .number)
                        .keyboardType(.numberPad).padding().foregroundStyle(.orange).border(.orange).cornerRadius(10)
                        .disabled(true) //Deshabilita la edicion del campo
                }.padding(.horizontal)
                HStack{
                    Button(action: {
                        if clienteSeleccionado != nil{
                            isShowingImputarView = true
                        }else{
                            titleAlert = "Error"
                            messageAlert = "Selecciona el usuario"
                            showingAlert = true
                        }
                    }){
                        Text("IMPUTAR").padding()
                    }.border(Color.gray, width: 2).cornerRadius(10)
                    Spacer()
                    Button(action: {
                        if clienteSeleccionado != nil && total != 0{
                            enviarDatosRecibo(
                                titular: clienteSeleccionado?.ord_cl00 ?? "",
                                operacion: String(numeroRandom),
                                cuenta: clienteSeleccionado?.cta_cl00 ?? "",
                                usuario: configData.usuarioConfig,
                                total: String(total),
                                empresa: configData.empresaConfig,
                                imputado: String(total),
                                sucursal: datosUsuario.sucursal,
                                celular: clienteSeleccionado?.tel_cl00 ?? ""
                            )
                            numeroRandom = generarNumeroAleatorio()
                            titleAlert = "Exito"
                            messageAlert = "Recibo Cargado Correctamente"
                            showingAlert = true
                        }else{
                            titleAlert = "Error"
                            messageAlert = "Selecciona el usuario y el importe"
                            showingAlert = true
                        }
                    }){
                        Text("GRABAR").padding()
                    }.border(Color.orange, width: 2).cornerRadius(10)
                }.padding(.horizontal)
                Text("Detalle").frame(alignment: .leading).font(.footnote)
                TextEditor(text: $detalle)
                    .frame(height: 70)
                    .border(Color.blue, width: 2)
                    .foregroundColor(.black)
                    .background(Color.green)
                    .cornerRadius(10)
                    .focused($keyboardBack)
                    .padding()
                HStack{
                    Text("Importe")//total a pagar
                    TextField("Importe", value: $total, format: .number).padding().border(.black,width: 2).cornerRadius(10)
                        .keyboardType(.numberPad) // Muestra teclado numérico
                    Spacer()
                    //boton + que cuando lo presiones muestra los valores ingresados por el usuario
                    Button(action: {
                        registros.append((detalleSeleccionado, importe))
                        mostrarRegistro = true
                        
                        // Actualiza el total
                        if  importe != 0 {
                            total += importe
                        }
                        if detalleSeleccionado != ""{
                            detalle = detalleSeleccionado
                        }
                        fechRe = fechRe
                        nroComprobante = nroComprobante
                        enviarDatosComprobante(operacion: String(numeroRandom),
                                               detalle: detalle,
                                               total:String(importe),
                                               pago:"Efectivo",
                                               fec_re90: fechRe,
                                               nro_re90: nroComprobante,
                                               emp_re90: configData.empresaConfig)
                        { result in
                            print(result)
                        }
                        
                        // Limpia los campos después de agregar el registro (opcional)
                        detalleSeleccionado = ""
                        detalle = ""
                        importe = 0
                    }) {
                        Text("+").font(.title)
                    }
                }.padding()
                Spacer()
                
                
                if mostrarRegistro {
                    VStack(alignment: .leading) { // Alinea los elementos a la izquierda
                        Text("Registros:")
                            .font(.headline)
                        
                        ForEach(registros.indices, id: \.self) { index in
                            let registro = registros[index]
                            Text("Detalle: \(registro.detalle)")
                            Text("Importe: \(registro.importe)")
                            Divider() // Separador entre registros
                        }
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                keyboardBack = false
            }
            
            //muestra la vista de seleccion de usuario
            /*  .sheet(isPresented: $isShowingUserSelection) {
             SeleccionUsuarioView(datosUsuario: $datosUsuario, selectedUser: $selectedUser )
             }*/
            .sheet(isPresented: $isShowingUserSelection){
                SelectorClienteView(onClienteSeleccionado: { cliente in
                    clienteSeleccionado = cliente
                    isShowingUserSelection = false
                })
            }
                .sheet(isPresented: $isShowingImputarView) {
                    ComprobantesImputadosView(importe: $importe, detalleSeleccionado: $detalleSeleccionado, operacionSeleccionada: $operacionSeleccionada, fechaRe: $fechRe, nroComprobante: $nroComprobante) // Pasa el Binding de importe
                }
                .alert(isPresented: $showingAlert){
                    Alert(title: Text(titleAlert), message: Text(messageAlert), dismissButton: .default(Text("OK")) {
                        if titleAlert == "Exito"{
                            dismiss()
                        }else{}
                    })
                }
            }.frame(maxWidth: .infinity)
                .background(Image("fondoc0").resizable().scaledToFill().edgesIgnoringSafeArea(.all))
        }
        
    }
