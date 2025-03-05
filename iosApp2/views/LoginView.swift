//
//  ContentView.swift
//  iosApp2
//
//  Created by federico on 20/02/2025.
//

import SwiftUI

struct LoginView: View {
    // variables de estado para el nombre de usuario y la contraseña
    @State public var username: String = ""
    @State public var password: String = ""
    
    // Variable de estado para controlar la navegación
    @State private var isLoggedIn: Bool = false
    
    // Variables de estado para mostrar alertas
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // campo de texto para el nombre de usuario
                TextField("Nombre de usuario", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // campo de texto para la contrasena
                SecureField("Contraseña", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Botón para verificar las credenciales
                Button(action: {
                    verifyCredentials()
                }) {
                    Text("Iniciar Sesion")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Navegación a la pantalla de bienvenida
                NavigationLink(destination: WelcomeView(username: username, password: password), isActive: $isLoggedIn) {
                    EmptyView() // El NavigationLink no muestra contenido visible
                }
            }
            .padding()
            .navigationTitle("Dato")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
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
                            isLoggedIn = true
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

