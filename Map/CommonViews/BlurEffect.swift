//
//  BlurEffect.swift
//  Map
//
//  Created by Nikola Malinovic on 30.03.21.
//

import SwiftUI

struct BlurEffect: UIViewRepresentable {
    var style = UIBlurEffect.Style.regular

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(frame: .zero)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
