//
//  ButtonState.swift
//  iosApp2
//
//  Created by federico on 27/05/2025.
//

import Foundation
import SwiftUI

enum ButtonState: Int, CaseIterable {
    case blanco = 0
    case verde = 1
    case orange = 2
    case rojo = 3

    var color: Color {
        switch self {
        case .blanco: return .white
        case .verde: return .green
        case .orange: return .orange
        case .rojo: return .red
        }
    }

    var next: ButtonState {
        let allStates = ButtonState.allCases
        if let currentIndex = allStates.firstIndex(of: self) {
            let nextIndex = (currentIndex + 1) % allStates.count
            return allStates[nextIndex]
        }
        return .blanco
    }
}
