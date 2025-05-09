//
//  CircularButton.swift
//  iosApp2
//
//  Created by federico on 27/03/2025.
//

import Foundation
import SwiftUI


struct CircularButton: View {
    let word: String
    @State private var isSelected = false
    @Binding var selectedWord: String?

    var body: some View {
        Button(action: {
            isSelected.toggle()
            if isSelected {
                selectedWord = word
            } else {
                selectedWord = nil
            }
        }) {
            HStack {
                Circle()
                    .fill(isSelected ? Color.blue : Color.gray)
                    .frame(width: 25, height: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 2)
                    )
                Text(word) // Mostrar la palabra al lado del botón
                    .font(.caption)
            }
        }
    }
}
