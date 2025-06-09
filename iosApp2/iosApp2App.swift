//
//  iosApp2App.swift
//  iosApp2
//
//  Created by federico on 20/02/2025.
//

import SwiftUI

let urlApi = "http://192.168.1.31/"

@main
 struct iosApp2App: App {
     @StateObject var configData = ConfigData()
     @StateObject var fechasConsultas = FechasConsultas()
     var body: some Scene {
         WindowGroup {
             LoginView()
                 .environmentObject(configData)
             .environmentObject(fechasConsultas)
         }
     }
 }
