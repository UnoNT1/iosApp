//
//  ContentView.swift
//  iosApp2
//
//  Created by federico on 20/02/2025.
//

import SwiftUI

struct LoginView: View {
    // variables de estado para el nombre de usuario y la contraseña
    @State public var username: String = "dato"
    @State public var password: String = "200492"
    
    // Variable de estado para controlar la navegación
    @State private var isLoggedIn: Bool = false
    
    @State private var isShowingConfig: Bool = false
    
    @EnvironmentObject var configData: ConfigData
    
    // Variables de estado para mostrar alertas
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var mostrarWelcomeVendedor = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("aa").resizable().scaledToFill().edgesIgnoringSafeArea(.all)
                VStack{
                    Image("bola3d").resizable().scaledToFit().frame(width: 100, height: 100)
                    Text("Dato 6.0").font(.title2).padding(.bottom,30)
                    // campo de texto para el nombre de usuario
                    Text("Usuario")
                    TextField("Nombre de usuario", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 300, alignment: .leading)
                    
                    // campo de texto para la contrasena
                    Text("contrasena")
                    SecureField("Contraseña", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 300, alignment: .leading)
                    // Botón para verificar las credenciales
                    Button(action: {
                        verifyCredentials()
                    }) {
                        Image("ingresar1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    }
                    
                    Button(action:{isShowingConfig = true}, label: {
                        Image("cfg_48").resizable().scaledToFit().frame(width: 48, height: 48)
                    })
                    
                }.padding()
            }
            //navega hacia la vista config
            .fullScreenCover(isPresented: $isShowingConfig) {
                ConfigView()
            }
            
            // Navegacion a la pantalla Vendedor
            .fullScreenCover(isPresented: $mostrarWelcomeVendedor) {
                WelcomeVendedorView()
                    .interactiveDismissDisabled(true)
            }
            
            // Navegación a la pantalla de bienvenida OS
            .fullScreenCover(isPresented: $isLoggedIn){
                WelcomeView(username: username, password: password)
                    .interactiveDismissDisabled(true)
            }
            
            
        }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    
    // Función para verificar las credenciales con la API
    func verifyCredentials() {
        // Validar que se hayan ingresado datos
        if username.isEmpty || password.isEmpty {
            alertMessage = "Por favor, ingresa un nombre de usuario y una contraseña."
            showAlert = true
            return
        }
        
        // URL de la API con los parámetros de usuario y contraseña
        let urlString = "\(urlApi)login.php?username=\(username)&password=\(password)"
        
        // Verificar que la URL sea válida
        guard let url = URL(string: urlString) else {
            alertMessage = "URL inválida."
            showAlert = true
            return
        }
        
        // Crear una solicitud HTTP
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error de la UrlSession: \(error)")
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                   print("Código de respuesta HTTP: \(httpResponse.statusCode)")
               }
            guard let data = data else {
                DispatchQueue.main.async {
                    alertMessage = "No se recibieron datos."
                    showAlert = true
                }
                return
            }
            
            // Decodificar la respuesta JSON
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let _ = json["usuario"] as? String {
                        // Credenciales correctas: activar la navegación
                        DispatchQueue.main.async {
                            if configData.menuValue == "OS"{
                            isLoggedIn = true
                            }else{
                                mostrarWelcomeVendedor = true
                            }
                        }
                    } else if let message = json["message"] as? String {
                        DispatchQueue.main.async {
                            alertMessage = message
                            showAlert = true
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    alertMessage = "Error al decodificar JSON."
                    showAlert = true
                }
            }
        }
        
        task.resume()
    }
}

