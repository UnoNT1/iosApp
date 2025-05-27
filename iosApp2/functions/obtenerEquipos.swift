//
//  obtenerEquipos.swift
//  iosApp2
//
//  Created by federico on 27/05/2025.
//

import Foundation


struct Equipos: Codable, Identifiable {
    // Para Identifiable. Usamos zzUnico si está disponible, si no, generamos un UUID.
    // Asumimos que zzUnico es único para cada registro.
    let id: UUID = UUID()

    // Todas las propiedades son String? porque la API a veces puede omitir campos
    // o devolverlos como nulos, como vimos en tu caso anterior.
    var zzNombre: String?
    var zzTitular: String?
    var zzDir: String?
    var zzTipo: String?
    var zzUnico: String? // Esta es la clave que podrías usar como ID si es única
    var zzNro: String?
    var zzCta: String?
    var zzEop: String?
    var zzLon: String? // Longitud
    var zzLat: String? // Latitud

    // No necesitamos un `CodingKeys` si los nombres de las propiedades en Swift
    // son exactamente los mismos que las claves en tu JSON (incluyendo mayúsculas/minúsculas).
}
