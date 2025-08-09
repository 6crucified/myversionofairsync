//
//  GlassEffect.swift
//  airsync-mac
//
//  Created by AI assistant on 2025-08-09.
//

import SwiftUI

extension View {
    @ViewBuilder
    func glassEffect(in shape: some Shape) -> some View {
        if #available(macOS 26.0, *) {
            self.background(.ultraThinMaterial)
                .clipShape(shape)
        } else {
            self.background(.thinMaterial)
                .clipShape(shape)
        }
    }
}

struct RectangleShape {
    static func rect(cornerRadius: CGFloat) -> some Shape {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
}