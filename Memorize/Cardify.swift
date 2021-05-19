//
//  Cardify.swift
//  Memorize
//
//  Created by Katerina Utlik on 3/18/21.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    
    init(isFaceUp: Bool, gradient: Gradient) {
        rotation = isFaceUp ? 0 : 180
        self.gradient = gradient
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    var gradient: Gradient

    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: conrnerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: conrnerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: conrnerRadius)
                .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private let conrnerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool, gradient: Gradient) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, gradient: gradient))
    }
}
