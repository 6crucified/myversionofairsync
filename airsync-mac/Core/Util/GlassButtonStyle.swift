// GlassButtonStyle.swift
// airsync-mac
//
// Created by AI assistant on 2025-08-09.
//

import SwiftUI

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color.white.opacity(0.25))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.4))
            )
            .opacity(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension GlassButtonStyle {
    static var glass: GlassButtonStyle { GlassButtonStyle() }
}