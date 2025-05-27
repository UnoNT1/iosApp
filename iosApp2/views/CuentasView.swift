//
//  CuentasView.swift
//  iosApp2
//
//  Created by federico on 13/03/2025.
//

import SwiftUI

struct CuentasView:View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        BackButton()
        Text("Vista de cuentas")
    }
}
