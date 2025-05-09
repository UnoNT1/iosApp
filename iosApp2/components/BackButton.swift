//
//  BackButton.swift
//  iosApp2
//
//  Created by federico on 28/03/2025.
//

import Foundation
import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action:{
           dismiss()
        }){
            Image("atras_64")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
        }.padding()
    }
}
