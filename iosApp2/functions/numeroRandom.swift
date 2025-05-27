//
//  numeroRandom.swift
//  iosApp2
//
//  Created by federico on 19/03/2025.
//

import Foundation


func generarNumeroAleatorio()->Int {
       let rango8Digitos = 10000000...99999999
       var numeroRandomGenerado = Int.random(in: rango8Digitos)
    return numeroRandomGenerado
   }
