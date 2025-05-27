//
//  convertirHora.swift
//  iosApp2
//
//  Created by federico on 08/04/2025.
//

import Foundation

func convertirHora(segundos: String?) -> String {
    guard let segundosString = segundos, let segundosInt = Int(segundosString) else {
        return "No disponible"
    }

    let horas = segundosInt / 3600
    let minutos = (segundosInt % 3600) / 60

    return String(format: "%02d:%02d", horas, minutos)
}
